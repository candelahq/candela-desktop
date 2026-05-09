import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/span_stats.dart';

/// Fetches token/cost telemetry for the dashboard.
///
/// Two mutually-exclusive modes, selected at construction time:
///
/// **Local mode** (`remoteUrl == null`)
///   Reads from `/_local/api/traces` on the candela sidecar (SQLite).
///
/// **Team mode** (`remoteUrl != null`)
///   Calls ConnectRPC `GetUsageSummary` + `GetModelBreakdown` on the
///   candela-analysis server. Uses a gcloud ADC Bearer token.
///   This is the primary path — team mode is the majority of users.
class TelemetryService {
  /// Local proxy port (default 8181). Used in local mode only.
  final int port;

  /// ConnectRPC base URL, e.g. `https://candela.example.com`.
  /// When set, team mode is active; local source is skipped.
  final String? remoteUrl;

  /// ADC Bearer token for team mode requests.
  final String? authToken;

  const TelemetryService({
    this.port = 8181,
    this.remoteUrl,
    this.authToken,
  });

  bool get isTeamMode => remoteUrl != null;

  // ── Public API ────────────────────────────────────────────────────────────

  Future<TelemetryResult?> fetch(TokenTimeRange range) async {
    final spans = isTeamMode ? await _fetchRemote(range) : await _fetchLocal();

    if (spans.isEmpty) return null;

    final cutoff = DateTime.now().subtract(range.duration);
    final filtered = spans.where((s) => s.timestamp.isAfter(cutoff)).toList();

    return TelemetryResult(
      summary: _buildSummary(filtered, range),
      models: _buildModelBreakdown(filtered),
      spans: filtered,
      isTeamMode: isTeamMode,
    );
  }

  // ── Local ─────────────────────────────────────────────────────────────────

  Future<List<SpanRecord>> _fetchLocal() async {
    try {
      final uri =
          Uri.http('localhost:$port', '/_local/api/traces', {'limit': '500'});
      final resp = await http.get(uri).timeout(const Duration(seconds: 5));
      if (resp.statusCode != 200) return [];
      final body = jsonDecode(resp.body) as Map<String, dynamic>;
      return (body['spans'] as List<dynamic>? ?? [])
          .map((e) => SpanRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Team / ConnectRPC ─────────────────────────────────────────────────────

  Future<List<SpanRecord>> _fetchRemote(TokenTimeRange range) async {
    final base = remoteUrl!.replaceAll(RegExp(r'/$'), '');
    final now = DateTime.now();
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
      // Fetch summary + model breakdown in parallel.
      final results = await Future.wait([
        http
            .post(
              Uri.parse('$base/candela.v1.DashboardService/GetUsageSummary'),
              headers: headers,
              body: jsonEncode({'project_id': '', 'time_range': timeRange}),
            )
            .timeout(const Duration(seconds: 10)),
        http
            .post(
              Uri.parse('$base/candela.v1.DashboardService/GetModelBreakdown'),
              headers: headers,
              body: jsonEncode({'project_id': '', 'time_range': timeRange}),
            )
            .timeout(const Duration(seconds: 10)),
      ]);

      final summaryResp = results[0];
      final modelsResp = results[1];

      if (summaryResp.statusCode != 200) return [];

      // Prefer model-level breakdown for accurate per-model numbers.
      if (modelsResp.statusCode == 200) {
        final modelsJson = jsonDecode(modelsResp.body) as Map<String, dynamic>;
        return _spansFromModelBreakdown(
            modelsJson['models'] as List<dynamic>? ?? [], start, now);
      }

      // Fallback: synthesize from summary time series.
      final summaryJson = jsonDecode(summaryResp.body) as Map<String, dynamic>;
      return _spansFromTimeSeries(
          summaryJson['cost_over_time'] as List<dynamic>? ?? [],
          summaryJson['tokens_over_time'] as List<dynamic>? ?? []);
    } catch (_) {
      return [];
    }
  }

  /// Synthesize one SpanRecord per call from GetModelBreakdown rows.
  /// Spreads calls evenly across the time window so the time-series
  /// chart buckets fill in realistically.
  List<SpanRecord> _spansFromModelBreakdown(
      List<dynamic> models, DateTime start, DateTime end) {
    final spans = <SpanRecord>[];
    for (final m in models) {
      final map = m as Map<String, dynamic>;
      final callCount = (map['call_count'] as num?)?.toInt() ?? 1;
      final inputTok = (map['input_tokens'] as num?)?.toInt() ?? 0;
      final outputTok = (map['output_tokens'] as num?)?.toInt() ?? 0;
      final cost = (map['cost_usd'] as num?)?.toDouble() ?? 0.0;
      final latency = (map['avg_latency_ms'] as num?)?.toDouble() ?? 0.0;
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

  /// Fallback: one synthetic span per cost-series bucket.
  List<SpanRecord> _spansFromTimeSeries(
      List<dynamic> costSeries, List<dynamic> tokenSeries) {
    final tokenMap = {
      for (final t in tokenSeries)
        (t as Map<String, dynamic>)['timestamp'] as String? ?? '':
            (t['value'] as num?)?.toInt() ?? 0,
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
        costUsd: (p['value'] as num?)?.toDouble() ?? 0.0,
        durationMs: 0,
        status: 'ok',
        timestamp: DateTime.tryParse(ts) ?? DateTime.now(),
        name: 'bucket',
      );
    }).toList();
  }

  DateTime _spread(DateTime start, DateTime end, int i, int total) {
    if (total <= 1) return start;
    final ms = end.difference(start).inMilliseconds;
    return start.add(Duration(milliseconds: (ms / total * i).round()));
  }

  // ── Aggregation ───────────────────────────────────────────────────────────

  UsageSummary _buildSummary(List<SpanRecord> spans, TokenTimeRange range) {
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
      costOverTime: _series(spans, range, (s) => s.costUsd),
      tokensOverTime: _series(spans, range, (s) => s.totalTokens.toDouble()),
      callsOverTime: _series(spans, range, (_) => 1.0),
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

  List<TimeSeriesPoint> _series(
    List<SpanRecord> spans,
    TokenTimeRange range,
    double Function(SpanRecord) val,
  ) {
    const n = 24;
    final now = DateTime.now();
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
      'Dec'
    ];
    return '${mo[t.month - 1]} ${t.day}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class TelemetryResult {
  final UsageSummary summary;
  final List<ModelBreakdown> models;
  final List<SpanRecord> spans;
  final bool isTeamMode;

  const TelemetryResult({
    required this.summary,
    required this.models,
    required this.spans,
    required this.isTeamMode,
  });
}

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
