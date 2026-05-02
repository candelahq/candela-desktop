/// A single line in the diagnostic log output.
class DiagnosticEntry {
  final DateTime timestamp;
  final String message;
  final DiagnosticStatus status;
  final String? detail;
  final String? fixCommand;
  final String? fixUrl;

  const DiagnosticEntry({
    required this.timestamp,
    required this.message,
    required this.status,
    this.detail,
    this.fixCommand,
    this.fixUrl,
  });
}

enum DiagnosticStatus { running, pass, fail, warn, info }

/// Summary of a complete diagnostic run.
class DiagnosticSummary {
  final int passed;
  final int failed;
  final int warned;

  const DiagnosticSummary({
    required this.passed,
    required this.failed,
    required this.warned,
  });

  int get total => passed + failed + warned;
  bool get allPassed => failed == 0;
}
