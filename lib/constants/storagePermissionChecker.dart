import 'package:permission_handler/permission_handler.dart';

Future<bool> checkStoragePermission(Permission permission) async {
  try {
    if (await permission.isGranted) {
      print('permission.isGranted');
      return true;
    } else {
      // print('object');
      // return false;
      print('permission.isNotGranted');

      var result = await permission.request();

      if ((await Permission.storage.isPermanentlyDenied) ||
          (await Permission.storage.isDenied)) {
        print('permission.isDenied');
        return false;
      }

      if (result == PermissionStatus.granted) {
        print('permission.isGranted 2');

        return true;
      }
    }
  } catch (e) {
    print('Exception - $e');
  }

  return false;
}
