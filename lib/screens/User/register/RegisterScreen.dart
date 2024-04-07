import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final passwordForm = GlobalKey<FormState>();
  final confrimPasswordForm = GlobalKey<FormState>();
  final emailForm = GlobalKey<FormState>();

  String? firstName, middleName, lastName;
  String? _email;
  String? _roleID;
  String? _address;
  String? _phone;
  String? _password;
  String? _confirmPassword;
  bool _isChecked = false;
  bool _isLoading = false;
  bool _isBtnActive = false;
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _nmcNumberFocusNode = FocusNode();
  bool _hiddenPassword = true;
  bool _hiddenPassword2 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 60.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Create Account',
              style: kStyleNormal.copyWith(
                  fontSize: 18.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox12(),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 120.0,
                              height: 140.0,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: mytextFormFieldWithPrefixIcon(
                              context,
                              _fullNameFocusNode,
                              'First Name',
                              'First Name',
                              'Enter your firstname',
                              firstName,
                              Icons.perm_identity_outlined,
                              kWhite,
                              onValueChanged: (value) {
                                firstName = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: mytextFormFieldWithPrefixIcon(
                              context,
                              FocusNode(),
                              'Middle Name',
                              'Middle Name',
                              'Enter your middle name',
                              middleName,
                              Icons.perm_identity_outlined,
                              kWhite,
                              onValueChanged: (value) {
                                middleName = value;
                              },
                              validateStatus: false,
                            ),
                          ),
                        ],
                      ),
                      mytextFormFieldWithPrefixIcon(
                        context,
                        FocusNode(),
                        'Last Name',
                        'Last Name',
                        'Enter your last name',
                        lastName,
                        Icons.perm_identity_outlined,
                        kWhite,
                        onValueChanged: (value) {
                          lastName = value;
                        },
                      ),
                      Text(
                        'Phone Number',
                        style: kStyleNormal.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox16(),
                      myCountryCodePicker(
                        hintText: 'Phone',
                        bgColor: kWhite,
                        onValueChanged: (value) {
                          _phone = value;
                        },
                      ),
                      myEmailTextFormFieldWithPrefixIcon(
                        context,
                        'Email',
                        'Email',
                        _email,
                        Icons.email_outlined,
                        kWhite,
                        onValueChanged: (value) {
                          _email = value;
                        },
                      ),
                      Text(
                        'Password',
                        style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      ),
                      const SizedBox16(),
                      Form(
                        key: passwordForm,
                        child: TextFormField(
                          obscureText: _hiddenPassword,
                          onChanged: (String value) {
                            _password = value;
                            passwordForm.currentState?.validate();
                          },
                          style: kStyleNormal.copyWith(fontSize: 12.0),
                          decoration: InputDecoration(
                            errorMaxLines: 2,
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
                                overflow: TextOverflow.clip,
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
                                  _hiddenPassword = !_hiddenPassword;
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
                            hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Enter your password';
                            } else if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[$@!#&]).{8,}$')
                                .hasMatch(v)) {
                              return '* Required: atleast one Uppercase and lowercase letters (A,z), numbers(0-9) and special characters(!, %, @, #, etc.)';
                            }
                            return null;
                          },
                          onSaved: (v) {
                            _password = v;
                          },
                        ),
                      ),
                      const SizedBox16(),
                      Text(
                        'Confirm Password',
                        style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 13.0),
                      ),
                      const SizedBox16(),
                      Form(
                        key: confrimPasswordForm,
                        child: TextFormField(
                          obscureText: _hiddenPassword2,
                          onChanged: (String value) {
                            _confirmPassword = value;
                            passwordForm.currentState?.validate();
                          },
                          style: kStyleNormal.copyWith(fontSize: 12.0),
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
                                  _hiddenPassword2 = !_hiddenPassword2;
                                });
                              },
                              child: Icon(
                                _hiddenPassword2
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
                            hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
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
                      ),
                      const SizedBox8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              activeColor: myColor.primaryColorDark,
                              side: const BorderSide(
                                  width: 1.0, color: Colors.grey),
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                              value: _isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isChecked = newValue!;
                                  _isBtnActive = newValue;
                                });
                              }),
                          const SizedBox(width: 5.0),
                          Text(
                            'Agree to',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'Terms and Conditions',
                            style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: myColor.primaryColorDark),
                          ),
                        ],
                      ),
                      const SizedBox8(),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: myColor.primaryColor,
                                  backgroundColor: myColor.primaryColorDark),
                            )
                          : SizedBox(
                              width: maxWidth(context),
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.primaryColorDark,
                                  disabledForegroundColor: myColor
                                      .primaryColorDark
                                      .withOpacity(0.38),
                                  disabledBackgroundColor: myColor
                                      .primaryColorDark
                                      .withOpacity(0.12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                onPressed: _isBtnActive
                                    ? () {
                                        _isChecked
                                            ? registerBtn(context)
                                            : nullBtn();
                                      }
                                    : null,
                                child: Text(
                                  'Register',
                                  style: kStyleButton,
                                ),
                              ),
                            ),
                      const SizedBox16(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> nullBtn() {
    return Fluttertoast.showToast(msg: "Validate");
  }

  void registerBtn(context) async {
    setState(() {
      _isLoading = true;
    });
    int statusCode;
    var isValid = _form.currentState?.validate();
    var isConfirmPwValid = confrimPasswordForm.currentState?.validate();
    var isPwValid = passwordForm.currentState?.validate();

    if (!isValid! || !isConfirmPwValid! || !isPwValid!) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    statusCode = await API().postData(
      context,
      ResgisterModel(
          password: _password,
          email: _email,
          firstName: firstName,
          lastName: lastName,
          middleName: middleName,
          phone: _phone,
          isVerified: "0"),
      endpoints.registerEndpoint,
    );

    if (statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      pop_upHelper.popUpToNewScreen(context, CoolAlertType.success,
          'Check your email to verify your account', const LoginScreen());
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
