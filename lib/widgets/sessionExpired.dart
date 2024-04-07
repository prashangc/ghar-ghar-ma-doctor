import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';

Widget sessionExpired(context) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox12(),
          CircleAvatar(
            radius: 40.0,
            backgroundColor: backgroundColor,
            child: Image.asset('assets/logo.png'),
          ),
          const SizedBox8(),
          Text(
            'Session Expired',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: myColor.primaryColorDark,
            ),
          ),
          const SizedBox16(),
          Text(
            'For security concerns, your session has been expired due to you inactivity. Please login again to continue.',
            textAlign: TextAlign.justify,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
          const SizedBox24(),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            child: Text(
              'Re-Login',
              style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold, color: myColor.primaryColorDark),
            ),
          ),
          const SizedBox16(),
        ],
      ),
    );
  });
}

setBiometric(context, profileModel) async {
  var myPassword = sharedPrefs.getFromDevice("myPassword");
  final isAuthenticated = await LocalAuthApi.authenticate();
  if (isAuthenticated) {
    sharedPrefs.storeToDevice(
        "biometricUserID", profileModel!.member!.id.toString());
    sharedPrefs.storeToDevice("biometricEmail", profileModel!.member!.email);
    sharedPrefs.storeToDevice("biometricPassword", myPassword);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Biometric Added',
            style: kStyleNormal.copyWith(color: kWhite),
          ),
        ],
      ),
      backgroundColor: kGreen,
    ));
  }
}
