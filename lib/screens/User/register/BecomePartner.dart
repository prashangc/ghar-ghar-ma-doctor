import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:location/location.dart' as locationPackage;

class BecomePartnerScreen extends StatefulWidget {
  final UserTypeModel userTypeModel;
  const BecomePartnerScreen({Key? key, required this.userTypeModel})
      : super(key: key);

  @override
  State<BecomePartnerScreen> createState() => _BecomePartnerScreenState();
}

class _BecomePartnerScreenState extends State<BecomePartnerScreen> {
  GoogleMapModel? testPopModal;
  final _form = GlobalKey<FormState>();
  String? _fullName,
      _yearsPracticed,
      companyContact,
      companyRegistration,
      _qualification,
      _photoBase64,
      _fileBase64,
      _taxFileBase64,
      _irdFileBase64,
      _storeName,
      _specialization;
  String? _nmcNumber,
      paymentTimeFrame,
      terminationTimeFrame,
      membershipFee,
      membershipTimeFrame;

  String? _email,
      guarantorName,
      guarantorContact,
      guarantorAddress,
      nomineeName,
      nomineeContact,
      nomineeAddress;
  String? _vendorTypeValue;
  String _salutation = 'Dr.';
  String? _vendorTypeID;
  String? _roleID;
  String? _address;
  String? _phone, _gender;
  String? _password;
  String? _confirmPassword;
  int? _departmentID;
  String? _department;
  ApiHandlerBloc? vendorTypeBloc;
  File? _photo, _file, _taxFile, _irdFile;
  bool _isChecked = false;
  final bool _isLoading = false;
  bool _isBtnActive = false;
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _nmcNumberFocusNode = FocusNode();
  final List<GetIDNameModel> nurseTypeList = [];
  final List<GetIDNameModel> vendorTypeList = [];
  List<GetIDNameModel> salutationList = [];
  List<GetIDNameModel> departmentDynamicModel = [];
  ApiHandlerBloc? departmentBloc;
  StateHandlerBloc? btnBloc;

