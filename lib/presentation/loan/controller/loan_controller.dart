import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class LoanController extends GetxController {
  final LocalAuthentication localAuth = LocalAuthentication();

  Future<void> _openSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.security);
  }

  Future<bool> authenticateUser() async {
    try {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        biometricOnly: false,
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (e.code == 'noCredentialsSet') {
        Get.snackbar(
          'Biometric Setup Required',
          'Please set up fingerprint or face unlock in your device settings.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          onTap: (snack) async {
            await _openSettings();
          },
        );
      } else {
        debugPrint("Authentication error: $e");
      }
      return false;
    } catch (e) {
      if (e.toString().contains('noCredentialsSet')) {
        Get.snackbar(
          'Biometric Setup Required',
          'Please set up fingerprint or face unlock in your device settings.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          onTap: (snack) async {
            await _openSettings();
          },
        );
      } else {
        debugPrint("Unexpected error: $e");
      }
      return false;
    }
  }
}
