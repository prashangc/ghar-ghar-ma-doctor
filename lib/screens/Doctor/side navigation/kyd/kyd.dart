import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class kyd extends StatefulWidget {
  const kyd({Key? key}) : super(key: key);

  @override
  State<kyd> createState() => _kydState();
}

class _kydState extends State<kyd> {
  int currentStep = 0;
  FilePickerResult? result;
  PlatformFile? file;
  File? fileImage, fileImage2;
  List<PlatformFile>? files;
  final List selectedIndexs = [];
  final _form = GlobalKey<FormState>();
  List<GetProvinceModel> getProvinceModel = [];
  List<GetIDNameModel> provinceModel = [];
  List<GetIDNameModel> districtModel = [];
  List<GetIDNameModel> wardModel = [];
  List<GetIDNameModel> municipalityModel = [];

  String? _firstName,
      _middleName,
      _lastName,
      _email,
      _provinceID,
      _gender,
      _dateOfBirth,
      _fatherName,
      _motherName,
      _grandFatherName,
      _spouseName,
      _phone,
      _nationality,
      _issuedDistrict,
      _districtID,
      _districtName,
      _provinceName,
      _wardID,
      _wardName,
      _municipalityID,
      _municipalityName,
      _daughterName,
      _citizenshipNumber,
      _issuedDate;
  bool kycFilledSuccesfully = false;
  bool isProvinceDropDownOpened = false;
  ApiHandlerBloc? provinceBloc, districtBloc, wardBloc, municipalityBloc;
  List<GetIDNameModel> nationalityDropDownList = [];

  submitBtn(context) async {
    int statusCode;
    statusCode = await API().postUserKyc(
      context,
      PostKycModel(
        firstName: _firstName,
        lastName: _lastName,
        middleName: _middleName,
        gender: _gender,
        birthDate: _dateOfBirth,
        citizenshipDate: _issuedDate,
        citizenshipNo: _citizenshipNumber,
        citizenshipIssueDistrict: _issuedDistrict,
        nationality: _nationality,
        mobileNumber: _phone,
        email: _email,
        country: _nationality,
        provinceId: int.parse(_provinceID.toString()),
        wardId: int.parse(_wardID.toString()),
        municipalityId: int.parse(_municipalityID.toString()),
        districtId: int.parse(_districtID.toString()),
        fatherFullName: _fatherName,
        motherFullName: _motherName,
        grandfatherFullName: _grandFatherName,
        husbandWifeFullName: _spouseName,
        latitude: '1',
        longitude: '1',
      ),
      fileImage!,
      fileImage2!,
      '  endpoints.postUserKYCEndpoint',
    );
    if (statusCode == 200) {
      mySnackbar.mySnackBar(context, 'success: $statusCode', Colors.green);
    } else {}
  }

  Widget myDropdownsWidget(titleText, Widget myWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        myWidget,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _districtID = '0';
    _wardID = '0';
    _provinceID = '0';
    _municipalityID = '0';
    provinceBloc = ApiHandlerBloc();
    districtBloc = ApiHandlerBloc();
    municipalityBloc = ApiHandlerBloc();
    wardBloc = ApiHandlerBloc();
    getProvinceApiData('all');
    for (int i = 0; i < nationalityList.length; i++) {
      nationalityDropDownList.add(GetIDNameModel(
        id: nationalityList[i],
        name: nationalityList[i],
      ));
    }
  }

