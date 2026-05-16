import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/process_manager.dart';
import '../providers.dart';
import '../theme/colors.dart';
import 'process_logs_dialog.dart';

class LocalServicesCard extends ConsumerWidget {
  const LocalServicesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processManager = ref.watch(processManagerProvider);
    final processes = processManager.all;

    if (processes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.router_outlined,
                  size: 16, color: CandelaColors.textMuted),
              SizedBox(width: 8),
              Text(
                'Local Services',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < processes.length; i++) ...[
            if (i > 0)
              const Divider(height: 24, color: CandelaColors.borderSubtle),
            _ProcessRow(
              process: processes[i],
              onStart: () => processManager.start(processes[i].name),
              onStop: () => processManager.stop(processes[i].name),
              onRestart: () => processManager.restart(processes[i].name),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  final ManagedProcess process;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onRestart;

  const _ProcessRow({
    required this.process,
    required this.onStart,
    required this.onStop,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = process.state == ProcessState.running;
    final isError = process.state == ProcessState.error;
    final isWorking = process.state == ProcessState.starting ||
        process.state == ProcessState.stopping;
    final notInstalled = process.state == ProcessState.notInstalled;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: CandelaColors.bgTertiary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CandelaColors.border),
          ),
          child: Center(
            child: Text(
              process.icon,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    process.displayName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CandelaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(state: process.state),
                ],
              ),
              const SizedBox(height: 4),
              if (isError && process.errorMessage != null)
                Text(
                  process.errorMessage!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CandelaColors.error,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              else if (notInstalled)
                const Text(
                  'Not installed or not found in PATH',
                  style: TextStyle(
                    fontSize: 11,
                    color: CandelaColors.textMuted,
                  ),
                )
              else
                Row(
                  children: [
                    if (process.port != null) ...[
                      const Icon(Icons.cable,
                          size: 10, color: CandelaColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        ':${process.port}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: CandelaColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (process.uptime != null) ...[
                      const Icon(Icons.schedule,
                          size: 10, color: CandelaColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        process.uptimeString,
                        style: const TextStyle(
                          fontSize: 11,
                          color: CandelaColors.textSecondary,
                        ),
                      ),
                    ] else if (!isRunning && !isWorking) ...[
                      const Text(
                        'Stopped',
                        style: TextStyle(
                          fontSize: 11,
                          color: CandelaColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (isWorking)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: CandelaColors.textMuted,
              ),
            ),
          )
        else if (isRunning) ...[
          IconButton(
            icon: const Icon(Icons.refresh, size: 16),
            tooltip: 'Restart',
            onPressed: onRestart,
            color: CandelaColors.textMuted,
            hoverColor: CandelaColors.bgHover,
            splashRadius: 16,
          ),
          IconButton(
            icon: const Icon(Icons.stop, size: 16),
            tooltip: 'Stop',
            onPressed: onStop,
            color: CandelaColors.error,
            hoverColor: CandelaColors.error.withAlpha(20),
            splashRadius: 16,
          ),
        ] else if (!notInstalled) ...[
          IconButton(
            icon: const Icon(Icons.play_arrow, size: 16),
            tooltip: 'Start',
            onPressed: onStart,
            color: CandelaColors.success,
            hoverColor: CandelaColors.success.withAlpha(20),
            splashRadius: 16,
          ),
        ],
        // Always show logs button unless not installed
        if (!notInstalled)
          IconButton(
            icon: const Icon(Icons.receipt_long, size: 16),
            tooltip: 'View Logs',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ProcessLogsDialog(processName: process.name),
              );
            },
            color: CandelaColors.textMuted,
            hoverColor: CandelaColors.bgHover,
            splashRadius: 16,
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProcessState state;

  const _StatusBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String text;

    switch (state) {
      case ProcessState.running:
        color = CandelaColors.success;
        text = 'RUNNING';
        break;
      case ProcessState.starting:
        color = CandelaColors.warning;
        text = 'STARTING';
        break;
      case ProcessState.stopping:
        color = CandelaColors.warning;
        text = 'STOPPING';
        break;
      case ProcessState.error:
        color = CandelaColors.error;
        text = 'ERROR';
        break;
      case ProcessState.stopped:
        color = CandelaColors.textMuted;
        text = 'STOPPED';
        break;
      case ProcessState.notInstalled:
        color = CandelaColors.textMuted;
        text = 'MISSING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}
