import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/identity_state.dart';

class IdentityCard extends StatefulWidget {
  final IdentityState identity;
  final VoidCallback onRefresh;

  const IdentityCard({super.key, required this.identity, required this.onRefresh});

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<IdentityCard> {
  String? _runningCommand;

  @override
  Widget build(BuildContext context) {
    final identity = widget.identity;
    final token = identity.tokenInfo;
    final statusColor = token == null
        ? CandelaColors.error
        : token.isValid
            ? (token.timeRemaining.inMinutes < 5 ? CandelaColors.warning : CandelaColors.success)
            : CandelaColors.error;
    final statusText = token == null
        ? '❌ No token'
        : token.isValid
            ? '✅ Valid — expires in ${token.expiryDisplay}'
            : '❌ Token expired';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CandelaColors.accent.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  _initials(identity.email),
                  style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: CandelaColors.accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    identity.email ?? 'Not authenticated',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  if (identity.adcInfo != null) ...[
                    _badge(identity.adcInfo!.displayType),
                    const SizedBox(height: 4),
                  ],
                  if (identity.project != null)
                    Text('GCP Project: ${identity.project}',
                      style: const TextStyle(fontSize: 12, color: CandelaColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(statusText, style: TextStyle(fontSize: 12, color: statusColor)),
                ],
              ),
            ),
            // Auth actions
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: _runningCommand != null ? null : widget.onRefresh,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text('Refresh'),
                ),
                const SizedBox(height: 6),
                _authButton(
                  label: 'gcloud login',
                  icon: Icons.person,
                  command: 'auth', args: ['login'],
                  tooltip: 'gcloud auth login — switch GCP user account',
                ),
                const SizedBox(height: 4),
                _authButton(
                  label: 'ADC login',
                  icon: Icons.key,
                  command: 'auth', args: ['application-default', 'login'],
                  tooltip: 'gcloud auth application-default login — refresh ADC credentials',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _authButton({
    required String label,
    required IconData icon,
    required String command,
    required List<String> args,
    required String tooltip,
  }) {
    final isRunning = _runningCommand == label;
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 120,
        child: OutlinedButton.icon(
          onPressed: isRunning ? null : () => _runGcloudAuth(label, command, args),
          icon: isRunning
            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5))
            : Icon(icon, size: 14),
          label: Text(isRunning ? 'Running...' : label, style: const TextStyle(fontSize: 11)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
    );
  }

  Future<void> _runGcloudAuth(String label, String command, List<String> args) async {
    setState(() => _runningCommand = label);
    try {
      // This opens a browser for the OAuth flow.
      final result = await Process.run('gcloud', [command, ...args]);
      if (result.exitCode == 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label completed successfully'), backgroundColor: CandelaColors.success),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label failed: ${result.stderr}'), backgroundColor: CandelaColors.error),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to run gcloud: $e'), backgroundColor: CandelaColors.error),
        );
      }
    }
    if (mounted) {
      setState(() => _runningCommand = null);
      widget.onRefresh();
    }
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, color: CandelaColors.textSecondary)),
    );
  }

  String _initials(String? email) {
    if (email == null) return '?';
    final parts = email.split('@').first.split('.');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return email[0].toUpperCase();
  }
}
