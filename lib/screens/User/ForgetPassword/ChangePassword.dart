import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  int currentStep = 0;
  String? _currentPassword, _newPassword, _confirmPassword;
  String currentText = "";
  int? isLastStep;
  final bool _hiddenPassword = true;
  final bool _hiddenConfirmPassword = true;
  bool _isLoading = false;
  final _currentPasswordForm = GlobalKey<FormState>();
  final _newPasswordForm = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            'Current Password',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: firstStepWidget(),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text(
            'New Password',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: secondStepWidget(),
        ),
      ];

  void changePasswordBtn() async {
    setState(() {
      _isLoading = true;
    });
    int statusCode;

    var isValid = _newPasswordForm.currentState?.validate();
    if (!isValid!) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    statusCode = await API().postData(
        context,
        PostChangeCurrentPasswordModel(
          currentPassword: _currentPassword,
          newPassword: _newPassword,
        ),
        endpoints.postChangePassword);
    if (statusCode == 200) {
      sharedPrefs.storeToDevice("myPassword", _newPassword);
      setState(() {
        _isLoading = false;
      });
      await pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.success, 'Password successfully changed');
      Navigator.pop(context);
    } else {
      mySnackbar.mySnackBar(
          context, 'Can\'t change password! Error: $statusCode', Colors.red);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Change Password',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Theme(
          data: ThemeData(
            canvasColor: Colors.red,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: myColor.primaryColorDark,
                  background: Colors.red,
                  secondary: Colors.green,
                ),
          ),
          child: Stepper(
              elevation: 0,
              type: StepperType.vertical,
              // onStepTapped: (int index) {
              //   if (currentStep != index) {
              //     currentStep = currentStep;
              //   }
              // },
              steps: getSteps(),
              currentStep: currentStep,
              controlsBuilder: (context, details) {
                isLastStep = getSteps().length - 1;
                return Container();
              }),
        ),
        floatingActionButton: FloatingActionButton(
          isExtended: true,
          elevation: 0.0,
          backgroundColor: myColor.primaryColorDark,
          onPressed: () {
            if (currentStep == 0) {
              var isValid = _currentPasswordForm.currentState?.validate();
              if (isValid!) {
                setState(() {
                  currentStep += 1;
                });
              }
            } else {
              changePasswordBtn();
            }
          },
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.0,
                      backgroundColor: myColor.dialogBackgroundColor),
                )
              : Icon(
                  isLastStep == currentStep
                      ? FontAwesomeIcons.check
                      : FontAwesomeIcons.arrowRight,
                  size: 18.0,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  Widget firstStepWidget() {
    return Form(
      key: _currentPasswordForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your current password',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox16(),
          TextFormField(
            style: kStyleNormal.copyWith(fontSize: 12.0),
            onChanged: (value) {
              setState(() {
                _currentPassword = value;
              });
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide:
                    BorderSide(color: myColor.primaryColorDark, width: 1.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.red, width: 0.0),
              ),
              errorStyle:
                  kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: 'Current Password',
              hintStyle: kStyleNormal.copyWith(
                  color: Colors.grey[400], fontSize: 12.0),
            ),
            validator: (v) {
              String myPassword = sharedPrefs.getFromDevice("myPassword");

              if (v!.isEmpty) {
                return 'Enter current password';
              } else if (myPassword != v) {
                return 'Old Password Incorrect';
              }
              return null;
            },
            onSaved: (v) {
              _currentPassword = v;
            },
          ),
        ],
      ),
    );
  }

  Widget secondStepWidget() {
    return Form(
      key: _newPasswordForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter New Password',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox8(),
          TextFormField(
            style: kStyleNormal.copyWith(fontSize: 12.0),
            onChanged: (value) {
              setState(() {
                _newPassword = value;
              });
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide:
                    BorderSide(color: myColor.primaryColorDark, width: 1.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.red, width: 0.0),
              ),
              errorStyle:
                  kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: 'New Password',
              hintStyle: kStyleNormal.copyWith(
                  color: Colors.grey[400], fontSize: 12.0),
            ),
            validator: (v) {
              String myPassword = sharedPrefs.getFromDevice("myPassword");
              if (v!.isEmpty) {
                return 'Enter new password';
              }
              if (myPassword == v) {
                return 'Cant\'t use old password';
              }
              return null;
            },
            onSaved: (v) {
              _newPassword = v;
            },
          ),
          const SizedBox12(),
          Text(
            'Confirm Password',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox8(),
          TextFormField(
            style: kStyleNormal.copyWith(fontSize: 12.0),
            onChanged: (value) {
              setState(() {
                _confirmPassword = value;
              });
            },
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide: BorderSide(color: Colors.white, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide:
                    BorderSide(color: myColor.primaryColorDark, width: 1.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.red, width: 0.0),
              ),
              errorStyle:
                  kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              hintText: 'Confirm Password',
              hintStyle: kStyleNormal.copyWith(
                  color: Colors.grey[400], fontSize: 12.0),
            ),
            validator: (v) {
              if (v!.isEmpty) {
                return 'Confirm new password';
              }

              if (_confirmPassword != _newPassword) {
                return 'Password doesn\'t match';
              }
              return null;
            },
            onSaved: (v) {
              _confirmPassword = v;
            },
          ),
          const SizedBox8(),
        ],
      ),
    );
  }
}
