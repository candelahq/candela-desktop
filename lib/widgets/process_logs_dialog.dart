import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/process_manager.dart';
import '../theme/colors.dart';

class ProcessLogsDialog extends ConsumerStatefulWidget {
  final String processName;

  const ProcessLogsDialog({super.key, required this.processName});

  @override
  ConsumerState<ProcessLogsDialog> createState() => _ProcessLogsDialogState();
}

class _ProcessLogsDialogState extends ConsumerState<ProcessLogsDialog> {
  Timer? _timer;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _refreshLogs();
    // Poll for new logs to avoid rebuilding the whole UI for every stdout line.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refreshLogs());
  }

  void _refreshLogs() {
    final notifier = ref.read(processManagerProvider.notifier);
    final newLogs = notifier.getLogs(widget.processName);
    // Simple dirty check to avoid unnecessary setStates
    if (_logs.length != newLogs.length ||
        (_logs.isNotEmpty &&
            newLogs.isNotEmpty &&
            _logs.last != newLogs.last)) {
      if (mounted) setState(() => _logs = newLogs);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch process manager state to react to state changes (starting, error, stopped)
    final pmState = ref.watch(processManagerProvider);
    final process = pmState.get(widget.processName);

    if (process == null) {
      return const AlertDialog(
        content: Text('Process no longer exists.'),
      );
    }

    final logText = _logs.isEmpty ? 'No logs available yet.' : _logs.join('\n');

    return AlertDialog(
      backgroundColor: CandelaColors.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: CandelaColors.borderSubtle)),
        ),
        child: Row(
          children: [
            Text(
              '${process.icon} ${process.displayName} Logs',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CandelaColors.textPrimary,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              tooltip: 'Copy to Clipboard',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: logText));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logs copied to clipboard')),
                );
              },
              color: CandelaColors.textMuted,
              hoverColor: CandelaColors.bgHover,
              splashRadius: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () => Navigator.of(context).pop(),
              color: CandelaColors.textMuted,
              hoverColor: CandelaColors.bgHover,
              splashRadius: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
      content: Container(
        width: 800,
        height: 500,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Dark terminal background
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CandelaColors.borderSubtle),
        ),
        child: SingleChildScrollView(
          reverse: true, // Auto-scroll to bottom
          child: SelectableText(
            logText,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Color(0xFFD4D4D4), // VS Code like text color
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
