import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDevice extends StatefulWidget {
  const VerifyDevice({Key? key}) : super(key: key);

  @override
  State<VerifyDevice> createState() => _VerifyDeviceState();
}

class _VerifyDeviceState extends State<VerifyDevice> {
  String currentText = "";
  StateHandlerBloc? btnBloc = StateHandlerBloc();
  StateHandlerBloc stepperBloc = StateHandlerBloc();
  ProfileModel? profileModel;
  final _otpForm = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String? testOTP, phoneNumber;

  void _verifyOTPBtn(context) async {
    var isValid = _otpForm.currentState?.validate();
    if (!isValid!) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    btnBloc!.storeData(true);
    int statusCode = await API().postData(
        context, VerifyDeviceModel(otp: currentText), 'verify-login-otp');
    if (statusCode == 200) {
      btnBloc!.storeData(false);
      sharedPrefs.removeFromDevice("phoneNumber");
      mySnackbar.mySnackBar(context, 'Device Verified', kGreen);
      Navigator.pop(
        context,
        GetIDNameModel(name: 'otpVerified'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    testOTP = sharedPrefs.getFromDevice("loggedId");
    phoneNumber = sharedPrefs.getFromDevice("phoneNumber");
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Verify New Device',
          color: backgroundColor,
          borderRadius: 12.0,
          showHomeIcon: Container(),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(), child: firstStepWidget()),
        floatingActionButton: FloatingActionButton(
          isExtended: true,
          elevation: 0.0,
          backgroundColor: myColor.primaryColorDark,
          onPressed: () {
            _verifyOTPBtn(context);
          },
          child: StreamBuilder<dynamic>(
            initialData: false,
            stream: btnBloc!.stateStream,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data) {
                  case true:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.0,
                          backgroundColor: myColor.dialogBackgroundColor),
                    );
                  case false:
                    return const Icon(
                      FontAwesomeIcons.arrowRight,
                      size: 18.0,
                      color: Colors.white,
                    );
                }
              }
              return const SizedBox();
            }),
          ),
        ),
      ),
    );
  }

  Widget firstStepWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            width: maxWidth(context) / 2,
            height: maxHeight(context) / 4,
          ),
          const SizedBox12(),
          Text(
            'OTP Verification',
            style: kStyleNormal.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Text.rich(
            TextSpan(
              text: 'Enter the OTP sent to ',
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                color: Colors.grey[400],
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: phoneNumber,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox16(),
          Form(
            key: _otpForm,
            child: PinCodeTextField(
              enablePinAutofill: true,
              appContext: context,
              pastedTextStyle: TextStyle(
                fontSize: 15.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter the OTP';
                }
                if (currentText != testOTP!.substring(testOTP!.length - 6)) {
                  return "Invalid OTP";
                } else {
                  return null;
                }
              },
              pinTheme: PinTheme(
                inactiveColor: myColor.primaryColorDark,
                activeColor: myColor.primaryColorDark,
                borderWidth: 1.3,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 40,
              ),
              textStyle: kStyleNormal.copyWith(
                fontSize: 18.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: myColor.primaryColorDark,
              animationDuration: const Duration(milliseconds: 300),
              errorAnimationController: errorController,
              controller: otpController,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                if (testOTP!.substring(testOTP!.length - 6) == currentText) {
                  _verifyOTPBtn(context);
                }
              },
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                return true;
              },
            ),
          ),
          const SizedBox16(),
          infoCard(
            context,
            myColor.dialogBackgroundColor,
            myColor.primaryColorDark,
            'Test purpose - Otp is  $testOTP disabled, use this OTP = ${testOTP!.substring(testOTP!.length - 6)}',
          ),
        ],
      ),
    );
  }
}
