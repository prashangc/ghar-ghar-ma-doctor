import 'package:local_auth/local_auth.dart';

checkBiometricSupport() async {
  bool? isBiometricSupported;

  final LocalAuthentication localAuthentication = LocalAuthentication();
  isBiometricSupported = await localAuthentication.isDeviceSupported();

  return isBiometricSupported;
}
