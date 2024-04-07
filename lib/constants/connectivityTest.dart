import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

internetRestored(BuildContext context, Function setStateCallback) {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      // goThere(context, const NoInternetScreen());
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (BuildContext context) => const NoInternetScreen()))
          .then((value) => setStateCallback(() {}));
    } else {
      String checkInternet = sharedPrefs.getFromDevice('checkInternet') ?? 'no';
      if (checkInternet != 'yes') {
        Navigator.pop(context, true);
        setStateCallback(() {});
        print('is reloaded test');
      }
    }
  });
}
