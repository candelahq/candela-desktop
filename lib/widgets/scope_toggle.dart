import 'package:flutter/material.dart';
import '../models/user_scope.dart';
import '../theme/colors.dart';

/// Compact segmented toggle for switching between personal ("My") and
/// global ("All") data visibility scopes.
///
/// Used across Dashboard, Today, and Traces screens when the app is
/// running in team mode.
class ScopeToggle extends StatelessWidget {
  final UserScope scope;
  final ValueChanged<UserScope> onChanged;
  const ScopeToggle({super.key, required this.scope, required this.onChanged});

  bool get _isGlobal => scope == UserScope.global;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _scopeChip('My', !_isGlobal, () {
            if (_isGlobal) {
              onChanged(UserScope.personal);
            }
          }),
          _scopeChip('All', _isGlobal, () {
            if (!_isGlobal) {
              onChanged(UserScope.global);
            }
          }),
        ],
      ),
    );
  }

  Widget _scopeChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:
              active ? CandelaColors.accent.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? CandelaColors.accent : CandelaColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
