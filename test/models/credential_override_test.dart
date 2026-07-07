import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/identity_state.dart';

void main() {
  group('CredentialOverride', () {
    test('isServiceAccount returns true for service_account type', () {
      const override = CredentialOverride(
        path: '/path/to/sa-key.json',
        type: 'service_account',
        clientEmail: 'my-sa@project.iam.gserviceaccount.com',
      );
      expect(override.isServiceAccount, isTrue);
    });

    test('isServiceAccount returns false for authorized_user type', () {
      const override = CredentialOverride(
        path: '/path/to/user-creds.json',
        type: 'authorized_user',
      );
      expect(override.isServiceAccount, isFalse);
    });

    test('displayLabel shows SA email when service account', () {
      const override = CredentialOverride(
        path: '/path/to/sa-key.json',
        type: 'service_account',
        clientEmail: 'my-sa@project.iam.gserviceaccount.com',
      );
      expect(override.displayLabel,
          'Service Account: my-sa@project.iam.gserviceaccount.com');
    });

    test('displayLabel shows type when no email', () {
      const override = CredentialOverride(
        path: '/path/to/creds.json',
        type: 'authorized_user',
      );
      expect(override.displayLabel, 'Credential type: authorized_user');
    });

    test('displayLabel falls back to path when no type', () {
      const override = CredentialOverride(
        path: '/path/to/unknown-creds.json',
      );
      expect(override.displayLabel, '/path/to/unknown-creds.json');
    });

    test('displayLabel shows SA email even when path is complex', () {
      const override = CredentialOverride(
        path: '/very/long/deeply/nested/path/to/service-account-key.json',
        type: 'service_account',
        clientEmail: 'deployer@prod-project.iam.gserviceaccount.com',
      );
      expect(override.displayLabel,
          'Service Account: deployer@prod-project.iam.gserviceaccount.com');
    });
  });

  group('IdentityState with credentialOverride', () {
    test('credentialOverride is null by default', () {
      const state = IdentityState();
      expect(state.credentialOverride, isNull);
    });

    test('credentialOverride is passed through', () {
      const override = CredentialOverride(
        path: '/path/to/sa-key.json',
        type: 'service_account',
        clientEmail: 'sa@project.iam.gserviceaccount.com',
      );
      const state = IdentityState(credentialOverride: override);
      expect(state.credentialOverride, isNotNull);
      expect(state.credentialOverride!.isServiceAccount, isTrue);
      expect(state.credentialOverride!.clientEmail,
          'sa@project.iam.gserviceaccount.com');
    });
  });
}
