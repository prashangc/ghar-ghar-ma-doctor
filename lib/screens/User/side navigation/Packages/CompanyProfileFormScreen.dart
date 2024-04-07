import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:location/location.dart' as locationPackage;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:http/http.dart' as http;

class CompanyProfileFormScreen extends StatefulWidget {
  const CompanyProfileFormScreen({super.key});

  @override
  State<CompanyProfileFormScreen> createState() =>
      _CompanyProfileFormScreenState();
}

class _CompanyProfileFormScreenState extends State<CompanyProfileFormScreen> {
  final _form = GlobalKey<FormState>();
  File? _compRegFileImage, _panFileImage, _logoFileImage;
  String? _compRegBase64,
      _panBase64,
      _logoBase64,
      _stringLogo,
      _stringCompanyReg,
      _ownerName,
      _compName,
      _compStartedDateEng,
      _compStartedDateNep,
      _desc,
      _panNo,
      _contact;
  GoogleMapModel? testPopModal;
  StateHandlerBloc loadingBloc = StateHandlerBloc();
  ProfileModel? profileModel;
  @override
  void initState() {
    super.initState();

    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));

    if (profileModel!.schoolProfile != null) {
      getCompanyProfile();
      convertNetworkImgToBase64();
    }
  }

  convertNetworkImgToBase64() async {
    // setState(() async {
    _compRegBase64 = await imageFromNetworkToBase64(
        profileModel!.schoolProfile!.paperWorkPdfPath!);
    _logoBase64 = await imageFromNetworkToBase64(
        profileModel!.schoolProfile!.companyImagePath!);
    // });
  }

  getCompanyProfile() {
    _panBase64 = profileModel!.schoolProfile!.paperWorkPdfPath;
    _stringLogo = profileModel!.schoolProfile!.companyImagePath;
    _stringCompanyReg = profileModel!.schoolProfile!.paperWorkPdfPath;
    _ownerName = profileModel!.schoolProfile!.ownerName;
    _compName = profileModel!.schoolProfile!.companyName;
    covertEnglishDateToNepali();
    covertEnglishDateToNepali();
    testPopModal =
        GoogleMapModel(address: profileModel!.schoolProfile!.companyAddress);
    _desc = profileModel!.schoolProfile!.description;
    _panNo = profileModel!.schoolProfile!.panNumber;
    _contact = profileModel!.schoolProfile!.contactNumber;
  }

  covertEnglishDateToNepali() {
    if (profileModel!.schoolProfile!.companyStartDate != null) {
      DateTime date = DateTime.parse(
          profileModel!.schoolProfile!.companyStartDate.toString());
      _compStartedDateEng = profileModel!.schoolProfile!.companyStartDate;
      _compStartedDateNep = date.toNepaliDateTime().toString().substring(0, 10);
    } else {
      _compStartedDateNep = profileModel!.schoolProfile!.companyStartDate;
      _compStartedDateEng = profileModel!.schoolProfile!.companyStartDate;
    }
  }

  _getLatLng(Function mySetState) async {
    locationPackage.LocationData? currentPosition;
    final locationPackage.Location location = locationPackage.Location();

    currentPosition = await location.getLocation();
    double? latitude, longitude;
    location.onLocationChanged
        .listen((locationPackage.LocationData currentLocation) {
      currentPosition = currentLocation;
    });
    mySetState(() {
      latitude = currentPosition!.latitude;
      longitude = currentPosition!.longitude;
    });
    var myPoppedData = await goThere(context, const MyGoogleMap());
    mySetState(() {
      testPopModal = myPoppedData;
    });
  }

  checkValidation() {
    if (_logoBase64 == null) {
      return 'You must upload your company logo.';
    } else if (testPopModal == null) {
      return 'You must select address.';
    } else if (_compRegBase64 == null) {
      return 'You must upload your company registration file.';
    } else if (_panBase64 == null) {
      return 'You must upload your pan card file.';
    } else {
      return null;
    }
  }

  postProfileBtn(context) async {
    var isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      var customValid = await checkValidation();
      if (customValid == null) {
        loadingBloc.storeData(1);
        int statusCode = await API().postData(
            context,
            PostCompanyProfileModel(
              ownerName: _ownerName,
              companyName: _compName,
              companyAddress: testPopModal!.address.toString(),
              companyStartDate: _compStartedDateEng,
              panNumber: _panNo,
              companyImage:
                  // profileModel!.schoolProfile != null ? base64ToPost :
                  _logoBase64,
              contactNumber: _contact,
              paperWorkPdf:
                  // profileModel!.schoolProfile != null ? base64ToPost2 :
                  _compRegBase64,
              description: _desc,
            ),
            profileModel!.schoolProfile != null
                ? '${endpoints.postCompanyProfileEndpoint}/${profileModel!.schoolProfile!.id}'
                : endpoints.postCompanyProfileEndpoint);
        if (statusCode == 200) {
          if (profileModel!.schoolProfile != null) {
            var profileResp =
                await API().getData(context, endpoints.getUserProfileEndpoint);
            ProfileModel p = ProfileModel.fromJson(profileResp);
            sharedPrefs.storeToDevice("userProfile", jsonEncode(p));
          }
          loadingBloc.storeData(0);
          pop_upHelper.popUpNavigatorPop(
              context,
              2,
              CoolAlertType.success,
              profileModel!.schoolProfile != null
                  ? 'Your company profile is updated successfully.'
                  : 'Your company profile is submitted successfully.');
          refreshPackageBloc.storeData(0);
        } else {
          loadingBloc.storeData(0);
        }
      } else {
        myToast.toast(customValid);
      }
    }
  }

  Future<String> imageFromNetworkToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      String base64Image = base64Encode(response.bodyBytes);
      return "data:image/png;base64,$base64Image";
    } else {
      throw Exception('Failed to load image: $imageUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
          backgroundColor: myColor.colorScheme.background,
          appBar: myCustomAppBar(
              title: 'Company Details',
              color: myColor.colorScheme.background,
              borderRadius: 0.0),
          bottomNavigationBar: Container(
              color: myColor.dialogBackgroundColor,
              width: maxWidth(context),
              height: 60.0,
              child: StreamBuilder<dynamic>(
                  initialData: 0,
                  stream: loadingBloc.stateStream,
                  builder: (c, s) {
                    return s.data == 0
                        ? Container(
                            height: 50.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5.0),
                            child: myCustomButton(
                                context,
                                myColor.primaryColorDark,
                                profileModel!.schoolProfile != null
                                    ? 'Update'
                                    : 'Submit',
                                kStyleNormal.copyWith(
                                    color: kWhite, fontSize: 14.0), () {
                              postProfileBtn(context);
                            }))
                        : Container(
                            height: 50.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5.0),
                            child: myBtnLoading(context, 50.0));
                  })),
          body: SizedBox(
            width: maxWidth(context),
            height: maxHeight(context),
            child: Column(children: [
              Expanded(
                child: Container(
                  width: maxWidth(context),
                  margin: const EdgeInsets.only(top: 12.0),
                  padding: const EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 0.0),
                  decoration: BoxDecoration(
                    color: myColor.dialogBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22.0),
                      topRight: Radius.circular(22.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        compInfoCard(),
                        docCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  Widget compInfoCard() {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox16(),
          Text(
            'Company Information',
            style: kStyleNormal.copyWith(
              fontSize: 16.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          mytextFormFieldWithPrefixIcon(
            context,
            FocusNode(),
            'Owner Name',
            _ownerName,
            'Enter company onwer name',
            _ownerName,
            Icons.perm_identity_outlined,
            kWhite.withOpacity(0.4),
            onValueChanged: (value) {
              _ownerName = value;
            },
          ),
          mytextFormFieldWithPrefixIcon(
            context,
            FocusNode(),
            'Company Name',
            _compName,
            'Enter company name',
            _compName,
            Icons.home_outlined,
            kWhite.withOpacity(0.4),
            onValueChanged: (value) {
              _compName = value;
            },
          ),
          Text(
            'Company Started Date (B.S.)',
            style: kStyleNormal.copyWith(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          widgetDatePicker(
              context,
              disableDateType: 'future',
              kStyleNormal.copyWith(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
              _compStartedDateNep,
              _compStartedDateNep,
              Icons.calendar_month_outlined,
              kWhite.withOpacity(0.4), onValueChanged: (value) {
            myfocusRemover(context);
            setState(() {
              _compStartedDateNep = value.nepaliDate;
              _compStartedDateEng = value.englishDate;
            });
          }),
          const SizedBox16(),
          Text(
            'Company Description',
            style: kStyleNormal.copyWith(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          myTextArea(context, kWhite.withOpacity(0.4),
              _desc ?? 'Write short desc about your company...',
              onValueChanged: (value) {
            _desc = value;
          }, errorMessage: 'Enter company description', validationCheck: _desc),
          const SizedBox16(),
          myNumberTextFormField(
            'Pan number',
            _panNo,
            'Enter pan number',
            _panNo,
            Icons.insert_drive_file_outlined,
            kWhite.withOpacity(0.4),
            onValueChanged: (value) {
              _panNo = value;
            },
          ),
          const SizedBox16(),
          myNumberTextFormField(
            'Contact number',
            _contact,
            'Enter contact number',
            _contact,
            Icons.call_outlined,
            kWhite.withOpacity(0.4),
            onValueChanged: (value) {
              _contact = value;
            },
          ),
          const SizedBox24(),
        ],
      ),
    );
  }

  Widget docCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documents',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        Text(
          'Company Image',
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Upload your company image and select your location. Your information will be confidentially secured.',
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
        ),
        const SizedBox16(),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: myImagePicker(
                textValue: 'Logo',
                stringImage: _stringLogo,
                bgColor: kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  setState(() {
                    _logoFileImage = value.file;
                    _logoBase64 = value.base64String;
                  });
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  requestLocationPermission(_getLatLng(setState), () {});
                },
                child: testPopModal == null
                    ? DottedBorder(
                        dashPattern: const [8, 10],
                        strokeWidth: 1,
                        color: myColor.primaryColor,
                        strokeCap: StrokeCap.round,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(5),
                        child: Container(
                          height: 95,
                          width: maxWidth(context),
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox8(),
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 3),
                              Text('Location',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                  )),
                              Text(
                                'View Map',
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox16(),
                            ],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                child: Text(
                                  testPopModal!.address.toString(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                  ),
                                )),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5.0),
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'Change address',
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
        const SizedBox16(),
        Text(
          'Company Registration File',
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        myFilePicker(
          textValue: 'Company Registration',
          color: kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            setState(() {
              _compRegFileImage = value.file;
              _compRegBase64 = value.base64String;
            });
          },
          stringFile: _stringCompanyReg,
        ),
        Text(
          'Pan Card File',
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        myFilePicker(
          textValue: 'Pan Card',
          color: kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            setState(() {
              _panFileImage = value.file;
              _panBase64 = value.base64String;
            });
          },
          stringFile: _panBase64,
        ),
        const SizedBox12(),
        Text(
          'Upload both company registration and pan card document of selected document type. Make sure all details are clearly visible.',
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
        ),
        const SizedBox16(),
      ],
    );
  }
}
