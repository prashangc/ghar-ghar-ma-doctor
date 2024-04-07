import 'package:local_auth/local_auth.dart';

Future<String?> getBiometricType() async {
  final LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = await auth.canCheckBiometrics;
  bool isDeviceSupported = await auth.isDeviceSupported();
  if (isDeviceSupported == true) {
    if (canCheckBiometrics == true) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        return 'is added in device';
      } else {
        return 'not added in device';
      }
      // for (int i = 0; i < availableBiometrics.length; i++) {
      //   print('availableBiometrics ${availableBiometrics[i]}');
      // }
      // if (availableBiometrics.contains(BiometricType.face) &&
      //     availableBiometrics.contains(BiometricType.fingerprint)) {
      //   return 'finger';
      // } else if (availableBiometrics.contains(BiometricType.face)) {
      //   return 'face';
      // } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      //   return 'finger';
      // } else {
      //   return null;
      // }
    } else {
      return 'device doesnt support';
    }
  } else {
    return 'device doesnt support';
  }
}
