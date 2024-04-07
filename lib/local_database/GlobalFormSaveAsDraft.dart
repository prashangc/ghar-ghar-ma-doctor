const String tableNameGlobalFormDraft = 'GlobalFormDraft';

class GlobalFormDraftColumns {
  static final List<String> values = [
    id,
    userID,
    salutation,
    firstName,
    middleName,
    lastName,
    phone,
    email,
    dobNep,
    dobEng,
    gender,
    nationality,
    branch,
    country,
    houseNoPerm,
    provinceIDPerm,
    provinceNamePerm,
    districtIDPerm,
    districtNamePerm,
    vdcIDPerm,
    vdcNamePerm,
    wardIDPerm,
    wardNamePerm,
    permanentAddress,
    houseNoTemp,
    provinceIDTemp,
    provinceNameTemp,
    districtIDTemp,
    districtNameTemp,
    vdcIDTemp,
    vdcNameTemp,
    wardIDTemp,
    wardNameTemp,
    temporaryAddress,
    workStatus,
    purposeOfAccount,
    incomeSource,
    annualIncome,
    occupation,
    pan,
    organizationName,
    organizationAddress,
    organizationContact,
    designation,
    identificationType,
    identificationDocNumber,
    issuedDateEng,
    issuedDateNep,
    issuedDistrict,
    fatherName,
    motherName,
    grandFatherName,
    grandMotherName,
    spouseName,
    maritalStatus,
    education,
    maxAmount,
    monthlyAmount,
    yearlyAmount,
    noOfMonthlyTransaction,
    noOfyearlyTransaction,
    nomineeName,
    nomineeFatherName,
    nomineeGrandfatherName,
    nomineeRelation,
    nomineeDobEng,
    nomineeDobNep,
    nomineeCitizenship,
    nomineeCitizenshipIssuedPlace,
    nomineeCitizenshipIssuedDateEng,
    nomineeCitizenshipIssuedDateNep,
    nomineePhone,
    nomineeCurrentAddress,
    nomineePermanentAddress,
    beneficiaryName,
    beneficiaryRelation,
    beneficiaryPhone,
    beneficiaryAddress,
  ];

  static const String id = '_id';
  static const String userID = 'userID';
  static const String salutation = 'salutation';
  static const String firstName = 'firstName';
  static const String middleName = 'middleName';
  static const String lastName = 'lastName';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String dobEng = 'dobEng';
  static const String dobNep = 'dobNep';
  static const String gender = 'gender';
  static const String nationality = 'nationality';
  static const String branch = 'branch';
  static const String country = 'country';

  static const String houseNoPerm = 'houseNoPerm';
  static const String provinceIDPerm = 'provinceIDPerm';
  static const String provinceNamePerm = 'provinceNamePerm';
  static const String districtIDPerm = 'districtIDPerm';
  static const String districtNamePerm = 'districtNamePerm';
  static const String vdcIDPerm = 'vdcIDPerm';
  static const String vdcNamePerm = 'vdcNamePerm';
  static const String wardIDPerm = 'wardIDPerm';
  static const String wardNamePerm = 'wardNamePerm';
  static const String permanentAddress = 'permanentAddress';

  static const String houseNoTemp = 'houseNoTemp';
  static const String provinceIDTemp = 'provinceIDTemp';
  static const String provinceNameTemp = 'provinceNameTemp';
  static const String districtIDTemp = 'districtIDTemp';
  static const String districtNameTemp = 'districtNameTemp';
  static const String vdcIDTemp = 'vdcIDTemp';
  static const String vdcNameTemp = 'vdcNameTemp';
  static const String wardIDTemp = 'wardIDTemp';
  static const String wardNameTemp = 'wardNameTemp';
  static const String temporaryAddress = 'temporaryAddress';

