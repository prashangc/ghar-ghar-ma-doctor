import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

requestLocationPermission(
    VoidCallback myMethod, VoidCallback onDeclinedMethod) async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  Location location = Location();

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (serviceEnabled) {
      myMethod();
    } else {
      onDeclinedMethod();
    }
  } else {
    myMethod();
  }

  // permissionGranted = await location.hasPermission();
  // if (permissionGranted == PermissionStatus.denied) {
  //   permissionGranted = await location.requestPermission();
  //   if (permissionGranted != PermissionStatus.granted) {
  //     print('my location is $permissionGranted');
  //     return;
  //   }
  // }
}
