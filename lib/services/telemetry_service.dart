import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/budget_info.dart';
import '../models/span_stats.dart';

// ── Error kinds ───────────────────────────────────────────────────────────────

/// Typed errors surfaced from [TelemetryService.fetch].
enum TelemetryErrorKind {
  /// Server returned 401 — token is expired or missing.
  authExpired,

  /// Network / timeout / parse failure.
  unreachable,
}

// ── Service ───────────────────────────────────────────────────────────────────

/// Fetches token/cost telemetry for the dashboard.
///
/// Two mutually-exclusive modes, selected at construction time:
///
/// **Local mode** (`remoteUrl == null`)
///   Reads from `/_local/api/traces` on the candela sidecar (SQLite).
///
/// **Team mode** (`remoteUrl != null`)
///   Calls ConnectRPC `GetUsageSummary` + `GetModelBreakdown` + `GetMyUsage`
///   on the candela-analysis server. Uses a gcloud ADC Bearer token.
///
/// Inject [httpClient] in tests to avoid real network calls.
class TelemetryService {
  /// Local proxy port. Must be 1–65535. Used in local mode only.
  final int port;

  /// ConnectRPC base URL, e.g. `https://candela.example.com`.
  /// When set, team mode is active; local source is skipped.
  final String? remoteUrl;

  /// ADC Bearer token for team mode requests.
  final String? authToken;

  // H5: injectable client enables testing without network.
  final http.Client _client;

  // Security / resource limits.
  static const _maxSyntheticSpans = 1000; // C4: cap OOM loop
  static const _maxBodyBytes = 5 * 1024 * 1024; // C5/H1: 5 MB response cap
  static const _requestTimeout = Duration(seconds: 10);
  static const _localTimeout = Duration(seconds: 5);

