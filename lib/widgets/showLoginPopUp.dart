import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/CheckoutScreen.dart';
import 'package:ghargharmadoctor/screens/User/book%20appointments/reviewBooking.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/home/ViewAllNurses/ReviewNurseBooking.dart';
import 'package:ghargharmadoctor/screens/User/login/VerifyDevice.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/register/RegisterScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

showLoginPopUp(BuildContext context, type,
    GuestLoginNavigationModel guestLoginNavigationModel) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    routeSettings: ModalRoute.of(context)!.settings,
    builder: ((builder) => LoginBottomSheet(
          type: type,
          guestLoginNavigationModel: guestLoginNavigationModel,
        )),
  );
}

class LoginBottomSheet extends StatefulWidget {
  final String? type;
  final GuestLoginNavigationModel? guestLoginNavigationModel;
  const LoginBottomSheet(
      {super.key, required this.type, required this.guestLoginNavigationModel});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final myForm = GlobalKey<FormState>();
  final emailForm = GlobalKey<FormState>();
  String? emailOrPhone, password;
  List<String> charList = [];
  String? isAmbulanceTracking;
  String countryCode = '+977';
  StateHandlerBloc continueBloc = StateHandlerBloc();
  StateHandlerBloc showPhoneBloc = StateHandlerBloc();
  @override
  Widget build(BuildContext context) {
    charList.add('a');
    isAmbulanceTracking = sharedPrefs.getFromDevice('isAmbulanceTracking');
    return loginBottomSheet(context);
  }

