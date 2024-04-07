class PostGlobalFormModel {
  int? id;
  String? formStatus;
  String? slug;
  int? userId;
  String? salutation;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? nationality;
  String? birthDate;
  String? accountBranch;
  String? currency;
  String? mobileNumber;
  String? email;
  String? country;
  String? tempHouseNumber;
  int? tempProvinceId;
  int? tempDistrictId;
  int? tempMunicipalityId;
  int? tempWardId;
  String? tempLocation;
  String? permHouseNumber;
  int? permProvinceId;
  int? permDistrictId;
  int? permMunicipalityId;
  int? permWardId;
  String? permLocation;
  String? workStatus;
  String? accountPurpose;
  String? sourceOfIncome;
  String? annualIncome;
  String? occupation;
  String? panNumber;
  String? organizationName;
  String? designation;
  String? organizationAddress;
  String? organizationNumber;
  String? fatherFullName;
  String? motherFullName;
  String? grandfatherFullName;
  String? grandmotherFullName;
  String? husbandWifeFullName;
  String? maritalStatus;
  String? maxAmountPerTansaction;
  String? numberOfMonthlyTransaction;
  String? monthlyAmountOfTransaction;
  String? numberOfYearlyTransaction;
  String? yearlyAmountOfTransaction;
  String? education;
  String? identificationType;
  String? identificationNo;
  String? citizenshipDate;
  String? citizenshipIssueDistrict;
  String? nomineeName;
  String? nomineeFatherName;
  String? nomineeGrandfatherName;
  String? nomineeRelation;
  String? nomineeCitizenshipIssuedPlace;
  String? nomineeCitizenshipNumber;
  String? nomineeCitizenshipIssuedDate;
  String? nomineeBirthdate;
  String? nomineePermanentAddress;
  String? nomineeCurrentAddress;
  String? nomineePhoneNumber;
  String? beneficiaryName;
  String? beneficiaryAddress;
  String? beneficiaryContactNumber;
  String? beneficiaryRelation;
  int? areYouNrn;
  int? usCitizen;
  int? usResidence;
  int? criminalOffence;
  int? greenCard;
  int? accountInOtherBanks;
  String? serviceForm;
  String? selfImage;
  String? selfImagePath;
  String? citizenshipFront;
  String? citizenshipFrontPath;
  String? citizenshipBack;
  String? citizenshipBackPath;
  String? latitude;
  String? longitude;

  PostGlobalFormModel(
      {this.id,
      this.formStatus,
      this.slug,
      this.userId,
      this.salutation,
      this.firstName,
      this.middleName,
      this.lastName,
      this.gender,
      this.nationality,
      this.birthDate,
      this.accountBranch,
      this.currency,
      this.mobileNumber,
      this.email,
      this.country,
      this.tempHouseNumber,
      this.tempProvinceId,
      this.tempDistrictId,
      this.tempMunicipalityId,
      this.tempWardId,
      this.tempLocation,
      this.permHouseNumber,
      this.permProvinceId,
      this.permDistrictId,
      this.permMunicipalityId,
      this.permWardId,
      this.permLocation,
      this.workStatus,
      this.accountPurpose,
      this.sourceOfIncome,
      this.annualIncome,
      this.occupation,
      this.panNumber,
      this.organizationName,
      this.designation,
      this.organizationAddress,
      this.organizationNumber,
      this.fatherFullName,
      this.motherFullName,
      this.grandfatherFullName,
      this.grandmotherFullName,
      this.husbandWifeFullName,
      this.maritalStatus,
      this.maxAmountPerTansaction,
      this.numberOfMonthlyTransaction,
      this.monthlyAmountOfTransaction,
      this.numberOfYearlyTransaction,
      this.yearlyAmountOfTransaction,
      this.education,
      this.identificationType,
      this.identificationNo,
      this.citizenshipDate,
      this.citizenshipIssueDistrict,
      this.nomineeName,
      this.nomineeFatherName,
      this.nomineeGrandfatherName,
      this.nomineeRelation,
      this.nomineeCitizenshipIssuedPlace,
      this.nomineeCitizenshipNumber,
      this.nomineeCitizenshipIssuedDate,
      this.nomineeBirthdate,
      this.nomineePermanentAddress,
      this.nomineeCurrentAddress,
      this.nomineePhoneNumber,
      this.beneficiaryName,
      this.beneficiaryAddress,
      this.beneficiaryContactNumber,
      this.beneficiaryRelation,
      this.areYouNrn,
      this.usCitizen,
      this.usResidence,
      this.criminalOffence,
      this.greenCard,
      this.accountInOtherBanks,
      this.serviceForm,
      this.selfImage,
      this.selfImagePath,
      this.citizenshipFront,
      this.citizenshipFrontPath,
      this.citizenshipBack,
      this.citizenshipBackPath,
      this.latitude,
      this.longitude});

  PostGlobalFormModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formStatus = json['form_status'];
    slug = json['slug'];
    userId = json['user_id'];
    salutation = json['salutation'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    nationality = json['nationality'];
    birthDate = json['birth_date'];
    accountBranch = json['account_branch'];
    currency = json['currency'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    country = json['country'];
    tempHouseNumber = json['temp_house_number'];
    tempProvinceId = json['temp_province_id'];
    tempDistrictId = json['temp_district_id'];
    tempMunicipalityId = json['temp_municipality_id'];
    tempWardId = json['temp_ward_id'];
    tempLocation = json['temp_location'];
    permHouseNumber = json['perm_house_number'];
    permProvinceId = json['perm_province_id'];
    permDistrictId = json['perm_district_id'];
    permMunicipalityId = json['perm_municipality_id'];
    permWardId = json['perm_ward_id'];
    permLocation = json['perm_location'];
    workStatus = json['work_status'];
    accountPurpose = json['account_purpose'];
    sourceOfIncome = json['source_of_income'];
    annualIncome = json['annual_income'];
    occupation = json['occupation'];
    panNumber = json['pan_number'];
    organizationName = json['organization_name'];
    designation = json['designation'];
    organizationAddress = json['organization_address'];
    organizationNumber = json['organization_number'];
    fatherFullName = json['father_full_name'];
    motherFullName = json['mother_full_name'];
    grandfatherFullName = json['grandfather_full_name'];
    grandmotherFullName = json['grandmother_full_name'];
    husbandWifeFullName = json['husband_wife_full_name'];
    maritalStatus = json['marital_status'];
    maxAmountPerTansaction = json['max_amount_per_tansaction'];
    numberOfMonthlyTransaction = json['number_of_monthly_transaction'];
    monthlyAmountOfTransaction = json['monthly_amount_of_transaction'];
    numberOfYearlyTransaction = json['number_of_yearly_transaction'];
    yearlyAmountOfTransaction = json['yearly_amount_of_transaction'];
    education = json['education'];
    identificationType = json['identification_type'];
    identificationNo = json['identification_no'];
    citizenshipDate = json['citizenship_date'];
    citizenshipIssueDistrict = json['citizenship_issue_district'];
    nomineeName = json['nominee_name'];
    nomineeFatherName = json['nominee_father_name'];
    nomineeGrandfatherName = json['nominee_grandfather_name'];
    nomineeRelation = json['nominee_relation'];
    nomineeCitizenshipIssuedPlace = json['nominee_citizenship_issued_place'];
    nomineeCitizenshipNumber = json['nominee_citizenship_number'];
    nomineeCitizenshipIssuedDate = json['nominee_citizenship_issued_date'];
    nomineeBirthdate = json['nominee_birthdate'];
    nomineePermanentAddress = json['nominee_permanent_address'];
    nomineeCurrentAddress = json['nominee_current_address'];
    nomineePhoneNumber = json['nominee_phone_number'];
    beneficiaryName = json['beneficiary_name'];
    beneficiaryAddress = json['beneficiary_address'];
    beneficiaryContactNumber = json['beneficiary_contact_number'];
    beneficiaryRelation = json['beneficiary_relation'];
    areYouNrn = json['are_you_nrn'];
    usCitizen = json['us_citizen'];
    usResidence = json['us_residence'];
    criminalOffence = json['criminal_offence'];
    greenCard = json['green_card'];
    accountInOtherBanks = json['account_in_other_banks'];
    serviceForm = json['service_form'];
    selfImage = json['self_image'];
    selfImagePath = json['self_image_path'];
    citizenshipFront = json['citizenship_front'];
    citizenshipFrontPath = json['citizenship_front_path'];
    citizenshipBack = json['citizenship_back'];
    citizenshipBackPath = json['citizenship_back_path'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['form_status'] = formStatus;
    data['slug'] = slug;
    data['user_id'] = userId;
    data['salutation'] = salutation;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['birth_date'] = birthDate;
    data['account_branch'] = accountBranch;
    data['currency'] = currency;
    data['mobile_number'] = mobileNumber;
    data['email'] = email;
    data['country'] = country;
    data['temp_house_number'] = tempHouseNumber;
    data['temp_province_id'] = tempProvinceId;
    data['temp_district_id'] = tempDistrictId;
    data['temp_municipality_id'] = tempMunicipalityId;
    data['temp_ward_id'] = tempWardId;
    data['temp_location'] = tempLocation;
    data['perm_house_number'] = permHouseNumber;
    data['perm_province_id'] = permProvinceId;
    data['perm_district_id'] = permDistrictId;
    data['perm_municipality_id'] = permMunicipalityId;
    data['perm_ward_id'] = permWardId;
    data['perm_location'] = permLocation;
    data['work_status'] = workStatus;
    data['account_purpose'] = accountPurpose;
    data['source_of_income'] = sourceOfIncome;
    data['annual_income'] = annualIncome;
    data['occupation'] = occupation;
    data['pan_number'] = panNumber;
    data['organization_name'] = organizationName;
    data['designation'] = designation;
    data['organization_address'] = organizationAddress;
    data['organization_number'] = organizationNumber;
    data['father_full_name'] = fatherFullName;
    data['mother_full_name'] = motherFullName;
    data['grandfather_full_name'] = grandfatherFullName;
    data['grandmother_full_name'] = grandmotherFullName;
    data['husband_wife_full_name'] = husbandWifeFullName;
    data['marital_status'] = maritalStatus;
    data['max_amount_per_tansaction'] = maxAmountPerTansaction;
    data['number_of_monthly_transaction'] = numberOfMonthlyTransaction;
    data['monthly_amount_of_transaction'] = monthlyAmountOfTransaction;
    data['number_of_yearly_transaction'] = numberOfYearlyTransaction;
    data['yearly_amount_of_transaction'] = yearlyAmountOfTransaction;
    data['education'] = education;
    data['identification_type'] = identificationType;
    data['identification_no'] = identificationNo;
    data['citizenship_date'] = citizenshipDate;
    data['citizenship_issue_district'] = citizenshipIssueDistrict;
    data['nominee_name'] = nomineeName;
    data['nominee_father_name'] = nomineeFatherName;
    data['nominee_grandfather_name'] = nomineeGrandfatherName;
    data['nominee_relation'] = nomineeRelation;
    data['nominee_citizenship_issued_place'] = nomineeCitizenshipIssuedPlace;
    data['nominee_citizenship_number'] = nomineeCitizenshipNumber;
    data['nominee_citizenship_issued_date'] = nomineeCitizenshipIssuedDate;
    data['nominee_birthdate'] = nomineeBirthdate;
    data['nominee_permanent_address'] = nomineePermanentAddress;
    data['nominee_current_address'] = nomineeCurrentAddress;
    data['nominee_phone_number'] = nomineePhoneNumber;
    data['beneficiary_name'] = beneficiaryName;
    data['beneficiary_address'] = beneficiaryAddress;
    data['beneficiary_contact_number'] = beneficiaryContactNumber;
    data['beneficiary_relation'] = beneficiaryRelation;
    data['are_you_nrn'] = areYouNrn;
    data['us_citizen'] = usCitizen;
    data['us_residence'] = usResidence;
    data['criminal_offence'] = criminalOffence;
    data['green_card'] = greenCard;
    data['account_in_other_banks'] = accountInOtherBanks;
    data['service_form'] = serviceForm;
    data['self_image'] = selfImage;
    data['self_image_path'] = selfImagePath;
    data['citizenship_front'] = citizenshipFront;
    data['citizenship_front_path'] = citizenshipFrontPath;
    data['citizenship_back'] = citizenshipBack;
    data['citizenship_back_path'] = citizenshipBackPath;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
