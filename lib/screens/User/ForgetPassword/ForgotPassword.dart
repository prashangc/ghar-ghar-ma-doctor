import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  int currentStep = 0;
  String? _email, _myOTP;
  String currentText = "";
  int? isLastStep;

  String? _password, _confirmPassword;
  bool _hiddenPassword = true;
  bool _hiddenConfirmPassword = true;
  bool _isLoading = false;
  final _emailForm = GlobalKey<FormState>();
  final _otpForm = GlobalKey<FormState>();
  final _newPasswordForm = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            'Verify email',
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
            'Verify OTP',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: secondStepWidget(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text(
            'Enter new password',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: thirdStepWidget(),
        ),
      ];

  void _verifyEmailBtn() async {
    print('_verifyEmailBtn()');
    setState(() {
      _isLoading = true;
    });
    int statusCode;

    var isValid = _emailForm.currentState?.validate();
    if (!isValid!) {
      print('empty data');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    statusCode = await API().postData(
        context,
        PostForgetPasswordModel(email: _email),
        endpoints.postForgetPasswordEndpoint);
    if (statusCode == 200) {
      print('Success: $statusCode');

      setState(() {
        _myOTP = sharedPrefs.getFromDevice("otp");
        _isLoading = false;
        currentStep += 1;
      });
      print(_myOTP);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verifyOTPBtn() async {
    var isValid = _otpForm.currentState?.validate();
    if (!isValid!) {
      print('empty data');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    print('_verifyOTPBtn()');

    setState(() {
      _isLoading = true;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      currentStep += 1;
    });
  }

  void _changePassword() async {
    print('_changePassword');
    setState(() {
      _isLoading = true;
    });
    int statusCode;

    var isValid = _newPasswordForm.currentState?.validate();
    if (!isValid!) {
      print('empty data');
      setState(() {
        _isLoading = false;
      });
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    statusCode = await API().postData(
        context,
        PostChangePasswordModel(
            email: _email,
            password: _password,
            passwordConfirmation: _confirmPassword,
            code: currentText),
        endpoints.changePasswordEndpoint);
    if (statusCode == 200) {
      setState(() {
        sharedPrefs.removeFromDevice("otp");
        _isLoading = false;
      });
      pop_upHelper.popUpToNewScreen(context, CoolAlertType.success,
          'Password Changed successfully', const LoginScreen());
    } else {
      setState(() {
        _isLoading = false;
      });
      mySnackbar.mySnackBar(context, 'Error: $statusCode', Colors.red);
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
          title: 'Forget Password',
          color: backgroundColor,
          borderRadius: 12.0,
          showHomeIcon: Container(),
        ),
        body: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: myColor.primaryColorDark,
                ),
          ),
          child: Stepper(
              physics: const BouncingScrollPhysics(),
              elevation: 0,
              type: StepperType.vertical,
              onStepTapped: (int index) {
                if (currentStep != index) {
                  currentStep = currentStep;
                }
              },
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
            currentStep == 0
                ? _verifyEmailBtn()
                : currentStep == isLastStep
                    ? _changePassword()
                    : _verifyOTPBtn();
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
      key: _emailForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your email to recieve the verification code',
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
                _email = value;
                print(_email);
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
              hintText: 'Email',
              hintStyle: kStyleNormal.copyWith(
                  color: Colors.grey[400], fontSize: 12.0),
            ),
            validator: (v) {
              return EmailValidator.validate(v!)
                  ? null
                  : "Please enter a valid email";
            },
            onSaved: (v) {
              _email = v;
            },
          ),
        ],
      ),
    );
  }

  Widget secondStepWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify the OTP from $_email',
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox16(),
        Form(
          key: _otpForm,
          child: PinCodeTextField(
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
              if (currentText != _myOTP) {
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
              debugPrint("Completed");

              if (_myOTP == currentText) {
                _verifyOTPBtn();
              }
            },
            onChanged: (value) {
              debugPrint(value);
              setState(() {
                currentText = value;
              });
              print(currentText);
            },
            beforeTextPaste: (text) {
              debugPrint("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),
        ),
      ],
    );
  }

  Widget thirdStepWidget() {
    return Form(
      key: _newPasswordForm,
      child: Column(children: [
        TextFormField(
          style: kStyleNormal.copyWith(fontSize: 12.0),
          obscureText: _hiddenPassword,
          onChanged: (String value) {
            setState(() {
              _password = value;
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _hiddenPassword = !_hiddenPassword;
                });
              },
              child: Icon(
                _hiddenPassword ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey[300],
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: 'Password',
            hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return 'Enter your password';
            }
            return null;
          },
          onSaved: (v) {
            _password = v;
          },
        ),
        const SizedBox8(),
        TextFormField(
          style: kStyleNormal.copyWith(fontSize: 12.0),
          obscureText: _hiddenConfirmPassword,
          onChanged: (String value) {
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _hiddenConfirmPassword = !_hiddenConfirmPassword;
                });
              },
              child: Icon(
                _hiddenConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 20,
                color: Colors.grey[300],
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: 'Confirm Password',
            hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return 'Confirm your password';
            }
            if (_password != v) {
              return 'Password doesn\'t match';
            }
            return null;
          },
          onSaved: (v) {
            _confirmPassword = v;
          },
        ),
      ]),
    );
  }
}