  getProvinceApiData(addressType) {
    if (addressType == 'district') {
      _districtID = null;
      _districtName = null;
      _municipalityID = null;
      _municipalityID = null;
      _wardID = null;
      _wardName = null;
      districtBloc!.fetchAPIList('fetchdistrict?province_id=$_provinceID');
    } else if (addressType == 'mun') {
      _municipalityID = null;
      _municipalityID = null;
      _wardID = null;
      _wardName = null;
      municipalityBloc!.fetchAPIList('fetchmun?district_id=$_districtID');
    } else if (addressType == 'ward') {
      _wardID = null;
      _wardName = null;
      wardBloc!.fetchAPIList('fetchward?municipality_id=$_municipalityID');
    } else {
      provinceBloc!.fetchAPIList(endpoints.getAllProvinceEndpoint);
      districtBloc!.fetchAPIList('fetchdistrict?province_id=$_provinceID');
      municipalityBloc!.fetchAPIList('fetchmun?district_id=$_districtID');
      wardBloc!.fetchAPIList('fetchward?municipality_id=$_municipalityID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
            title: 'KYD', color: backgroundColor, borderRadius: 0.0),
        body:
            //  kycFilledSuccesfully
            //     ? successWidget()
            //     :
            Container(
          height: maxHeight(context),
          margin: const EdgeInsets.only(top: 15.0),
          // padding: const EdgeInsets.symmetric(horizontal: 20.0),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Theme(
            data: ThemeData(
              canvasColor: Colors.transparent,
              unselectedWidgetColor: Colors.green,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: myColor.primaryColorDark,
                  ),
            ),
            child: Stepper(
              physics: const BouncingScrollPhysics(),
              elevation: 0,
              type: StepperType.horizontal,
              // onStepTapped: (step) => setState(() {
              //   currentStep = step;
              // }),
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () {},
              controlsBuilder: (context, details) {
                final isLastStep = currentStep == getSteps().length - 1;
                return Container(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  color: myColor.dialogBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                            width: maxWidth(context),
                            height: 50,
                            child: myButton(
                              context,
                              myColor.primaryColorDark,
                              !isLastStep ? 'Next' : "Submit",
                              () {
                                myfocusRemover(context);
                                // var isValid = _form.currentState?.validate();
                                // if (isValid!) {
                                if (isLastStep) {
                                  // setState(() {
                                  //   kycFilledSuccesfully = true;
                                  // });
                                  print("send data to the server");
                                  submitBtn(context);
                                } else {
                                  setState(() {
                                    currentStep += 1;
                                  });
                                }
                                // }
                                // return;
                              },
                            )),
                        const SizedBox8(),
                        GestureDetector(
                          onTap: () {
                            currentStep == 0
                                ? Navigator.pop(context)
                                : setState(() {
                                    currentStep -= 1;
                                  });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: myColor.primaryColorDark, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: maxWidth(context),
                            height: 50,
                            child: Center(
                              child: Text(
                                currentStep == 0 ? 'Cancel' : "Back",
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: currentStep == 0
              ? Text(
                  'Personal Details',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : const Text(
                  '',
                ),
          content: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your Details',
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          color: myColor.primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox24(),
                      mytextFormField(
                        context,
                        'First Name',
                        _firstName,
                        'Enter your fullname',
                        _firstName,
                        onValueChanged: (value) {
                          _firstName = value;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: mytextFormField(
                              context,
                              'Middle Name',
                              _middleName,
                              'Enter your fullname',
                              _middleName,
                              onValueChanged: (value) {
                                _middleName = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: mytextFormField(
                              context,
                              'Last Name',
                              _lastName,
                              'Enter your fullname',
                              _lastName,
                              onValueChanged: (value) {
                                _lastName = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      myPhonetextFormField(
                        context,
                        '',
                        _phone,
                        onValueChanged: (value) {
                          _phone = value;
                        },
                      ),
                      myEmailTextFormFieldWithPrefixIcon(
                        context,
                        'Email',
                        _email,
                        _email,
                        onValueChanged: (value) {
                          _email = value;
                        },
                      ),
                      widgetDatePicker(
                          context,
                          kStyleNormal.copyWith(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          _dateOfBirth,
                          _dateOfBirth,
                          Icons.cake_outlined,
                          Colors.white.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _dateOfBirth = value.nepaliDate;
                        });
                      }),

                      mytextFormField(
                        context,
                        'Father\'s Name',
                        _fatherName,
                        'Enter your Father\'s name',
                        _fatherName,
                        onValueChanged: (value) {
                          _fatherName = value;
                        },
                      ),
                      mytextFormField(
                        context,
                        'Mother\'s Name',
                        _motherName,
                        'Enter your Mother\'s name',
                        _motherName,
                        onValueChanged: (value) {
                          _motherName = value;
                        },
                      ),
                      mytextFormField(
                        context,
                        'Grandfather\'s Name',
                        _grandFatherName,
                        'Enter your Grandfather\'s name',
                        _grandFatherName,
                        onValueChanged: (value) {
                          _grandFatherName = value;
                        },
                      ),
                      mytextFormField(
                        context,
                        'Spouse\'s Name',
                        _spouseName,
                        'Enter your Spouse\'s name',
                        _spouseName,
                        onValueChanged: (value) {
                          _spouseName = value;
                        },
                      ),
                      // mytextFormField(
                      //   context,
                      //   'Son\'s Name',
                      //   _sonName,
                      //   'Enter your Son\'s name',
                      //   _sonName,
                      //   onValueChanged: (value) {
                      //     _sonName = value;
                      //   },
                      // ),
                      // mytextFormField(
                      //   context,
                      //   'Daughter\'s Name',
                      //   _daughterName,
                      //   'Enter your Daughter\'s name',
                      //   _daughterName,
                      //   onValueChanged: (value) {
                      //     _daughterName = value;
                      //   },
                      // ),
                      myGender(
                          context,
                          kStyleNormal.copyWith(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          Colors.white.withOpacity(0.4),
                          _gender, onValueChanged: (value) {
                        _gender = value;
                      }),
                      const SizedBox16(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          // state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: currentStep == 1
              ? Text(
                  'Address',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : const Text(
                  '',
                ),
          content: Column(
            children: [
              currentStep != 1
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          myDropdownsWidget(
                              'Select Nationality',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _nationality ?? '',
                                  nationalityDropDownList,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {
                                setState(() {
                                  _nationality = value.name;
                                });
                              })),
                          const SizedBox16(),
                          allStreamBuilders(),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Step(
          // state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: currentStep == 2
              ? Text(
                  'Documents',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                )
              : const Text(
                  '',
                ),
          content: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Choose Document Type',
                    //   style: kStyleNormal.copyWith(
                    //     fontSize: 13.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox16(),
                    // SizedBox(
                    //   height: 35,
                    //   child: ListView.builder(
                    //     physics: const BouncingScrollPhysics(),
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: documentTypeList.length,
                    //     itemBuilder: (ctx, i) {
                    //       final isSelected = selectedIndexs.contains(i);
                    //       return GestureDetector(
                    //         onTap: () {
                    //           setState(
                    //             () {
                    //               if (isSelected) {
                    //                 selectedIndexs.remove(i);
                    //               } else if (selectedIndexs.isNotEmpty) {
                    //                 selectedIndexs.clear();
                    //                 selectedIndexs.add(i);
                    //               } else {
                    //                 selectedIndexs.add(i);
                    //               }
                    //             },
                    //           );
                    //         },
                    //         child: Container(
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 5.0),
                    //           margin: const EdgeInsets.only(right: 10.0),
                    //           decoration: BoxDecoration(
                    //             color: isSelected
                    //                 ? myColor.primaryColorDark
                    //                 : Colors.transparent,
                    //             border: Border.all(
                    //                 color: myColor.primaryColorDark,
                    //                 width: 1.0),
                    //             borderRadius: BorderRadius.circular(5.0),
                    //           ),
                    //           child: Center(
                    //             child: Text(
                    //               documentTypeList[i].textValue.toString(),
                    //               style: kStyleNormal.copyWith(
                    //                 color: isSelected
                    //                     ? Colors.white
                    //                     : myColor.primaryColorDark,
                    //                 fontSize: 12.0,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     shrinkWrap: true,
                    //   ),
                    // ),

                    // const SizedBox16(),
                    mytextFormField(
                      context,
                      'Citizenship No.',
                      _citizenshipNumber,
                      'Enter citizenship no.',
                      _citizenshipNumber,
                      onValueChanged: (value) {
                        _citizenshipNumber = value;
                      },
                    ),
                    widgetDatePicker(
                        context,
                        kStyleNormal.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                        _issuedDate,
                        _issuedDate,
                        Icons.cake_outlined,
                        Colors.white.withOpacity(0.4), onValueChanged: (value) {
                      setState(() {
                        _issuedDate = value.nepaliDate;
                      });
                    }),

                    mytextFormField(
                      context,
                      'Issued District',
                      _issuedDistrict,
                      'Enter issued district',
                      _issuedDistrict,
                      onValueChanged: (value) {
                        _issuedDistrict = value;
                      },
                    ),
                    Text(
                      'ID Proof',
                      style: kStyleNormal.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Upload both front and back of your citizenship card. Make sure all details are clearly visible',
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
                            textValue: 'Front',
                            bgColor: Colors.white.withOpacity(0.4),
                            onValueChanged: (value) {
                              setState(() {
                                fileImage = value.file;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 1,
                          child: myImagePicker(
                            textValue: 'Back',
                            bgColor: Colors.white.withOpacity(0.4),
                            onValueChanged: (value) {
                              setState(() {
                                fileImage2 = value.file;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];

  Widget allStreamBuilders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<ApiResponse<dynamic>>(
          stream: provinceBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return myDropDown2Loading(
                      context,
                      'Select Province',
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      '',
                      provinceModel,
                      onValueChanged: (value) {});
                case Status.COMPLETED:
                  getProvinceModel = List<GetProvinceModel>.from(snapshot
                      .data!.data
                      .map((i) => GetProvinceModel.fromJson(i)));
                  provinceModel.clear();
                  for (int i = 0; i < getProvinceModel.length; i++) {
                    provinceModel.add(GetIDNameModel(
                      id: getProvinceModel[i].id.toString(),
                      name: getProvinceModel[i].englishName,
                    ));
                  }
                  if (snapshot.data!.data.isEmpty) {
                    return myDropdownsWidget(
                      'Select Province',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _provinceName ?? '',
                          provinceModel,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {}),
                    );
                  }

                  return myDropdownsWidget(
                    'Select Province',
                    myDropDown2(
                        context,
                        Icons.perm_identity,
                        Colors.black,
                        Colors.black,
                        maxWidth(context),
                        _provinceName ?? '',
                        provinceModel,
                        myColor.scaffoldBackgroundColor.withOpacity(0.4),
                        onValueChanged: (value) {
                      setState(() {
                        _provinceID = value.id;
                        _provinceName = value.name;
                        getProvinceApiData('district');
                      });
                    }),
                  );

                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    height: 135.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('Server Error', style: kStyleNormal),
                    ),
                  );
              }
            }
            return SizedBox(
              width: maxWidth(context),
              height: 200,
            );
          }),
        ),
        const SizedBox16(),
        StreamBuilder<ApiResponse<dynamic>>(
          stream: districtBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return myDropDown2Loading(
                      context,
                      'Select District',
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      '',
                      districtModel,
                      onValueChanged: (value) {});
                case Status.COMPLETED:
                  List<GetDistrictModel> getDistrictModel =
                      List<GetDistrictModel>.from(snapshot.data!.data
                          .map((i) => GetDistrictModel.fromJson(i)));
                  districtModel.clear();
                  for (int i = 0; i < getDistrictModel.length; i++) {
                    districtModel.add(GetIDNameModel(
                      id: getDistrictModel[i].id.toString(),
                      name: getDistrictModel[i].englishName,
                    ));
                  }
                  if (snapshot.data!.data.isEmpty) {
                    return myDropdownsWidget(
                        'Select Province',
                        myDropDown2(
                            context,
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _districtName ?? '',
                            districtModel,
                            myColor.scaffoldBackgroundColor.withOpacity(0.4),
                            onValueChanged: (value) {}));
                  }

                  return myDropdownsWidget(
                      'Select District',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _districtName ?? '',
                          districtModel,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _districtID = value.id;
                          _districtName = value.name;
                          getProvinceApiData('mun');
                        });
                      }));
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    height: 135.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('Server Error', style: kStyleNormal),
                    ),
                  );
              }
            }
            return SizedBox(
              width: maxWidth(context),
              height: 200,
            );
          }),
        ),
        const SizedBox16(),
        StreamBuilder<ApiResponse<dynamic>>(
          stream: municipalityBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return myDropDown2Loading(
                      context,
                      'Select VDC/Municipality',
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _municipalityName ?? '',
                      municipalityModel,
                      onValueChanged: (value) {});
                case Status.COMPLETED:
                  List<GetMunicipalityModel> getMunicipalityModel =
                      List<GetMunicipalityModel>.from(snapshot.data!.data
                          .map((i) => GetMunicipalityModel.fromJson(i)));
                  municipalityModel.clear();
                  for (int i = 0; i < getMunicipalityModel.length; i++) {
                    municipalityModel.add(GetIDNameModel(
                      id: getMunicipalityModel[i].id.toString(),
                      name: getMunicipalityModel[i].englishName,
                    ));
                  }
                  if (snapshot.data!.data.isEmpty) {
                    return myDropdownsWidget(
                        'Select VDC/Municipality',
                        myDropDown2(
                            context,
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _municipalityName ?? '',
                            municipalityModel,
                            myColor.scaffoldBackgroundColor.withOpacity(0.4),
                            onValueChanged: (value) {}));
                  }

                  return myDropdownsWidget(
                      'Select VDC/Municipality',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _municipalityName ?? '',
                          municipalityModel,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _municipalityID = value.id;
                          _municipalityName = value.name;
                          getProvinceApiData('ward');
                        });
                      }));
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    height: 135.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('Server Error', style: kStyleNormal),
                    ),
                  );
              }
            }
            return SizedBox(
              width: maxWidth(context),
              height: 200,
            );
          }),
        ),
        const SizedBox16(),
        StreamBuilder<ApiResponse<dynamic>>(
          stream: wardBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return myDropDown2Loading(
                      context,
                      'Select Ward',
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _wardName ?? '',
                      wardModel,
                      onValueChanged: (value) {});
                case Status.COMPLETED:
                  List<GetWardModel> getWardModel = List<GetWardModel>.from(
                      snapshot.data!.data.map((i) => GetWardModel.fromJson(i)));
                  wardModel.clear();
                  for (int i = 0; i < getWardModel.length; i++) {
                    wardModel.add(GetIDNameModel(
                      id: getWardModel[i].id.toString(),
                      name: getWardModel[i].wardName.toString(),
                    ));
                  }
                  if (snapshot.data!.data.isEmpty) {
                    return myDropdownsWidget(
                        'Select Ward',
                        myDropDown2(
                            context,
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _wardName ?? '',
                            wardModel,
                            myColor.scaffoldBackgroundColor.withOpacity(0.4),
                            onValueChanged: (value) {}));
                  }

                  return myDropdownsWidget(
                      'Select Ward',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _wardName ?? '',
                          wardModel,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _wardID = value.id;
                          _wardName = value.name;
                        });
                      }));
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    height: 135.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text('Server Error', style: kStyleNormal),
                    ),
                  );
              }
            }
            return SizedBox(
              width: maxWidth(context),
              height: 200,
            );
          }),
        ),
      ],
    );
  }

  Widget successWidget() {
    return Column(
      children: [
        const Text('KYC already filled'),
        const SizedBox8(),
        myButton(context, myColor.primaryColorDark, 'Reset KYC?', () {
          setState(() {
            kycFilledSuccesfully = false;
            currentStep = 0;
          });
        })
      ],
    );
  }

  Widget mytextFormField(
      BuildContext context, titleText, hintText, errorMessage, textValue,
      {required ValueChanged<String>? onValueChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        TextFormField(
          textCapitalization: TextCapitalization.words,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
          onChanged: (String value) {
            onValueChanged!(value);
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.perm_identity_outlined,
              size: 16.0,
              color: Colors.black,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            filled: true,
            fillColor: Colors.white.withOpacity(0.4),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide:
                  BorderSide(color: myColor.primaryColorDark, width: 1.5),
            ),
            errorStyle:
                kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            hintText: hintText,
            hintStyle:
                kStyleNormal.copyWith(fontSize: 12.0, color: Colors.grey[400]),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          onSaved: (v) {
            textValue = v;
          },
        ),
        const SizedBox16(),
      ],
    );
  }
}