  static const String workStatus = 'workStatus';
  static const String purposeOfAccount = 'purposeOfAccount';
  static const String incomeSource = 'incomeSource';
  static const String annualIncome = 'annualIncome';
  static const String occupation = 'occupation';
  static const String pan = 'pan';
  static const String organizationName = 'organizationName';
  static const String organizationAddress = 'organizationAddress';
  static const String organizationContact = 'organizationContact';
  static const String designation = 'designation';

  static const String identificationType = 'identificationType';
  static const String identificationDocNumber = 'identificationDocNumber';
  static const String issuedDateEng = 'issudedDateEng';
  static const String issuedDateNep = 'issudedDateNep';
  static const String issuedDistrict = 'issuedDistrict';

  static const String fatherName = 'fatherName';
  static const String motherName = 'motherName';
  static const String grandFatherName = 'grandFatherName';
  static const String spouseName = 'spouseName';
  static const String grandMotherName = 'grandMotherName';
  static const String maritalStatus = 'maritalStatus';

  static const String education = 'education';
  static const String maxAmount = 'maxAmount';
  static const String monthlyAmount = 'monthlyAmount';
  static const String yearlyAmount = 'yearlyAmount';
  static const String noOfMonthlyTransaction = 'noOfMonthlyTransaction';
  static const String noOfyearlyTransaction = 'noOfyearlyTransaction';

  static const String nomineeName = 'nomineeName';
  static const String nomineeFatherName = 'nomineeFatherName';
  static const String nomineeGrandfatherName = 'nomineeGrandfatherName';
  static const String nomineeRelation = 'nomineeRelation';
  static const String nomineeDobEng = 'nomineeDobEng';
  static const String nomineeDobNep = 'nomineeDobNep';
  static const String nomineeCitizenship = 'nomineeCitizenship';
  static const String nomineeCitizenshipIssuedPlace =
      'nomineeCitizenshipIssuedPlace';
  static const String nomineeCitizenshipIssuedDateEng =
      'nomineeCitizenshipIssuedDateEng';
  static const String nomineeCitizenshipIssuedDateNep =
      'nomineeCitizenshipIssuedDateNep';
  static const String nomineePhone = 'nomineePhone';
  static const String nomineeCurrentAddress = 'nomineeCurrentAddress';
  static const String nomineePermanentAddress = 'nomineePermanentAddress';

  static const String beneficiaryName = 'beneficiaryName';
  static const String beneficiaryRelation = 'beneficiaryRelation';
  static const String beneficiaryPhone = 'beneficiaryPhone';
  static const String beneficiaryAddress = 'beneficiaryAddress';
}

class GlobalFormDraftDatabaseModel {
  final int? id;
  final int? userID;
  final String? salutation;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? dobNep;
  final String? dobEng;
  final String? gender;
  final String? nationality;
  final String? branch;
  final String? country;
  final String? houseNoPerm;
  final String? provinceIDPerm;
  final String? provinceNamePerm;
  final String? districtIDPerm;
  final String? districtNamePerm;
  final String? vdcIDPerm;
  final String? vdcNamePerm;
  final String? wardIDPerm;
  final String? wardNamePerm;
  final String? permanentAddress;
  final String? houseNoTemp;
  final String? provinceIDTemp;
  final String? provinceNameTemp;
  final String? districtIDTemp;
  final String? districtNameTemp;
  final String? vdcIDTemp;
  final String? vdcNameTemp;
  final String? wardIDTemp;
  final String? wardNameTemp;
  final String? temporaryAddress;
  final String? workStatus;
  final String? purposeOfAccount;
  final String? incomeSource;
  final String? annualIncome;
  final String? occupation;
  final String? pan;
  final String? organizationName;
  final String? organizationAddress;
  final String? organizationContact;
  final String? designation;
  final String? identificationType;
  final String? identificationDocNumber;
  final String? issuedDateEng;
  final String? issuedDateNep;
  final String? issuedDistrict;
  final String? fatherName;
  final String? motherName;
  final String? grandFatherName;
  final String? grandMotherName;
  final String? spouseName;
  final String? maritalStatus;
  final String? education;
  final String? maxAmount;
  final String? monthlyAmount;
  final String? yearlyAmount;
  final String? noOfMonthlyTransaction;
  final String? noOfyearlyTransaction;
  final String? nomineeName;
  final String? nomineeFatherName;
  final String? nomineeGrandfatherName;
  final String? nomineeRelation;
  final String? nomineeDobEng;
  final String? nomineeDobNep;
  final String? nomineeCitizenship;
  final String? nomineeCitizenshipIssuedPlace;
  final String? nomineeCitizenshipIssuedDateEng;
  final String? nomineeCitizenshipIssuedDateNep;
  final String? nomineePhone;
  final String? nomineeCurrentAddress;
  final String? nomineePermanentAddress;
  final String? beneficiaryName;
  final String? beneficiaryRelation;
  final String? beneficiaryPhone;
  final String? beneficiaryAddress;

