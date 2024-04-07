import 'dart:convert';

import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/profileScreen.dart';

refresh(context) async {
  var kycResp = await API().getData(context, endpoints.getkycStatusEndpoint);
  KycResponseModel kycResponseModel = KycResponseModel.fromJson(kycResp);
  sharedPrefs.storeToDevice("kycStatus", kycResponseModel.message);
  refreshGlobalFormBloc.storeData('refresh');

  var profileResp =
      await API().getData(context, endpoints.getUserProfileEndpoint);
  ProfileModel profileModel = ProfileModel.fromJson(profileResp);
  sharedPrefs.storeToDevice("userProfile", jsonEncode(profileModel));

  if (profileModel.member!.roles != null &&
      profileModel.member!.roles!.length > 1) {
    sharedPrefs.storeToDevice("becomeMember", "memberVerified");
  }

  refreshMainSreenBloc.storeData(profileModel);
}
