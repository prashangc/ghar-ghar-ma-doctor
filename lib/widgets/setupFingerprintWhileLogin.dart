import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget setupFingerprintWhileLogin(context, profileModel, type) {
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox12(),
          Text(
            type == 'face' ? 'Setup FaceID' : 'Setup Biometrics',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: myColor.primaryColorDark,
            ),
          ),
          const SizedBox16(),
          const Divider(),
          const SizedBox16(),
          GestureDetector(
            onTap: () {
              setBiometric(context, profileModel);
            },
            child: Icon(
              type == 'face'
                  ? FontAwesomeIcons.cameraRetro
                  : Icons.fingerprint_outlined,
              size: 100,
              color: myColor.primaryColorDark,
            ),
          ),
          const SizedBox24(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    sharedPrefs.storeToDevice("biometricStatus", "dontShow");
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Never',
                    style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: myColor.primaryColorDark),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        sharedPrefs.storeToDevice(
                            "biometricStatus", "dontShow");
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Later',
                        style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            color: myColor.primaryColorDark),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setBiometric(context, profileModel);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        'Yes',
                        style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            color: myColor.primaryColorDark),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
