import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

Widget myQr(String data, String type) {
  var test = sharedPrefs.getFromDevice("userProfile");
  ProfileModel? profileModel;
  if (test != null) {
    profileModel = ProfileModel.fromJson(json.decode(test));
  }
  String platform = Platform.isAndroid ? 'android' : 'ios';
  String jsonData = profileModel != null && profileModel.memberType != null
      ? '{"key": "$data", "type": "$type", "platform": "$platform","familyType": "${profileModel.memberType}" }'
      : '{"key": "$data", "type": "$type", "platform": "$platform","familyType": "None" }';
  String key = 'ufxhqsy7ytiiibye';
  List<int> keyBytes = key.codeUnits;
  List<int> dataBytes = jsonData.codeUnits;
  List<int> encryptedBytes = [];
  for (int i = 0; i < dataBytes.length; i++) {
    encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
  }
  String encryptedData = String.fromCharCodes(encryptedBytes);
  return PrettyQr(
    size: 200,
    data: encryptedData,
    errorCorrectLevel: QrErrorCorrectLevel.M,
    roundEdges: true,
    elementColor: kBlack,
  );
}
