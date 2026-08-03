import '../models/span_stats.dart';

/// Holds the comparison between current and previous period.
///
/// Uses a half-split of the selected time range's series data:
/// earlier half = "previous", later half = "current".
class PeriodComparison {
  final double costChangePercent;
  final double callsChangePercent;

  /// Combined token trend (input + output). `null` when the baseline is zero
  /// and the change is undefined.
  final double? tokensChangePercent;

  const PeriodComparison({
    required this.costChangePercent,
    required this.callsChangePercent,
    required this.tokensChangePercent,
  });

  /// Returns a human-readable label describing the half-split comparison.
  static String labelForRange(TokenTimeRange range) {
    switch (range) {
      case TokenTimeRange.todayUtc:
        return 'vs earlier today';
      case TokenTimeRange.h24:
        return 'vs earlier 24h';
      case TokenTimeRange.d7:
        return 'vs earlier 7d';
      case TokenTimeRange.d30:
        return 'vs earlier 30d';
    }
  }

  /// Computes the period comparison from time-series data.
  ///
  /// Splits into equal-length halves (drops the middle point when odd)
  /// to avoid bias from unequal bucket counts.
  factory PeriodComparison.fromSummary(UsageSummary summary) {
    return PeriodComparison(
      costChangePercent: (_computeChange(summary.costOverTime) ?? 0) * 100,
      callsChangePercent: (_computeChange(summary.callsOverTime) ?? 0) * 100,
      tokensChangePercent: _computeChange(summary.tokensOverTime) != null
          ? _computeChange(summary.tokensOverTime)! * 100
          : null,
    );
  }

  /// Returns the fractional change between equal-sized halves, or `null`
  /// when the baseline (first half) is zero — growth from nothing is undefined.
  static double? _computeChange(List<TimeSeriesPoint> series) {
    if (series.length < 2) return null;

    // Use equal-length halves; drop the middle point when length is odd.
    final half = series.length ~/ 2;
    final currStart = series.length - half;
    double prev = 0;
    double curr = 0;

    for (int i = 0; i < half; i++) {
      prev += series[i].value;
    }
    for (int i = currStart; i < series.length; i++) {
      curr += series[i].value;
    }

    if (prev == 0) return null;
    return (curr - prev) / prev;
  }
}
