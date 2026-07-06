import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Banner shown when the Candela CLI needs to be installed or upgraded.
///
/// Displays an actionable message with an install/upgrade button and
/// a progress indicator during the operation.
class CliStatusBanner extends StatelessWidget {
  /// Whether the CLI is installed at all.
  final bool isInstalled;

  /// Currently installed version, if any.
  final String? installedVersion;

  /// Latest available version from the tap.
  final String? latestVersion;

  /// Whether Homebrew is available.
  final bool isBrewAvailable;

  /// Whether an install/upgrade is currently in progress.
  final bool isLoading;

  /// Error message from the last operation, if any.
  final String? error;

  /// Called when the user taps "Install" or "Upgrade".
  final VoidCallback? onAction;

  /// Called when the user dismisses an error.
  final VoidCallback? onDismissError;

  const CliStatusBanner({
    super.key,
    required this.isInstalled,
    this.installedVersion,
    this.latestVersion,
    required this.isBrewAvailable,
    this.isLoading = false,
    this.error,
    this.onAction,
    this.onDismissError,
  });

  @override
  Widget build(BuildContext context) {
    // Nothing to show if CLI is installed and up to date.
    if (isInstalled && !_hasUpgrade && error == null) {
      return const SizedBox.shrink();
    }

    final Color bannerColor;
    final IconData icon;
    final String message;
    final String? buttonLabel;

    if (error != null) {
      bannerColor = CandelaColors.error;
      icon = Icons.error_outline;
      message = error!;
      buttonLabel = 'Dismiss';
    } else if (!isBrewAvailable && Platform.isMacOS) {
      bannerColor = CandelaColors.warning;
      icon = Icons.warning_amber_rounded;
      message = 'Homebrew is required to install the Candela CLI. '
          'Visit https://brew.sh to install it.';
      buttonLabel = null;
    } else if (!isInstalled) {
      bannerColor = CandelaColors.warning;
      icon = Icons.download_rounded;
      message = 'Candela CLI is required for the proxy.';
      buttonLabel = Platform.isMacOS ? 'Install via Homebrew' : null;
    } else if (_hasUpgrade) {
      bannerColor = CandelaColors.accent;
      icon = Icons.upgrade_rounded;
      message = 'Candela CLI update: v$installedVersion → v$latestVersion';
      buttonLabel = 'Upgrade';
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bannerColor.withAlpha(25),
        border: Border.all(color: bannerColor.withAlpha(80)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: bannerColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: bannerColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: CandelaColors.accent,
                ),
              ),
            )
          else if (buttonLabel != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: TextButton(
                onPressed: error != null ? onDismissError : onAction,
                style: TextButton.styleFrom(
                  backgroundColor: bannerColor.withAlpha(30),
                  foregroundColor: bannerColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get _hasUpgrade =>
      isInstalled &&
      installedVersion != null &&
      latestVersion != null &&
      installedVersion != latestVersion;
}