  TelemetryService({
    this.port = 8181,
    this.remoteUrl,
    this.authToken,
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client() {
    // H6: validate port range at construction time.
    if (port <= 0 || port > 65535) {
      throw ArgumentError.value(port, 'port', 'Must be 1–65535');
    }
  }

  bool get isTeamMode => remoteUrl != null;

  /// Release the underlying HTTP connection pool.
  /// Call when the service is no longer needed (e.g., in dispose()).
  void dispose() => _client.close();

  /// Validate that [url] has a safe scheme and non-empty host (C2: SSRF guard).
  static bool isSafeUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Fetch telemetry for [range]. Returns `null` when no data is available.
  ///
  /// The returned [TelemetryResult] may carry a [TelemetryErrorKind] to let
  /// the UI show actionable error messages (e.g. "token expired").
  Future<TelemetryResult?> fetch(TokenTimeRange range) async {
    // C2: reject unsafe remote URLs before making any request.
    if (remoteUrl != null && !isSafeUrl(remoteUrl!)) {
      return const TelemetryResult.withError(
        isTeamMode: true,
        error: TelemetryErrorKind.unreachable,
      );
    }

    // H3: single stable `now` reference used throughout this fetch cycle.
    final now = DateTime.now();

    List<SpanRecord> spans;
    TelemetryErrorKind? errorKind;
    BudgetInfo? budget;
    List<GrantInfo> grants = [];
    double? totalRemainingUsd;

    if (isTeamMode) {
      (spans, errorKind, budget, grants, totalRemainingUsd) =
          await _fetchRemote(range, now);
    } else {
      (spans, errorKind) = await _fetchLocal(range);
    }

    if (spans.isEmpty) {
      if (errorKind != null) {
        return TelemetryResult.withError(
            isTeamMode: isTeamMode, error: errorKind);
      }
      // Return zeroed summary rather than null so the UI shows an empty state
      // ("no calls yet") rather than a misleading "cannot reach backend" error.
      return TelemetryResult.empty(
        isTeamMode: isTeamMode,
        budget: budget,
        activeGrants: grants,
        totalRemainingUsd: totalRemainingUsd,
      );
    }

    final cutoff = now.subtract(range.duration);
    final filtered = spans.where((s) => s.timestamp.isAfter(cutoff)).toList();

    // Return empty-state result if all spans fall outside the requested window.
    if (filtered.isEmpty) {
      return errorKind != null
          ? TelemetryResult.withError(isTeamMode: isTeamMode, error: errorKind)
          : TelemetryResult.empty(
              isTeamMode: isTeamMode,
              budget: budget,
              activeGrants: grants,
              totalRemainingUsd: totalRemainingUsd,
            );
    }

    return TelemetryResult(
      summary: buildSummary(filtered, range, now),
      models: _buildModelBreakdown(filtered),
      spans: filtered,
      isTeamMode: isTeamMode,
      budget: budget,
      activeGrants: grants,
      totalRemainingUsd: totalRemainingUsd,
    );
  }

  // ── Local ───────────────────────────────────────────────────────────────────

  Future<(List<SpanRecord>, TelemetryErrorKind?)> _fetchLocal(
      TokenTimeRange range) async {
    // Use a larger limit for longer ranges — 500 is not enough for 7d/30d views.
    final limit = range == TokenTimeRange.h24 ? 500 : 2000;
    try {
      final uri = Uri.http(
          'localhost:$port', '/_local/api/traces', {'limit': '$limit'});
      final resp = await _client.get(uri).timeout(_localTimeout);

      // H1: reject oversized responses before decoding.
      if (resp.bodyBytes.length > _maxBodyBytes) {
        return (<SpanRecord>[], TelemetryErrorKind.unreachable);
      }
      // Non-200 means the proxy endpoint is missing/wrong version —
      // treat as unreachable so the UI shows an actionable error.
      if (resp.statusCode != 200) {
        return (<SpanRecord>[], TelemetryErrorKind.unreachable);
      }

      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      final spans = (body['spans'] as List<dynamic>? ?? [])
          .map((e) => SpanRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      return (spans, null);
    } catch (_) {
      return (<SpanRecord>[], TelemetryErrorKind.unreachable);
    }
  }

  // ── Team / ConnectRPC ───────────────────────────────────────────────────────

  Future<
      (
        List<SpanRecord>,
        TelemetryErrorKind?,
        BudgetInfo?,
        List<GrantInfo>,
        double?
      )> _fetchRemote(TokenTimeRange range, DateTime now) async {
    final base = remoteUrl!.replaceAll(RegExp(r'/$'), '');
    final start = now.subtract(range.duration);

    final headers = {
      'Content-Type': 'application/json',
      'Connect-Protocol-Version': '1',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    final timeRange = {
      'start': start.toUtc().toIso8601String(),
      'end': now.toUtc().toIso8601String(),
    };

    try {
      final results = await Future.wait([
        _client
            .post(
              Uri.parse('$base/candela.v1.DashboardService/GetUsageSummary'),
              headers: headers,
              body: jsonEncode({'project_id': '', 'time_range': timeRange}),
            )
            .timeout(_requestTimeout),
        _client
            .post(
              Uri.parse('$base/candela.v1.DashboardService/GetModelBreakdown'),
              headers: headers,
              body: jsonEncode({'project_id': '', 'time_range': timeRange}),
            )
            .timeout(_requestTimeout),
        // GetMyUsage carries budget + active_grants for the waterfall card.
        // .catchError ensures this call is truly non-fatal — a failure here
        // yields a 500 sentinel so spans/summary are still returned normally.
        _client
            .post(
              Uri.parse('$base/candela.v1.DashboardService/GetMyUsage'),
              headers: headers,
              body: jsonEncode({'project_id': '', 'time_range': timeRange}),
            )
            .timeout(_requestTimeout)
            .catchError((Object e) {
          // Non-fatal: budget display is best-effort. Log for observability.
          debugPrint('[TelemetryService] GetMyUsage failed (non-fatal): $e');
          return http.Response('', 500);
        }),
      ]);

      final summaryResp = results[0];
      final modelsResp = results[1];
      final usageResp = results[2];

      // C1/C3: distinguish 401 (auth expired) from other errors.
      if (summaryResp.statusCode == 401) {
        return (
          <SpanRecord>[],
          TelemetryErrorKind.authExpired,
          null,
          <GrantInfo>[],
          null
        );
      }
      if (summaryResp.statusCode != 200) {
        return (
          <SpanRecord>[],
          TelemetryErrorKind.unreachable,
          null,
          <GrantInfo>[],
          null
        );
      }

      // H1: enforce response body size limit before decoding.
      if (summaryResp.bodyBytes.length > _maxBodyBytes ||
          modelsResp.bodyBytes.length > _maxBodyBytes) {
        return (
          <SpanRecord>[],
          TelemetryErrorKind.unreachable,
          null,
          <GrantInfo>[],
          null
        );
      }

      // Parse budget/grant data from GetMyUsage (non-fatal if missing/error).
      BudgetInfo? budget;
      List<GrantInfo> grants = [];
      double? totalRemainingUsd;
      if (usageResp.statusCode == 200 &&
          usageResp.bodyBytes.length <= _maxBodyBytes) {
        try {
          final usageJson = jsonDecode(usageResp.body) as Map<String, dynamic>;
          budget = _parseBudget(usageJson['budget']);
          grants =
              _parseGrants(_field(usageJson, 'activeGrants', 'active_grants'));
          final rawRemaining = _parseNum(
                  _field(usageJson, 'totalRemainingUsd', 'total_remaining_usd'))
              ?.toDouble();
          // Clamp server value: must be non-negative and finite.
          // Guards against buggy/malicious responses (NaN, -$n, Infinity).
          if (rawRemaining != null &&
              !rawRemaining.isNaN &&
              !rawRemaining.isInfinite) {
            totalRemainingUsd = rawRemaining.clamp(0.0, 1e9);
          }
        } catch (_) {
          // Budget data is display-only — swallow parse errors.
        }
      }

      if (modelsResp.statusCode == 200) {
        final modelsJson = jsonDecode(modelsResp.body) as Map<String, dynamic>;
        final spans = _spansFromModelBreakdown(
            modelsJson['models'] as List<dynamic>? ?? [], start, now);
        return (spans, null, budget, grants, totalRemainingUsd);
      }

      // Fallback: synthesize from summary time series.
      final summaryJson = jsonDecode(summaryResp.body) as Map<String, dynamic>;
      final spans = _spansFromTimeSeries(
        (_field(summaryJson, 'costOverTime', 'cost_over_time')
                as List<dynamic>?) ??
            [],
        (_field(summaryJson, 'tokensOverTime', 'tokens_over_time')
                as List<dynamic>?) ??
            [],
      );
      return (spans, null, budget, grants, totalRemainingUsd);
    } on FormatException {
      return (
        <SpanRecord>[],
        TelemetryErrorKind.unreachable,
        null,
        <GrantInfo>[],
        null
      );
    } catch (_) {
      return (
        <SpanRecord>[],
        TelemetryErrorKind.unreachable,
        null,
        <GrantInfo>[],
        null
      );
    }
  }

  // ── Budget/grant parsers ─────────────────────────────────────────────────────

  static BudgetInfo? _parseBudget(dynamic raw) {
    if (raw is! Map<String, dynamic>) return null;
    try {
      final limitUsd =
          _parseNum(_field(raw, 'limitUsd', 'limit_usd'))?.toDouble() ?? 0.0;
      final spentUsd =
          _parseNum(_field(raw, 'spentUsd', 'spent_usd'))?.toDouble() ?? 0.0;
      final tokensUsed =
          _parseNum(_field(raw, 'tokensUsed', 'tokens_used'))?.toInt() ?? 0;
      final periodEndRaw = (_field(raw, 'periodEnd', 'period_end')) as String?;
      final periodEnd = periodEndRaw != null
          ? DateTime.tryParse(periodEndRaw) ?? DateTime.now().toUtc()
          : DateTime.now().toUtc().add(const Duration(days: 1));
      return BudgetInfo(
        limitUsd: limitUsd,
        spentUsd: spentUsd,
        tokensUsed: tokensUsed,
        period: BudgetPeriodKind.daily,
        periodEnd: periodEnd,
      );
    } catch (_) {
      return null;
    }
  }

  static List<GrantInfo> _parseGrants(dynamic raw) {
    if (raw is! List) return [];
    final grants = <GrantInfo>[];
    for (final item in raw) {
      if (item is! Map<String, dynamic>) continue;
      try {
        final expiresRaw = (_field(item, 'expiresAt', 'expires_at')) as String?;
        grants.add(GrantInfo(
          // Use .toString() for string fields — guards against int IDs from
          // schema evolution (e.g. proto3 int64 JSON → numeric type).
          id: item['id']?.toString() ?? '',
          amountUsd:
              _parseNum(_field(item, 'amountUsd', 'amount_usd'))?.toDouble() ??
                  0.0,
          spentUsd:
              _parseNum(_field(item, 'spentUsd', 'spent_usd'))?.toDouble() ??
                  0.0,
          reason: (_field(item, 'reason', 'reason'))?.toString() ?? '',
          grantedBy:
              (_field(item, 'grantedBy', 'granted_by'))?.toString() ?? '',
          expiresAt: expiresRaw != null ? DateTime.tryParse(expiresRaw) : null,
        ));
      } catch (_) {
        continue;
      }
    }
    return grants;
  }

  // ── Synthesis helpers ───────────────────────────────────────────────────────

  /// Parse a numeric value that may be a JSON number OR a proto3 int64 string.
  /// Proto3 encodes int64/uint64 fields as JSON strings (e.g. "21" not 21).
  static num? _parseNum(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  /// Lookup a value under either its camelCase or snake_case key.
  /// Proto3 JSON uses camelCase by default; some backends may use snake_case.
  static dynamic _field(Map<String, dynamic> map, String camel, String snake) {
    return map[camel] ?? map[snake];
  }

  List<SpanRecord> _spansFromModelBreakdown(
      List<dynamic> models, DateTime start, DateTime end) {
    final spans = <SpanRecord>[];
    for (final m in models) {
      final map = m as Map<String, dynamic>;
      // C4: cap callCount to prevent OOM loop from malicious server response.
      // Proto3 JSON encodes int64 as strings, so use _parseNum for safe parsing.
      final callCount =
          (_parseNum(_field(map, 'callCount', 'call_count'))?.toInt() ?? 1)
              .clamp(1, _maxSyntheticSpans);
      final inputTok =
          _parseNum(_field(map, 'inputTokens', 'input_tokens'))?.toInt() ?? 0;
      final outputTok =
          _parseNum(_field(map, 'outputTokens', 'output_tokens'))?.toInt() ?? 0;
      final cost =
          _parseNum(_field(map, 'costUsd', 'cost_usd'))?.toDouble() ?? 0.0;
      final latency = _parseNum(_field(map, 'avgLatencyMs', 'avg_latency_ms'))
              ?.toDouble() ??
          0.0;
      final model = map['model'] as String? ?? 'unknown';
      final provider = map['provider'] as String? ?? 'team';

      for (var i = 0; i < callCount; i++) {
        spans.add(SpanRecord(
          spanId: 'r-$model-$i',
          traceId: 'r-$model',
          model: model,
          provider: provider,
          inputTokens: (inputTok / callCount).round(),
          outputTokens: (outputTok / callCount).round(),
          totalTokens: ((inputTok + outputTok) / callCount).round(),
          costUsd: cost / callCount,
          durationMs: latency,
          status: 'ok',
          timestamp: _spread(start, end, i, callCount),
          name: 'chat $model',
        ));
      }
    }
    return spans;
  }

  List<SpanRecord> _spansFromTimeSeries(
      List<dynamic> costSeries, List<dynamic> tokenSeries) {
    final tokenMap = {
      for (final t in tokenSeries)
        (t as Map<String, dynamic>)['timestamp'] as String? ?? '':
            _parseNum(t['value'])?.toInt() ?? 0,
    };

    return costSeries.map((point) {
      final p = point as Map<String, dynamic>;
      final ts = p['timestamp'] as String? ?? '';
      return SpanRecord(
        spanId: 'r-ts-$ts',
        traceId: 'r-ts',
        model: 'unknown',
        provider: 'team',
        inputTokens: 0,
        outputTokens: 0,
        totalTokens: tokenMap[ts] ?? 0,
        costUsd: _parseNum(p['value'])?.toDouble() ?? 0.0,
        durationMs: 0,
        status: 'ok',
        timestamp: DateTime.tryParse(ts) ?? DateTime.now(),
        name: 'bucket',
      );
    }).toList();
  }

  /// Spread span [i] of [total] evenly across [start]–[end].
  /// H4: when total==1, place at window midpoint so it lands in a middle bucket.
  DateTime _spread(DateTime start, DateTime end, int i, int total) {
    final ms = end.difference(start).inMilliseconds;
    if (total <= 1) {
      return start.add(Duration(milliseconds: ms ~/ 2));
    }
    return start.add(Duration(milliseconds: (ms / total * i).round()));
  }

  // ── Aggregation ─────────────────────────────────────────────────────────────

  /// H3: [now] is passed in from [fetch] to ensure consistent bucket alignment.
  UsageSummary buildSummary(
      List<SpanRecord> spans, TokenTimeRange range, DateTime now) {
    int totalIn = 0, totalOut = 0;
    double totalCost = 0, totalMs = 0;
    for (final s in spans) {
      totalIn += s.inputTokens;
      totalOut += s.outputTokens;
      totalCost += s.costUsd;
      totalMs += s.durationMs;
    }
    return UsageSummary(
      totalCalls: spans.length,
      totalInputTokens: totalIn,
      totalOutputTokens: totalOut,
      totalCostUsd: totalCost,
      avgLatencyMs: spans.isEmpty ? 0.0 : totalMs / spans.length,
      costOverTime: _series(spans, range, now, (s) => s.costUsd),
      tokensOverTime:
          _series(spans, range, now, (s) => s.totalTokens.toDouble()),
      callsOverTime: _series(spans, range, now, (_) => 1.0),
    );
  }

  List<ModelBreakdown> _buildModelBreakdown(List<SpanRecord> spans) {
    final map = <String, _Accum>{};
    for (final s in spans) {
      final a = map.putIfAbsent('${s.provider}::${s.model}',
          () => _Accum(model: s.model, provider: s.provider));
      a.callCount++;
      a.inputTokens += s.inputTokens;
      a.outputTokens += s.outputTokens;
      a.costUsd += s.costUsd;
      a.latencySum += s.durationMs;
    }
    return map.values
        .map((a) => ModelBreakdown(
              model: a.model,
              provider: a.provider,
              callCount: a.callCount,
              inputTokens: a.inputTokens,
              outputTokens: a.outputTokens,
              costUsd: a.costUsd,
              avgLatencyMs: a.callCount == 0 ? 0 : a.latencySum / a.callCount,
            ))
        .toList()
      ..sort((a, b) => b.costUsd.compareTo(a.costUsd));
  }

  /// H3: [now] is passed in to ensure bucket timestamps are stable.
  List<TimeSeriesPoint> _series(
    List<SpanRecord> spans,
    TokenTimeRange range,
    DateTime now,
    double Function(SpanRecord) val,
  ) {
    const n = 24;
    final start = now.subtract(range.duration);
    final bucketMs = range.duration.inMilliseconds ~/ n;

    final sums = List<double>.filled(n, 0.0);
    for (final s in spans) {
      final off = s.timestamp.difference(start).inMilliseconds;
      if (off < 0) continue;
      sums[(off / bucketMs).floor().clamp(0, n - 1)] += val(s);
    }

    return List.generate(n, (i) {
      final t = start.add(Duration(milliseconds: bucketMs * i));
      return TimeSeriesPoint(label: _label(t, range), value: sums[i]);
    });
  }

  String _label(DateTime t, TokenTimeRange r) {
    if (r == TokenTimeRange.h24) {
      return '${t.hour.toString().padLeft(2, '0')}:'
          '${t.minute.toString().padLeft(2, '0')}';
    }
    const mo = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${mo[t.month - 1]} ${t.day}';
  }
}

// ── Result ────────────────────────────────────────────────────────────────────

class TelemetryResult {
  final UsageSummary? summary;
  final List<ModelBreakdown> models;
  final List<SpanRecord> spans;
  final bool isTeamMode;
  // C1/C3: typed error so UI can show actionable messages.
  final TelemetryErrorKind? error;

  /// Budget for the current period. Null in solo/local mode or when not
  /// configured on the server.
  final BudgetInfo? budget;

  /// Active grants (earliest-expiry first, matching server deduction order).
  final List<GrantInfo> activeGrants;

  /// Server-computed total remaining across budget + all grants.
  final double? totalRemainingUsd;

  const TelemetryResult({
    required this.summary,
    required this.models,
    required this.spans,
    required this.isTeamMode,
    this.error,
    this.budget,
    this.activeGrants = const [],
    this.totalRemainingUsd,
  });

  /// Convenience constructor for error-only results.
  const TelemetryResult.withError({
    required this.isTeamMode,
    required TelemetryErrorKind this.error,
  })  : summary = null,
        models = const [],
        spans = const [],
        budget = null,
        activeGrants = const [],
        totalRemainingUsd = null;

  /// Connected successfully but no spans in the selected time range.
  const TelemetryResult.empty({
    required this.isTeamMode,
    this.budget,
    this.activeGrants = const [],
    this.totalRemainingUsd,
  })  : summary = null,
        models = const [],
        spans = const [],
        error = null;

  bool get hasData => summary != null;
}

// ── Internal accumulator ──────────────────────────────────────────────────────

class _Accum {
  final String model;
  final String provider;
  int callCount = 0;
  int inputTokens = 0;
  int outputTokens = 0;
  double costUsd = 0;
  double latencySum = 0;
  _Accum({required this.model, required this.provider});
}
