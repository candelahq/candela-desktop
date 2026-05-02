import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../models/identity_state.dart';

/// Reads and parses the Application Default Credentials file.
class AdcService {
  /// Read the ADC credentials file and return its info.
  Future<AdcInfo?> readAdcFile() async {
    final adcPath = _adcPath();
    final file = File(adcPath);

    if (!await file.exists()) return null;

    try {
      final content =
          json.decode(await file.readAsString()) as Map<String, dynamic>;
      return AdcInfo(
        path: adcPath,
        type: content['type'] as String? ?? 'unknown',
        clientEmail: content['client_email'] as String?,
        quotaProject: content['quota_project_id'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  String _adcPath() {
    final home = Platform.environment['HOME'] ?? '';
    // Standard ADC location on macOS/Linux.
    return path.join(home, '.config', 'gcloud',
        'application_default_credentials.json');
  }
}