Widget myPhonetextFormField(BuildContext context, hintText, textValue,
    {required ValueChanged<String>? onValueChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Phone',
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox16(),
      TextFormField(
        keyboardType: TextInputType.number,
        style: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
        onChanged: (String value) {
          onValueChanged!(value);
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.call_outlined,
            size: 16.0,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Colors.white, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          hintText: hintText,
          hintStyle:
              kStyleNormal.copyWith(fontSize: 12.0, color: Colors.grey[400]),
        ),
        validator: (v) {
          if (v!.isEmpty) {
            return 'Enter your phone number';
          }
          if (v.length != 10) {
            return 'Mobile Number must be of 10 digits';
          }
          return null;
        },
        onSaved: (v) {
          textValue = v;
        },
      ),
      const SizedBox16(),
    ],
  );
}

Widget myEmailTextFormFieldWithPrefixIcon(
    BuildContext context, titleText, labelText, textValue,
    {required ValueChanged<String>? onValueChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox16(),
      TextFormField(
        onChanged: (String value) {
          onValueChanged!(value);
        },
        style: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.mail_outlined,
            size: 16.0,
            color: Colors.black,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: Colors.white, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: labelText,
          hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
        ),
        validator: (v) {
          return EmailValidator.validate(v!)
              ? null
              : "Please enter a valid email";
        },
        onSaved: (v) {
          textValue = v;
        },
      ),
      const SizedBox16(),
    ],
  );
}

