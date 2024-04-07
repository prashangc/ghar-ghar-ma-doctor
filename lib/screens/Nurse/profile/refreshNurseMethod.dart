import 'dart:convert';

import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/NurseTabViews/NurseProfileTab.dart';

refreshNurseProfile(context) async {
  var profileResp =
      await API().getData(context, endpoints.getNurseProfileEndpoint);
  NurseProfileModel nurseProfileModel = NurseProfileModel.fromJson(profileResp);
  sharedPrefs.storeToDevice("nurseProfile", jsonEncode(nurseProfileModel));
  refreshNurseProfileBloc.storeData(nurseProfileModel);
}
