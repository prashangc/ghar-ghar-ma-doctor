import 'dart:convert';

import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Vendor/profile/VendorProfileTabView/VendorProfileTabView.dart';

refreshVendorProfile(context) async {
  var profileResp =
      await API().getData(context, endpoints.getVendorProfileEndpoint);
  VendorProfileModel vendorProfileModel =
      VendorProfileModel.fromJson(profileResp);
  sharedPrefs.storeToDevice("doctorProfile", jsonEncode(vendorProfileModel));
  refreshVendorProfileBloc.storeData(vendorProfileModel);
}