  const GlobalFormDraftDatabaseModel({
    this.id,
    this.userID,
    this.salutation,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phone,
    this.email,
    this.dobNep,
    this.dobEng,
    this.gender,
    this.nationality,
    this.branch,
    this.country,
    this.houseNoPerm,
    this.provinceIDPerm,
    this.provinceNamePerm,
    this.districtIDPerm,
    this.districtNamePerm,
    this.vdcIDPerm,
    this.vdcNamePerm,
    this.wardIDPerm,
    this.wardNamePerm,
    this.permanentAddress,
    this.houseNoTemp,
    this.provinceIDTemp,
    this.provinceNameTemp,
    this.districtIDTemp,
    this.districtNameTemp,
    this.vdcIDTemp,
    this.vdcNameTemp,
    this.wardIDTemp,
    this.wardNameTemp,
    this.temporaryAddress,
    this.workStatus,
    this.purposeOfAccount,
    this.incomeSource,
    this.annualIncome,
    this.occupation,
    this.pan,
    this.organizationName,
    this.organizationAddress,
    this.organizationContact,
    this.designation,
    this.identificationType,
    this.identificationDocNumber,
    this.issuedDateEng,
    this.issuedDateNep,
    this.issuedDistrict,
    this.fatherName,
    this.motherName,
    this.grandFatherName,
    this.grandMotherName,
    this.spouseName,
    this.maritalStatus,
    this.education,
    this.maxAmount,
    this.monthlyAmount,
    this.yearlyAmount,
    this.noOfMonthlyTransaction,
    this.noOfyearlyTransaction,
    this.nomineeName,
    this.nomineeFatherName,
    this.nomineeGrandfatherName,
    this.nomineeRelation,
    this.nomineeDobEng,
    this.nomineeDobNep,
    this.nomineeCitizenship,
    this.nomineeCitizenshipIssuedPlace,
    this.nomineeCitizenshipIssuedDateEng,
    this.nomineeCitizenshipIssuedDateNep,
    this.nomineePhone,
    this.nomineeCurrentAddress,
    this.nomineePermanentAddress,
    this.beneficiaryName,
    this.beneficiaryRelation,
    this.beneficiaryPhone,
    this.beneficiaryAddress,
  });

