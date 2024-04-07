import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/LoginModel/LoginResponseModel.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

bool isTimeoutPopupShown = false;

class API {
  final String _baseUrl = "https://test.ghargharmadoctor.com/api/"; //demo API

  Future<dynamic> getData(context, String endpoint) async {
    var token = sharedPrefs.getFromDevice("token");
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(days: 1),
        onTimeout: () {
          // if (isTimeoutPopupShown == false) {
          // isTimeoutPopupShown = true;
          pop_upHelper.popUpNavigatorPop(
              context, 1, CoolAlertType.error, 'Server Timeout');
          // } else {
          //   isTimeoutPopupShown = false;
          // }
          return responseJson;
          // _returnResponse(context, http.Response('', 408));
          // http.Response(
          //     'Error', 408); // Request Timeout response status code
        },
      );
      responseJson = _returnResponse(context, response);
      if (endpoint == endpoints.getUserProfileEndpoint) {
        if (token != null) {
          ProfileModel profileModel = ProfileModel.fromJson(responseJson);
          sharedPrefs.storeToDevice("userProfile", jsonEncode(profileModel));
          sharedPrefs.storeToDevice(
              "userProfilePicture", profileModel.imagePath ?? 'empty');
          sharedPrefs.storeToDevice(
              "userName", profileModel.member!.name.toString());
        }
      }

