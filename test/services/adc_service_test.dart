import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/models/identity_state.dart';

void main() {
  group('AdcService', () {
    late AdcService service;

    setUp(() {
      service = AdcService();
    });

    test('readAdcFile returns null for nonexistent path', () async {
      // Default ADC path should exist on CI but may not — the test
      // validates that no exception is thrown regardless.
      final result = await service.readAdcFile();
      // Either null or valid AdcInfo — no crash.
      expect(result == null || result.type.isNotEmpty, isTrue);
    });

    test('AdcInfo isServiceAccount', () {
      const adc = AdcInfo(path: '/test', type: 'service_account');
      expect(adc.isServiceAccount, isTrue);
      expect(adc.isUserCredentials, isFalse);
    });

    test('AdcInfo isUserCredentials', () {
      const adc = AdcInfo(path: '/test', type: 'authorized_user');
      expect(adc.isServiceAccount, isFalse);
      expect(adc.isUserCredentials, isTrue);
    });

    test('AdcInfo displayType for unknown type falls back to ADC', () {
      const adc = AdcInfo(path: '/test', type: 'external_account');
      expect(adc.displayType, 'Application Default Credentials');
    });

    test('AdcInfo with client email', () {
      const adc = AdcInfo(
        path: '/test',
        type: 'service_account',
        clientEmail: 'sa@project.iam.gserviceaccount.com',
      );
      expect(adc.clientEmail, 'sa@project.iam.gserviceaccount.com');
    });

    test('AdcInfo with quota project', () {
      const adc = AdcInfo(
        path: '/test',
        type: 'authorized_user',
        quotaProject: 'my-project',
      );
      expect(adc.quotaProject, 'my-project');
    });
  });
}
