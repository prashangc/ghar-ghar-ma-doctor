import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class UpdateEmailScreen extends StatefulWidget {
  String email;
  UpdateEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<UpdateEmailScreen> createState() => _UpdateEmailScreenState();
}

class _UpdateEmailScreenState extends State<UpdateEmailScreen> {
  String currentText = "";
  int? isLastStep;
  StateHandlerBloc? btnBloc = StateHandlerBloc();
  StateHandlerBloc stepperBloc = StateHandlerBloc();
  ProfileModel? profileModel;
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  List<Step> getSteps(index) => [
        Step(
          state: index > 0 ? StepState.complete : StepState.indexed,
          isActive: index >= 0,
          title: Text(
            'Enter Email',
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

  void _verifyEmailBtn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    btnBloc!.storeData(true);
    int statusCode;
    statusCode = await API().postData(
        context,
        PatchProfileModel(email: widget.email),
        endpoints.updateEmailReceiveOtp);
    if (statusCode == 200) {
      stepperBloc.storeData(1);
      btnBloc!.storeData(false);
    } else {
      btnBloc!.storeData(false);
    }
  }

  void _verifyOTPBtn(context, otp) async {
    FocusManager.instance.primaryFocus?.unfocus();
    btnBloc!.storeData(true);
    int statusCode = await API().postData(
        context,
        PostOtpVerificationModel(
          otp: otp.toString(),
        ),
        endpoints.verifyEmailOtp);
    if (statusCode == 200) {
      btnBloc!.storeData(false);
      Navigator.pop(
        context,
        GetIDNameModel(
          id: '1',
        ),
      );
      pop_upHelper.customAlert(context, 'SUCCESS', 'Email verified');
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
          title: 'Update Email',
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
                  s.data == 0 ? _verifyEmailBtn() : _verifyOTPBtn(context, '1');
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your email to recieve the OTP code',
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
              widget.email = value;
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
            fillColor: kWhite,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: kWhite, width: 0.0),
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
            hintText: widget.email,
            hintStyle:
                kStyleNormal.copyWith(color: Colors.grey[400], fontSize: 12.0),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return "Enter your email";
            }
            return null;
          },
          onSaved: (v) {
            widget.email = v.toString();
          },
        ),
      ],
    );
  }

  Widget secondStepWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verify the OTP from ${widget.email}',
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox16(),
        PinCodeTextField(
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
            _verifyOTPBtn(context, currentText);
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
      ],
    );
  }
}
