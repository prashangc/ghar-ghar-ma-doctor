import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class UpdatePhoneNumberScreen extends StatefulWidget {
  final String? dob;
  final String? gender;
  const UpdatePhoneNumberScreen({Key? key, this.dob, this.gender})
      : super(key: key);

  @override
  State<UpdatePhoneNumberScreen> createState() =>
      _UpdatePhoneNumberScreenState();
}

class _UpdatePhoneNumberScreenState extends State<UpdatePhoneNumberScreen> {
  String? _phone, otpResponse;
  String currentText = "";
  int? isLastStep;
  StateHandlerBloc? btnBloc = StateHandlerBloc();
  StateHandlerBloc stepperBloc = StateHandlerBloc();
  ProfileModel? profileModel;
  final _phoneForm = GlobalKey<FormState>();
  final _otpForm = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    _phone = profileModel!.member!.phone;
  }

  List<Step> getSteps(index) => [
        Step(
          state: index > 0 ? StepState.complete : StepState.indexed,
          isActive: index >= 0,
          title: Text(
            'Enter Mobile No.',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: firstStepWidget(),
        ),
        Step(
          state: index > 1 ? StepState.complete : StepState.indexed,
          isActive: index >= 1,
          title: Text(
            'Verify OTP',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: secondStepWidget(),
        ),
      ];

  void _verifyPhoneBtn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    var isValid = _phoneForm.currentState?.validate();
    if (isValid!) {
      btnBloc!.storeData(true);
      int statusCode;
      statusCode = await API().postData(
          context,
          PatchProfileModel(
            name: profileModel!.member!.name,
            email: profileModel!.member!.email,
            dob: profileModel!.dob ?? widget.dob,
            gender: profileModel!.gender ?? widget.gender,
            phone: '+977$_phone',
          ),
          'admin/user-profile/update/${profileModel!.id}');
      if (statusCode == 200) {
        var resp = await API().getPostResponseData(
            context, PatchProfileModel(phone: '+977$_phone'), 'verify-phone');
        if (resp != null) {
          VerifyNumberOTPResp verifyNumberOTPResp =
              VerifyNumberOTPResp.fromJson(resp);
          otpResponse = verifyNumberOTPResp.otp.toString();
          stepperBloc.storeData(1);
        }
        btnBloc!.storeData(false);
      } else {
        btnBloc!.storeData(false);
      }
    }
  }

  void _verifyOTPBtn(context, otp) async {
    print('otp $otp');
    var isValid = _otpForm.currentState?.validate();
    if (!isValid!) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    btnBloc!.storeData(true);
    int statusCode = await API().postData(
        context,
        PostOtpVerificationModel(
          otp: otp.toString(),
        ),
        'verify-otp');
    if (statusCode == 200) {
      btnBloc!.storeData(false);
      Navigator.pop(
        context,
        GetIDNameModel(
          id: '1',
        ),
      );
      pop_upHelper.customAlert(context, 'SUCCESS', 'Phone number verified');
    } else {
      btnBloc!.storeData(false);
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
          title: 'Update Phone',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: myColor.primaryColorDark,
                ),
          ),
          child: StreamBuilder<dynamic>(
              initialData: 0,
              stream: stepperBloc.stateStream,
              builder: (context, snapshot) {
                return Stepper(
                    physics: const BouncingScrollPhysics(),
                    elevation: 0,
                    type: StepperType.vertical,
                    steps: getSteps(snapshot.data),
                    currentStep: snapshot.data,
                    controlsBuilder: (context, details) {
                      isLastStep = getSteps(snapshot.data).length - 1;
                      return Container();
                    });
              }),
        ),
        floatingActionButton: StreamBuilder<dynamic>(
            stream: stepperBloc.stateStream,
            initialData: 0,
            builder: (context, s) {
              return FloatingActionButton(
                isExtended: true,
                elevation: 0.0,
                backgroundColor: myColor.primaryColorDark,
                onPressed: () {
                  s.data == 0 ? _verifyPhoneBtn() : _verifyOTPBtn(context, '1');
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
                          return Icon(
                            isLastStep == s.data
                                ? FontAwesomeIcons.check
                                : FontAwesomeIcons.arrowRight,
                            size: 18.0,
                            color: Colors.white,
                          );
                      }
                    }
                    return const SizedBox();
                  }),
                ),
              );
            }),
      ),
    );
  }

  Widget firstStepWidget() {
    return Form(
      key: _phoneForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your mobile number to recieve the OTP code',
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
                _phone = value;
              });
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
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
              hintText: _phone ?? 'Mobile No.',
              hintStyle: kStyleNormal.copyWith(
                  color: Colors.grey[400], fontSize: 12.0),
            ),
            validator: (v) {
              if (v!.isEmpty) {
                return "Enter mobile number";
              }
              return null;
            },
            onSaved: (v) {
              _phone = v;
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
          'Verify the OTP from $_phone',
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            color: Colors.grey[400],
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
              if (currentText != otpResponse) {
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
              if (otpResponse == currentText) {
                _verifyOTPBtn(context, currentText);
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
      ],
    );
  }
}
