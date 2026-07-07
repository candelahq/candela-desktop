import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/identity_state.dart';
import '../../services/candela_auth_service.dart';

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
                  const Text(
                    'Primary Team Identity (GCP)',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CandelaColors.accent),
                  ),
                  const SizedBox(height: 2),
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
                  if (identity.credentialOverride != null) ...[
                    const SizedBox(height: 6),
                    _credentialOverrideBanner(identity.credentialOverride!),
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
                        'candela auth login\nRefresh or switch ADC credentials',
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
      // Use `candela auth login` (native OAuth, no gcloud needed).
      try {
        _adcProcess = await Process.start('candela', ['auth', 'login'],
            environment: CandelaAuthService().augmentedEnv);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Candela CLI not found — install via: brew install candelahq/tap/candela'),
                backgroundColor: CandelaColors.warning),
          );
        }
        _adcProcess = null;
        if (mounted) setState(() {});
        return;
      }
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
              content: Text('Failed to start login: $e'),
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

  Widget _credentialOverrideBanner(CredentialOverride override) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CandelaColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CandelaColors.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 14, color: CandelaColors.warning),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GOOGLE_APPLICATION_CREDENTIALS override active',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: CandelaColors.warning,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  override.displayLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: CandelaColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  override.isServiceAccount
                      ? 'Client libraries will authenticate as this SA, '
                          'not your ADC identity. '
                          'Run: unset GOOGLE_APPLICATION_CREDENTIALS'
                      : 'Client libraries may use different credentials '
                          'than shown above. '
                          'Run: unset GOOGLE_APPLICATION_CREDENTIALS',
                  style: const TextStyle(
                    fontSize: 10,
                    color: CandelaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
