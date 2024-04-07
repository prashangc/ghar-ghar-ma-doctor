import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/GeneralTabBarView.dart';

Widget setupBiometricsBottomSheet(context2, form, type) {
  String password = '';
  String myPassword = sharedPrefs.getFromDevice("myPassword");
  continueBtn(context) async {
    var isValid = form.currentState?.validate();
    if (!isValid!) {
      if (kDebugMode) {
        print('enter valid  data');
      }
    } else {
      Navigator.pop(context);
      if (type == 'addingBiometric') {
        final isAuthenticated = await LocalAuthApi.authenticate();
        var test = sharedPrefs.getFromDevice("userProfile");
        if (isAuthenticated) {
          ProfileModel profileModel = ProfileModel.fromJson(json.decode(test));
          sharedPrefs.storeToDevice(
              "biometricUserID", profileModel.member!.id.toString());
          sharedPrefs.storeToDevice(
              "biometricEmail", profileModel.member!.email);
          sharedPrefs.storeToDevice("biometricPassword", password);
          sharedPrefs.storeToDevice("biometricStatus", 'dontShow');
          mySnackbar.mySnackBar(context2, 'Biometric Added', kGreen);
          switchBloc.storeData(true);
        }
      } else {
        switchBloc.storeData(false);
        sharedPrefs.removeFromDevice('biometricUserID');
        sharedPrefs.removeFromDevice('biometricEmail');
        sharedPrefs.removeFromDevice('biometricPassword');
        sharedPrefs.storeToDevice("biometricPassword", 'show');
      }
    }
  }

  bool hiddenPassword = true;
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Setup Biometrics',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
            const SizedBox24(),
            Text(
              'Confirm your current password to setup fingerprint',
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox16(),
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  TextFormField(
                    style: kStyleNormal.copyWith(
                        fontSize: 12.0, color: Colors.black),
                    obscureText: hiddenPassword,
                    onChanged: (String value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 16.0),
                      filled: true,
                      fillColor: kWhite.withOpacity(0.4),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: Colors.white, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                            color: myColor.primaryColorDark, width: 1.5),
                      ),
                      errorStyle: kStyleNormal.copyWith(
                          color: Colors.red, fontSize: 12.0),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 16.0,
                        color: Colors.black,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hiddenPassword = !hiddenPassword;
                          });
                        },
                        child: Icon(
                          hiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: kStyleNormal.copyWith(
                          fontSize: 12.0, color: Colors.black),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'Enter current password';
                      } else if (myPassword != v) {
                        return 'Old Password Incorrect';
                      }
                      return null;
                    },
                    onSaved: (v) {
                      password = v!;
                    },
                  ),
                  const SizedBox24(),
                  SizedBox(
                    width: maxWidth(context),
                    height: 50.0,
                    child: myCustomButton(
                      context,
                      myColor.primaryColorDark,
                      'Continue',
                      kStyleNormal.copyWith(color: kWhite),
                      () {
                        continueBtn(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}