  @override
  void initState() {
    if (widget.userTypeModel.name == 'Doctor') {
      departmentBloc = ApiHandlerBloc();
      departmentBloc!.fetchAPIList(endpoints.getDepartmentEndpoint);
      salutationList.clear();
      for (int i = 0; i < saluationData.length; i++) {
        salutationList.add(GetIDNameModel(
          id: saluationData[i],
          name: saluationData[i],
        ));
      }
    }
    btnBloc = StateHandlerBloc();
    vendorTypeBloc = ApiHandlerBloc();
    vendorTypeBloc!.fetchAPIList(endpoints.getAllVendorsEndpoint);
    super.initState();
    _roleID = widget.userTypeModel.roleId;
    if (widget.userTypeModel.name == 'Nurse') {
      for (int i = 0; i < nurseTypeListData.length; i++) {
        nurseTypeList.add(GetIDNameModel(
          id: nurseTypeListData[i],
          name: nurseTypeListData[i],
        ));
      }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          toolbarHeight: 60.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Become a ${widget.userTypeModel.name}',
              style: kStyleNormal.copyWith(
                  fontSize: 18.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox12(),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(_vendorTypeValue);
                        },
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 120.0,
                              height: 140.0,
                            ),
                          ),
                        ),
                      ),
                      widget.userTypeModel.name == 'Doctor' ||
                              widget.userTypeModel.name == 'Nurse'
                          ? myNumberTextFormField(
                              widget.userTypeModel.name == 'Doctor'
                                  ? 'NMC no.'
                                  : 'NNC no.',
                              widget.userTypeModel.name == 'Doctor'
                                  ? 'NMC no.'
                                  : 'NNC no.',
                              widget.userTypeModel.name == 'Doctor'
                                  ? 'Enter your NMC no.'
                                  : 'Enter your NNC no.',
                              _nmcNumber,
                              Icons.numbers,
                              kWhite,
                              onValueChanged: (value) {
                                _nmcNumber = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Doctor'
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Salutation',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox16(),
                                      myDropDown2(
                                        context,
                                        Icons.medical_services_outlined,
                                        Colors.black,
                                        Colors.black,
                                        maxWidth(context),
                                        _salutation,
                                        salutationList,
                                        myColor.scaffoldBackgroundColor,
                                        onValueChanged: (value) {
                                          setState(() {
                                            _salutation = value.name!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  flex: 1,
                                  child: StreamBuilder<ApiResponse<dynamic>>(
                                    stream: departmentBloc!.apiListStream,
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        switch (snapshot.data!.status) {
                                          case Status.LOADING:
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Department',
                                                  style: kStyleNormal.copyWith(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox16(),
                                                myDropDown2(
                                                  context,
                                                  Icons.room_outlined,
                                                  Colors.black,
                                                  Colors.black,
                                                  maxWidth(context),
                                                  'Select Department',
                                                  departmentDynamicModel,
                                                  myColor
                                                      .scaffoldBackgroundColor,
                                                  onValueChanged: (value) {},
                                                ),
                                              ],
                                            );
                                          case Status.COMPLETED:
                                            if (snapshot.data!.data.isEmpty) {
                                              return Container();
                                            }
                                            List<DepartmentModel>
                                                departmentModel =
                                                List<DepartmentModel>.from(
                                                    snapshot.data!.data.map(
                                                        (i) => DepartmentModel
                                                            .fromJson(i)));
                                            departmentDynamicModel.clear();
                                            for (int i = 0;
                                                i < departmentModel.length;
                                                i++) {
                                              departmentDynamicModel.add(
                                                GetIDNameModel(
                                                  id: departmentModel[i]
                                                      .id
                                                      .toString(),
                                                  name: departmentModel[i]
                                                      .department
                                                      .toString(),
                                                ),
                                              );
                                            }
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Department',
                                                  style: kStyleNormal.copyWith(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox16(),
                                                myDropDown2(
                                                  context,
                                                  Icons
                                                      .health_and_safety_outlined,
                                                  kBlack,
                                                  kBlack,
                                                  maxWidth(context),
                                                  _department ??
                                                      'Select Department',
                                                  departmentDynamicModel,
                                                  myColor
                                                      .scaffoldBackgroundColor,
                                                  onValueChanged: (value) {
                                                    setState(() {
                                                      _departmentID = int.parse(
                                                          value.id.toString());
                                                      _department =
                                                          value.name.toString();
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          case Status.ERROR:
                                            return Container(
                                              width: maxWidth(context),
                                              height: 135.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Center(
                                                child: Text('Server Error'),
                                              ),
                                            );
                                        }
                                      }
                                      return SizedBox(
                                        width: maxWidth(context),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Doctor'
                          ? const SizedBox16()
                          : Container(),
                      widget.userTypeModel.name == 'Doctor' ||
                              widget.userTypeModel.name == 'Nurse'
                          ? mytextFormFieldWithPrefixIcon(
                              context,
                              FocusNode(),
                              'Specialization',
                              _specialization ?? 'Enter your specialization',
                              'Enter your specialization',
                              _specialization,
                              Icons.local_hospital_outlined,
                              kWhite,
                              onValueChanged: (value) {
                                _specialization = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Doctor' ||
                              widget.userTypeModel.name == 'Nurse'
                          ? myNumberTextFormField(
                              'Years Practiced',
                              _yearsPracticed ?? 'Enter your years practiced',
                              'Enter your years practiced',
                              _yearsPracticed,
                              Icons.calendar_month_outlined,
                              kWhite,
                              onValueChanged: (value) {
                                _yearsPracticed = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Doctor' ||
                              widget.userTypeModel.name == 'Nurse'
                          ? mytextFormFieldWithPrefixIcon(
                              context,
                              FocusNode(),
                              'Qualification',
                              _qualification ?? 'Enter your qualification',
                              'Enter your qualification',
                              _qualification,
                              Icons.health_and_safety_outlined,
                              kWhite,
                              onValueChanged: (value) {
                                _qualification = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? mytextFormFieldWithPrefixIcon(
                              context,
                              FocusNode(),
                              'Store Name',
                              _storeName ?? 'Enter your Store Name',
                              'Enter your store name',
                              _storeName,
                              Icons.store,
                              kWhite,
                              onValueChanged: (value) {
                                _storeName = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? StreamBuilder<ApiResponse<dynamic>>(
                              stream: vendorTypeBloc!.apiListStream,
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.LOADING:
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Vendor Type',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox16(),
                                          myDropDown2(
                                              context,
                                              Icons.shop_2_outlined,
                                              const Color.fromARGB(
                                                  255, 5, 2, 2),
                                              Colors.black,
                                              maxWidth(context),
                                              'Loading',
                                              vendorTypeList,
                                              Colors.white,
                                              onValueChanged: (value) {}),
                                        ],
                                      );

                                    case Status.COMPLETED:
                                      List<AllListOfVendorsModel>
                                          allListOfVendorsModel =
                                          List<AllListOfVendorsModel>.from(
                                              snapshot.data!.data.map((i) =>
                                                  AllListOfVendorsModel
                                                      .fromJson(i)));
                                      vendorTypeList.clear();
                                      for (int i = 0;
                                          i < allListOfVendorsModel.length;
                                          i++) {
                                        vendorTypeList.add(GetIDNameModel(
                                          id: allListOfVendorsModel[i]
                                              .id
                                              .toString(),
                                          name: allListOfVendorsModel[i]
                                              .vendorType,
                                        ));
                                      }
                                      if (snapshot.data!.data.isEmpty) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Vendor Type',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox16(),
                                            myDropDown2(
                                                context,
                                                Icons.shop_2_outlined,
                                                Colors.black,
                                                Colors.black,
                                                maxWidth(context),
                                                'No any type',
                                                vendorTypeList,
                                                myColor.scaffoldBackgroundColor
                                                    .withOpacity(0.4),
                                                onValueChanged: (value) {}),
                                          ],
                                        );
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Vendor Type',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox16(),
                                          myDropDown2(
                                              context,
                                              Icons.shop_2_outlined,
                                              Colors.black,
                                              Colors.black,
                                              maxWidth(context),
                                              _vendorTypeValue ?? 'Select Type',
                                              vendorTypeList,
                                              myColor.scaffoldBackgroundColor,
                                              onValueChanged: (value) {
                                            setState(() {
                                              _vendorTypeID = value.id;
                                              _vendorTypeValue = value.name;
                                            });
                                          }),
                                        ],
                                      );
                                    case Status.ERROR:
                                      return Column(
                                        children: [
                                          Text(
                                            'Vendor Type',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox16(),
                                          myDropDown2(
                                              context,
                                              Icons.shop_2_outlined,
                                              const Color.fromARGB(
                                                  255, 5, 2, 2),
                                              Colors.black,
                                              maxWidth(context),
                                              'Server Error',
                                              vendorTypeList,
                                              Colors.white,
                                              onValueChanged: (value) {}),
                                        ],
                                      );
                                  }
                                }
                                return SizedBox(
                                  width: maxWidth(context),
                                  height: 200,
                                );
                              }),
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? const SizedBox16()
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? myNumberTextFormField(
                              'Company contact',
                              companyContact ?? 'Enter your company contact',
                              'Enter your company contact',
                              companyContact,
                              Icons.call_outlined,
                              kWhite,
                              onValueChanged: (value) {
                                companyContact = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Vendor' ||
                              widget.userTypeModel.name == 'RO'
                          ? myNumberTextFormField(
                              widget.userTypeModel.name == 'RO'
                                  ? 'Marketing Supervisor Code'
                                  : 'Registration number',
                              companyRegistration ??
                                  (widget.userTypeModel.name == 'RO'
                                      ? 'Enter your marketing supervisor code'
                                      : 'Enter your registration number'),
                              widget.userTypeModel.name == 'RO'
                                  ? 'Enter your marketing supervisor code'
                                  : 'Enter your registration number',
                              companyRegistration,
                              Icons.numbers,
                              kWhite,
                              onValueChanged: (value) {
                                companyRegistration = value;
                              },
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Doctor' ||
                              widget.userTypeModel.name == 'Nurse' ||
                              widget.userTypeModel.name == 'RO'
                          ? myGender(
                              context,
                              kStyleNormal.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                              kWhite,
                              _gender,
                              onValueChanged: (value) {
                                _gender = value;
                              },
                            )
                          : Container(),
                      const SizedBox16(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.userTypeModel.name == 'Vendor'
                                      ? 'Your Logo'
                                      : 'Your Photo',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox16(),
                                myImagePicker(
                                  textValue: 'Profile',
                                  bgColor: kWhite,
                                  onValueChanged: (value) {
                                    setState(() {
                                      _photo = value.file;
                                      _photoBase64 = value.base64String;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Address',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox16(),
                                GestureDetector(
                                  onTap: () {
                                    requestLocationPermission(
                                        _getLatLng(setState), () {});
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
                                            width: maxWidth(context),
                                            decoration: BoxDecoration(
                                              color: kWhite,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox8(),
                                                Icon(
                                                  Icons.location_on,
                                                  size: 35,
                                                  color:
                                                      myColor.primaryColorDark,
                                                ),
                                                const SizedBox(height: 3),
                                                Text('Location',
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      fontSize: 12.0,
                                                    )),
                                                Text(
                                                  'View Map',
                                                  style: kStyleNormal.copyWith(
                                                    color: myColor
                                                        .primaryColorDark,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10.0),
                                              width: maxWidth(context),
                                              decoration: BoxDecoration(
                                                color: kWhite.withOpacity(0.4),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0)),
                                              ),
                                              child: Text(
                                                testPopModal!.address
                                                    .toString(),
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                height: 25,
                                                width: (maxWidth(context) / 2) -
                                                    25.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                      style:
                                                          kStyleNormal.copyWith(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox16(),
                      Text(
                        widget.userTypeModel.name == 'Vendor'
                            ? 'Company Registration'
                            : 'Upload File',
                        style: kStyleNormal.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox16(),
                      myFilePicker(
                        textValue: 'Upload File',
                        color: kWhite,
                        onValueChanged: (value) {
                          setState(() {
                            _file = value.file;
                            _fileBase64 = value.base64String;
                          });
                        },
                      ),
                      widget.userTypeModel.name == 'Vendor'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox12(),
                                Text(
                                  'Tax Clearance Document',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox16(),
                                myFilePicker(
                                  textValue: 'Upload File',
                                  color: kWhite,
                                  onValueChanged: (value) {
                                    setState(() {
                                      _taxFile = value.file;
                                      _taxFileBase64 = value.base64String;
                                    });
                                  },
                                ),
                                const SizedBox12(),
                                Text(
                                  'IRD Document',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox16(),
                                myFilePicker(
                                  textValue: 'Upload File',
                                  color: kWhite,
                                  onValueChanged: (value) {
                                    setState(() {
                                      _irdFile = value.file;
                                      _irdFileBase64 = value.base64String;
                                    });
                                  },
                                ),
                              ],
                            )
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? nomineeCard()
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? guarantorCard()
                          : Container(),
                      widget.userTypeModel.name == 'Vendor'
                          ? membershipCard()
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              activeColor: myColor.primaryColorDark,
                              side: const BorderSide(
                                  width: 1.0, color: Colors.grey),
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                              value: _isChecked,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _isChecked = newValue!;
                                  _isBtnActive = newValue;
                                });
                              }),
                          const SizedBox(width: 5.0),
                          Text(
                            'Agree to',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'Terms and Conditions',
                            style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: myColor.primaryColorDark),
                          ),
                        ],
                      ),
                      const SizedBox8(),
                      StreamBuilder<dynamic>(
                          initialData: _isLoading,
                          stream: btnBloc!.stateStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return myBtnLoading(context, 55.0);
                            } else {
                              return SizedBox(
                                width: maxWidth(context),
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: myColor.primaryColorDark,
                                    disabledForegroundColor: myColor
                                        .primaryColorDark
                                        .withOpacity(0.38),
                                    disabledBackgroundColor: myColor
                                        .primaryColorDark
                                        .withOpacity(0.12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  onPressed: _isBtnActive
                                      ? () {
                                          _isChecked
                                              ? registerBtn(context)
                                              : nullBtn();
                                        }
                                      : null,
                                  child: Text(
                                    widget.userTypeModel.name == 'Doctor' ||
                                            widget.userTypeModel.name == 'Nurse'
                                        ? 'Submit'
                                        : 'Create',
                                    style: kStyleButton,
                                  ),
                                ),
                              );
                            }
                          }),
                      const SizedBox16(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nomineeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox8(),
        Text(
          'Nominator Details',
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
          'Nominator Name',
          nomineeName ?? 'Enter your nominator Name',
          'Enter your nominator name',
          nomineeName,
          Icons.perm_identity_outlined,
          kWhite,
          onValueChanged: (value) {
            nomineeName = value;
          },
        ),
        myNumberTextFormField(
          'Nominator Contact',
          nomineeContact ?? 'Enter your nominator contact',
          'Enter your nominator contact',
          nomineeContact,
          Icons.call_outlined,
          kWhite,
          onValueChanged: (value) {
            nomineeContact = value;
          },
        ),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Nominator Address',
          nomineeAddress ?? 'Enter your nominator address',
          'Enter your nominator address',
          nomineeAddress,
          Icons.location_on_outlined,
          kWhite,
          onValueChanged: (value) {
            nomineeAddress = value;
          },
        ),
      ],
    );
  }

  Widget guarantorCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox8(),
        Text(
          'Guarantor Details',
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
          'Guarantor name',
          guarantorName ?? 'Enter your guarantor name',
          'Enter your guarantor name',
          guarantorName,
          Icons.perm_identity_outlined,
          kWhite,
          onValueChanged: (value) {
            guarantorName = value;
          },
        ),
        myNumberTextFormField(
          'Guarantor Contact',
          guarantorContact ?? 'Enter your guarantor contact',
          'Enter your guarantor contact',
          guarantorContact,
          Icons.call_outlined,
          kWhite,
          onValueChanged: (value) {
            guarantorContact = value;
          },
        ),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Guarantor Address',
          guarantorAddress ?? 'Enter your guarantor address',
          'Enter your guarantor address',
          guarantorAddress,
          Icons.location_on_outlined,
          kWhite,
          onValueChanged: (value) {
            guarantorAddress = value;
          },
        ),
      ],
    );
  }

  Widget membershipCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox8(),
        Text(
          'Membership Details',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        myNumberTextFormField(
          'Membership time frame',
          membershipTimeFrame,
          'Enter your membership time frame',
          membershipTimeFrame,
          Icons.calendar_month_outlined,
          kWhite,
          onValueChanged: (value) {
            membershipTimeFrame = value;
          },
        ),
        myNumberTextFormField(
          'Membership fee',
          membershipFee,
          'Enter your membership fee',
          membershipFee,
          Icons.attach_money_outlined,
          kWhite,
          onValueChanged: (value) {
            membershipFee = value;
          },
        ),
        myNumberTextFormField(
          'Payment time frame',
          paymentTimeFrame,
          'Enter your payment time frame',
          paymentTimeFrame,
          Icons.calendar_month_outlined,
          kWhite,
          onValueChanged: (value) {
            paymentTimeFrame = value;
          },
        ),
        myNumberTextFormField(
          'Termination time frame',
          terminationTimeFrame,
          'Enter your termination time frame',
          terminationTimeFrame,
          Icons.calendar_month_outlined,
          kWhite,
          onValueChanged: (value) {
            terminationTimeFrame = value;
          },
        ),
      ],
    );
  }

  Future<bool?> nullBtn() {
    return Fluttertoast.showToast(msg: "Validate");
  }

  void registerBtn(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    int? statusCode;
    var isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      btnBloc!.storeData(!_isLoading);
      switch (widget.userTypeModel.name) {
        case 'RO':
          statusCode = await API().postData(
            context,
            BecomeRoModel(
              address: testPopModal!.address.toString(),
              file: _fileBase64,
              image: _photoBase64,
              marketing: companyRegistration,
              gender: _gender,
            ),
            endpoints.postBecomePartnerRoEndpoint,
          );
          break;

        case 'Vendor':
          statusCode = await API().postData(
            context,
            BecomeVendorModel(
              store: _storeName,
              vendorType: _vendorTypeID,
              address: testPopModal!.address.toString(),
              file: _fileBase64,
              image: _photoBase64,
              ird: _irdFileBase64,
              tax: _taxFileBase64,
              registrationNo: companyRegistration,
              companyContact: companyContact,
              guarantorName: guarantorName,
              guarantorAddress: guarantorAddress,
              guarantorContact: guarantorContact,
              nominatorName: nomineeName,
              nominatorAddress: nomineeAddress,
              nominatorContact: nomineeContact,
              membershipTimeFrame: membershipTimeFrame,
              membershipFee: int.parse(membershipFee.toString()),
              paymentTimeFrame: paymentTimeFrame,
              terminationTimeFrame: terminationTimeFrame,
            ),
            endpoints.postBecomePartnerVendorEndpoint,
          );
          break;

        case 'Driver':
          statusCode = await API().postData(
            context,
            BecomeDriverModel(
              address: testPopModal!.address.toString(),
              file: _fileBase64,
              image: _photoBase64,
            ),
            endpoints.postBecomePartnerDriverEndpoint,
          );
          break;

        case 'Doctor':
          statusCode = await API().postData(
            context,
            BecomeDoctorModel(
              nmcNo: _nmcNumber,
              salutation: _salutation,
              department: _departmentID,
              gender: _gender,
              qualification: _qualification,
              specialization: _specialization,
              yearPracticed: _yearsPracticed,
              address: testPopModal!.address.toString(),
              file: _fileBase64,
              image: _photoBase64,
            ),
            endpoints.postBecomePartnerDoctorEndpoint,
          );
          break;

        case 'Nurse':
          statusCode = await API().postData(
            context,
            BecomeNurseModel(
              nncNo: _nmcNumber,
              gender: _gender,
              qualification: _qualification,
              yearPracticed: _yearsPracticed,
              address: testPopModal!.address.toString(),
              file: _fileBase64,
              image: _photoBase64,
            ),
            endpoints.postBecomePartnerNurseEndpoint,
          );
          break;
        default:
      }
    }

    if (statusCode == 200) {
      sharedPrefs.storeToDevice("becomeMember", "pending");
      pop_upHelper.popUpToNewScreen(
          context,
          CoolAlertType.success,
          '${widget.userTypeModel.name} document has been submitted.',
          const MainHomePage(
            index: 4,
            tabIndex: 0,
          ));
      btnBloc!.storeData(_isLoading);
    } else {
      btnBloc!.storeData(_isLoading);
    }
  }
}