  Widget loginBottomSheet(context) {
    continueBtn() async {
      myfocusRemover(context);
      int statusCode;
      var isValid = myForm.currentState?.validate();
      if (!isValid!) {
        return;
      } else {
        continueBloc.storeData(1);
        statusCode = await API().postData(
            context,
            LoginModel(
                password: password,
                email: charList.isEmpty
                    ? '$countryCode$emailOrPhone'
                    : emailOrPhone),
            endpoints.loginEndpoint);
      }
      if (statusCode == 200) {
        String loggedId = sharedPrefs.getFromDevice("loggedId");
        if (loggedId == "Already Logged In Device") {
          sharedPrefs.storeToDevice("myPassword", password);
          await API().getData(context, endpoints.getUserProfileEndpoint);
          var test = sharedPrefs.getFromDevice("userProfile");
          ProfileModel profileModel = ProfileModel.fromJson(json.decode(test));
          if (isAmbulanceTracking == 'showAmbulanceForm' ||
              isAmbulanceTracking == 'showTrackingScreen') {
            goThere(context, const GoogleMapAmbulanceUserSide());
          } else {
            switch (widget.type) {
              case 'profileIcon':
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'buyProduct':
                goThere(
                  context,
                  CheckoutScreen(
                    cartDatabaseModel:
                        widget.guestLoginNavigationModel!.buyProduct!,
                    totalAmount: widget.guestLoginNavigationModel!.amount!,
                  ),
                );
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'buyPackage':
                var resp = await API()
                    .getData(context, endpoints.getIndividualPackageEndpoint);
                IndividualPackagesListModel individualPackagesListModel =
                    IndividualPackagesListModel.fromJson(resp);
                if (individualPackagesListModel.myPackage != null) {
                  Navigator.of(context)
                      .removeRoute(ModalRoute.of(context) as Route);

                  Navigator.pop(context);
                } else {
                  Navigator.of(context)
                      .removeRoute(ModalRoute.of(context) as Route);
                }
                break;
              case 'alreadyInCart':
                mySnackbar.mySnackBarCustomized(
                    context, 'Already in cart', 'View', () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  goThere(context, const MyCart());
                }, Colors.black.withOpacity(0.7));
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'addToCart':
                var dbHelper = MyDatabase.instance.addToCartLocalDB(
                    widget.guestLoginNavigationModel!.myCart!);
                mySnackbar.mySnackBarCustomized(
                    context, 'Already in cart', 'View', () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  goThere(context, const MyCart());
                }, Colors.black.withOpacity(0.7));
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'bookDoctor':
                goThere(
                    context,
                    ReviewBooking(
                      dateValue: widget.guestLoginNavigationModel!.dateValue!,
                      doctors: widget.guestLoginNavigationModel!.doctors!,
                      timeUniqueID:
                          widget.guestLoginNavigationModel!.timeUniqueID!,
                      timeValue: widget.guestLoginNavigationModel!.shiftValue!,
                      yourProblem:
                          widget.guestLoginNavigationModel!.yourProblem!,
                      consultationType: widget
                          .guestLoginNavigationModel!.selectedTimeShiftID!,
                    ));
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'bookNurse':
                goThere(
                    context,
                    ReviewNurseBooking(
                      allNurseModel:
                          widget.guestLoginNavigationModel!.allNurseModel!,
                      dateValue: widget.guestLoginNavigationModel!.dateValue!,
                      shiftValue: widget.guestLoginNavigationModel!.shiftValue!,
                      yourProblem:
                          widget.guestLoginNavigationModel!.yourProblem!,
                      totalAmount:
                          widget.guestLoginNavigationModel!.totalAmount!,
                      selectedTimeShiftID: widget
                          .guestLoginNavigationModel!.selectedTimeShiftID!,
                    ));
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'bookAmbulance':
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              case 'bookLab':
                Navigator.of(context)
                    .removeRoute(ModalRoute.of(context) as Route);
                break;
              default:
            }
            continueBloc.storeData(0);
            refreshMainSreenBloc.storeData(profileModel);
            refreshPackageBloc.storeData('a');
          }
        } else {
          continueBloc.storeData(0);
          var getIDNameModel = await goThere(context, const VerifyDevice());
          if (getIDNameModel.name == 'otpVerified') {
            continueBtn();
          }
        }
      }
    }

    bool hiddenPassword = true;
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              CircleAvatar(
                radius: 40.0,
                backgroundColor: backgroundColor,
                child: Image.asset('assets/logo.png'),
              ),
              Text(
                'Sign in to continue',
                style: kStyleNormal.copyWith(
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox16(),
              const SizedBox8(),
              Form(
                key: myForm,
                child: Column(
                  children: [
                    Form(
                      key: emailForm,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        onChanged: (String value) {
                          var isValid = emailForm.currentState?.validate();

                          emailOrPhone = value;
                          if (emailOrPhone!.length >= 3 &&
                              emailOrPhone![0].contains(RegExp(r'[0-9]')) &&
                              emailOrPhone![1].contains(RegExp(r'[0-9]')) &&
                              emailOrPhone![2].contains(RegExp(r'[0-9]'))) {
                            charList.clear();
                            List<String> numberList = [
                              '0',
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9'
                            ];
                            for (var rune in emailOrPhone!.runes) {
                              var character = String.fromCharCode(rune);
                              if (!numberList.contains(character)) {
                                charList.add(character);
                              }
                            }
                            if (charList.isNotEmpty) {
                              showPhoneBloc.storeData(false);
                            } else {
                              showPhoneBloc.storeData(true);
                            }
                          } else {
                            showPhoneBloc.storeData(false);
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16.0),
                            filled: true,
                            fillColor: kWhite,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              borderSide: BorderSide(color: kWhite, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              borderSide: BorderSide(
                                  color: myColor.primaryColorDark, width: 1.5),
                            ),
                            errorStyle: kStyleNormal.copyWith(
                                color: Colors.red, fontSize: 12.0),
                            prefixIcon: StreamBuilder<dynamic>(
                                initialData: false,
                                stream: showPhoneBloc.stateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data == false) {
                                    return const Icon(
                                      Icons.perm_identity_outlined,
                                      size: 16.0,
                                      color: Colors.black,
                                    );
                                  } else {
                                    return AnimatedSize(
                                      curve: Curves.elasticInOut,
                                      duration: const Duration(seconds: 9),
                                      child: Container(
                                        width: 104.0,
                                        height: 20.0,
                                        padding:
                                            const EdgeInsets.only(left: 11.0),
                                        decoration: BoxDecoration(
                                          color: kTransparent,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: SingleChildScrollView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          child: InternationalPhoneNumberInput(
                                            // hintText: hintText.replaceAll('+977', ''),
                                            onInputChanged:
                                                (PhoneNumber number) {
                                              countryCode =
                                                  number.phoneNumber.toString();
                                            },
                                            selectorConfig:
                                                const SelectorConfig(
                                              useEmoji: true,
                                              selectorType:
                                                  PhoneInputSelectorType
                                                      .BOTTOM_SHEET,
                                            ),
                                            ignoreBlank: false,
                                            autoValidateMode:
                                                AutovalidateMode.disabled,
                                            spaceBetweenSelectorAndTextField: 0,
                                            selectorTextStyle: const TextStyle(
                                                color: Colors.black),
                                            initialValue: PhoneNumber(
                                              isoCode: 'NP',
                                            ),
                                            formatInput: false,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            hintStyle: kStyleNormal.copyWith(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                            hintText: 'Email or Phone'),
                        validator: (v) {
                          // return EmailValidator.validate(v!)
                          //     ? null
                          //     : "Please enter a valid email";
                          if (v!.isEmpty) {
                            return 'Please enter email or phone';
                          } else if (v.contains(RegExp(r'[& ]'))) {
                            return '* Character(&, %, -, #, etc.) are not accepted.';
                          }
                          return null;
                        },
                        onSaved: (v) {
                          emailOrPhone = v;
                        },
                      ),
                    ),
                    const SizedBox12(),

                    // mytextFormFieldWithPrefixIcon(
                    //   context,
                    //   FocusNode(),
                    //   null,
                    //   'Email or Phone',
                    //   'Enter Email or Phone',
                    //   emailOrPhone,
                    //   Icons.perm_identity_outlined,
                    //   kWhite,
                    //   onValueChanged: (value) async {
                    //     emailOrPhone = value;
                    //   },
                    // ),

                    TextFormField(
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        color: kBlack,
                      ),
                      obscureText: hiddenPassword,
                      onChanged: (String value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
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
                          Icons.lock_outlined,
                          size: 16,
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
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      onSaved: (v) {
                        password = v;
                      },
                    ),
                    const SizedBox12(),
                  ],
                ),
              ),
              StreamBuilder<dynamic>(
                  initialData: 0,
                  stream: continueBloc.stateStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == 0) {
                      return SizedBox(
                        width: maxWidth(context),
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Continue',
                          kStyleNormal.copyWith(
                              color: Colors.white, fontSize: 14.0),
                          () {
                            continueBtn();
                          },
                        ),
                      );
                    } else {
                      return myBtnLoading(context, 50.0);
                    }
                  }),
              const SizedBox8(),
              GestureDetector(
                onTap: () {
                  goThere(context, const RegisterScreen());
                },
                child: Text(
                  'Register',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox24(),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By signing in you agree to our ',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'terms and condition ',
                        style: kStyleNormal.copyWith(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'and ',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text: 'privacy policy',
                        style: kStyleNormal.copyWith(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
