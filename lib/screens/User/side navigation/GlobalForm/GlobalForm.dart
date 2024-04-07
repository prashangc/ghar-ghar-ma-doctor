import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/screens/User/profile/profileScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:location/location.dart' as locationPackage;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class GlobalForm extends StatefulWidget {
  const GlobalForm({Key? key}) : super(key: key);

  @override
  State<GlobalForm> createState() => _GlobalFormState();
}

class _GlobalFormState extends State<GlobalForm> {
  final scrollToPermAddressKey = GlobalKey<FormState>();
  final scrollToIdentificationKey = GlobalKey<FormState>();
  ProfileModel? profileModel;
  int? userID;
  String? globalFormID;
  int currentStep = 0;
  bool _isTermsAndConditionsChecked = false;
  bool _isSaveAsAbove = false;
  bool checkCondition = true;
  int areYouNRN = 0,
      areYouUSResidence = 0,
      haveGreenCard = 0,
      haveAnotherAccountBank = 0,
      haveCriminalOffence = 0,
      areYouUSCitizen = 0;
  StateHandlerBloc? areYouNRNBloc,
      haveGreenCardBloc,
      skipNomineeBloc,
      skipBeneficiaryBloc,
      haveAnotherAccountBankBloc,
      areYouUSCitizenBloc,
      areYouUSResidenceBloc,
      dobBloc,
      haveCriminalOffenceBloc;
  FilePickerResult? result;
  PlatformFile? file;
  File? _docBackFileImage, _docFrontFileImage, _profileFileImage;
  String? _docFrontBase64, _docBackBase64, _profileBase64;
  List<PlatformFile>? files;
  StateHandlerBloc? btnBloc;
  List selectedIndexs = [];
  final _form = GlobalKey<FormState>();
  List<GetProvinceModel> getProvinceModel = [];
  List<GetIDNameModel> provinceModel = [];
  List<GetIDNameModel> districtModel = [];
  List<GetIDNameModel> wardModel = [];
  List<GetIDNameModel> municipalityModel = [];
  List<GetProvinceModel> getProvinceModelTemp = [];
  List<GetIDNameModel> provinceModelTemp = [];
  List<GetIDNameModel> districtModelTemp = [];
  List<GetIDNameModel> wardModelTemp = [];
  List<GetIDNameModel> municipalityModelTemp = [];
  PostGlobalFormModel? viewGlobalFormModel;
  String _country = 'Nepal';
  String? _firstName,
      _countryFlag,
      _middleName,
      _lastName,
      _email,
      _salutation,
      _provinceID,
      _provinceIDTemp,
      _gender,
      _dateOfBirthEng,
      _dateOfBirthNep,
      _fatherName,
      _motherName,
      _grandFatherName,
      _spouseName,
      _phone,
      _nationality,
      _accountBranch,
      _grandMotherName,
      _issuedDistrict,
      _currency,
      _districtIDTemp,
      _districtNameTemp,
      _provinceNameTemp,
      _wardIDTemp,
      _wardNameTemp,
      _municipalityIDTemp,
      _municipalityNameTemp,
      _districtID,
      _districtName,
      _provinceName,
      _wardID,
      _wardName,
      _municipalityID,
      _municipalityName,
      _permAddress,
      _tempAddress,
      _maritalStatus,
      _workStatus,
      _citizenshipNumber,
      _issuedDateNep,
      _houseNo,
      _houseNoTemp,
      _issuedDateEng,
      _frontBase64Img,
      _backBase64Img,
      _purposeOfAccount,
      _incomeSource,
      _occupation,
      _organizationContact,
      _organizationName,
      _organizationAddress,
      _designation,
      _panNo,
      _annualIncome,
      _identificationType,
      _education,
      _noOfYearlyTransaction,
      _noOfMonthlyTransaction,
      _yearlyAmount,
      _monthlyAmount,
      _maxAmount,
      _nomineeGrandfatherName,
      _nomineeFatherName,
      _nomineeName,
      _nomineeRelation,
      _nomineeCitizenshipIssuedPlace,
      _nomineeCitizenshipNumber,
      _nomineeCitizenshipIssuedDateEng,
      _nomineeCitizenshipIssuedDateNep,
      _nomineeBirthdateEng,
      _nomineeBirthdateNep,
      _nomineePermanentAddress,
      _nomineeCurrentAddress,
      _nomineePhoneNumber,
      _beneficiaryAddress,
      _beneficiaryName,
      _beneficiaryContact,
      _beneficiaryRelation;
  bool kycFilledSuccesfully = false;
  bool isProvinceDropDownOpened = false;
  ApiHandlerBloc? provinceBloc,
      districtBloc,
      wardBloc,
      municipalityBloc,
      kycBloc;
  ApiHandlerBloc? provinceBlocTemp,
      viewGlobalFormBloc,
      districtBlocTemp,
      wardBlocTemp,
      municipalityBlocTemp;
  GoogleMapModel? testPopModal;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    kycBloc = ApiHandlerBloc();
    kycBloc!.fetchAPIList(endpoints.getkycStatusEndpoint, context: context);
    viewGlobalFormBloc = ApiHandlerBloc();
    viewGlobalFormBloc!.fetchAPIList(endpoints.getViewGlobalForm);

