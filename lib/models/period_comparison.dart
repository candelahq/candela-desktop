import '../models/span_stats.dart';

/// Holds the comparison between current and previous period.
class PeriodComparison {
  final double costChangePercent;
  final double callsChangePercent;
  final double inputTokensChangePercent;
  final double outputTokensChangePercent;

  const PeriodComparison({
    required this.costChangePercent,
    required this.callsChangePercent,
    required this.inputTokensChangePercent,
    required this.outputTokensChangePercent,
  });

  /// Returns a human-readable label like 'vs yesterday' or 'vs last 7d'
  static String labelForRange(TokenTimeRange range) {
    switch (range) {
      case TokenTimeRange.todayUtc:
        return 'vs yesterday';
      case TokenTimeRange.h24:
        return 'vs prev 24h';
      case TokenTimeRange.d7:
        return 'vs prev 7d';
      case TokenTimeRange.d30:
        return 'vs prev 30d';
    }
  }

  /// Computes the period comparison roughly using the time series data.
  /// First half of the time series represents previous period, second half represents current period.
  factory PeriodComparison.fromSummary(UsageSummary summary) {
    return PeriodComparison(
      costChangePercent: _computeChange(summary.costOverTime) * 100,
      callsChangePercent: _computeChange(summary.callsOverTime) * 100,
      // We only have total tokensOverTime in UsageSummary, so use that for both.
      inputTokensChangePercent: _computeChange(summary.tokensOverTime) * 100,
      outputTokensChangePercent: _computeChange(summary.tokensOverTime) * 100,
    );
  }

  static double _computeChange(List<TimeSeriesPoint> series) {
    if (series.length < 2) return 0.0;

    final mid = series.length ~/ 2;
    double prev = 0;
    double curr = 0;

    for (int i = 0; i < mid; i++) {
      prev += series[i].value;
    }
    for (int i = mid; i < series.length; i++) {
      curr += series[i].value;
    }

    if (prev == 0) return curr > 0 ? 1.0 : 0.0;
    return (curr - prev) / prev;
  }
}
