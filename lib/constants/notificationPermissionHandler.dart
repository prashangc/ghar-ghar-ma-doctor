import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/EnableNotificationScreen/EnableNotificationScreen.dart';
import 'package:permission_handler/permission_handler.dart';

requestNotificationPermission(context, {ifGranted}) async {
  String myStatus = await checkNotificationPermission();
  if (myStatus != 'System notifications are enabled.') {
    goThere(
      context,
      EnableNotificationScreen(
        myMethod: await ifGranted,
      ),
    );
  } else {
    ifGranted();
  }
}

checkNotificationPermission() async {
  PermissionStatus status = await Permission.notification.status;
  if (status.isGranted) {
    return 'System notifications are enabled.';
  } else {
    return 'System notifications are disabled.';
  }
}