      if (endpoint == endpoints.getDoctorProfileEndpoint) {
        if (token != null) {
          DoctorProfileModel doctorProfileModel =
              DoctorProfileModel.fromJson(responseJson);
          sharedPrefs.storeToDevice(
              "doctorProfile", jsonEncode(doctorProfileModel));
        }
      }
      if (endpoint == endpoints.getNurseProfileEndpoint) {
        if (token != null) {
          NurseProfileModel nurseProfileModel =
              NurseProfileModel.fromJson(responseJson);
          sharedPrefs.storeToDevice(
              "nurseProfile", jsonEncode(nurseProfileModel));
        }
      }
      if (endpoint == endpoints.getVendorProfileEndpoint) {
        if (token != null) {
          VendorProfileModel vendorProfileModel =
              VendorProfileModel.fromJson(responseJson);
          sharedPrefs.storeToDevice(
              "vendorProfile", jsonEncode(vendorProfileModel));
        }
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.info, 'Request Timeout');
      // requestTimeOutBloc.storeData(true);
      throw FetchDataException('Request Timeout');
    }
    return responseJson;
  }

  Future<dynamic> deleteData(String endpoint, {model, context}) async {
    var token = sharedPrefs.getFromDevice("token");
    int statusCode;
    var responseJson;
    try {
      final response = await http.delete(
        Uri.parse(_baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(model),
      );

      responseJson = _returnResponse(context, response);
      statusCode = response.statusCode;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return statusCode;
  }

  Future<dynamic> postData(context, dynamic model, String endpoint) async {
    print(endpoint);
    int statusCode;
    var token = sharedPrefs.getFromDevice("token");
    String? responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl + endpoint),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
              "Accept": "application/json",
            },
            body: jsonEncode(model),
          )
          .timeout(const Duration(seconds: 30));
      statusCode = response.statusCode;
      if (statusCode != 200) {
        if (endpoint == 'login') {
          Navigator.pop(context);
          _returnResponse(context, response);
        } else {
          _returnResponse(context, response);
        }
      }
      responseJson = response.body;
      String? userID;

      if (statusCode == 200 && endpoint == 'login') {
        var resp = json.decode(response.body.toString());
        LoginResponseModel loginResponseModel =
            LoginResponseModel.fromJson(resp);
        if (loginResponseModel.user!.isSchool == 0) {
          userID = loginResponseModel.user!.id.toString();
          sharedPrefs.storeUserID("userID", userID);
          sharedPrefs.storeToDevice("isSchool", "isSchool");
        } else {
          String token = loginResponseModel.token.toString();
          String tokenId = loginResponseModel.tokenId.toString();
          String loggedId = loginResponseModel.loggedId.toString();
          String phoneNumber = loginResponseModel.user!.phone.toString();
          userID = loginResponseModel.user!.id.toString();
          sharedPrefs.storeUserID("userID", userID);
          sharedPrefs.storeToDevice("token", token);
          sharedPrefs.storeToDevice("tokenId", tokenId);
          sharedPrefs.storeToDevice("loggedId", loggedId);
          sharedPrefs.storeToDevice("phoneNumber", phoneNumber);
        }
      }
      if (statusCode == 200 &&
          endpoint == endpoints.postForgetPasswordEndpoint) {
        var resp;
        resp = json.decode(response.body);
        OTPResponseModel oTPResponseModel = OTPResponseModel.fromJson(resp);
        String otp = oTPResponseModel.oTP.toString();
        sharedPrefs.storeToDevice("otp", otp);
      }
      if (token != null) {
        String userType = sharedPrefs.getFromDevice("userType") ?? '';
        switch (userType) {
          case 'isDoctor':
            var doctorProfile =
                await sharedPrefs.getFromDevice("doctorProfile");
            DoctorProfileModel doctorProfileModel =
                DoctorProfileModel.fromJson(json.decode(doctorProfile));
            String doctorID = doctorProfileModel.id.toString();
            if (statusCode == 200 &&
                endpoint == 'admin/doctor-profile/update/$doctorID') {
              await API().getData(context, endpoints.getDoctorProfileEndpoint);
            }
            break;
          case 'isDriver':
            break;
          case 'isNurse':
            var nurseProfile = await sharedPrefs.getFromDevice("nurseProfile");
            NurseProfileModel nurseProfileModel =
                NurseProfileModel.fromJson(json.decode(nurseProfile));
            String nurseID = nurseProfileModel.id.toString();
            if (statusCode == 200 &&
                endpoint == 'admin/nurse-profile/update/1$nurseID') {
              await API().getData(context, endpoints.getNurseProfileEndpoint);
            }
            break;
          default:
            var test = await sharedPrefs.getFromDevice("userProfile");
            String urlID = '';
            if (test != null) {
              ProfileModel profileModel =
                  ProfileModel.fromJson(json.decode(test));
              urlID = profileModel.id.toString();
            }
            if (statusCode == 200 &&
                endpoint == 'admin/user-profile/update/$urlID') {
              await API().getData(context, endpoints.getUserProfileEndpoint);
            }
        }
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      if (endpoint == 'login') {
        Navigator.pop(context);
      }
      pop_upHelper.popUpNavigatorPop(context, 1, CoolAlertType.error,
          'Request Timeout. Please check your internet connection');
      // throw FetchDataException('Request timed out');
      return 408;
    }
    return statusCode;
  }

  Future<dynamic> getPostResponseData(
      BuildContext context, dynamic model, String endpoint) async {
    int statusCode;
    var token = sharedPrefs.getFromDevice("token");

    print("token is here: $token");
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: jsonEncode(model),
      );
      statusCode = response.statusCode;
      print('statusCode $statusCode');
      if (statusCode != 200) {
        _returnResponse(context, response);
      } else {
        responseJson = json.decode(response.body.toString());
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    print('responseJson $responseJson');
    return responseJson;
  }

  Future<dynamic> postUserKyc(BuildContext context, PostKycModel model,
      File citizenshipFront, File citizenshipBack, String endpoint) async {
    Uri url = Uri.parse(_baseUrl + endpoint);
    int statusCode;
    String? responseJson;
    var token = sharedPrefs.getFromDevice("token");
    try {
      var citizenshipFrontstream =
          http.ByteStream(DelegatingStream.typed(citizenshipFront.openRead()));
      var citizenshipFrontLength = await citizenshipFront.length();

      var citizenshipBackstream =
          http.ByteStream(DelegatingStream.typed(citizenshipBack.openRead()));
      var citizenshipBackLength = await citizenshipBack.length();
      var request = http.MultipartRequest("POST", url);

      request.headers["Authorization"] = 'Bearer $token';
      request.headers["Content-Type"] = 'application/json';
      request.headers["Accept"] = 'application/json';
      request.fields["first_name"] = model.firstName!;
      request.fields["middle_name"] = model.middleName!;
      request.fields["last_name"] = model.lastName!;
      request.fields["gender"] = model.gender!;
      request.fields["birth_date"] = model.birthDate!;
      request.fields["citizenship_date"] = model.citizenshipDate!;
      request.fields["citizenship_no"] = model.citizenshipNo!;
      request.fields["citizenship_issue_district"] =
          model.citizenshipIssueDistrict!;
      request.fields["nationality"] = model.nationality!;
      request.fields["mobile_number"] = model.mobileNumber!;
      request.fields["email"] = model.email!;
      request.fields["country"] = model.country!;
      request.fields["province_id"] = model.provinceId.toString();
      request.fields["district_id"] = model.districtId.toString();

      request.fields["father_full_name"] = model.fatherFullName!;
      request.fields["grandfather_full_name"] = model.grandfatherFullName!;
      request.fields["mother_full_name"] = model.motherFullName!;
      request.fields["husband_wife_full_name"] = model.husbandWifeFullName!;
      request.fields["latitude"] = model.latitude!;
      request.fields["longitude"] = model.longitude!;

      request.fields["municipality_id"] = model.municipalityId.toString();
      request.fields["ward_id"] = model.wardId.toString();

      var multipartFile1 = http.MultipartFile(
          'citizenship_front', citizenshipFrontstream, citizenshipFrontLength,
          filename: basename(citizenshipFront.path));
      request.files.add(multipartFile1);

      var multipartFile2 = http.MultipartFile(
          'citizenship_back', citizenshipBackstream, citizenshipBackLength,
          filename: basename(citizenshipBack.path));
      request.files.add(multipartFile2);
      var response = await request.send();
      statusCode = response.statusCode;
      final responseJson = await response.stream.bytesToString();
      print('responseJson ${response.reasonPhrase}');
      print('response.request ${response.request}');
      print('response.stream ${response.stream}');
      print('responseJson $responseJson');
      if (response.statusCode == 400) {
        var test = jsonDecode(responseJson);
        List myErrorList = test['message'].values.toList();
        pop_upHelper.popUpNavigatorPop(
            context, 1, CoolAlertType.error, myErrorList[0][0]);
      }
      print('responseJson length ${responseJson.length}');
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    print(statusCode);
    return statusCode;
  }

  Future<File> downloadFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      Directory? directory = await getExternalStorageDirectory();
      String newPath = '/storage/emulated/0/Download/GD/';
      directory = Directory(newPath);
      File? file;

      if (await directory.exists()) {
        file = File('${directory.path}$filename');
        await file.writeAsBytes(response.bodyBytes);
      } else {
        await directory.create(recursive: true);
      }
      myToast.toast('File Downloaded at ${directory.path}');

      return file!;
    } catch (error) {
      print('pdf downloading error = $error');
      return File('');
    }
  }

  Future<dynamic> postNurseImage(
    String name,
    String email,
    String phone,
    String nncNo,
    String gender,
    String qualification,
    String yearPracticed,
    String address,
    File photo1,
    String endpoint,
  ) async {
    Uri url = Uri.parse(_baseUrl + endpoint);
    int statusCode;
    String responseJson;
    var token = sharedPrefs.getFromDevice("token");

    print("token is here: $token");
    try {
      var stream1 = http.ByteStream(DelegatingStream.typed(photo1.openRead()));
      var length1 = await photo1.length();
      var request = http.MultipartRequest("POST", url);

      request.headers["Authorization"] = 'Bearer $token';
      request.headers["Content-Type"] = 'application/json';
      request.headers["Accept"] = 'application/json';
      request.fields["name"] = name;
      request.fields["email"] = email;
      request.fields["phone"] = phone;
      request.fields["nnc_no"] = nncNo;
      request.fields["gender"] = gender;
      request.fields["qualification"] = qualification;
      request.fields["year_practiced"] = yearPracticed;
      request.fields["address"] = address;
      var multipartFile1 = http.MultipartFile('image', stream1, length1,
          filename: basename(photo1.path));
      request.files.add(multipartFile1);
      var response = await request.send();
      statusCode = response.statusCode;
      final responseJson = await response.stream.bytesToString();
      if (token != null) {
        var doctorProfile = await sharedPrefs.getFromDevice("nurseProfile");
        NurseProfileModel nurseProfileModel =
            NurseProfileModel.fromJson(json.decode(doctorProfile));
        String nurseID = nurseProfileModel.id.toString();
        if (statusCode == 200 &&
            endpoint == 'admin/nurse-profile/update/$nurseID') {
          await API().getData(context, endpoints.getNurseProfileEndpoint);
        }
      }
      print(statusCode);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    print(statusCode);
    return statusCode;
  }
}

