import 'dart:convert';

import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';

var t = sharedPrefs.getFromDevice("userProfile");
ProfileModel p = ProfileModel.fromJson(json.decode(t));
String hideEmail(String email) {
  if (email.length <= 2) {
    return email.replaceAll(email[0], "*");
  } else if (email.length <= 4) {
    return "${email[0]}*${email[email.indexOf("@") - 1]}${email.substring(email.indexOf("@"))}";
  } else {
    return email[0] +
        "*" * (email.indexOf("@") - 2) +
        email[email.indexOf("@") - 1] +
        email.substring(email.indexOf("@"));
  }
}

class TwoFactorDescModel {
  final String one;
  final String two;
  final String three;
  final String four;
  final String five;
  TwoFactorDescModel({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  });
}

List<TwoFactorDescModel> twoFactorDescList = [
  TwoFactorDescModel(
    one: 'By enabling this, every time you ',
    two: 'login ',
    three: 'from a new device, you\'ll be prompted to enter ',
    four: 'verificaion OTP',
    five: '.',
  ),
  TwoFactorDescModel(
    one: 'A ',
    two: 'verification code ',
    three: 'with be sent to you via email when you login in ',
    four: hideEmail(p.member!.email.toString()),
    five: '.',
  ),
];
