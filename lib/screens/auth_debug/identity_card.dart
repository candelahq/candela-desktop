import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/identity_state.dart';
import '../../services/gcloud_service.dart';

class IdentityCard extends StatefulWidget {
  final IdentityState identity;
  final VoidCallback onRefresh;

  const IdentityCard(
      {super.key, required this.identity, required this.onRefresh});

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<IdentityCard> {
  @override
  void dispose() {
    _adcProcess?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final identity = widget.identity;
    final token = identity.tokenInfo;
    final statusColor = token == null
        ? CandelaColors.error
        : token.isValid
            ? (token.timeRemaining.inMinutes < 5
                ? CandelaColors.warning
                : CandelaColors.success)
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CandelaColors.accent.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  _initials(identity.email),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: CandelaColors.accent,
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
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  if (identity.adcInfo != null) ...[
                    _badge(identity.adcInfo!.displayType),
                    const SizedBox(height: 4),
                  ],
                  if (identity.project != null)
                    Text('GCP Project: ${identity.project}',
                        style: const TextStyle(
                            fontSize: 12, color: CandelaColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(statusText,
                      style: TextStyle(fontSize: 12, color: statusColor)),
                  // Show dashboard auth identity (gcloud auth) if available.
                  if (identity.dashboardTokenInfo != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.dashboard,
                            size: 12, color: CandelaColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Dashboard auth: ${identity.dashboardTokenInfo!.email ?? 'unknown'}',
                          style: const TextStyle(
                              fontSize: 11, color: CandelaColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                  // Warn if ADC and gcloud auth are different accounts.
                  if (identity.hasMismatchedIdentities) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CandelaColors.warning.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: CandelaColors.warning.withAlpha(80)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber,
                              size: 13, color: CandelaColors.warning),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'ADC and gcloud auth are different accounts — '
                              'dashboard data may not match your expectations',
                              style: TextStyle(
                                  fontSize: 11, color: CandelaColors.warning),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Auth actions
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: _adcProcess != null ? null : widget.onRefresh,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text('Refresh'),
                ),
                const SizedBox(height: 6),
                if (_adcProcess == null)
                  Tooltip(
                    message:
                        'gcloud auth application-default login\nRefresh or switch ADC credentials',
                    child: SizedBox(
                      width: 130,
                      child: OutlinedButton.icon(
                        onPressed: _runAdcLogin,
                        icon: const Icon(Icons.key, size: 14),
                        label: const Text('ADC Login',
                            style: TextStyle(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 130,
                    child: OutlinedButton.icon(
                      onPressed: _cancelAdcLogin,
                      icon: const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 1.5)),
                      label:
                          const Text('Cancel', style: TextStyle(fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                        foregroundColor: CandelaColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Process? _adcProcess;

  Future<void> _runAdcLogin() async {
    if (!mounted) return;
    setState(() {});
    try {
      _adcProcess = await Process.start(
          'gcloud', ['auth', 'application-default', 'login'],
          environment: GCloudService().augmentedEnv);
      if (mounted) setState(() {}); // show cancel button

      final exitCode = await _adcProcess!.exitCode;
      if (!mounted) return;

      if (exitCode == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('ADC credentials refreshed'),
              backgroundColor: CandelaColors.success),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('ADC login exited with code $exitCode'),
              backgroundColor: CandelaColors.error),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to run gcloud: $e'),
              backgroundColor: CandelaColors.error),
        );
      }
    }
    _adcProcess = null;
    if (mounted) {
      setState(() {});
      widget.onRefresh();
    }
  }

  void _cancelAdcLogin() {
    _adcProcess?.kill();
    _adcProcess = null;
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ADC login cancelled')),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 11, color: CandelaColors.textSecondary)),
    );
  }

  String _initials(String? email) {
    if (email == null) return '?';
    final parts = email.split('@').first.split('.');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return email[0].toUpperCase();
  }
}
