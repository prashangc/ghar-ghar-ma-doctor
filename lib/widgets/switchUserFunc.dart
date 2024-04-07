import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/main/mainHomePageDoctor.dart';
import 'package:ghargharmadoctor/screens/Driver/main/mainHomePageDriver.dart';
import 'package:ghargharmadoctor/screens/Nurse/main/mainHomePageNurse.dart';
import 'package:ghargharmadoctor/screens/Vendor/bottom%20navigation/MainVendorScreen.dart';

switchUserFunc(context, int role) async {
  if (role == 4) {
    var resp = await API().getData(context, endpoints.getDoctorProfileEndpoint);
    if (resp != null) {
      DoctorProfileModel profileModel = DoctorProfileModel.fromJson(resp);
      goThere(
          context,
          MainHomePageDoctor(
            index: 3,
            isSwitched: true,
            switchType: 'Doctor',
            image: profileModel.imagePath.toString(),
            name: profileModel.user!.name.toString(),
          ));
    }
    sharedPrefs.storeToDevice("userType", 'isDoctor');
  } else if (role == 5) {
    var resp = await API().getData(context, endpoints.getVendorProfileEndpoint);
    if (resp != null) {
      VendorProfileModel profileModel = VendorProfileModel.fromJson(resp);
      goThere(
          context,
          MainVendorScreen(
            index: 2,
            isSwitched: true,
            switchType: 'Store',
            image: profileModel.imagePath.toString(),
            name: profileModel.user!.name.toString(),
          ));
    }
    sharedPrefs.storeToDevice("userType", 'isVendor');
  } else if (role == 7) {
    var resp = await API().getData(context, endpoints.getNurseProfileEndpoint);
    if (resp != null) {
      NurseProfileModel profileModel = NurseProfileModel.fromJson(resp);
      goThere(
          context,
          MainHomePageNurse(
            index: 3,
            isSwitched: true,
            switchType: 'Nurse',
            image: profileModel.imagePath.toString(),
            name: profileModel.user!.name.toString(),
          ));
    }
    sharedPrefs.storeToDevice("userType", 'isNurse');
  } else if (role == 9) {
    var resp =
        await await API().getData(context, endpoints.getUserProfileEndpoint);
    if (resp != null) {
      NurseProfileModel profileModel = NurseProfileModel.fromJson(resp);
      goThere(
          context,
          MainHomePageDriver(
            index: 1,
            isSwitched: true,
            switchType: 'Driver',
            image: profileModel.imagePath.toString(),
            name: profileModel.user!.name.toString(),
          ));
    }
    sharedPrefs.storeToDevice("userType", 'isDriver');
  } else {}
}
