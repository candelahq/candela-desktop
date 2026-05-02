import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../services/process_manager.dart';
import '../../models/provider_status.dart';

/// Card showing a local provider with connectivity status + Start/Stop/Restart controls.
class RuntimeControlCard extends StatelessWidget {
  final ManagedProcess process;
  final VoidCallback? onStart;
  final VoidCallback? onStop;
  final VoidCallback? onRestart;
  final VoidCallback? onRemove;
  final ProviderStatus? providerStatus;

  const RuntimeControlCard({
    super.key,
    required this.process,
    this.onStart,
    this.onStop,
    this.onRestart,
    this.onRemove,
    this.providerStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 8),
          _statusInfo(),
          if (process.errorMessage != null) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.warning_amber, size: 12, color: CandelaColors.error),
              const SizedBox(width: 4),
              Flexible(child: Text(
                process.errorMessage!,
                style: const TextStyle(fontSize: 11, color: CandelaColors.error),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              )),
            ]),
          ],
          if (process.recentLogs.isNotEmpty && process.state == ProcessState.error) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CandelaColors.bgTertiary,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(maxHeight: 60),
              child: SingleChildScrollView(
                child: Text(
                  process.recentLogs.takeLast(5).join('\n'),
                  style: const TextStyle(fontSize: 10, fontFamily: 'SF Mono, monospace', color: CandelaColors.textMuted),
                ),
              ),
            ),
          ],
          const Spacer(),
          _controls(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(children: [
      Text(process.icon, style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 8),
      Expanded(child: Text(
        process.displayName,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      )),
      _stateBadge(),
      if (onRemove != null) ...[
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close, size: 14, color: CandelaColors.textMuted),
        ),
      ],
    ]);
  }

  Widget _stateBadge() {
    final (label, color) = switch (process.state) {
      ProcessState.running => ('Running', CandelaColors.success),
      ProcessState.starting => ('Starting...', CandelaColors.accent),
      ProcessState.stopping => ('Stopping...', CandelaColors.accent),
      ProcessState.error => ('Error', CandelaColors.error),
      ProcessState.notInstalled => ('Not installed', CandelaColors.textMuted),
      ProcessState.stopped => ('Stopped', CandelaColors.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (process.state == ProcessState.starting || process.state == ProcessState.stopping)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: SizedBox(width: 10, height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: color)),
          ),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _statusInfo() {
    if (process.state == ProcessState.running) {
      final models = providerStatus?.models ?? [];
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _infoRow('Port', ':${process.port}'),
        if (process.pid != null) _infoRow('PID', '${process.pid}'),
        if (process.uptime != null) _infoRow('Uptime', process.uptimeString),
        if (models.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Models: ${models.take(3).join(", ")}${models.length > 3 ? " +${models.length - 3}" : ""}',
              style: const TextStyle(fontSize: 10, color: CandelaColors.textMuted),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
      ]);
    }
    if (process.state == ProcessState.notInstalled) {
      return const Text(
        'Binary not found in PATH',
        style: TextStyle(fontSize: 11, color: CandelaColors.textMuted),
      );
    }
    return const Text(
      'Ready to start',
      style: TextStyle(fontSize: 11, color: CandelaColors.textMuted),
    );
  }

  Widget _controls() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      if (process.state == ProcessState.stopped)
        _actionButton(Icons.play_arrow, 'Start', CandelaColors.success, onStart),
      if (process.state == ProcessState.running) ...[
        _actionButton(Icons.refresh, 'Restart', CandelaColors.accent, onRestart),
        const SizedBox(width: 8),
        _actionButton(Icons.stop, 'Stop', CandelaColors.error, onStop),
      ],
      if (process.state == ProcessState.error)
        _actionButton(Icons.play_arrow, 'Retry', CandelaColors.accent, onStart),
    ]);
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback? onTap) {
    return Tooltip(
      message: label,
      child: Material(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Text('$label: $value',
      style: const TextStyle(fontSize: 11, color: CandelaColors.textSecondary)),
  );

  Color get _borderColor => switch (process.state) {
    ProcessState.running => CandelaColors.success.withValues(alpha: 0.3),
    ProcessState.error => CandelaColors.error.withValues(alpha: 0.3),
    _ => CandelaColors.borderSubtle,
  };
}

extension<T> on List<T> {
  List<T> takeLast(int n) => length <= n ? this : sublist(length - n);
}