    userID = int.parse(sharedPrefs.getUserID('userID'));
    dobBloc = StateHandlerBloc();
    _districtID = '0';
    _wardID = '0';
    _provinceID = '0';
    _municipalityID = '0';
    _districtIDTemp = '0';
    _wardIDTemp = '0';
    _provinceIDTemp = '0';
    _municipalityIDTemp = '0';
    provinceBloc = ApiHandlerBloc();
    districtBloc = ApiHandlerBloc();
    municipalityBloc = ApiHandlerBloc();
    wardBloc = ApiHandlerBloc();
    provinceBlocTemp = ApiHandlerBloc();
    districtBlocTemp = ApiHandlerBloc();
    municipalityBlocTemp = ApiHandlerBloc();
    wardBlocTemp = ApiHandlerBloc();
    btnBloc = StateHandlerBloc();
    getProvinceApiData('all');
    getProvinceApiDataTemp('all');
    areYouNRNBloc = StateHandlerBloc();
    skipNomineeBloc = StateHandlerBloc();
    skipBeneficiaryBloc = StateHandlerBloc();
    haveGreenCardBloc = StateHandlerBloc();
    haveAnotherAccountBankBloc = StateHandlerBloc();
    areYouUSCitizenBloc = StateHandlerBloc();
    areYouUSResidenceBloc = StateHandlerBloc();
    haveCriminalOffenceBloc = StateHandlerBloc();
  }

  refresh() async {
    await getProfileData();
    // await getLocalData();
  }

  getProfileData() {
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    if (profileModel != null) {
      List<String> words = profileModel!.member!.name!.split(" ");
      if (words.isNotEmpty) {
        _firstName = words[0];

        if (words.length > 1) {
          _lastName = words[words.length - 1];
          if (words.length > 2) {
            _middleName = words.sublist(1, words.length - 1).join(" ");
          }
        }
      }
      _email = profileModel!.member!.email;
      _gender = profileModel!.gender;
      _phone = profileModel!.member!.phone;

      _dateOfBirthEng = profileModel!.dob;
      if (profileModel!.dob != null) {
        DateTime date = DateTime.parse(profileModel!.dob.toString());
        _dateOfBirthNep = date.toNepaliDateTime().toString().substring(0, 10);
      }
      _country = profileModel!.country.toString();
    }
  }

  getKycDataFromAPI() {
    _firstName = viewGlobalFormModel!.firstName;
    _middleName = viewGlobalFormModel!.middleName;
    _lastName = viewGlobalFormModel!.lastName;
    _email = viewGlobalFormModel!.email;
    _gender = viewGlobalFormModel!.gender;
    _fatherName = viewGlobalFormModel!.fatherFullName;
    _motherName = viewGlobalFormModel!.motherFullName;
    _grandFatherName = viewGlobalFormModel!.grandfatherFullName;
    _spouseName = viewGlobalFormModel!.husbandWifeFullName;
    _phone = viewGlobalFormModel!.mobileNumber;
    _currency = viewGlobalFormModel!.currency;
    _salutation = viewGlobalFormModel!.salutation;
    _provinceID = viewGlobalFormModel!.permProvinceId.toString();
    _provinceIDTemp = viewGlobalFormModel!.tempProvinceId.toString();
    _dateOfBirthEng = viewGlobalFormModel!.birthDate;
    if (viewGlobalFormModel!.birthDate != null) {
      DateTime date = DateTime.parse(viewGlobalFormModel!.birthDate.toString());
      _dateOfBirthNep = date.toNepaliDateTime().toString().substring(0, 10);
    }

    _nationality = viewGlobalFormModel!.nationality;
    _accountBranch = viewGlobalFormModel!.accountBranch;
    _grandMotherName = viewGlobalFormModel!.grandmotherFullName;
    _issuedDistrict = viewGlobalFormModel!.citizenshipIssueDistrict;
    _country = viewGlobalFormModel!.country!;
    _districtIDTemp = viewGlobalFormModel!.tempDistrictId.toString();
    // _districtNameTemp = viewGlobalFormModel!.districtNameTemp;
    // _provinceNameTemp = viewGlobalFormModel!.provinceNameTemp;
    _wardIDTemp = viewGlobalFormModel!.tempWardId.toString();
    // _wardNameTemp = viewGlobalFormModel!.wardNameTemp;
    _municipalityIDTemp = viewGlobalFormModel!.tempMunicipalityId.toString();
    // _municipalityNameTemp = viewGlobalFormModel!.vdcNameTemp;
    _districtID = viewGlobalFormModel!.permDistrictId.toString();
    // _districtName = viewGlobalFormModel!.districtNamePerm;
    // _provinceName = viewGlobalFormModel!.provinceNamePerm;
    _wardID = viewGlobalFormModel!.permWardId.toString();
    // _wardName = viewGlobalFormModel!.wardNamePerm;
    _municipalityID = viewGlobalFormModel!.permMunicipalityId.toString();
    // _municipalityName = viewGlobalFormModel!.vdcNamePerm;
    _permAddress = viewGlobalFormModel!.permLocation;
    _tempAddress = viewGlobalFormModel!.tempLocation;
    _maritalStatus = viewGlobalFormModel!.maritalStatus;
    _workStatus = viewGlobalFormModel!.workStatus;
    _citizenshipNumber = viewGlobalFormModel!.identificationNo;
    _issuedDateEng = viewGlobalFormModel!.citizenshipDate;

    if (viewGlobalFormModel!.citizenshipDate != null) {
      DateTime date =
          DateTime.parse(viewGlobalFormModel!.citizenshipDate.toString());
      _issuedDateNep = date.toNepaliDateTime().toString().substring(0, 10);
    }
    _houseNo = viewGlobalFormModel!.permHouseNumber;
    _houseNoTemp = viewGlobalFormModel!.tempHouseNumber;
    // _frontBase64Img = viewGlobalFormModel!.phone;
    // _backBase64Img = viewGlobalFormModel!.phone;
    _purposeOfAccount = viewGlobalFormModel!.accountPurpose;
    _incomeSource = viewGlobalFormModel!.sourceOfIncome;
    _occupation = viewGlobalFormModel!.occupation;
    _organizationContact = viewGlobalFormModel!.organizationNumber;
    _organizationName = viewGlobalFormModel!.organizationName;
    _organizationAddress = viewGlobalFormModel!.organizationAddress;
    _designation = viewGlobalFormModel!.designation;

    _panNo = viewGlobalFormModel!.panNumber;
    _annualIncome = viewGlobalFormModel!.annualIncome;
    _identificationType = viewGlobalFormModel!.identificationType;

    _education = viewGlobalFormModel!.education;
    _noOfYearlyTransaction = viewGlobalFormModel!.numberOfYearlyTransaction;
    _noOfMonthlyTransaction = viewGlobalFormModel!.numberOfMonthlyTransaction;
    _yearlyAmount = viewGlobalFormModel!.yearlyAmountOfTransaction;
    _monthlyAmount = viewGlobalFormModel!.monthlyAmountOfTransaction;
    _maxAmount = viewGlobalFormModel!.maxAmountPerTansaction;

    _nomineeGrandfatherName = viewGlobalFormModel!.nomineeGrandfatherName;
    _nomineeFatherName = viewGlobalFormModel!.nomineeFatherName;
    _nomineeName = viewGlobalFormModel!.nomineeName;
    _nomineeRelation = viewGlobalFormModel!.nomineeRelation;
    _nomineeCitizenshipIssuedPlace =
        viewGlobalFormModel!.nomineeCitizenshipIssuedPlace;
    _nomineeCitizenshipNumber = viewGlobalFormModel!.nomineeCitizenshipNumber;
    _nomineeCitizenshipIssuedDateEng =
        viewGlobalFormModel!.nomineeCitizenshipIssuedDate;
    if (viewGlobalFormModel!.nomineeCitizenshipIssuedDate != null) {
      DateTime date = DateTime.parse(
          viewGlobalFormModel!.nomineeCitizenshipIssuedDate.toString());
      _nomineeCitizenshipIssuedDateNep =
          date.toNepaliDateTime().toString().substring(0, 10);
    }

    _nomineeBirthdateEng = viewGlobalFormModel!.nomineeBirthdate;
    if (viewGlobalFormModel!.nomineeBirthdate != null) {
      DateTime date =
          DateTime.parse(viewGlobalFormModel!.nomineeBirthdate.toString());
      _nomineeBirthdateNep =
          date.toNepaliDateTime().toString().substring(0, 10);
    }
    _nomineePermanentAddress = viewGlobalFormModel!.nomineePermanentAddress;
    _nomineeCurrentAddress = viewGlobalFormModel!.nomineeCurrentAddress;
    _nomineePhoneNumber = viewGlobalFormModel!.nomineePhoneNumber;
    _beneficiaryAddress = viewGlobalFormModel!.beneficiaryAddress;
    _beneficiaryName = viewGlobalFormModel!.beneficiaryRelation;
    _beneficiaryContact = viewGlobalFormModel!.beneficiaryContactNumber;
    _beneficiaryRelation = viewGlobalFormModel!.beneficiaryRelation;
  }
  // Future getLocalData() async {
  //   globalFormDraftDatabaseModel =
  //       await MyDatabase.instance.fetchGlobalFormDraftData(userID);
  //   if (globalFormDraftDatabaseModel.isEmpty) {
  //     createFirstRowInDb();
  //   }
  //   if (kDebugMode) {
  //     print(globalFormDraftDatabaseModel.length);
  //     print(
  //         'kycSaveAsDraftDatabaseModel[0].lastName ${viewGlobalFormModel!.lastName}');
  //   }
  //   _firstName = viewGlobalFormModel!.firstName;
  //   _middleName = viewGlobalFormModel!.middleName;
  //   _lastName = viewGlobalFormModel!.lastName;
  //   _email = viewGlobalFormModel!.email;
  //   _gender = viewGlobalFormModel!.gender;
  //   _fatherName = viewGlobalFormModel!.fatherName;
  //   _motherName = viewGlobalFormModel!.motherName;
  //   _grandFatherName = viewGlobalFormModel!.grandFatherName;
  //   _spouseName = viewGlobalFormModel!.spouseName;
  //   _phone = viewGlobalFormModel!.phone;

  //   _salutation = viewGlobalFormModel!.salutation;
  //   _provinceID = viewGlobalFormModel!.provinceIDPerm;
  //   _provinceIDTemp = viewGlobalFormModel!.provinceIDTemp;
  //   _dateOfBirthEng = viewGlobalFormModel!.dobEng;
  //   _dateOfBirthNep = viewGlobalFormModel!.dobNep;
  //   _nationality = viewGlobalFormModel!.nationality;
  //   _accountBranch = viewGlobalFormModel!.branch;
  //   _grandMotherName = viewGlobalFormModel!.grandMotherName;
  //   _issuedDistrict = viewGlobalFormModel!.issuedDistrict;
  //   _country = viewGlobalFormModel!.country!;
  //   _districtIDTemp = viewGlobalFormModel!.districtIDTemp;
  //   _districtNameTemp = viewGlobalFormModel!.districtNameTemp;
  //   _provinceNameTemp = viewGlobalFormModel!.provinceNameTemp;
  //   _wardIDTemp = viewGlobalFormModel!.wardIDTemp;
  //   _wardNameTemp = viewGlobalFormModel!.wardNameTemp;
  //   _municipalityIDTemp = viewGlobalFormModel!.vdcIDTemp;
  //   _municipalityNameTemp = viewGlobalFormModel!.vdcNameTemp;
  //   _districtID = viewGlobalFormModel!.districtIDPerm;
  //   _districtName = viewGlobalFormModel!.districtNamePerm;
  //   _provinceName = viewGlobalFormModel!.provinceNamePerm;
  //   _wardID = viewGlobalFormModel!.wardIDPerm;
  //   _wardName = viewGlobalFormModel!.wardNamePerm;
  //   _municipalityID = viewGlobalFormModel!.vdcIDPerm;
  //   _municipalityName = viewGlobalFormModel!.vdcNamePerm;
  //   _permAddress = viewGlobalFormModel!.permanentAddress;
  //   _tempAddress = viewGlobalFormModel!.temporaryAddress;
  //   _maritalStatus = viewGlobalFormModel!.maritalStatus;
  //   _workStatus = viewGlobalFormModel!.workStatus;
  //   _citizenshipNumber =
  //       viewGlobalFormModel!.identificationDocNumber;
  //   _issuedDateNep = viewGlobalFormModel!.issuedDateNep;
  //   _houseNo = viewGlobalFormModel!.houseNoPerm;
  //   _houseNoTemp = viewGlobalFormModel!.houseNoTemp;
  //   _issuedDateEng = viewGlobalFormModel!.issuedDateEng;
  //   // _frontBase64Img = viewGlobalFormModel!.phone;
  //   // _backBase64Img = viewGlobalFormModel!.phone;
  //   _purposeOfAccount = viewGlobalFormModel!.purposeOfAccount;
  //   _incomeSource = viewGlobalFormModel!.incomeSource;
  //   _occupation = viewGlobalFormModel!.occupation;
  //   _organizationContact = viewGlobalFormModel!.organizationContact;
  //   _organizationName = viewGlobalFormModel!.organizationName;
  //   _organizationAddress = viewGlobalFormModel!.organizationAddress;
  //   _designation = viewGlobalFormModel!.designation;

  //   _panNo = viewGlobalFormModel!.pan;
  //   _annualIncome = viewGlobalFormModel!.annualIncome;
  //   _identificationType = viewGlobalFormModel!.identificationType;

  //   _education = viewGlobalFormModel!.education;
  //   _noOfYearlyTransaction =
  //       viewGlobalFormModel!.noOfyearlyTransaction;
  //   _noOfMonthlyTransaction =
  //       viewGlobalFormModel!.noOfMonthlyTransaction;
  //   _yearlyAmount = viewGlobalFormModel!.yearlyAmount;
  //   _monthlyAmount = viewGlobalFormModel!.monthlyAmount;
  //   _maxAmount = viewGlobalFormModel!.maxAmount;

  //   _nomineeGrandfatherName =
  //       viewGlobalFormModel!.nomineeGrandfatherName;
  //   _nomineeFatherName = viewGlobalFormModel!.nomineeFatherName;
  //   _nomineeName = viewGlobalFormModel!.nomineeName;
  //   _nomineeRelation = viewGlobalFormModel!.nomineeRelation;
  //   _nomineeCitizenshipIssuedPlace =
  //       viewGlobalFormModel!.nomineeCitizenshipIssuedPlace;
  //   _nomineeCitizenshipNumber =
  //       viewGlobalFormModel!.nomineeCitizenship;
  //   _nomineeCitizenshipIssuedDateEng =
  //       viewGlobalFormModel!.nomineeCitizenshipIssuedDateEng;
  //   _nomineeCitizenshipIssuedDateNep =
  //       viewGlobalFormModel!.nomineeCitizenshipIssuedDateNep;
  //   _nomineeBirthdateEng = viewGlobalFormModel!.nomineeDobEng;
  //   _nomineeBirthdateNep = viewGlobalFormModel!.nomineeDobNep;
  //   _nomineePermanentAddress =
  //       viewGlobalFormModel!.nomineePermanentAddress;
  //   _nomineeCurrentAddress =
  //       viewGlobalFormModel!.nomineeCurrentAddress;
  //   _nomineePhoneNumber = viewGlobalFormModel!.nomineePhone;
  //   _beneficiaryAddress = viewGlobalFormModel!.beneficiaryAddress;
  //   _beneficiaryName = viewGlobalFormModel!.beneficiaryRelation;
  //   _beneficiaryContact = viewGlobalFormModel!.beneficiaryPhone;
  //   _beneficiaryRelation = viewGlobalFormModel!.beneficiaryRelation;

  //   if (_provinceID != '') {
  //     districtBloc!.fetchAPIList('fetchdistrict?province_id=$_provinceID');
  //   }
  //   if (_districtID != '') {
  //     municipalityBloc!.fetchAPIList('fetchmun?district_id=$_districtID');
  //   }
  //   print('_municipalityID $_municipalityID');
  //   if (_municipalityID != '') {
  //     wardBloc!.fetchAPIList('fetchward?municipality_id=$_municipalityID');
  //   }
  //   if (_provinceIDTemp != '') {
  //     districtBlocTemp!
  //         .fetchAPIList('fetchdistrict?province_id=$_provinceIDTemp');
  //   }
  //   if (_districtIDTemp != '') {
  //     municipalityBlocTemp!
  //         .fetchAPIList('fetchmun?district_id=$_districtIDTemp');
  //   }
  //   if (_municipalityIDTemp != '') {
  //     wardBlocTemp!
  //         .fetchAPIList('fetchward?municipality_id=$_municipalityIDTemp');
  //   }

  //   setState(() {});
  // }

  // createFirstRowInDb() {
  //   MyDatabase.instance.addGlobalFormDraft(
  //     const GlobalFormDraftDatabaseModel(
  //       id: 1,
  //     ),
  //     // GlobalFormDraftDatabaseModel(
  //     //   userID: userID,
  //     //   id: 1,
  //     //   salutation: '',
  //     //   firstName: '',
  //     //   middleName: '',
  //     //   lastName: '',
  //     //   phone: '',
  //     //   email: '',
  //     //   dobNep: '',
  //     //   dobEng: '',
  //     //   gender: '',
  //     //   nationality: '',
  //     //   branch: '',
  //     //   country: '',
  //     //   houseNoPerm: '',
  //     //   provinceIDPerm: '',
  //     //   provinceNamePerm: '',
  //     //   districtIDPerm: '',
  //     //   districtNamePerm: '',
  //     //   vdcIDPerm: '',
  //     //   vdcNamePerm: '',
  //     //   wardIDPerm: '',
  //     //   wardNamePerm: '',
  //     //   permanentAddress: '',
  //     //   houseNoTemp: '',
  //     //   provinceIDTemp: '',
  //     //   provinceNameTemp: '',
  //     //   districtIDTemp: '',
  //     //   districtNameTemp: '',
  //     //   vdcIDTemp: '',
  //     //   vdcNameTemp: '',
  //     //   wardIDTemp: '',
  //     //   wardNameTemp: '',
  //     //   temporaryAddress: '',
  //     //   workStatus: '',
  //     //   purposeOfAccount: '',
  //     //   incomeSource: '',
  //     //   annualIncome: '',
  //     //   occupation: '',
  //     //   pan: '',
  //     //   organizationName: '',
  //     //   organizationAddress: '',
  //     //   organizationContact: '',
  //     //   designation: '',
  //     //   identificationType: '',
  //     //   identificationDocNumber: '',
  //     //   issuedDateEng: '',
  //     //   issuedDateNep: '',
  //     //   issuedDistrict: '',
  //     //   fatherName: '',
  //     //   motherName: '',
  //     //   grandFatherName: '',
  //     //   grandMotherName: '',
  //     //   spouseName: '',
  //     //   maritalStatus: '',
  //     //   education: '',
  //     //   maxAmount: '',
  //     //   monthlyAmount: '',
  //     //   yearlyAmount: '',
  //     //   noOfMonthlyTransaction: '',
  //     //   noOfyearlyTransaction: '',
  //     //   nomineeName: '',
  //     //   nomineeFatherName: '',
  //     //   nomineeGrandfatherName: '',
  //     //   nomineeRelation: '',
  //     //   nomineeDobEng: '',
  //     //   nomineeDobNep: '',
  //     //   nomineeCitizenship: '',
  //     //   nomineeCitizenshipIssuedPlace: '',
  //     //   nomineeCitizenshipIssuedDateEng: '',
  //     //   nomineeCitizenshipIssuedDateNep: '',
  //     //   nomineePhone: '',
  //     //   nomineeCurrentAddress: '',
  //     //   nomineePermanentAddress: '',
  //     //   beneficiaryName: '',
  //     //   beneficiaryRelation: '',
  //     //   beneficiaryPhone: '',
  //     //   beneficiaryAddress: '',
  //     // ),
  //   );
  // }

  // updateGlobalFormDraft(key, value) {
  //   MyDatabase.instance.updateGlobalFormDraft(
  //     key, value,
  //     // GlobalFormDraftDatabaseModel(
  //     //   userID: userID,
  //     //   id: 1,
  //     //   salutation: _salutation ?? '',
  //     //   firstName: _firstName ?? '',
  //     //   middleName: _middleName ?? '',
  //     //   lastName: _lastName ?? '',
  //     //   phone: _phone ?? '',
  //     //   email: _email ?? '',
  //     //   dobNep: _dateOfBirthNep ?? '',
  //     //   dobEng: _dateOfBirthEng ?? '',
  //     //   gender: _gender ?? '',
  //     //   nationality: _nationality ?? '',
  //     //   branch: _accountBranch ?? '',
  //     //   country: _country ?? '',
  //     //   houseNoPerm: _houseNo ?? '',
  //     //   provinceIDPerm: _provinceID ?? '',
  //     //   provinceNamePerm: _provinceName ?? '',
  //     //   districtIDPerm: _districtID ?? '',
  //     //   districtNamePerm: _districtName ?? '',
  //     //   vdcIDPerm: _municipalityID ?? '',
  //     //   vdcNamePerm: _municipalityName ?? '',
  //     //   wardIDPerm: _wardID ?? '',
  //     //   wardNamePerm: _wardName ?? '',
  //     //   permanentAddress: _permAddress ?? '',
  //     //   houseNoTemp: _houseNoTemp ?? '',
  //     //   provinceIDTemp: _provinceIDTemp ?? '',
  //     //   provinceNameTemp: _provinceNameTemp ?? '',
  //     //   districtIDTemp: _districtIDTemp ?? '',
  //     //   districtNameTemp: _districtNameTemp ?? '',
  //     //   vdcIDTemp: _municipalityIDTemp ?? '',
  //     //   vdcNameTemp: _municipalityNameTemp ?? '',
  //     //   wardIDTemp: _wardIDTemp ?? '',
  //     //   wardNameTemp: _wardNameTemp ?? '',
  //     //   temporaryAddress: _tempAddress ?? '',
  //     //   workStatus: _workStatus ?? '',
  //     //   purposeOfAccount: _purposeOfAccount ?? '',
  //     //   incomeSource: _incomeSource ?? '',
  //     //   annualIncome: _annualIncome ?? '',
  //     //   occupation: _occupation ?? '',
  //     //   pan: _panNo ?? '',
  //     //   organizationName: _organizationName ?? '',
  //     //   organizationAddress: _organizationAddress ?? '',
  //     //   organizationContact: _organizationContact ?? '',
  //     //   designation: _designation ?? '',
  //     //   identificationType: _identificationType ?? '',
  //     //   identificationDocNumber: _citizenshipNumber ?? '',
  //     //   issuedDateEng: _issuedDateEng ?? '',
  //     //   issuedDateNep: _issuedDateNep ?? '',
  //     //   issuedDistrict: _issuedDistrict ?? '',
  //     //   fatherName: _fatherName ?? '',
  //     //   motherName: _motherName ?? '',
  //     //   grandFatherName: _grandFatherName ?? '',
  //     //   grandMotherName: _grandMotherName ?? '',
  //     //   spouseName: _spouseName ?? '',
  //     //   maritalStatus: _maritalStatus ?? '',
  //     //   education: _education ?? '',
  //     //   maxAmount: _maxAmount ?? '',
  //     //   monthlyAmount: _monthlyAmount ?? '',
  //     //   yearlyAmount: _yearlyAmount ?? '',
  //     //   noOfMonthlyTransaction: _noOfMonthlyTransaction ?? '',
  //     //   noOfyearlyTransaction: _noOfYearlyTransaction ?? '',
  //     //   nomineeName: _nomineeName ?? '',
  //     //   nomineeFatherName: _nomineeFatherName ?? '',
  //     //   nomineeGrandfatherName: _nomineeGrandfatherName ?? '',
  //     //   nomineeRelation: _nomineeRelation ?? '',
  //     //   nomineeDobEng: _nomineeBirthdateEng ?? '',
  //     //   nomineeDobNep: _nomineeBirthdateNep ?? '',
  //     //   nomineeCitizenship: _nomineeCitizenshipNumber ?? '',
  //     //   nomineeCitizenshipIssuedPlace: _nomineeCitizenshipIssuedPlace ?? '',
  //     //   nomineeCitizenshipIssuedDateEng: _nomineeCitizenshipIssuedDateEng ?? '',
  //     //   nomineeCitizenshipIssuedDateNep: _nomineeCitizenshipIssuedDateNep ?? '',
  //     //   nomineePhone: _nomineePhoneNumber ?? '',
  //     //   nomineeCurrentAddress: _nomineeCurrentAddress ?? '',
  //     //   nomineePermanentAddress: _nomineePermanentAddress ?? '',
  //     //   beneficiaryName: _beneficiaryName ?? '',
  //     //   beneficiaryRelation: _beneficiaryRelation ?? '',
  //     //   beneficiaryPhone: _beneficiaryContact ?? '',
  //     //   beneficiaryAddress: _beneficiaryAddress ?? '',
  //     // ),
  //   );
  //   setState(() {});
  // }

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

  getProvinceApiDataTemp(addressType) {
    if (addressType == 'district') {
      _districtIDTemp = null;
      _districtNameTemp = null;
      _municipalityIDTemp = null;
      _municipalityIDTemp = null;
      _wardIDTemp = null;
      _wardNameTemp = null;
      districtBlocTemp!
          .fetchAPIList('fetchdistrict?province_id=$_provinceIDTemp');
    } else if (addressType == 'mun') {
      _municipalityIDTemp = null;
      _municipalityIDTemp = null;
      _wardIDTemp = null;
      _wardNameTemp = null;
      municipalityBlocTemp!
          .fetchAPIList('fetchmun?district_id=$_districtIDTemp');
    } else if (addressType == 'ward') {
      _wardIDTemp = null;
      _wardNameTemp = null;
      wardBlocTemp!
          .fetchAPIList('fetchward?municipality_id=$_municipalityIDTemp');
    } else {
      provinceBlocTemp!.fetchAPIList(endpoints.getAllProvinceEndpoint);
      districtBlocTemp!
          .fetchAPIList('fetchdistrict?province_id=$_provinceIDTemp');
      municipalityBlocTemp!
          .fetchAPIList('fetchmun?district_id=$_districtIDTemp');
      wardBlocTemp!
          .fetchAPIList('fetchward?municipality_id=$_municipalityIDTemp');
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

  void scrollToWidget(GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final ScrollableState scrollableState =
          Scrollable.of(key.currentContext!);
      scrollableState.position.ensureVisible(
        renderObject,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  nextBtn() {
    if (currentStep == 0) {
      submitPersonalInformation();
    } else if (currentStep == 1) {
      submitAddressInformation();
    } else if (currentStep == 2) {
      submitFamilyAndTransactionDetails();
    } else if (currentStep == 3) {
      submitNomineeDetails();
    } else if (currentStep == 4) {
      submitDocumentDetails();
    }
  }

  submitPersonalInformation() async {
    btnBloc!.storeData(true);
    var resp;
    resp = await API().getPostResponseData(
      context,
      PostGlobalFormModel(
        firstName: _firstName,
        middleName: _middleName,
        lastName: _lastName,
        salutation: _salutation,
        gender: _gender,
        nationality: _nationality,
        birthDate: _dateOfBirthEng,
        accountBranch: _accountBranch,
        currency: _currency,
        mobileNumber: _phone,
        email: _email,
        country: _country,
      ),
      endpoints.postKYCPersonalInformationEndpoint,
    );
    if (resp != null) {
      GlobalFormRespData globalFormRespData = GlobalFormRespData.fromJson(resp);
      btnBloc!.storeData(false);
      setState(() {
        currentStep += 1;
      });
      sharedPrefs.storeToDevice(
          "globalFormID", globalFormRespData.kycId.toString());
      scrollToWidget(scrollToPermAddressKey);
    } else {
      btnBloc!.storeData(false);
    }
  }

  submitAddressInformation() async {
    btnBloc!.storeData(true);
    globalFormID = sharedPrefs.getFromDevice("globalFormID");
    int statusCode;
    statusCode = await API().postData(
        context,
        PostGlobalFormModel(
          permHouseNumber: _houseNo,
          permProvinceId: int.parse(_provinceID.toString()),
          permDistrictId: int.parse(_districtID.toString()),
          permMunicipalityId: int.parse(_municipalityID.toString()),
          permWardId: int.parse(_wardID.toString()),
          permLocation: _permAddress,
          tempHouseNumber: _houseNoTemp,
          tempProvinceId: int.parse(_provinceIDTemp.toString()),
          tempDistrictId: int.parse(_districtIDTemp.toString()),
          tempMunicipalityId: int.parse(_municipalityIDTemp.toString()),
          tempWardId: int.parse(_wardIDTemp.toString()),
          tempLocation: _tempAddress,
          workStatus: _workStatus,
          accountPurpose: _purposeOfAccount,
          sourceOfIncome: _incomeSource,
          annualIncome: _annualIncome,
          occupation: _occupation,
          panNumber: _panNo,
          organizationName: _organizationName,
          designation: _designation,
          organizationAddress: _organizationAddress,
          organizationNumber: _organizationContact,
        ),
        'kyc/address-information/$globalFormID');
    if (statusCode == 200) {
      btnBloc!.storeData(false);
      setState(() {
        currentStep += 1;
      });
      scrollToWidget(scrollToIdentificationKey);
    } else {
      btnBloc!.storeData(false);
    }
  }

  submitFamilyAndTransactionDetails() async {
    btnBloc!.storeData(true);
    globalFormID = sharedPrefs.getFromDevice("globalFormID");
    int statusCode;
    statusCode = await API().postData(
        context,
        PostGlobalFormModel(
          identificationType: _identificationType,
          identificationNo: _citizenshipNumber,
          citizenshipDate: _issuedDateEng,
          citizenshipIssueDistrict: _issuedDistrict,
          fatherFullName: _fatherName,
          motherFullName: _motherName,
          grandfatherFullName: _grandFatherName,
          grandmotherFullName: _grandMotherName,
          husbandWifeFullName: _spouseName,
          maritalStatus: _maritalStatus,
          education: _education,
          maxAmountPerTansaction: _maxAmount,
          monthlyAmountOfTransaction: _monthlyAmount,
          yearlyAmountOfTransaction: _yearlyAmount,
          numberOfMonthlyTransaction: _noOfMonthlyTransaction,
          numberOfYearlyTransaction: _noOfYearlyTransaction,
        ),
        'kyc/professional-information/$globalFormID');
    if (statusCode == 200) {
      btnBloc!.storeData(false);
      setState(() {
        currentStep += 1;
      });
    } else {
      btnBloc!.storeData(false);
    }
  }

  submitTransactionDetails() {
    sharedPrefs.getFromDevice("globalFormID");
  }

  submitNomineeDetails() async {
    btnBloc!.storeData(true);
    globalFormID = sharedPrefs.getFromDevice("globalFormID");
    int statusCode;
    statusCode = await API().postData(
        context,
        PostGlobalFormModel(
          nomineeName: _nomineeName,
          nomineeFatherName: _nomineeFatherName,
          nomineeGrandfatherName: _nomineeGrandfatherName,
          nomineeRelation: _nomineeRelation,
          nomineeBirthdate: _nomineeBirthdateEng,
          nomineeCitizenshipNumber: _nomineeCitizenshipNumber,
          nomineeCitizenshipIssuedPlace: _nomineeCitizenshipIssuedPlace,
          nomineeCitizenshipIssuedDate: _nomineeCitizenshipIssuedDateEng,
          nomineePhoneNumber: _nomineePhoneNumber,
          nomineeCurrentAddress: _nomineeCurrentAddress,
          nomineePermanentAddress: _nomineePermanentAddress,
          beneficiaryName: _beneficiaryName,
          beneficiaryRelation: _beneficiaryRelation,
          beneficiaryContactNumber: _beneficiaryContact,
          beneficiaryAddress: _beneficiaryAddress,
          areYouNrn: areYouNRN,
          accountInOtherBanks: haveAnotherAccountBank,
          criminalOffence: haveCriminalOffence,
          greenCard: haveGreenCard,
          usCitizen: areYouUSCitizen,
          usResidence: areYouUSResidence,
        ),
        'kyc/declaration-and-services/$globalFormID');
    if (statusCode == 200) {
      btnBloc!.storeData(false);
      setState(() {
        currentStep += 1;
      });
    } else {
      btnBloc!.storeData(false);
    }
  }

  submitDocumentDetails() async {
    if (testPopModal == null) {
      myToast.toast("Select Address");
    } else {
      btnBloc!.storeData(true);
      globalFormID = sharedPrefs.getFromDevice("globalFormID");
      int statusCode;
      statusCode = await API().postData(
        context,
        PostGlobalFormModel(
          longitude: testPopModal!.lng.toString(),
          latitude: testPopModal!.lat.toString(),
          citizenshipFront: _docFrontBase64,
          citizenshipBack: _docBackBase64,
          selfImage: _profileBase64,
        ),
        'kyc/upload-document/$globalFormID',
      );
      if (statusCode == 200) {
        mySnackbar.mySnackBar(context, "Global Form Submiited", kGreen);
        refreshGlobalFormBloc.storeData('refresh');
        Navigator.pop(context);
        // goThere(
        //     context,
        //     const MainHomePage(
        //       index: 4,
        //       tabIndex: 0,
        //     ));
        btnBloc!.storeData(false);
        sharedPrefs.storeToDevice("kycStatus", 'kyc not verified.');
        refreshPackageBloc.storeData('refresh');
      } else {
        btnBloc!.storeData(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
            title: 'Global Form', color: backgroundColor, borderRadius: 0.0),
        body: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: StreamBuilder<ApiResponse<dynamic>>(
            stream: kycBloc!.apiListStream,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return Container(
                      height: 200,
                      margin: const EdgeInsets.fromLTRB(
                        20.0,
                        20.0,
                        20.0,
                        20.0,
                      ),
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: AnimatedLoading(),
                      ),
                    );
                  case Status.COMPLETED:
                    KycResponseModel kycResponseModel =
                        KycResponseModel.fromJson(snapshot.data!.data);
                    sharedPrefs.storeToDevice(
                        "kycStatus", kycResponseModel.message);
                    if (kycResponseModel.message == 'kyc not verified.') {
                      return globalFormPendingCard();
                    } else {
                      return StreamBuilder<ApiResponse<dynamic>>(
                        stream: viewGlobalFormBloc!.apiListStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return Container(
                                  height: 200,
                                  margin: const EdgeInsets.fromLTRB(
                                    20.0,
                                    20.0,
                                    20.0,
                                    20.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: myColor.dialogBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: AnimatedLoading(),
                                  ),
                                );
                              case Status.COMPLETED:
                                if (snapshot.data!.data.isEmpty) {
                                  if (checkCondition == true) {
                                    refresh();
                                  }
                                  checkCondition = false;
                                } else {
                                  viewGlobalFormModel =
                                      PostGlobalFormModel.fromJson(
                                          snapshot.data!.data);
                                  if (checkCondition == true) {
                                    if (viewGlobalFormModel!.formStatus ==
                                        'personal-information') {
                                      currentStep = 1;
                                    } else if (viewGlobalFormModel!
                                            .formStatus ==
                                        'address-information') {
                                      currentStep = 2;
                                    } else if (viewGlobalFormModel!
                                            .formStatus ==
                                        'professional-information') {
                                      currentStep = 3;
                                    } else if (viewGlobalFormModel!
                                            .formStatus ==
                                        'declaration-and-services') {
                                      currentStep = 4;
                                    } else if (viewGlobalFormModel!
                                            .formStatus ==
                                        'upload-document') {
                                      currentStep = 5;
                                    }
                                    getKycDataFromAPI();
                                  }
                                  checkCondition = false;
                                }
                                return Theme(
                                  data: ThemeData(
                                    canvasColor: kTransparent,
                                    colorScheme: Theme.of(context)
                                        .colorScheme
                                        .copyWith(
                                          onSurface: kWhite.withOpacity(0.4),
                                          primary: myColor.primaryColorDark,
                                        ),
                                  ),
                                  child: Stepper(
                                    physics: const BouncingScrollPhysics(),
                                    elevation: 0,
                                    margin: EdgeInsets.zero,
                                    type: StepperType.horizontal,
                                    onStepTapped: (step) {
                                      setState(() {
                                        currentStep = step;
                                      });
                                    },
                                    steps: getSteps(),
                                    currentStep: currentStep,
                                    controlsBuilder: (context, details) {
                                      final isLastStep =
                                          currentStep == getSteps().length - 1;
                                      return Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        color: myColor.dialogBackgroundColor,
                                        child: Column(
                                          children: [
                                            StreamBuilder<dynamic>(
                                                initialData: false,
                                                stream: btnBloc!.stateStream,
                                                builder:
                                                    (context, loadingData) {
                                                  return loadingData.data ==
                                                          true
                                                      ? myCircularIndicator()
                                                      : SizedBox(
                                                          width:
                                                              maxWidth(context),
                                                          height: 50.0,
                                                          child: myButton(
                                                            context,
                                                            isLastStep &&
                                                                    _isTermsAndConditionsChecked ==
                                                                        false
                                                                ? myColor
                                                                    .primaryColorDark
                                                                    .withOpacity(
                                                                        0.12)
                                                                : myColor
                                                                    .primaryColorDark,
                                                            !isLastStep
                                                                ? 'Save'
                                                                : "Submit",
                                                            () {
                                                              myfocusRemover(
                                                                  context);
                                                              // if (isValid!) {
                                                              if (isLastStep) {
                                                                // setState(() {
                                                                //   kycFilledSuccesfully = true;
                                                                // });
                                                                if (_isTermsAndConditionsChecked ==
                                                                    true) {
                                                                  submitDocumentDetails();
                                                                }
                                                              } else {
                                                                nextBtn();
                                                                _scrollController.animateTo(
                                                                    0,
                                                                    curve: Curves
                                                                        .easeIn,
                                                                    duration:
                                                                        const Duration(
                                                                      milliseconds:
                                                                          200,
                                                                    ));
                                                              }
                                                              // }
                                                              // return;
                                                            },
                                                          ),
                                                        );
                                                }),
                                            const SizedBox8(),
                                            GestureDetector(
                                              onTap: () {
                                                // currentStep == 0
                                                //     ?
                                                Navigator.pop(context);
                                                // : setState(() {
                                                //     currentStep -= 1;
                                                //   });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: myColor
                                                          .primaryColorDark,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                width: maxWidth(context),
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    // currentStep == 0 ?

                                                    'Cancel',
                                                    //  : "Back",
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      color: myColor
                                                          .primaryColorDark,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );

                              case Status.ERROR:
                                return Container();
                            }
                          }
                          return const SizedBox();
                        }),
                      );
                    }

                    return Container();
                  case Status.ERROR:
                    return Container();
                }
              }
              return SizedBox(
                width: maxWidth(context),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget globalFormPendingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      width: maxWidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            width: maxWidth(context),
            height: maxHeight(context) / 4,
          ),
          const SizedBox8(),
          SizedBox(
            width: maxWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'VERIFICATION',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: myColor.primaryColorDark,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'PENDING',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: const Color(0xFF52C8F4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox12(),
          RichText(
            text: TextSpan(
              style: kStyleNormal,
              children: [
                TextSpan(
                  text: 'Your Global Form is submitted Successfully. ',
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
                TextSpan(
                  text:
                      '— We will notify you once it is verified. Thank you for joining us.)',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text(
            '',
          ),
          content: firstStep(),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text(
            '',
          ),
          content: secondStep(),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text(
            '',
          ),
          content: thirdStep(),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text(
            '',
          ),
          content: fifthStep(),
        ),
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: const Text(
            '',
          ),
          content: sixthStep(),
        ),
      ];
  Widget sixthStep() {
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
        const SizedBox24(),
        Text(
          'Your Image',
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Upload your image and select your location. Your information will be confidentially secured.',
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
                textValue: 'Profile',
                bgColor: Colors.white.withOpacity(0.4),
                onValueChanged: (value) {
                  setState(() {
                    _profileFileImage = value.file;
                    _profileBase64 = value.base64String;
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
                            bottom: 0,
                            child: Container(
                              height: 25,
                              width: maxWidth(context),
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
          'Document Proof',
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Upload both front and back image of selected document type. Make sure all details are clearly visible.',
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
                    _docFrontFileImage = value.file;
                    _docFrontBase64 = value.base64String;
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
                    _docBackFileImage = value.file;
                    _docBackBase64 = value.base64String;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                activeColor: myColor.primaryColorDark,
                side: const BorderSide(width: 1.0, color: Colors.grey),
                visualDensity: const VisualDensity(horizontal: -4),
                value: _isTermsAndConditionsChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isTermsAndConditionsChecked = newValue!;
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
        const SizedBox16(),
      ],
    );
  }

  Widget firstStep() {
    return Column(
      children: [
        Column(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: myDropdownsWidget(
                      'Salutation',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _salutation ?? '',
                          salutationDropDownList,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _salutation = value.name;
                        });
                      })),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 2,
                  child: mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'First Name',
                    _firstName,
                    'Enter your fullname',
                    _firstName,
                    Icons.perm_identity_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _firstName = value;
                      // updateGlobalFormDraft(
                      //     GlobalFormDraftColumns.firstName, _firstName);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'Middle Name',
                    _middleName,
                    'Enter your fullname',
                    _middleName,
                    Icons.perm_identity_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _middleName = value;
                      // updateGlobalFormDraft(
                      //     GlobalFormDraftColumns.middleName, _middleName);
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'Last Name',
                    _lastName,
                    'Enter your fullname',
                    _lastName,
                    Icons.perm_identity_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _lastName = value;
                      // updateGlobalFormDraft(
                      //     GlobalFormDraftColumns.firstName, _firstName);
                    },
                  ),
                ),
              ],
            ),
            myNumberTextFormField(
              'Phone',
              _phone,
              'Enter your phone number',
              _phone,
              Icons.call_outlined,
              kWhite.withOpacity(0.4),
              onValueChanged: (value) {
                _phone = value;
                // updateGlobalFormDraft(
                //     GlobalFormDraftColumns.firstName, _firstName);
              },
              readOnlyStatus: true,
            ),
            myEmailTextFormFieldWithPrefixIcon(
              context,
              'Email',
              _email,
              _email,
              Icons.email_outlined,
              kWhite.withOpacity(0.4),
              onValueChanged: (value) {
                _email = value;
                // updateGlobalFormDraft(
                //     GlobalFormDraftColumns.firstName, _firstName);
              },
              isReadOnly: true,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Date of Birth (B.S.)',
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
                  _dateOfBirthNep,
                  _dateOfBirthNep,
                  Icons.cake_outlined,
                  kWhite.withOpacity(0.4), onValueChanged: (value) {
                setState(() {
                  _dateOfBirthNep = value.nepaliDate;
                  _dateOfBirthEng = value.englishDate;
                });
              }),
              const SizedBox16(),
              Text(
                'Date of Birth (A.D.)',
                style: kStyleNormal.copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox16(),
              widgetDatePicker(
                  context,
                  language: 'Eng',
                  disableDateType: 'future',
                  kStyleNormal.copyWith(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                  _dateOfBirthEng,
                  _dateOfBirthEng,
                  Icons.cake_outlined,
                  kWhite.withOpacity(0.4), onValueChanged: (value) {
                setState(() {
                  _dateOfBirthNep = value.nepaliDate;
                  _dateOfBirthEng = value.englishDate;
                });
              }),
            ]),
            const SizedBox16(),
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
            myDropdownsWidget(
                'Nationality',
                myDropDown2(
                    context,
                    Icons.perm_identity,
                    Colors.black,
                    Colors.black,
                    maxWidth(context),
                    _nationality ?? '',
                    nationalityDropDownList,
                    myColor.scaffoldBackgroundColor.withOpacity(0.4),
                    onValueChanged: (value) {
                  setState(() {
                    _nationality = value.name;
                    // updateGlobalFormDraft(
                    //     GlobalFormDraftColumns.firstName, _firstName);
                  });
                })),
            const SizedBox16(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: myDropdownsWidget(
                      'Branch',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _accountBranch ?? '',
                          accountBranchDropDownList,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _accountBranch = value.name;
                          // updateGlobalFormDraft(
                          // GlobalFormDraftColumns.firstName, _firstName);
                        });
                      })),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 85.0,
                    child: myCountryPicker(
                      titleText: "Country",
                      initialCountry: _countryFlag,
                      onValueChanged: (v) {
                        _country = v;
                        _countryFlag = v;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox16(),
            myDropdownsWidget(
                'Currency',
                myDropDown2(
                    context,
                    Icons.perm_identity,
                    Colors.black,
                    Colors.black,
                    maxWidth(context),
                    _currency ?? '',
                    currencyDropDownList,
                    myColor.scaffoldBackgroundColor.withOpacity(0.4),
                    onValueChanged: (value) {
                  setState(() {
                    _currency = value.name;
                    // updateGlobalFormDraft(
                    //     GlobalFormDraftColumns.firstName, _firstName);
                  });
                })),
            const SizedBox16(),
          ],
        ),
      ],
    );
  }

  Widget thirdStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: scrollToIdentificationKey,
          child: Text(
            'Identification Details',
            style: kStyleNormal.copyWith(
              fontSize: 16.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox24(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: myDropdownsWidget(
                  'Identification Type',
                  myDropDown2(
                      context,
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _identificationType ?? '',
                      identificationDropDownList,
                      myColor.scaffoldBackgroundColor.withOpacity(0.4),
                      onValueChanged: (value) {
                    setState(() {
                      _identificationType = value.name;
                      // updateGlobalFormDraft(
                      //     GlobalFormDraftColumns.firstName, _firstName);
                    });
                  })),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: myNumberTextFormField(
                'Identification Doc No.',
                _citizenshipNumber,
                'Enter your document no.',
                _citizenshipNumber,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _citizenshipNumber = value;

                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Issued Date (B.S.)',
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
                      _issuedDateNep,
                      _issuedDateNep,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4), onValueChanged: (value) {
                    setState(() {
                      _issuedDateNep = value.nepaliDate;
                      _issuedDateEng = value.englishDate;
                    });
                  }),
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
                    'Issued Date (A.D.)',
                    style: kStyleNormal.copyWith(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox16(),
                  widgetDatePicker(
                      context,
                      language: 'Eng',
                      disableDateType: 'future',
                      kStyleNormal.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                      _issuedDateEng,
                      _issuedDateEng,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4), onValueChanged: (value) {
                    setState(() {
                      _issuedDateNep = value.nepaliDate;
                      _issuedDateEng = value.englishDate;
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox16(),
        myDropdownsWidget(
            'Issued Place',
            myDropDown2(
                context,
                Icons.perm_identity,
                Colors.black,
                Colors.black,
                maxWidth(context),
                _issuedDistrict ?? '',
                districtDropDownList,
                myColor.scaffoldBackgroundColor.withOpacity(0.4),
                onValueChanged: (value) {
              setState(() {
                _issuedDistrict = value.name;
                // updateGlobalFormDraft(
                //     GlobalFormDraftColumns.firstName, _firstName);
              });
            })),
        const SizedBox24(),
        Divider(
          color: myColor.primaryColorDark,
        ),
        const SizedBox16(),
        Text(
          'Family Details',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox24(),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Father\'s Name',
          _fatherName,
          'Enter your father\'s name',
          _fatherName,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _fatherName = value;
            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Mother\'s Name',
          _motherName,
          'Enter your mother\'s name',
          _motherName,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _motherName = value;
            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Grandfather\'s Name',
          _grandFatherName,
          'Enter your grandfather\'s name',
          _grandFatherName,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _grandFatherName = value;
            // updateGlobalFormDraft(
            // GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Grandmother\'s Name',
          _grandMotherName,
          'Enter your grandmother\'s name',
          _grandMotherName,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _grandMotherName = value;
            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        myDropdownsWidget(
            'Marital Status',
            myDropDown2(
                context,
                Icons.perm_identity,
                Colors.black,
                Colors.black,
                maxWidth(context),
                _maritalStatus ?? '',
                maritalStatusDropDownList,
                myColor.scaffoldBackgroundColor.withOpacity(0.4),
                onValueChanged: (value) {
              setState(() {
                _maritalStatus = value.name;
                // updateGlobalFormDraft(
                //     GlobalFormDraftColumns.firstName, _firstName);
              });
            })),
        _maritalStatus != 'Un-Married' ? const SizedBox16() : Container(),
        _maritalStatus != 'Un-Married'
            ? mytextFormFieldWithPrefixIcon(
                context,
                FocusNode(),
                'Spouse\'s Name',
                _spouseName,
                'Enter your spouse\'s name',
                _spouseName,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _spouseName = value;
                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              )
            : Container(),
        _maritalStatus == 'Un-Married' ? const SizedBox16() : Container(),
        Text(
          'Education Details',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox24(),
        myDropdownsWidget(
            'Education',
            myDropDown2(
                context,
                Icons.perm_identity,
                Colors.black,
                Colors.black,
                maxWidth(context),
                _education ?? '',
                educationDropDownList,
                myColor.scaffoldBackgroundColor.withOpacity(0.4),
                onValueChanged: (value) {
              setState(() {
                _education = value.name;
                // updateGlobalFormDraft(
                //     GlobalFormDraftColumns.firstName, _firstName);
              });
            })),
        const SizedBox16(),
        Divider(
          color: myColor.primaryColorDark,
        ),
        const SizedBox16(),
        Text(
          'Transaction',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox24(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: myNumberTextFormField(
                'Max. Amount',
                _maxAmount,
                'Enter max amount',
                _maxAmount,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _maxAmount = value;

                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: myNumberTextFormField(
                'Monthly Amount',
                _monthlyAmount,
                'Enter monthly amount',
                _monthlyAmount,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _monthlyAmount = value;

                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
          ],
        ),
        const SizedBox16(),
        myNumberTextFormField(
          'Yearly amount',
          _yearlyAmount,
          'Enter yearly amount',
          _yearlyAmount,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _yearlyAmount = value;

            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        const SizedBox16(),
        myNumberTextFormField(
          'No. of monthly transaction',
          _noOfMonthlyTransaction,
          'Enter no. of monthly transaction',
          _noOfMonthlyTransaction,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _noOfMonthlyTransaction = value;

            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        const SizedBox16(),
        myNumberTextFormField(
          'No. of yearly transaction',
          _noOfYearlyTransaction,
          'Enter no. of yearly transaction',
          _noOfYearlyTransaction,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _noOfYearlyTransaction = value;

            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        const SizedBox16(),
      ],
    );
  }

  Widget fifthStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nominee Details',
              style: kStyleNormal.copyWith(
                fontSize: 16.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(children: [
              Text(
                'skip',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 30.0,
                height: 30.0,
                child: StreamBuilder<dynamic>(
                    initialData: false,
                    stream: skipNomineeBloc!.stateStream,
                    builder: (context, snapshot) {
                      return Checkbox(
                          activeColor: myColor.primaryColorDark,
                          side: BorderSide(
                              width: 1.0, color: myColor.primaryColorDark),
                          visualDensity: const VisualDensity(horizontal: -4),
                          value: snapshot.data,
                          onChanged: (bool? newValue) {
                            skipNomineeBloc!.storeData(newValue);
                          });
                    }),
              ),
            ]),
          ],
        ),
        const SizedBox24(),
        StreamBuilder<dynamic>(
            initialData: false,
            stream: skipNomineeBloc!.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return Column(
                  children: [
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Nominee Name',
                      _nomineeName,
                      'Enter your nominee name',
                      _nomineeName,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        _nomineeName = value;
                        // updateGlobalFormDraft(
                        //     GlobalFormDraftColumns.firstName, _firstName);
                      },
                    ),
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Nominee Father Name',
                      _nomineeFatherName,
                      'Enter your nominee father name',
                      _nomineeFatherName,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        _nomineeFatherName = value;
                        //   updateGlobalFormDraft(
                        //       GlobalFormDraftColumns.firstName, _firstName);
                      },
                    ),
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Nominee Grandfather Name',
                      _nomineeGrandfatherName,
                      'Enter your nominee grandfather name',
                      _nomineeGrandfatherName,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        _nomineeGrandfatherName = value;
                        // updateGlobalFormDraft(
                        //     GlobalFormDraftColumns.firstName, _firstName);
                      },
                    ),
                    myDropdownsWidget(
                        'Nominee Relation',
                        myDropDown2(
                            context,
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _nomineeRelation ?? '',
                            nomineeRelationDropDownList,
                            myColor.scaffoldBackgroundColor.withOpacity(0.4),
                            onValueChanged: (value) {
                          setState(() {
                            _nomineeRelation = value.name;
                            // updateGlobalFormDraft(
                            //     GlobalFormDraftColumns.firstName, _firstName);
                          });
                        })),
                    const SizedBox16(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Birth (B.S.)',
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
                                  _nomineeBirthdateNep,
                                  _nomineeBirthdateNep,
                                  Icons.perm_identity_outlined,
                                  kWhite.withOpacity(0.4),
                                  onValueChanged: (value) {
                                setState(() {
                                  _nomineeBirthdateNep = value.nepaliDate;
                                  _nomineeBirthdateEng = value.englishDate;
                                });
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Birth (A.D.)',
                                style: kStyleNormal.copyWith(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox16(),
                              widgetDatePicker(
                                  context,
                                  language: 'Eng',
                                  disableDateType: 'future',
                                  kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  _nomineeBirthdateEng,
                                  _nomineeBirthdateEng,
                                  Icons.perm_identity_outlined,
                                  kWhite.withOpacity(0.4),
                                  onValueChanged: (value) {
                                setState(() {
                                  _nomineeBirthdateNep = value.nepaliDate;
                                  _nomineeBirthdateEng = value.englishDate;
                                });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox16(),
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Citizenship No.',
                      _nomineeCitizenshipNumber,
                      'Enter citizenship no.',
                      _nomineeCitizenshipNumber,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        _nomineeCitizenshipNumber = value;
                        // updateGlobalFormDraft(
                        //     GlobalFormDraftColumns.firstName, _firstName);
                      },
                    ),
                    myDropdownsWidget(
                        'Issued Place',
                        myDropDown2(
                            context,
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _nomineeCitizenshipIssuedPlace ?? '',
                            districtDropDownList,
                            myColor.scaffoldBackgroundColor.withOpacity(0.4),
                            onValueChanged: (value) {
                          setState(() {
                            _nomineeCitizenshipIssuedPlace = value.name;
                            // updateGlobalFormDraft(
                            //     GlobalFormDraftColumns.firstName, _firstName);
                          });
                        })),
                    const SizedBox16(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Issued Date (B.S.)',
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
                                  _nomineeCitizenshipIssuedDateNep,
                                  _nomineeCitizenshipIssuedDateNep,
                                  Icons.perm_identity_outlined,
                                  Colors.white.withOpacity(0.4),
                                  onValueChanged: (value) {
                                setState(() {
                                  _nomineeCitizenshipIssuedDateNep =
                                      value.nepaliDate;
                                  _nomineeCitizenshipIssuedDateEng =
                                      value.englishDate;
                                });
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Issued Date (A.D.)',
                                style: kStyleNormal.copyWith(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox16(),
                              widgetDatePicker(
                                  context,
                                  language: 'Eng',
                                  disableDateType: 'future',
                                  kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  _nomineeCitizenshipIssuedDateEng,
                                  _nomineeCitizenshipIssuedDateEng,
                                  Icons.perm_identity_outlined,
                                  kWhite.withOpacity(0.4),
                                  onValueChanged: (value) {
                                setState(() {
                                  _nomineeCitizenshipIssuedDateNep =
                                      value.nepaliDate;
                                  _nomineeCitizenshipIssuedDateEng =
                                      value.englishDate;
                                });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox16(),
                    myNumberTextFormField(
                      'Nominee Phone',
                      _nomineePhoneNumber,
                      'Enter nominee phone number',
                      _nomineePhoneNumber,
                      Icons.call_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        _nomineePhoneNumber = value;
                        // updateGlobalFormDraft(
                        //     GlobalFormDraftColumns.firstName, _firstName);
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: mytextFormFieldWithPrefixIcon(
                            context,
                            FocusNode(),
                            'Current Address',
                            _nomineeCurrentAddress,
                            'Enter nominee current address',
                            _nomineeCurrentAddress,
                            Icons.perm_identity_outlined,
                            kWhite.withOpacity(0.4),
                            onValueChanged: (value) {
                              _nomineeCurrentAddress = value;
                              // updateGlobalFormDraft(
                              //     GlobalFormDraftColumns.firstName, _firstName);
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: mytextFormFieldWithPrefixIcon(
                            context,
                            FocusNode(),
                            'Permanent Address',
                            _nomineePermanentAddress,
                            'Enter nominee permanent address',
                            _nomineePermanentAddress,
                            Icons.perm_identity_outlined,
                            kWhite.withOpacity(0.4),
                            onValueChanged: (value) {
                              _nomineePermanentAddress = value;
                              // updateGlobalFormDraft(
                              //     GlobalFormDraftColumns.firstName, _firstName);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox24(),
                    Divider(
                      color: myColor.primaryColorDark,
                    ),
                    const SizedBox16(),
                  ],
                );
              } else {
                return Container();
              }
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Beneficiary Details',
              style: kStyleNormal.copyWith(
                fontSize: 16.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(children: [
              Text(
                'skip',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 30.0,
                height: 30.0,
                child: StreamBuilder<dynamic>(
                    initialData: false,
                    stream: skipBeneficiaryBloc!.stateStream,
                    builder: (context, snapshot) {
                      return Checkbox(
                          activeColor: myColor.primaryColorDark,
                          side: BorderSide(
                              width: 1.0, color: myColor.primaryColorDark),
                          visualDensity: const VisualDensity(horizontal: -4),
                          value: snapshot.data,
                          onChanged: (bool? newValue) {
                            skipBeneficiaryBloc!.storeData(newValue);
                          });
                    }),
              ),
            ]),
          ],
        ),
        StreamBuilder<dynamic>(
            initialData: false,
            stream: skipBeneficiaryBloc!.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return Column(children: [
                  const SizedBox16(),
                  mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'Beneficiary Name',
                    _beneficiaryName,
                    'Enter your benficiary name',
                    _beneficiaryName,
                    Icons.perm_identity_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _beneficiaryName = value;
                      // updateGlobalFormDraft(
                      // GlobalFormDraftColumns.firstName, _firstName);
                    },
                  ),
                  myDropdownsWidget(
                      'Relation',
                      myDropDown2(
                          context,
                          Icons.perm_identity,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _beneficiaryRelation ?? '',
                          nomineeRelationDropDownList,
                          myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          onValueChanged: (value) {
                        setState(() {
                          _beneficiaryRelation = value.name;
                          // updateGlobalFormDraft(
                          //     GlobalFormDraftColumns.firstName, _firstName);
                        });
                      })),
                  const SizedBox16(),
                  Row(
                    children: [
                      Expanded(
                        child: myNumberTextFormField(
                          'Phone',
                          _beneficiaryContact,
                          'Enter beneficiary phone number',
                          _beneficiaryContact,
                          Icons.call_outlined,
                          kWhite.withOpacity(0.4),
                          onValueChanged: (value) {
                            _beneficiaryContact = value;
                            // updateGlobalFormDraft(
                            //     GlobalFormDraftColumns.firstName, _firstName);
                          },
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: mytextFormFieldWithPrefixIcon(
                          context,
                          FocusNode(),
                          'Address',
                          _beneficiaryAddress,
                          'Enter benficiary address',
                          _beneficiaryAddress,
                          Icons.perm_identity_outlined,
                          kWhite.withOpacity(0.4),
                          onValueChanged: (value) {
                            _beneficiaryAddress = value;
                            //      updateGlobalFormDraft(
                            // GlobalFormDraftColumns.firstName, _firstName);
                          },
                        ),
                      ),
                    ],
                  ),
                ]);
              } else {
                return Container();
              }
            }),
        const SizedBox24(),
        Text(
          'Check Lists',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox24(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: checkBoxCard('Are you NRN?', areYouNRNBloc,
                    onValueChanged: (v) {
              areYouNRN = v;
            })),
            const SizedBox(width: 20.0),
            Expanded(
                child: checkBoxCard('Are you US Citizen?', areYouUSCitizenBloc,
                    onValueChanged: (v) {
              areYouUSCitizen = v;
            })),
          ],
        ),
        const SizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:
                    checkBoxCard('Are you US residence?', areYouUSResidenceBloc,
                        onValueChanged: (v) {
              areYouUSResidence = v;
            })),
            const SizedBox(width: 20.0),
            Expanded(
                child: checkBoxCard('Are you involved in criminal offence?',
                    haveCriminalOffenceBloc, onValueChanged: (v) {
              haveCriminalOffence = v;
            })),
          ],
        ),
        const SizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:
                    checkBoxCard('Do you have green card?', haveGreenCardBloc,
                        onValueChanged: (v) {
              haveGreenCard = v;
            })),
            const SizedBox(width: 20.0),
            Expanded(
                child: checkBoxCard('Do you have account in other bank?',
                    haveAnotherAccountBankBloc, onValueChanged: (v) {
              haveAnotherAccountBank = v;
            })),
          ],
        ),
        const SizedBox24(),
      ],
    );
  }

  Widget secondStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            print('a');
            btnBloc!.storeData(false);
          },
          child: Form(
            key: scrollToPermAddressKey,
            child: Text(
              'Permanent Address',
              style: kStyleNormal.copyWith(
                fontSize: 16.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox24(),
        myNumberTextFormField(
          'House No.',
          _houseNo,
          'Enter your house no.',
          _houseNo,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _houseNo = value;
            if (_isSaveAsAbove == true) {
              _houseNoTemp = _houseNo;
            }
            print('_houseNo $_houseNo');
            // updateGlobalFormDraft(
            //     GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: provinceBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'Province',
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
                              'Province',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _provinceName ?? '',
                                  provinceModel,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'Province',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _provinceName ?? '',
                                provinceModel,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _provinceID = value.id;
                                _provinceName = value.name;
                                getProvinceApiData('district');
                                if (_isSaveAsAbove == true) {
                                  _provinceIDTemp = _provinceID;
                                  _provinceNameTemp = _provinceName;
                                }
                                // updateGlobalFormDraft(
                                //     GlobalFormDraftColumns.firstName,
                                // _firstName);
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
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: districtBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'District',
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
                              'District',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _districtName ?? '',
                                  districtModel,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'District',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _districtName ?? '',
                                districtModel,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _districtID = value.id;
                                _districtName = value.name;
                                getProvinceApiData('mun');
                                if (_isSaveAsAbove == true) {
                                  _districtIDTemp = _districtID;
                                  _districtNameTemp = _districtName;
                                }
                                // updateGlobalFormDraft(
                                //     GlobalFormDraftColumns.firstName,
                                //     _firstName);
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
            ),
          ],
        ),
        const SizedBox16(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: municipalityBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'VDC/Municipality',
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
                              'VDC/Municipality',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _municipalityName ?? '',
                                  municipalityModel,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'VDC/Municipality',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                kBlack,
                                kBlack,
                                maxWidth(context),
                                _municipalityName ?? '',
                                municipalityModel,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _municipalityID = value.id;
                                _municipalityName = value.name;
                                getProvinceApiData('ward');
                                if (_isSaveAsAbove == true) {
                                  _municipalityIDTemp = _municipalityID;
                                  _municipalityNameTemp = _municipalityName;
                                }
                                //       updateGlobalFormDraft(
                                //         GlobalFormDraftColumns.firstName,
                                //       _firstName);
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
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: wardBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'Ward',
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _wardName ?? '',
                            wardModel,
                            onValueChanged: (value) {});
                      case Status.COMPLETED:
                        List<GetWardModel> getWardModel =
                            List<GetWardModel>.from(snapshot.data!.data
                                .map((i) => GetWardModel.fromJson(i)));
                        wardModel.clear();
                        for (int i = 0; i < getWardModel.length; i++) {
                          wardModel.add(GetIDNameModel(
                            id: getWardModel[i].id.toString(),
                            name: getWardModel[i].wardName.toString(),
                          ));
                        }
                        if (snapshot.data!.data.isEmpty) {
                          return myDropdownsWidget(
                              'Ward',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _wardName ?? '',
                                  wardModel,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'Ward',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _wardName ?? '',
                                wardModel,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _wardID = value.id;
                                _wardName = value.name;
                                if (_isSaveAsAbove == true) {
                                  _wardIDTemp = _wardID;
                                  _wardNameTemp = _wardName;
                                }
                                //         updateGlobalFormDraft(
                                //         GlobalFormDraftColumns.firstName,
                                //             _firstName);
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
            ),
          ],
        ),
        const SizedBox16(),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Permanent Address',
          _permAddress,
          'Enter your permanent address',
          _permAddress,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _permAddress = value;
            //     updateGlobalFormDraft(
            //        GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        const SizedBox24(),
        Divider(
          color: myColor.primaryColorDark,
        ),
        const SizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Temporary Address',
              style: kStyleNormal.copyWith(
                fontSize: 16.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Same as above',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(width: 5.0),
                Checkbox(
                    activeColor: myColor.primaryColorDark,
                    side: const BorderSide(width: 1.0, color: Colors.grey),
                    visualDensity: const VisualDensity(horizontal: -4),
                    value: _isSaveAsAbove,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isSaveAsAbove = newValue!;
                        if (_isSaveAsAbove == true) {
                          _houseNoTemp = _houseNo;
                          _tempAddress = _permAddress;
                          _provinceNameTemp = _provinceName;
                          _provinceIDTemp = _provinceID;
                          _districtNameTemp = _districtName;
                          _districtIDTemp = _districtID;
                          _municipalityIDTemp = _municipalityID;
                          _municipalityNameTemp = _municipalityName;
                          _wardIDTemp = _wardID;
                          _wardNameTemp = _wardName;
                        } else {
                          _houseNoTemp = '';
                          _tempAddress = '';
                          _provinceNameTemp = '';
                          _provinceIDTemp = '';
                          _districtNameTemp = '';
                          _districtIDTemp = '';
                          _municipalityIDTemp = '';
                          _municipalityNameTemp = '';
                          _wardIDTemp = '';
                          _wardNameTemp = '';
                        }
                      });
                    }),
              ],
            ),
          ],
        ),
        const SizedBox16(),
        myNumberTextFormField(
          'House No.',
          _houseNoTemp,
          'Enter your fullname',
          _houseNoTemp,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _houseNoTemp = value;
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: provinceBlocTemp!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'Province',
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
                        provinceModelTemp.clear();
                        for (int i = 0; i < getProvinceModel.length; i++) {
                          provinceModelTemp.add(GetIDNameModel(
                            id: getProvinceModel[i].id.toString(),
                            name: getProvinceModel[i].englishName,
                          ));
                        }
                        if (snapshot.data!.data.isEmpty) {
                          return myDropdownsWidget(
                              'Province',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _provinceNameTemp ?? '',
                                  provinceModelTemp,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'Province',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _provinceNameTemp ?? '',
                                provinceModelTemp,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _provinceIDTemp = value.id;
                                _provinceNameTemp = value.name;
                                getProvinceApiDataTemp('district');
                                //   updateGlobalFormDraft(
                                //       GlobalFormDraftColumns.firstName,
                                //       _firstName);
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
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: districtBlocTemp!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'District',
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            '',
                            districtModelTemp,
                            onValueChanged: (value) {});
                      case Status.COMPLETED:
                        List<GetDistrictModel> getDistrictModel =
                            List<GetDistrictModel>.from(snapshot.data!.data
                                .map((i) => GetDistrictModel.fromJson(i)));
                        districtModelTemp.clear();
                        for (int i = 0; i < getDistrictModel.length; i++) {
                          districtModelTemp.add(GetIDNameModel(
                            id: getDistrictModel[i].id.toString(),
                            name: getDistrictModel[i].englishName,
                          ));
                        }
                        if (snapshot.data!.data.isEmpty) {
                          return myDropdownsWidget(
                              'District',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _districtNameTemp ?? '',
                                  districtModelTemp,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'District',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _districtNameTemp ?? '',
                                districtModelTemp,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _districtIDTemp = value.id;
                                _districtNameTemp = value.name;
                                getProvinceApiDataTemp('mun');
                                //      updateGlobalFormDraft(
                                //                   GlobalFormDraftColumns.firstName,
                                //      _firstName);
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
            ),
          ],
        ),
        const SizedBox16(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: municipalityBlocTemp!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'VDC/Municipality',
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _municipalityNameTemp ?? '',
                            municipalityModelTemp,
                            onValueChanged: (value) {});
                      case Status.COMPLETED:
                        List<GetMunicipalityModel> getMunicipalityModel =
                            List<GetMunicipalityModel>.from(snapshot.data!.data
                                .map((i) => GetMunicipalityModel.fromJson(i)));
                        municipalityModelTemp.clear();
                        for (int i = 0; i < getMunicipalityModel.length; i++) {
                          municipalityModelTemp.add(GetIDNameModel(
                            id: getMunicipalityModel[i].id.toString(),
                            name: getMunicipalityModel[i].englishName,
                          ));
                        }
                        if (snapshot.data!.data.isEmpty) {
                          return myDropdownsWidget(
                              'VDC/Municipality 2',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _municipalityNameTemp ?? '',
                                  municipalityModelTemp,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'VDC/Municipality 2',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _municipalityNameTemp ?? '',
                                municipalityModelTemp,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _municipalityIDTemp = value.id;
                                _municipalityNameTemp = value.name;
                                getProvinceApiDataTemp('ward');
                                //updateGlobalFormDraft(
                                //  GlobalFormDraftColumns.firstName,
                                //      _firstName);
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
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: wardBlocTemp!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return myDropDown2Loading(
                            context,
                            'Ward',
                            Icons.perm_identity,
                            Colors.black,
                            Colors.black,
                            maxWidth(context),
                            _wardNameTemp ?? '',
                            wardModelTemp,
                            onValueChanged: (value) {});
                      case Status.COMPLETED:
                        List<GetWardModel> getWardModel =
                            List<GetWardModel>.from(snapshot.data!.data
                                .map((i) => GetWardModel.fromJson(i)));
                        wardModelTemp.clear();
                        for (int i = 0; i < getWardModel.length; i++) {
                          wardModelTemp.add(GetIDNameModel(
                            id: getWardModel[i].id.toString(),
                            name: getWardModel[i].wardName.toString(),
                          ));
                        }
                        if (snapshot.data!.data.isEmpty) {
                          return myDropdownsWidget(
                              'Ward',
                              myDropDown2(
                                  context,
                                  Icons.perm_identity,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _wardNameTemp ?? '',
                                  wardModelTemp,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {}));
                        }

                        return myDropdownsWidget(
                            'Ward',
                            myDropDown2(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                _wardNameTemp ?? '',
                                wardModelTemp,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (value) {
                              setState(() {
                                _wardIDTemp = value.id;
                                _wardNameTemp = value.name;
                                //    updateGlobalFormDraft(
                                //      GlobalFormDraftColumns.firstName,
                                //     _firstName);
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
            ),
          ],
        ),
        const SizedBox16(),
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          'Temporary Address',
          _tempAddress,
          'Enter your temporary address',
          _tempAddress,
          Icons.perm_identity_outlined,
          kWhite.withOpacity(0.4),
          onValueChanged: (value) {
            _tempAddress = value;
            //    updateGlobalFormDraft(
            //       GlobalFormDraftColumns.firstName, _firstName);
          },
        ),
        const SizedBox24(),
        Divider(
          color: myColor.primaryColorDark,
        ),
        const SizedBox16(),
        Text(
          'Occupation',
          style: kStyleNormal.copyWith(
            fontSize: 16.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox24(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: myDropdownsWidget(
                  'Work Status',
                  myDropDown2(
                      context,
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _workStatus ?? '',
                      workStatusDropDownList,
                      myColor.scaffoldBackgroundColor.withOpacity(0.4),
                      onValueChanged: (value) {
                    setState(() {
                      _workStatus = value.name;
                      //     updateGlobalFormDraft(
                      //        GlobalFormDraftColumns.firstName, _firstName);
                    });
                  })),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: myDropdownsWidget(
                  'Purpose of Account',
                  myDropDown2(
                      context,
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _purposeOfAccount ?? '',
                      purposeOfAccountDropDownList,
                      myColor.scaffoldBackgroundColor.withOpacity(0.4),
                      onValueChanged: (value) {
                    setState(() {
                      _purposeOfAccount = value.name;
                      // updateGlobalFormDraft(
                      //    GlobalFormDraftColumns.firstName, _firstName);
                    });
                  })),
            ),
          ],
        ),
        const SizedBox16(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: myDropdownsWidget(
                  'Income Source',
                  myDropDown2(
                      context,
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _incomeSource ?? '',
                      incomeSourceDropDownList,
                      myColor.scaffoldBackgroundColor.withOpacity(0.4),
                      onValueChanged: (value) {
                    setState(() {
                      _incomeSource = value.name;
                      //        updateGlobalFormDraft(
                      //           GlobalFormDraftColumns.firstName, _firstName);
                    });
                  })),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: myNumberTextFormField(
                'Annual Income',
                _annualIncome,
                'Enter your annual income',
                _annualIncome,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _annualIncome = value;

                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: myDropdownsWidget(
                  'Occupation',
                  myDropDown2(
                      context,
                      Icons.perm_identity,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _occupation ?? '',
                      occupationDropDownList,
                      myColor.scaffoldBackgroundColor.withOpacity(0.4),
                      onValueChanged: (value) {
                    setState(() {
                      _occupation = value.name;
                      //    updateGlobalFormDraft(
                      //       GlobalFormDraftColumns.firstName, _firstName);
                    });
                  })),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: myNumberTextFormField(
                'PAN No.',
                _panNo,
                'Enter your PAN no.',
                _panNo,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _panNo = value;

                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: mytextFormFieldWithPrefixIcon(
                context,
                FocusNode(),
                'Organization Name',
                _organizationName,
                'Enter your organization name',
                _organizationName,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _organizationName = value;
                  //      updateGlobalFormDraft(
                  //           GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: mytextFormFieldWithPrefixIcon(
                context,
                FocusNode(),
                'Designation',
                _designation,
                'Enter your designation',
                _designation,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _designation = value;
                  //  updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: mytextFormFieldWithPrefixIcon(
                context,
                FocusNode(),
                'Organization Address',
                _organizationAddress,
                'Enter your organization address',
                _organizationAddress,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _organizationAddress = value;
                  //  updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 1,
              child: myNumberTextFormField(
                'Organization Contact',
                _organizationContact,
                'Enter your organization contact',
                _organizationContact,
                Icons.perm_identity_outlined,
                kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  _organizationContact = value;

                  // updateGlobalFormDraft(
                  //     GlobalFormDraftColumns.firstName, _firstName);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget checkBoxCard(name, StateHandlerBloc? dynamicBloc,
      {ValueChanged<int>? onValueChanged}) {
    return Row(children: [
      Expanded(
        child: Text(
          name,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        width: 30.0,
        height: 30.0,
        child: StreamBuilder<dynamic>(
            initialData: false,
            stream: dynamicBloc!.stateStream,
            builder: (context, snapshot) {
              return Checkbox(
                  activeColor: myColor.primaryColorDark,
                  side: BorderSide(width: 1.0, color: myColor.primaryColorDark),
                  visualDensity: const VisualDensity(horizontal: -4),
                  value: snapshot.data,
                  onChanged: (bool? newValue) {
                    dynamicBloc.storeData(newValue!);
                    onValueChanged!(newValue == true ? 1 : 0);
                    // setState(() {
                    // checkBoxValue = newValue!;
                    // print(checkBoxValue);
                    // });
                  });
            }),
      ),
    ]);
  }
}
