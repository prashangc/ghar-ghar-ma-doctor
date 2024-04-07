import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class popUpHelper {
  customAlert(context, message, value) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: kTransparent,
              contentPadding: EdgeInsets.zero,
              // insetPadding: EdgeInsets.zero,
              content: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: myColor.primaryColorDark,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 38.0),
                    width: maxWidth(context),
                    child: Container(
                        padding: const EdgeInsets.all(
                          4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kWhite.withOpacity(0.2),
                        ),
                        child: Icon(
                          message == 'SUCCESS' ? Icons.check : Icons.error,
                          color: myColor.dialogBackgroundColor,
                          size: 60.0,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox12(),
                          Text(
                            message.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox8(),
                          Text(
                            value,
                            overflow: TextOverflow.clip,
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox12(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor.primaryColorDark,
                              elevation: 0.0,
                              padding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: kTransparent,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Ok',
                              style: kStyleNormal.copyWith(color: kWhite),
                            ),
                          ),
                          const SizedBox12(),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  Future<dynamic> popUpNavigatorPop(
    context,
    int popCount,
    msgType,
    textValue,
  ) {
    return CoolAlert.show(
        loopAnimation: true,
        context: context,
        type: msgType,
        // text: textValue,
        confirmBtnColor: myColor.primaryColorDark,
        backgroundColor: myColor.primaryColorDark,
        widget: Text(
          textValue,
          textAlign: TextAlign.center,
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
          ),
        ),
        onConfirmBtnTap: () {
          for (int i = 0; i < popCount; i++) {
            Navigator.pop(context);
          }
        });
  }

  Future<dynamic> popUpToNewScreen(
      BuildContext context, msgType, textValue, screen) {
    return CoolAlert.show(
        loopAnimation: true,
        context: context,
        type: msgType,
        widget: Text(
          textValue,
          textAlign: TextAlign.center,
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
          ),
        ),
        confirmBtnColor: myColor.primaryColorDark,
        backgroundColor: myColor.primaryColorDark,
        // autoCloseDuration: const Duration(seconds: 2),
        onConfirmBtnTap: () {
          Navigator.pop(context);
          goThere(context, screen);
        });
  }

  Future<dynamic> popUpLogout(BuildContext context) {
    return CoolAlert.show(
        loopAnimation: true,
        context: context,
        type: CoolAlertType.confirm,
        confirmBtnColor: myColor.primaryColorDark,
        backgroundColor: myColor.primaryColorDark,
        confirmBtnText: 'Logout',
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          logoutBloc.storeData(true);
          int statusCode = await API().deleteData(
              context: context,
              Platform.isAndroid
                  ? '${endpoints.deleteFCMWhileLogoutEndpoint}?platform=Android'
                  : '${endpoints.deleteFCMWhileLogoutEndpoint}?platform=iOS',
              model: null);
          if (statusCode == 200) {
            clearLocalStorage();
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);

            logoutBloc.storeData(false);
          } else {
            clearLocalStorage();
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);

            logoutBloc.storeData(false);
          }
        });
  }

  Future<dynamic> popUpExitApp(BuildContext context) {
    return CoolAlert.show(
        loopAnimation: true,
        context: context,
        type: CoolAlertType.info,
        title: 'Confirm Exit?',
        confirmBtnColor: myColor.primaryColorDark,
        backgroundColor: myColor.primaryColorDark,
        confirmBtnText: 'Ok',
        confirmBtnTextStyle: kStyleNormal.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        cancelBtnTextStyle: kStyleNormal.copyWith(
          color: Colors.grey[400],
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        showCancelBtn: true,
        cancelBtnText: 'Cancel',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          if (Platform.isAndroid) {
            exit(0);
          } else if (Platform.isIOS) {
            exit(0);
          }
        });
  }

  Future<dynamic> popUpDelete(context, Function myTap) {
    return CoolAlert.show(
        loopAnimation: true,
        context: context,
        type: CoolAlertType.info,
        title: 'Are you sure?',
        confirmBtnColor: myColor.primaryColorDark,
        backgroundColor: myColor.primaryColorDark,
        confirmBtnText: 'Remove',
        confirmBtnTextStyle: kStyleNormal.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        cancelBtnTextStyle: kStyleNormal.copyWith(
          color: Colors.grey[400],
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        showCancelBtn: true,
        cancelBtnText: 'Cancel',
        // onCancelBtnTap: () {
        //   Navigator.pop(context);
        // },
        onConfirmBtnTap: () {
          myTap();
        });
  }

  Future<dynamic> popUpTap(context, textValue, myTap) {
    return CoolAlert.show(
        loopAnimation: true,
        context: context,
        type: CoolAlertType.info,
        // text: textValue,
        confirmBtnColor: myColor.primaryColorDark,
        backgroundColor: myColor.primaryColorDark,
        widget: Text(
          textValue,
          textAlign: TextAlign.center,
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
          ),
        ),
        onConfirmBtnTap: () {
          myTap();
        });
  }

  clearLocalStorage() {
    sharedPrefs.removeFromDevice('isChecked');
    sharedPrefs.removeFromDevice('showCase1');
    sharedPrefs.removeFromDevice('token');
    sharedPrefs.removeFromDevice('tokenId');
    sharedPrefs.removeFromDevice('userProfile');
    sharedPrefs.removeFromDevice('familyId');
    sharedPrefs.removeFromDevice('roleID');
    sharedPrefs.removeFromDevice('myPassword');
    sharedPrefs.removeFromDevice('email');
    sharedPrefs.removeFromDevice('docBookingRespID');
    sharedPrefs.removeFromDevice('username');
    sharedPrefs.removeFromDevice('userType');
    sharedPrefs.removeFromDevice('showGlobalFormUI');
    sharedPrefs.removeFromDevice('doctorProfile');
    sharedPrefs.removeFromDevice('nurseProfile');
  }
}

final pop_upHelper = popUpHelper();
