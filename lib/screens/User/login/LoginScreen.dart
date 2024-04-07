import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/LoginEmailAutoSuggestionModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/ForgetPassword/ForgotPassword.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/login/VerifyDevice.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/register/RegisterScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pusher_client/pusher_client.dart';

class LoginScreen extends StatefulWidget {
  final String? logout;
  const LoginScreen({Key? key, this.logout}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _phoneOrEmail, fcm;
  String countryCode = '+977';
  String? _password, biometricEmail, biometricPassword;
  bool _isChecked = false;
  final bool _isLoading = false;
  bool _showLoginPopUp = false;
  final _form = GlobalKey<FormState>();
  final _emailForm = GlobalKey<FormState>();
  PusherClient? pusher;
  Channel? channel;
  List<String> charList = [];
  GetIDNameModel? getIDNameModel;
  final GlobalKey<State> loadingKey = GlobalKey<State>();
  bool _hiddenPassword = true;
  bool isKeyboard = false;
  int exitCounter = 0;
  final FocusNode _phoneOrEmailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final LocalAuthentication auth = LocalAuthentication();
  String? isAmbulanceTracking;
  StateHandlerBloc? showPhoneBloc,
      qrBloc,
      timerBloc,
      showHideQRBloc,
      showAutoSuggestionBloc;
  TextEditingController myText = TextEditingController();
  bool? isBiometricSupported;
  List<LoginAutoSuggestionModel> mySuggestionList = [];
  List<LoginAutoSuggestionModel> filteredSuggestionList = [];
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    sharedPrefs.removeFromDevice('checkInternet');
    myCheckBiometricSupport();
    charList.add('a');
    showPhoneBloc = StateHandlerBloc();
    showHideQRBloc = StateHandlerBloc();
    qrBloc = StateHandlerBloc();
    timerBloc = StateHandlerBloc();
    showAutoSuggestionBloc = StateHandlerBloc();
    getFromLocalDb();
    biometricEmail = sharedPrefs.getFromDevice("biometricEmail");
    biometricPassword = sharedPrefs.getFromDevice("biometricPassword");
    isAmbulanceTracking = sharedPrefs.getFromDevice('isAmbulanceTracking');
    bool showCheck = sharedPrefs.getBooleanFromDevice("isChecked");
  }

  getFromLocalDb() async {
    mySuggestionList = await MyDatabase.instance.fetchEmailsFromDb();
    setState(() {});
  }

  myCheckBiometricSupport() async {
    isBiometricSupported = await checkBiometricSupport();
    setState(() {});
  }

