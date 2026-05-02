import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../models/diagnostic_entry.dart';
import '../../services/diagnostic_runner.dart';

class DiagnosticLog extends StatefulWidget {
  final DiagnosticRunner runner;
  const DiagnosticLog({super.key, required this.runner});

  @override
  State<DiagnosticLog> createState() => _DiagnosticLogState();
}

class _DiagnosticLogState extends State<DiagnosticLog> {
  final _scrollController = ScrollController();
  final _entries = <DiagnosticEntry>[];
  StreamSubscription<DiagnosticEntry>? _sub;

  @override
  void initState() {
    super.initState();
    _entries.addAll(widget.runner.history);
    _sub = widget.runner.entries.listen((entry) {
      setState(() => _entries.add(entry));
      // Auto-scroll to bottom.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: CandelaColors.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.borderSubtle),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: CandelaColors.borderSubtle)),
            ),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 14, color: CandelaColors.textMuted),
                const SizedBox(width: 8),
                const Text('Output', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: CandelaColors.textMuted)),
                const Spacer(),
                InkWell(
                  onTap: _entries.isEmpty ? null : () {
                    final text = _entries.map((e) =>
                      '[${_fmt(e.timestamp)}] ${e.message}'
                    ).join('\n');
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Diagnostic log copied to clipboard')),
                    );
                  },
                  child: const Row(children: [
                    Icon(Icons.copy, size: 12, color: CandelaColors.textMuted),
                    SizedBox(width: 4),
                    Text('Copy', style: TextStyle(fontSize: 11, color: CandelaColors.textMuted)),
                  ]),
                ),
              ],
            ),
          ),
          // Log entries
          Expanded(
            child: _entries.isEmpty
                ? const Center(child: Text('Click "Run All Tests" to start diagnostics',
                    style: TextStyle(fontSize: 12, color: CandelaColors.textMuted)))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: _entries.length,
                    itemBuilder: (_, i) => _buildEntry(_entries[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(DiagnosticEntry entry) {
    final color = switch (entry.status) {
      DiagnosticStatus.pass => CandelaColors.success,
      DiagnosticStatus.fail => CandelaColors.error,
      DiagnosticStatus.warn => CandelaColors.warning,
      DiagnosticStatus.info => CandelaColors.textMuted,
      DiagnosticStatus.running => CandelaColors.accent,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('[${_fmt(entry.timestamp)}] ',
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace', color: CandelaColors.textMuted)),
          Expanded(
            child: Text(entry.message,
              style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: color)),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
}
