import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';

refreshToken(BuildContext context) async {
  String tokenId = sharedPrefs.getFromDevice('tokenId') ?? 'none';

  if (tokenId != 'none') {
    var resp = await API().getData(context, endpoints.revokeTokenEndpoint);
    if (resp != null) {
      RefreshTokenResponseModel refreshTokenResponseModel =
          RefreshTokenResponseModel.fromJson(resp);
      sharedPrefs.storeToDevice(
          'token', refreshTokenResponseModel.refreshToken);
    }
  }
}
