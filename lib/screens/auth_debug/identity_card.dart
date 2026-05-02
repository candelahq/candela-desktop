import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../models/identity_state.dart';

class IdentityCard extends StatelessWidget {
  final IdentityState identity;
  final VoidCallback onRefresh;

  const IdentityCard({super.key, required this.identity, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
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
            // Refresh button
            OutlinedButton(
              onPressed: onRefresh,
              child: const Text('Refresh Token'),
            ),
          ],
        ),
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