  GlobalFormDraftDatabaseModel copy({
    final int? id,
    final int? userID,
    final String? salutation,
    final String? firstName,
    final String? middleName,
    final String? lastName,
    final String? phone,
    final String? email,
    final String? dobNep,
    final String? dobEng,
    final String? gender,
    final String? nationality,
    final String? branch,
    final String? country,
    final String? houseNoPerm,
    final String? provinceIDPerm,
    final String? provinceNamePerm,
    final String? districtIDPerm,
    final String? districtNamePerm,
    final String? vdcIDPerm,
    final String? vdcNamePerm,
    final String? wardIDPerm,
    final String? wardNamePerm,
    final String? permanentAddress,
    final String? houseNoTemp,
    final String? provinceIDTemp,
    final String? provinceNameTemp,
    final String? districtIDTemp,
    final String? districtNameTemp,
    final String? vdcIDTemp,
    final String? vdcNameTemp,
    final String? wardIDTemp,
    final String? wardNameTemp,
    final String? temporaryAddress,
    final String? workStatus,
    final String? purposeOfAccount,
    final String? incomeSource,
    final String? annualIncome,
    final String? occupation,
    final String? pan,
    final String? organizationName,
    final String? organizationAddress,
    final String? organizationContact,
    final String? designation,
    final String? identificationType,
    final String? identificationDocNumber,
    final String? issuedDateEng,
    final String? issuedDateNep,
    final String? issuedDistrict,
    final String? fatherName,
    final String? motherName,
    final String? grandFatherName,
    final String? grandMotherName,
    final String? spouseName,
    final String? maritalStatus,
    final String? education,
    final String? maxAmount,
    final String? monthlyAmount,
    final String? yearlyAmount,
    final String? noOfMonthlyTransaction,
    final String? noOfyearlyTransaction,
    final String? nomineeName,
    final String? nomineeFatherName,
    final String? nomineeGrandfatherName,
    final String? nomineeRelation,
    final String? nomineeDobEng,
    final String? nomineeDobNep,
    final String? nomineeCitizenship,
    final String? nomineeCitizenshipIssuedPlace,
    final String? nomineeCitizenshipIssuedDateEng,
    final String? nomineeCitizenshipIssuedDateNep,
    final String? nomineePhone,
    final String? nomineeCurrentAddress,
    final String? nomineePermanentAddress,
    final String? beneficiaryName,
    final String? beneficiaryRelation,
    final String? beneficiaryPhone,
    final String? beneficiaryAddress,
  }) =>
      GlobalFormDraftDatabaseModel(
        id: id ?? this.id,
        userID: userID ?? this.userID,
        salutation: salutation ?? this.salutation,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        dobEng: dobEng ?? this.dobEng,
        dobNep: dobNep ?? this.dobNep,
        gender: gender ?? this.gender,
        nationality: nationality ?? this.nationality,
        branch: branch ?? this.branch,
        country: country ?? this.country,
        houseNoPerm: houseNoPerm ?? this.houseNoPerm,
        provinceIDPerm: provinceIDPerm ?? this.provinceIDPerm,
        provinceNamePerm: provinceNamePerm ?? this.provinceNamePerm,
        districtIDPerm: districtIDPerm ?? this.districtIDPerm,
        districtNamePerm: districtNamePerm ?? this.districtNamePerm,
        vdcIDPerm: vdcIDPerm ?? this.vdcIDPerm,
        vdcNamePerm: vdcNamePerm ?? this.vdcNamePerm,
        wardIDPerm: wardIDPerm ?? this.wardIDPerm,
        wardNamePerm: wardNamePerm ?? this.wardNamePerm,
        permanentAddress: permanentAddress ?? this.permanentAddress,
        houseNoTemp: houseNoTemp ?? this.houseNoTemp,
        provinceIDTemp: provinceIDTemp ?? this.provinceIDTemp,
        provinceNameTemp: provinceNameTemp ?? this.provinceNameTemp,
        districtIDTemp: districtIDTemp ?? this.districtIDTemp,
        districtNameTemp: districtNameTemp ?? this.districtNameTemp,
        vdcIDTemp: vdcIDTemp ?? this.vdcIDTemp,
        vdcNameTemp: vdcNameTemp ?? this.vdcNameTemp,
        wardIDTemp: wardIDTemp ?? this.wardIDTemp,
        wardNameTemp: wardNameTemp ?? this.wardNameTemp,
        temporaryAddress: temporaryAddress ?? this.temporaryAddress,
        workStatus: workStatus ?? this.workStatus,
        purposeOfAccount: purposeOfAccount ?? this.purposeOfAccount,
        incomeSource: incomeSource ?? this.incomeSource,
        annualIncome: annualIncome ?? this.annualIncome,
        occupation: occupation ?? this.occupation,
        pan: pan ?? this.pan,
        organizationName: organizationName ?? this.organizationName,
        organizationAddress: organizationAddress ?? this.organizationAddress,
        organizationContact: organizationContact ?? this.organizationContact,
        designation: designation ?? this.designation,
        identificationType: identificationType ?? this.identificationType,
        identificationDocNumber:
            identificationDocNumber ?? this.identificationDocNumber,
        issuedDateEng: issuedDateEng ?? this.issuedDateEng,
        issuedDateNep: issuedDateNep ?? this.issuedDateNep,
        issuedDistrict: issuedDistrict ?? this.issuedDistrict,
        fatherName: fatherName ?? this.fatherName,
        motherName: motherName ?? this.motherName,
        grandFatherName: grandFatherName ?? this.grandFatherName,
        grandMotherName: grandMotherName ?? this.grandMotherName,
        spouseName: spouseName ?? this.spouseName,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        education: education ?? this.education,
        maxAmount: maxAmount ?? this.maxAmount,
        monthlyAmount: monthlyAmount ?? this.monthlyAmount,
        yearlyAmount: yearlyAmount ?? this.yearlyAmount,
        noOfMonthlyTransaction:
            noOfMonthlyTransaction ?? this.noOfMonthlyTransaction,
        noOfyearlyTransaction:
            noOfyearlyTransaction ?? this.noOfyearlyTransaction,
        nomineeName: nomineeName ?? this.nomineeName,
        nomineeFatherName: nomineeFatherName ?? this.nomineeFatherName,
        nomineeGrandfatherName:
            nomineeGrandfatherName ?? this.nomineeGrandfatherName,
        nomineeRelation: nomineeRelation ?? this.nomineeRelation,
        nomineeDobEng: nomineeDobEng ?? this.nomineeDobEng,
        nomineeDobNep: nomineeDobNep ?? this.nomineeDobNep,
        nomineeCitizenship: nomineeCitizenship ?? this.nomineeCitizenship,
        nomineeCitizenshipIssuedPlace:
            nomineeCitizenshipIssuedPlace ?? this.nomineeCitizenshipIssuedPlace,
        nomineeCitizenshipIssuedDateEng: nomineeCitizenshipIssuedDateEng ??
            this.nomineeCitizenshipIssuedDateEng,
        nomineeCitizenshipIssuedDateNep: nomineeCitizenshipIssuedDateNep ??
            this.nomineeCitizenshipIssuedDateNep,
        nomineePhone: nomineePhone ?? this.nomineePhone,
        nomineeCurrentAddress:
            nomineeCurrentAddress ?? this.nomineeCurrentAddress,
        nomineePermanentAddress:
            nomineePermanentAddress ?? this.nomineePermanentAddress,
        beneficiaryName: beneficiaryName ?? this.beneficiaryName,
        beneficiaryRelation: beneficiaryRelation ?? this.beneficiaryRelation,
        beneficiaryPhone: beneficiaryPhone ?? this.beneficiaryPhone,
        beneficiaryAddress: beneficiaryAddress ?? this.beneficiaryAddress,
      );