dynamic _returnResponse(context, http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = json.decode(response.body.toString());
      return responseJson;

    case 400:
      var test = jsonDecode(response.body);
      List myErrorList = test['message'].values.toList();
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, myErrorList[0][0]);

      return response.statusCode;
    // throw BadRequestException(response.body.toString());
    case 401:
      var test = jsonDecode(response.body);
      List myErrorList = test['message'].values.toList();
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, myErrorList[0][0]);

      return response.statusCode;

    // throw UnauthorisedException(response.body.toString());
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 408:
      // var responseJson = json.decode(response.body.toString());
      // PackageResponseModel respModel =
      //     PackageResponseModel.fromJson(responseJson);
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, 'Server Timeout');
      // throw UnauthorisedException(response.body.toString());
      return response.statusCode;
    case 404:
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, '404'.toString());
      return response.statusCode;
    case 409:
      var responseJson = json.decode(response.body.toString());
      PackageResponseModel respModel =
          PackageResponseModel.fromJson(responseJson);
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, respModel.message.toString());
      // throw UnauthorisedException(response.body.toString());
      return response.statusCode;

    case 422:
      var responseJson = json.decode(response.body.toString());
      PackageResponseModel respModel =
          PackageResponseModel.fromJson(responseJson);
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, respModel.message.toString());
      // throw UnauthorisedException(response.body.toString());
      return response.statusCode;
    case 500:
      print('responseJson ${response.body}');
      pop_upHelper.popUpNavigatorPop(context, 1, CoolAlertType.error,
          'Server is under maintainance'.toString());
      return response.statusCode;
    case 302:
      pop_upHelper.popUpNavigatorPop(context, 1, CoolAlertType.error,
          'Error During Communication with server.');
      return response.statusCode;

    default:
      errorResponse(context, response);
    // throw FetchDataException(
    //     'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

errorResponse(BuildContext context, http.Response response) {
  if (response.statusCode > 500) {
    pop_upHelper.popUpNavigatorPop(
        context, 1, CoolAlertType.error, 'Server is busy'.toString());
    return response.statusCode;
  }
  if (response.statusCode < 500 && response.statusCode > 400) {
    try {
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, 'Server is busy'.toString());
      return response.statusCode;
    } catch (e) {
      print(e);
    }
  }
  // if (response.statusCode == 0) {
  //   try {
  //     pop_upHelper.popUpNavigatorPop(
  //         context,
  //         1,
  //         CoolAlertType.error,
  //         'Please go to your email and verify your account before proceeding.'
  //             .toString());
  //     return response.statusCode;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