Widget myDropDown2Loading(
    BuildContext context,
    titleText,
    icon,
    Color iconColor,
    Color titleTextColor,
    width,
    hintText,
    List<GetIDNameModel> listItemData,
    {required ValueChanged<GetIDNameModel>? onValueChanged}) {
  String? selectedValue;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontWeight: FontWeight.bold,
          color: titleTextColor,
        ),
      ),
      const SizedBox16(),
      DropdownButtonHideUnderline(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: iconColor,
                ),
                const SizedBox(width: 10.0),
                Text(
                  hintText,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            items: listItemData
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.perm_identity,
                            size: 16,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            item.name.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (dynamic value) {
              onValueChanged!(value);
            },

            icon: Container(
              width: 15.0,
              height: 15.0,
              margin: const EdgeInsets.only(right: 10.0),
              child: CircularProgressIndicator(
                backgroundColor: myColor.primaryColorDark,
                color: myColor.dialogBackgroundColor,
                strokeWidth: 1.5,
              ),
            ),
            dropdownOverButton: true,
            iconSize: 20,
            iconEnabledColor: myColor.primaryColorDark,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,
            buttonWidth: width,
            buttonPadding: const EdgeInsets.only(left: 8),
            buttonElevation: 0,
            dropdownElevation: 0,
            // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8.0),
            ),
            itemHeight: 40,
            itemPadding: const EdgeInsets.symmetric(horizontal: 14),
            dropdownMaxHeight: 180,
            dropdownPadding: const EdgeInsets.symmetric(horizontal: 3),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 3,
            scrollbarAlwaysShow: false,
            offset: const Offset(0, 0),
          ),
        ),
      ),
    ],
  );
}

Widget imageFilledContainer(context, fileImage) {
  return Stack(
    children: [
      Container(
        height: 100,
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: Image.file(
            fileImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          height: 25,
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
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
                Icons.file_upload,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 5.0),
              Text(
                'Re-upload',
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
  );
}

Widget filePickerContainer(context, text) {
  return DottedBorder(
    dashPattern: const [9, 10],
    strokeWidth: 2,
    color: myColor.primaryColor,
    strokeCap: StrokeCap.round,
    borderType: BorderType.RRect,
    radius: const Radius.circular(5),
    child: Container(
      width: maxWidth(context),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox12(),
          Icon(
            Icons.file_upload,
            size: 35,
            color: myColor.primaryColorDark,
          ),
          const SizedBox(height: 3),
          Text(text,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              )),
          Text(
            'Browse',
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
  );
}
