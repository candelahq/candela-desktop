/// Shared formatting utilities used across Dashboard, Today, Traces, and
/// Models screens.
///
/// Extracted to eliminate duplicated `_fmtTok` / `_fmtTokens` functions that
/// were copy-pasted across four files.
library;

/// Formats a token count into a compact, human-readable string.
///
/// Examples: `42` → `"42"`, `1500` → `"1.5k"`, `2300000` → `"2.3M"`
String formatTokenCount(int v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
  return '$v';
}
