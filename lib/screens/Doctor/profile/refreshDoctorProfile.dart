import 'dart:convert';

import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/DoctorProfileTabView/DoctorProfileTabView.dart';

refreshDoctorProfile(context) async {
  var profileResp =
      await API().getData(context, endpoints.getDoctorProfileEndpoint);
  DoctorProfileModel doctorProfileModel =
      DoctorProfileModel.fromJson(profileResp);
  sharedPrefs.storeToDevice("doctorProfile", jsonEncode(doctorProfileModel));
  refreshDoctorProfileBloc.storeData(doctorProfileModel);
}