  static GlobalFormDraftDatabaseModel fromJson(Map<String, Object?> json) =>
      GlobalFormDraftDatabaseModel(
        id: json[GlobalFormDraftColumns.id] as int?,
        userID: json[GlobalFormDraftColumns.userID] as int?,
        salutation: json[GlobalFormDraftColumns.salutation] as String?,
        firstName: json[GlobalFormDraftColumns.firstName] as String,
        middleName: json[GlobalFormDraftColumns.middleName] as String,
        lastName: json[GlobalFormDraftColumns.lastName] as String,
        phone: json[GlobalFormDraftColumns.phone] as String,
        email: json[GlobalFormDraftColumns.email] as String,
        dobNep: json[GlobalFormDraftColumns.dobNep] as String,
        dobEng: json[GlobalFormDraftColumns.dobEng] as String,
        gender: json[GlobalFormDraftColumns.gender] as String,
        nationality: json[GlobalFormDraftColumns.nationality] as String,
        branch: json[GlobalFormDraftColumns.branch] as String,
        country: json[GlobalFormDraftColumns.country] as String,
        houseNoPerm: json[GlobalFormDraftColumns.houseNoPerm] as String,
        provinceIDPerm: json[GlobalFormDraftColumns.provinceIDPerm] as String,
        provinceNamePerm:
            json[GlobalFormDraftColumns.provinceNamePerm] as String,
        districtIDPerm: json[GlobalFormDraftColumns.districtIDPerm] as String,
        districtNamePerm:
            json[GlobalFormDraftColumns.districtNamePerm] as String,
        vdcIDPerm: json[GlobalFormDraftColumns.vdcIDPerm] as String,
        vdcNamePerm: json[GlobalFormDraftColumns.vdcNamePerm] as String,
        wardIDPerm: json[GlobalFormDraftColumns.wardIDPerm] as String,
        wardNamePerm: json[GlobalFormDraftColumns.wardNamePerm] as String,
        permanentAddress:
            json[GlobalFormDraftColumns.permanentAddress] as String,
        houseNoTemp: json[GlobalFormDraftColumns.houseNoTemp] as String,
        provinceIDTemp: json[GlobalFormDraftColumns.provinceIDTemp] as String,
        provinceNameTemp:
            json[GlobalFormDraftColumns.provinceNameTemp] as String,
        districtIDTemp: json[GlobalFormDraftColumns.districtIDTemp] as String,
        districtNameTemp:
            json[GlobalFormDraftColumns.districtNameTemp] as String,
        vdcIDTemp: json[GlobalFormDraftColumns.vdcIDTemp] as String,
        vdcNameTemp: json[GlobalFormDraftColumns.vdcNameTemp] as String,
        wardIDTemp: json[GlobalFormDraftColumns.wardIDTemp] as String,
        wardNameTemp: json[GlobalFormDraftColumns.wardNameTemp] as String,
        temporaryAddress:
            json[GlobalFormDraftColumns.temporaryAddress] as String,
        workStatus: json[GlobalFormDraftColumns.workStatus] as String,
        purposeOfAccount:
            json[GlobalFormDraftColumns.purposeOfAccount] as String,
        incomeSource: json[GlobalFormDraftColumns.incomeSource] as String,
        annualIncome: json[GlobalFormDraftColumns.annualIncome] as String,
        occupation: json[GlobalFormDraftColumns.occupation] as String,
        pan: json[GlobalFormDraftColumns.pan] as String,
        organizationName:
            json[GlobalFormDraftColumns.organizationName] as String,
        organizationAddress:
            json[GlobalFormDraftColumns.organizationAddress] as String,
        organizationContact:
            json[GlobalFormDraftColumns.organizationContact] as String,
        designation: json[GlobalFormDraftColumns.designation] as String,
        identificationType:
            json[GlobalFormDraftColumns.identificationType] as String,
        identificationDocNumber:
            json[GlobalFormDraftColumns.identificationDocNumber] as String,
        issuedDateEng: json[GlobalFormDraftColumns.issuedDateEng] as String,
        issuedDateNep: json[GlobalFormDraftColumns.issuedDateNep] as String,
        issuedDistrict: json[GlobalFormDraftColumns.issuedDistrict] as String,
        fatherName: json[GlobalFormDraftColumns.fatherName] as String,
        motherName: json[GlobalFormDraftColumns.motherName] as String,
        grandFatherName: json[GlobalFormDraftColumns.grandFatherName] as String,
        grandMotherName: json[GlobalFormDraftColumns.grandMotherName] as String,
        spouseName: json[GlobalFormDraftColumns.spouseName] as String,
        maritalStatus: json[GlobalFormDraftColumns.maritalStatus] as String,
        education: json[GlobalFormDraftColumns.education] as String,
        maxAmount: json[GlobalFormDraftColumns.maxAmount] as String,
        monthlyAmount: json[GlobalFormDraftColumns.monthlyAmount] as String,
        yearlyAmount: json[GlobalFormDraftColumns.yearlyAmount] as String,
        noOfMonthlyTransaction:
            json[GlobalFormDraftColumns.noOfMonthlyTransaction] as String,
        noOfyearlyTransaction:
            json[GlobalFormDraftColumns.noOfyearlyTransaction] as String,
        nomineeName: json[GlobalFormDraftColumns.nomineeName] as String,
        nomineeFatherName:
            json[GlobalFormDraftColumns.nomineeFatherName] as String,
        nomineeGrandfatherName:
            json[GlobalFormDraftColumns.nomineeGrandfatherName] as String,
        nomineeRelation: json[GlobalFormDraftColumns.nomineeRelation] as String,
        nomineeDobEng: json[GlobalFormDraftColumns.nomineeDobEng] as String,
        nomineeDobNep: json[GlobalFormDraftColumns.nomineeDobNep] as String,
        nomineeCitizenship:
            json[GlobalFormDraftColumns.nomineeCitizenship] as String,
        nomineeCitizenshipIssuedPlace:
            json[GlobalFormDraftColumns.nomineeCitizenshipIssuedPlace]
                as String,
        nomineeCitizenshipIssuedDateEng:
            json[GlobalFormDraftColumns.nomineeCitizenshipIssuedDateEng]
                as String,
        nomineeCitizenshipIssuedDateNep:
            json[GlobalFormDraftColumns.nomineeCitizenshipIssuedDateNep]
                as String,
        nomineePhone: json[GlobalFormDraftColumns.nomineePhone] as String,
        nomineeCurrentAddress:
            json[GlobalFormDraftColumns.nomineeCurrentAddress] as String,
        nomineePermanentAddress:
            json[GlobalFormDraftColumns.nomineePermanentAddress] as String,
        beneficiaryName: json[GlobalFormDraftColumns.beneficiaryName] as String,
        beneficiaryRelation:
            json[GlobalFormDraftColumns.beneficiaryRelation] as String,
        beneficiaryPhone:
            json[GlobalFormDraftColumns.beneficiaryPhone] as String,
      );
  Map<String, Object?> toJson() => {
        GlobalFormDraftColumns.id: id,
        GlobalFormDraftColumns.userID: userID,
        GlobalFormDraftColumns.salutation: salutation,
        GlobalFormDraftColumns.firstName: firstName,
        GlobalFormDraftColumns.middleName: middleName,
        GlobalFormDraftColumns.lastName: lastName,
        GlobalFormDraftColumns.phone: phone,
        GlobalFormDraftColumns.email: email,
        GlobalFormDraftColumns.dobNep: dobNep,
        GlobalFormDraftColumns.dobEng: dobEng,
        GlobalFormDraftColumns.gender: gender,
        GlobalFormDraftColumns.nationality: nationality,
        GlobalFormDraftColumns.branch: branch,
        GlobalFormDraftColumns.country: country,
        GlobalFormDraftColumns.houseNoPerm: houseNoPerm,
        GlobalFormDraftColumns.provinceIDPerm: provinceIDPerm,
        GlobalFormDraftColumns.provinceNamePerm: provinceNamePerm,
        GlobalFormDraftColumns.districtIDPerm: districtIDPerm,
        GlobalFormDraftColumns.districtNamePerm: districtNamePerm,
        GlobalFormDraftColumns.vdcIDPerm: vdcIDPerm,
        GlobalFormDraftColumns.vdcNamePerm: vdcNamePerm,
        GlobalFormDraftColumns.wardIDPerm: wardIDPerm,
        GlobalFormDraftColumns.wardNamePerm: wardNamePerm,
        GlobalFormDraftColumns.permanentAddress: permanentAddress,
        GlobalFormDraftColumns.houseNoTemp: houseNoTemp,
        GlobalFormDraftColumns.provinceIDTemp: provinceIDTemp,
        GlobalFormDraftColumns.provinceNameTemp: provinceNameTemp,
        GlobalFormDraftColumns.districtIDTemp: districtIDTemp,
        GlobalFormDraftColumns.districtNameTemp: districtNameTemp,
        GlobalFormDraftColumns.vdcIDTemp: vdcIDTemp,
        GlobalFormDraftColumns.vdcNameTemp: vdcNameTemp,
        GlobalFormDraftColumns.wardIDTemp: wardIDTemp,
        GlobalFormDraftColumns.wardNameTemp: wardNameTemp,
        GlobalFormDraftColumns.temporaryAddress: temporaryAddress,
        GlobalFormDraftColumns.workStatus: workStatus,
        GlobalFormDraftColumns.purposeOfAccount: purposeOfAccount,
        GlobalFormDraftColumns.incomeSource: incomeSource,
        GlobalFormDraftColumns.annualIncome: annualIncome,
        GlobalFormDraftColumns.occupation: occupation,
        GlobalFormDraftColumns.pan: pan,
        GlobalFormDraftColumns.organizationName: organizationName,
        GlobalFormDraftColumns.organizationAddress: organizationAddress,
        GlobalFormDraftColumns.organizationContact: organizationContact,
        GlobalFormDraftColumns.designation: designation,
        GlobalFormDraftColumns.identificationType: identificationType,
        GlobalFormDraftColumns.identificationDocNumber: identificationDocNumber,
        GlobalFormDraftColumns.issuedDateEng: issuedDateEng,
        GlobalFormDraftColumns.issuedDateNep: issuedDateNep,
        GlobalFormDraftColumns.issuedDistrict: issuedDistrict,
        GlobalFormDraftColumns.fatherName: fatherName,
        GlobalFormDraftColumns.motherName: motherName,
        GlobalFormDraftColumns.grandFatherName: grandFatherName,
        GlobalFormDraftColumns.grandMotherName: grandMotherName,
        GlobalFormDraftColumns.spouseName: spouseName,
        GlobalFormDraftColumns.maritalStatus: maritalStatus,
        GlobalFormDraftColumns.education: education,
        GlobalFormDraftColumns.maxAmount: maxAmount,
        GlobalFormDraftColumns.monthlyAmount: monthlyAmount,
        GlobalFormDraftColumns.yearlyAmount: yearlyAmount,
        GlobalFormDraftColumns.noOfMonthlyTransaction: noOfMonthlyTransaction,
        GlobalFormDraftColumns.noOfyearlyTransaction: noOfyearlyTransaction,
        GlobalFormDraftColumns.nomineeName: nomineeName,
        GlobalFormDraftColumns.nomineeFatherName: nomineeFatherName,
        GlobalFormDraftColumns.nomineeGrandfatherName: nomineeGrandfatherName,
        GlobalFormDraftColumns.nomineeRelation: nomineeRelation,
        GlobalFormDraftColumns.nomineeDobEng: nomineeDobEng,
        GlobalFormDraftColumns.nomineeDobNep: nomineeDobNep,
        GlobalFormDraftColumns.nomineeCitizenship: nomineeCitizenship,
        GlobalFormDraftColumns.nomineeCitizenshipIssuedPlace:
            nomineeCitizenshipIssuedPlace,
        GlobalFormDraftColumns.nomineeCitizenshipIssuedDateEng:
            nomineeCitizenshipIssuedDateEng,
        GlobalFormDraftColumns.nomineeCitizenshipIssuedDateNep:
            nomineeCitizenshipIssuedDateNep,
        GlobalFormDraftColumns.nomineePhone: nomineePhone,
        GlobalFormDraftColumns.nomineeCurrentAddress: nomineeCurrentAddress,
        GlobalFormDraftColumns.nomineePermanentAddress: nomineePermanentAddress,
        GlobalFormDraftColumns.beneficiaryName: beneficiaryName,
        GlobalFormDraftColumns.beneficiaryRelation: beneficiaryRelation,
        GlobalFormDraftColumns.beneficiaryPhone: beneficiaryPhone,
        GlobalFormDraftColumns.beneficiaryAddress: beneficiaryAddress
      };
}