  showLogoutBottomModelSheet(context) {
    Future.delayed(const Duration(seconds: 0)).then((_) {
      showModalBottomSheet(
          context: context,
          backgroundColor: backgroundColor,
          isScrollControlled: true,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (builder) {
            return StatefulBuilder(builder: (c, setState) {
              return GestureDetector(
                onTap: () {
                  myfocusRemover(context);
                },
                child: Container(
                  width: maxWidth(context),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
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
                        'Logged Out',
                        style: kStyleNormal.copyWith(
                          color: myColor.primaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox16(),
                      Text(
                        'New device detected, you have been logged out.',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox16(),
                    ],
                  ),
                ),
              );
            });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.logout == 'qrLogout' && _showLoginPopUp == false) {
      _showLoginPopUp = true;
      showLogoutBottomModelSheet(context);
    }
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      if (isKeyboard == false) {
        showHideQRBloc!.storeData(true);
      }
      isKeyboard = true;
    } else {
      isKeyboard = false;
      showHideQRBloc!.storeData(false);
    }
    return WillPopScope(
      onWillPop: () async {
        exitCounter = exitCounter + 1;
        if (exitCounter == 2) {
          exitCounter = 0;
          SystemNavigator.pop();
          return false;
        } else {
          myToast.toast('Press back again to exit');
          return false;
        }
      },
      child: GestureDetector(
        onTap: () {
          myfocusRemover(context);
          showAutoSuggestionBloc!.storeData(false);
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: StreamBuilder<dynamic>(
              initialData: false,
              stream: showHideQRBloc!.stateStream,
              builder: (context, showHideQRBlocSnap) {
                return showHideQRBlocSnap.data == true
                    ? Container()
                    : FloatingActionButton.extended(
                        backgroundColor: myColor.primaryColorDark,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: myColor.dialogBackgroundColor,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: ((builder) => StreamBuilder<dynamic>(
                                  initialData: false,
                                  stream: timerBloc!.stateStream,
                                  builder: (context, timeSnap) {
                                    return myExpandedSheetCard(timeSnap.data);
                                  }))).then((value) async {
                            pusher!.unsubscribe('my-channel');
                            await pusher!.disconnect();
                          });
                        },
                        icon: Icon(
                          Icons.qr_code,
                          color: kWhite,
                          size: 25.0,
                        ),
                        label: Text(
                          'Login With QR',
                          style: kStyleNormal.copyWith(
                            color: kWhite,
                            fontSize: 12,
                          ),
                        ),
                      );
              }),
          body: SizedBox(
            width: maxWidth(context),
            height: maxHeight(context),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox24(),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: 180.0,
                                  height: 180.0,
                                ),
                              ),
                            ),
                            const SizedBox24(),
                            Form(
                              key: _emailForm,
                              child: myLoginEmailTextFormField(
                                context,
                                _phoneOrEmailFocusNode,
                                'Email/Number',
                                'Email or Phone',
                                'Enter Email or Phone',
                                _phoneOrEmail,
                                Icons.perm_identity_outlined,
                                kWhite,
                                onValueChanged: (value) async {
                                  _phoneOrEmail = value;
                                  if (value.isNotEmpty) {
                                    filteredSuggestionList = await MyDatabase
                                        .instance
                                        .fetchOnlyEmailOrPhoneFromSearchInput(
                                            value);
                                    setState(() {});
                                    if (filteredSuggestionList.isNotEmpty) {
                                      showAutoSuggestionBloc!.storeData(true);
                                    } else {
                                      showAutoSuggestionBloc!.storeData(false);
                                    }
                                  } else {
                                    charList.add('a');
                                    showAutoSuggestionBloc!.storeData(false);
                                  }

                                  if (_phoneOrEmail!.length >= 3 &&
                                      _phoneOrEmail![0]
                                          .contains(RegExp(r'[0-9]')) &&
                                      _phoneOrEmail![1]
                                          .contains(RegExp(r'[0-9]')) &&
                                      _phoneOrEmail![2]
                                          .contains(RegExp(r'[0-9]'))) {
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
                                    for (var rune in _phoneOrEmail!.runes) {
                                      var character = String.fromCharCode(rune);
                                      if (!numberList.contains(character)) {
                                        charList.add(character);
                                      }
                                    }
                                    if (charList.isNotEmpty) {
                                      showPhoneBloc!.storeData(false);
                                    } else {
                                      showPhoneBloc!.storeData(true);
                                    }
                                  } else {
                                    showPhoneBloc!.storeData(false);
                                  }
                                },
                              ),
                            ),
                            Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox16(),
                                    Text(
                                      'Password',
                                      style: kStyleNormal.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox16(),
                                    Focus(
                                      focusNode: _passwordFocusNode,
                                      child: TextFormField(
                                        style: kStyleNormal.copyWith(
                                          fontSize: 12.0,
                                          color: _passwordFocusNode.hasFocus
                                              ? Colors.black
                                              : Colors.black,
                                        ),
                                        obscureText: _hiddenPassword,
                                        onChanged: (String value) {
                                          _password = value;
                                        },
                                        onTap: () {
                                          showAutoSuggestionBloc!
                                              .storeData(false);
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            borderSide: BorderSide(
                                                color: myColor.primaryColorDark,
                                                width: 1.5),
                                          ),
                                          errorStyle: kStyleNormal.copyWith(
                                              color: Colors.red,
                                              fontSize: 12.0),
                                          prefixIcon: const Icon(
                                            Icons.lock_outlined,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _hiddenPassword =
                                                    !_hiddenPassword;
                                              });
                                            },
                                            child: Icon(
                                              _hiddenPassword
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
                                          _password = v;
                                        },
                                      ),
                                    ),
                                    const SizedBox8(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    myColor.primaryColorDark,
                                                side: const BorderSide(
                                                    width: 1.0,
                                                    color: Colors.grey),
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal: -4),
                                                value: _isChecked,
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    _isChecked = newValue!;
                                                  });
                                                }),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              'Stay Logged In',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            goThere(context,
                                                const NewPasswordScreen());
                                          },
                                          child: Text(
                                            'Forgot Password?',
                                            style: kStyleNormal.copyWith(
                                              color: myColor.primaryColorDark,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox8(),
                                  ],
                                ),
                                StreamBuilder<dynamic>(
                                    initialData: false,
                                    stream: showAutoSuggestionBloc!.stateStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == false) {
                                        return Container();
                                      } else {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: myColor
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(12.0),
                                                      bottomRight:
                                                          Radius.circular(
                                                              12.0))),
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  filteredSuggestionList.length,
                                              itemBuilder: (ctx, i) {
                                                var data =
                                                    filteredSuggestionList[i];
                                                int startIndex = 0;
                                                int endIndex = 0;
                                                if (data.phone != null &&
                                                    int.tryParse(
                                                            _phoneOrEmail!) !=
                                                        null) {
                                                  startIndex = data.phone!
                                                      .indexOf(_phoneOrEmail!);
                                                  endIndex = startIndex +
                                                      _phoneOrEmail!.length;
                                                }
                                                if (data.email != null &&
                                                    int.tryParse(
                                                            _phoneOrEmail!) ==
                                                        null) {
                                                  startIndex = data.email!
                                                      .toLowerCase()
                                                      .indexOf(_phoneOrEmail!
                                                          .toLowerCase());
                                                  endIndex = startIndex +
                                                      _phoneOrEmail!
                                                          .toLowerCase()
                                                          .length;
                                                }

                                                return GestureDetector(
                                                  onTap: () {
                                                    _emailController.clear();
                                                    if (int.tryParse(
                                                            _phoneOrEmail!) !=
                                                        null) {
                                                      if (_phoneOrEmail!
                                                              .length <
                                                          3) {
                                                        String phone = data
                                                            .phone!
                                                            .toString();
                                                        _emailController.text =
                                                            phone;
                                                        _emailController
                                                                .selection =
                                                            TextSelection.collapsed(
                                                                offset:
                                                                    _emailController
                                                                        .text
                                                                        .length);
                                                      } else {
                                                        String phone = data
                                                            .phone!
                                                            .toString()
                                                            .substring(4, 14);
                                                        _emailController.text =
                                                            phone;
                                                        _emailController
                                                                .selection =
                                                            TextSelection.collapsed(
                                                                offset:
                                                                    _emailController
                                                                        .text
                                                                        .length);
                                                      }
                                                    } else {
                                                      String email = data.email!
                                                          .toString();
                                                      _emailController.text =
                                                          email;
                                                      _emailController
                                                              .selection =
                                                          TextSelection.collapsed(
                                                              offset:
                                                                  _emailController
                                                                      .text
                                                                      .length);
                                                    }
                                                    showAutoSuggestionBloc!
                                                        .storeData(false);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 17.0,
                                                        vertical: 0.0),
                                                    child: Column(
                                                      children: [
                                                        i == 0
                                                            ? const SizedBox12()
                                                            : Container(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              int.tryParse(
                                                                          _phoneOrEmail!) !=
                                                                      null
                                                                  ? Icons
                                                                      .call_outlined
                                                                  : Icons
                                                                      .mail_outlined,
                                                              size: 16,
                                                              color: kBlack,
                                                            ),
                                                            const SizedBox(
                                                                width: 14.0),
                                                            Expanded(
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  style: kStyleNormal
                                                                      .copyWith(
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: int.tryParse(_phoneOrEmail!) !=
                                                                              null
                                                                          ? data.phone!.substring(
                                                                              0,
                                                                              startIndex)
                                                                          : data.email!.substring(
                                                                              0,
                                                                              startIndex),
                                                                      style: kStyleNormal
                                                                          .copyWith(
                                                                        fontSize:
                                                                            12.0,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: int.tryParse(_phoneOrEmail!) !=
                                                                              null
                                                                          ? data.phone!.substring(
                                                                              startIndex,
                                                                              endIndex)
                                                                          : data.email!.substring(
                                                                              startIndex,
                                                                              endIndex),
                                                                      style: kStyleNormal.copyWith(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: myColor
                                                                              .primaryColorDark,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    TextSpan(
                                                                      text: int.tryParse(_phoneOrEmail!) !=
                                                                              null
                                                                          ? data.phone!.substring(
                                                                              endIndex)
                                                                          : data
                                                                              .email!
                                                                              .substring(
                                                                              endIndex,
                                                                            ),
                                                                      style: kStyleNormal
                                                                          .copyWith(
                                                                        fontSize:
                                                                            12.0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        i !=
                                                                filteredSuggestionList
                                                                        .length -
                                                                    1
                                                            ? Column(
                                                                children: [
                                                                  const SizedBox2(),
                                                                  const SizedBox2(),
                                                                  Divider(
                                                                      color:
                                                                          backgroundColor),
                                                                  const SizedBox2(),
                                                                  const SizedBox2(),
                                                                ],
                                                              )
                                                            : const SizedBox12()
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: maxWidth(context),
                                    height: 60,
                                    child: myButton(
                                      context,
                                      myColor.primaryColorDark,
                                      'Login',
                                      () {
                                        loginBtn(context);
                                      },
                                    ),
                                  ),
                                ),
                                isBiometricSupported == true
                                    ? biometricEmail == null
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              loginWithBiometric(context);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10.0),
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: myColor.primaryColorDark,
                                              ),
                                              child: Icon(
                                                Icons.fingerprint_outlined,
                                                color: kWhite,
                                                size: 35.0,
                                              ),
                                            ),
                                          )
                                    : Container(),
                              ],
                            ),
                            const SizedBox12(),
                            GestureDetector(
                              onTap: () {
                                goThere(context, const RegisterScreen());
                              },
                              child: Container(
                                width: maxWidth(context),
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: myColor.primaryColorDark),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have an account?',
                                      style: kStyleNormal.copyWith(),
                                    ),
                                    Text(
                                      ' Register',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox16(),
                            GestureDetector(
                              onTap: () async {
                                sharedPrefs
                                    .removeFromDevice('isAmbulanceTracking');
                                sharedPrefs.removeFromDevice('ambulanceLat');
                                sharedPrefs.removeFromDevice('ambulanceLng');
                                sharedPrefs.removeFromDevice('token');
                                ProfileModel profileModel = ProfileModel(
                                  member: Member(
                                      firstName: 'Guest',
                                      name: 'Guest',
                                      email: 'guest@gmail,com'),
                                  // imagePath:
                                  //     'https://www.google.com/imgres?imgurl=https%3A%2F%2Fcdn.icon-icons.com%2Ficons2%2F1378%2FPNG%2F512%2Favatardefault_92824.png&imgrefurl=https%3A%2F%2Ficon-icons.com%2Ficon%2Favatar-default-user%2F92824&tbnid=G1GtLIoK7BPRZM&vet=12ahUKEwjpwOjvodD7AhX8K7cAHSniAIkQMygFegUIARDzAQ..i&docid=Db02IJWYsaweqM&w=512&h=512&q=user%20icon%20image&client=opera-gx&ved=2ahUKEwjpwOjvodD7AhX8K7cAHSniAIkQMygFegUIARDzAQ',
                                );
                                sharedPrefs.storeToDevice(
                                    "userProfile", jsonEncode(profileModel));
                                goThere(
                                    context,
                                    const MainHomePage(
                                      index: 0,
                                      tabIndex: 0,
                                    ));
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'View as Guest',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox12(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  connectSocketIO(key) async {
    pusher = PusherClient(
      'cd3ed25c9be7e1f981d8',
      PusherOptions(
        cluster: 'ap2',
      ),
    );
    await pusher!.connect();
    channel = pusher!.subscribe('my-channel');
    channel!.bind('my-event', (event) {
      QrLoginRespModel qrLoginRespModel =
          QrLoginRespModel.fromJson(json.decode(event!.data.toString()));
      if (key == qrLoginRespModel.message) {
        sharedPrefs.storeToDevice("token", qrLoginRespModel.token.toString());
        login();
      }
    });
  }

  login() async {
    var resp = await API().getData(context, endpoints.getUserProfileEndpoint);
    if (resp != null) {
      Navigator.pop(context);
      goThere(context, const MainHomePage(index: 0, tabIndex: 0));
      pop_upHelper.customAlert(
          context, 'SUCCESS', 'Successfully logged in via QR.');
      pusher!.unsubscribe('my-channel');
      await pusher!.disconnect();
    }
  }

  Widget myExpandedSheetCard(timerBoolValue) {
    GetFCMToken(context);
    fcm = sharedPrefs.getFromDevice('fcm');
    getQrKey(setState) async {
      var resp = await API().getPostResponseData(context,
          PostQrFcmModel(fcm: fcm), endpoints.postAndReceiveQRkeyEndpoint);
      if (resp != null) {
        GetQrKeyModel getQrKeyModel = GetQrKeyModel.fromJson(resp);
        qrBloc!.storeData(getQrKeyModel.key);
      } else {
        qrBloc!.storeData('error');
      }
    }

    if (timerBoolValue == false) {
      getQrKey(setState);
    }
    return StatefulBuilder(builder: (context, setState) {
      void startRefreshQr() {
        Timer.periodic(const Duration(seconds: 30), (Timer t) {
          getQrKey(setState);
        });
      }

      if (timerBoolValue != false) {
        startRefreshQr();
      }

      if (timerBoolValue == false) {
        timerBloc!.storeData(true);
      }
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: StreamBuilder<dynamic>(
            initialData: 'loading',
            stream: qrBloc!.stateStream,
            builder: (context, snap) {
              connectSocketIO(snap.data);
              if (snap.data == 'error') {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 20.0),
                  child: SizedBox(
                    height: 60.0,
                    child: infoCard(
                        context,
                        myColor.dialogBackgroundColor,
                        myColor.primaryColorDark,
                        'Something went again. Please try again !'),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    myfocusRemover(context);
                  },
                  child: Container(
                    width: maxWidth(context),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox16(),
                        Container(
                          width: 40,
                          height: 6,
                          decoration: BoxDecoration(
                            color: myColor.primaryColorDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox16(),
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: backgroundColor,
                          child: Image.asset('assets/logo.png'),
                        ),
                        Text(
                          'My Login QR',
                          style: kStyleNormal.copyWith(
                            color: myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox16(),
                        snap.data == 'loading'
                            ? Stack(
                                children: [
                                  myQr('snap.data', 'login'),
                                  Positioned(
                                    child: Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        color: kWhite.withOpacity(0.9),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    top: 1,
                                    bottom: 1,
                                    left: 1,
                                    right: 1,
                                    child: AnimatedLoading(),
                                  ),
                                ],
                              )
                            : myQr(snap.data, 'login'),
                        const SizedBox24(),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'To login scan this ',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'QR ',
                                  style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'with your ',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                  ),
                                ),
                                TextSpan(
                                  text: 'primary device ',
                                  style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '.',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      );
    });
  }

  void loginBtn(context) async {
    myfocusRemover(context);
    showHideQRBloc!.storeData(false);

    bool connection = await checkInternetConnection();
    if (connection == true) {
      int statusCode;
      var isValid = _form.currentState?.validate();
      var isValidEmail = _emailForm.currentState?.validate();
      if (!isValid! && !isValidEmail!) {
        return;
      } else {
        loginLoading();
        statusCode = await API().postData(
            context,
            LoginModel(
              password: _password,
              email: charList.isEmpty
                  ? '$countryCode${_emailController.text}'
                  : _emailController.text,
              platform: 'mobile',
              uniqueId: await getDeviceUniqueId(),
            ),
            endpoints.loginEndpoint);

        if (statusCode == 200) {
          String isSchool = sharedPrefs.getFromDevice("isSchool") ?? 'empty';
          if (isSchool == "isSchool") {
            Navigator.pop(context);
            sharedPrefs.removeFromDevice("isSchool");
            pop_upHelper.popUpNavigatorPop(
              context,
              1,
              CoolAlertType.error,
              "In order to login from a school account, please visit ASAout website.",
            );
          } else {
            String loggedId = sharedPrefs.getFromDevice("loggedId");
            if (loggedId == "Two Factor Authorization Is Disabled" ||
                loggedId == 'Already Logged In Device') {
              sharedPrefs.storeBooleanToDevice("isChecked", _isChecked);
              sharedPrefs.storeToDevice("myPassword", _password);
              await API().getData(context, endpoints.getUserProfileEndpoint);
              isAmbulanceTracking == 'showAmbulanceForm' ||
                      isAmbulanceTracking == 'showTrackingScreen'
                  ? goThere(context, const GoogleMapAmbulanceUserSide())
                  : goThere(
                      context,
                      const MainHomePage(
                        tabIndex: 0,
                        index: 0,
                      ));
              String userID = sharedPrefs.getUserID("userID");
              if (mySuggestionList.length <= 2) {
                if (mySuggestionList.isEmpty) {
                  addToDB(userID);
                } else {
                  var userIdExists =
                      await MyDatabase.instance.checkIfUserIdExits(userID);
                  if (userIdExists == true) {
                    updateEitherPhoneOrEmail(userID);
                  } else {
                    addToDB(userID);
                  }
                }
              } else {
                var userIdExists =
                    await MyDatabase.instance.checkIfUserIdExits(userID);
                if (userIdExists == false) {
                  replaceEmailInDB(userID);
                } else {
                  updateEitherPhoneOrEmail(userID);
                }
              }
            } else {
              Navigator.pop(context);
              var getIDNameModel = await goThere(context, const VerifyDevice());
              if (getIDNameModel.name == 'otpVerified') {
                loginBtn(context);
              }
            }
          }
        }
      }
    } else {
      mySnackbar.mySnackBar(context, 'No internet connection', kRed);
    }
  }

  replaceEmailInDB(userID) async {
    var myRowID = await MyDatabase.instance.findOldestDateRow();
    await MyDatabase.instance.replaceEmailWholeRow(
      userID,
      charList.isEmpty ? '$countryCode$_phoneOrEmail' : null,
      charList.isEmpty ? null : _phoneOrEmail,
      myRowID,
    );
  }

  updateEitherPhoneOrEmail(userID) async {
    var columnName =
        await MyDatabase.instance.checkIfEmailOrPhoneIsNullOrNOt(userID);
    if (columnName == 'phone' && charList.isEmpty) {
      await MyDatabase.instance
          .updatePhoneOrEmail(userID, columnName, '$countryCode$_phoneOrEmail');
    } else if (columnName == 'email' && charList.isNotEmpty) {
      await MyDatabase.instance
          .updatePhoneOrEmail(userID, columnName, _phoneOrEmail);
    }
  }

  addToDB(userID) {
    var myData = LoginAutoSuggestionModel(
      email: charList.isEmpty ? null : _phoneOrEmail,
      phone: charList.isEmpty ? '$countryCode$_phoneOrEmail' : null,
      userId: int.parse(userID.toString()),
      date: DateTime.now().toString(),
    );
    MyDatabase.instance.addLoginAutoSuggestionToDb(myData);
  }

  loginWithBiometric(context) async {
    bool connection = await checkInternetConnection();
    if (connection == true) {
      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        loginLoading();
        int statusCode;
        statusCode = await API().postData(
            context,
            LoginModel(
              password: biometricPassword,
              email: biometricEmail,
              platform: 'mobile',
              uniqueId: await getDeviceUniqueId(),
            ),
            endpoints.loginEndpoint);

        if (statusCode == 200) {
          sharedPrefs.storeBooleanToDevice("isChecked", _isChecked);
          sharedPrefs.storeToDevice("myPassword", biometricPassword);
          await API().getData(context, endpoints.getUserProfileEndpoint);
          isAmbulanceTracking == 'showAmbulanceForm' ||
                  isAmbulanceTracking == 'showTrackingScreen'
              ? goThere(context, const GoogleMapAmbulanceUserSide())
              : goThere(
                  context,
                  const MainHomePage(
                    tabIndex: 0,
                    index: 0,
                  ));
        }
      }
    } else {
      mySnackbar.mySnackBar(context, 'No internet connection', kRed);
    }
  }

  Widget myLoginEmailTextFormField(BuildContext context, FocusNode focusNode,
      titleText, hintText, errorMessage, textValue, intialIcon, bgColor,
      {required ValueChanged<String>? onValueChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            color: kBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        StreamBuilder<dynamic>(
            initialData: false,
            stream: showAutoSuggestionBloc!.stateStream,
            builder: (context, snapshot) {
              return Focus(
                focusNode: focusNode,
                child: TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    color: kBlack,
                  ),
                  onChanged: (String value) {
                    bool? isValid;
                    if (value.isEmpty) {
                      isValid == null;
                    }
                    isValid = _emailForm.currentState?.validate();
                    onValueChanged!(value);
                  },
                  decoration: InputDecoration(
                    errorMaxLines: 2,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                    filled: true,
                    fillColor: bgColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(snapshot.data == true ? 0.0 : 8.0),
                        bottomRight:
                            Radius.circular(snapshot.data == true ? 0.0 : 8.0),
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: bgColor, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(snapshot.data == true ? 0.0 : 8.0),
                        bottomRight:
                            Radius.circular(snapshot.data == true ? 0.0 : 8.0),
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                          color: myColor.primaryColorDark, width: 1.5),
                    ),
                    errorStyle:
                        kStyleNormal.copyWith(color: kRed, fontSize: 12.0),
                    prefixIcon: StreamBuilder<dynamic>(
                        initialData: false,
                        stream: showPhoneBloc!.stateStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == false) {
                            return Icon(
                              intialIcon,
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
                                padding: const EdgeInsets.only(left: 11.0),
                                decoration: BoxDecoration(
                                  color: kTransparent,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: InternationalPhoneNumberInput(
                                    hintText: hintText.replaceAll('+977', ''),
                                    onInputChanged: (PhoneNumber number) {
                                      setState(() {
                                        countryCode =
                                            number.phoneNumber.toString();
                                      });
                                    },
                                    selectorConfig: const SelectorConfig(
                                      useEmoji: true,
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    spaceBetweenSelectorAndTextField: 0,
                                    selectorTextStyle:
                                        const TextStyle(color: Colors.black),
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
                    hintText: hintText,
                    hintStyle: kStyleNormal.copyWith(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return errorMessage;
                    } else if (!RegExp(r'^[a-zA-Z0-9.@-]+$').hasMatch(v)) {
                      return '* Sorry, only letters (a-z), numbers (0-9), and periods(.) are allowed.';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    textValue = v;
                  },
                ),
              );
            }),
      ],
    );
  }

  loginLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async => true,
              child: SimpleDialog(
                  insetPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  backgroundColor: myColor.dialogBackgroundColor,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        const SizedBox16(),
                        const SizedBox16(),
                        const SizedBox16(),
                        const SizedBox16(),
                        const AnimatedLoading(),
                        const SizedBox16(),
                        const SizedBox16(),
                        Text(
                          'Logging In',
                          style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                        const SizedBox16(),
                        const SizedBox16(),
                      ]),
                    )
                  ]));
        });
  }
}
