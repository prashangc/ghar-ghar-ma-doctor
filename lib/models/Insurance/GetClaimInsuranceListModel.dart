class GetClaimInsuranceListModel {
  int? id;
  String? companyName;
  String? address;
  String? phone;
  String? slug;
  String? createdAt;
  String? updatedAt;
  List<Claims>? claims;

  GetClaimInsuranceListModel(
      {this.id,
      this.companyName,
      this.address,
      this.phone,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.claims});

  GetClaimInsuranceListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    address = json['address'];
    phone = json['phone'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['claims'] != null) {
      claims = <Claims>[];
      json['claims'].forEach((v) {
        claims!.add(Claims.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['address'] = address;
    data['phone'] = phone;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (claims != null) {
      data['claims'] = claims!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Claims {
  int? id;
  int? userId;
  int? packageInsuranceId;
  String? slug;
  int? claimAmount;
  String? handWrittenLetter;
  String? handWrittenLetterPath;
  String? medicalReport;
  String? medicalReportPath;
  String? invoice;
  String? invoicePath;
  String? approvedDate;
  String? setelledDate;
  String? rejectedDate;
  int? claimingUserId;
  String? insuranceStatus;
  String? createdAt;
  String? updatedAt;
  int? userpackageId;
  Insuranceee? insurance;
  Userrr? user;
  Claimmm? claim;

  Claims(
      {this.id,
      this.userId,
      this.packageInsuranceId,
      this.slug,
      this.claimAmount,
      this.handWrittenLetter,
      this.handWrittenLetterPath,
      this.medicalReport,
      this.medicalReportPath,
      this.invoice,
      this.invoicePath,
      this.approvedDate,
      this.setelledDate,
      this.rejectedDate,
      this.claimingUserId,
      this.insuranceStatus,
      this.createdAt,
      this.updatedAt,
      this.userpackageId,
      this.insurance,
      this.user,
      this.claim});

  Claims.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    packageInsuranceId = json['package_insurance_id'];
    slug = json['slug'];
    claimAmount = json['claim_amount'];
    handWrittenLetter = json['hand_written_letter'];
    handWrittenLetterPath = json['hand_written_letter_path'];
    medicalReport = json['medical_report'];
    medicalReportPath = json['medical_report_path'];
    invoice = json['invoice'];
    invoicePath = json['invoice_path'];
    approvedDate = json['approved_date'];
    setelledDate = json['setelled_date'];
    rejectedDate = json['rejected_date'];
    claimingUserId = json['claiming_user_id'];
    insuranceStatus = json['insurance_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userpackageId = json['userpackage_id'];
    insurance = json['insurance'] != null
        ? Insuranceee.fromJson(json['insurance'])
        : null;
    user = json['user'] != null ? Userrr.fromJson(json['user']) : null;
    claim = json['claim'] != null ? Claimmm.fromJson(json['claim']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['package_insurance_id'] = packageInsuranceId;
    data['slug'] = slug;
    data['claim_amount'] = claimAmount;
    data['hand_written_letter'] = handWrittenLetter;
    data['hand_written_letter_path'] = handWrittenLetterPath;
    data['medical_report'] = medicalReport;
    data['medical_report_path'] = medicalReportPath;
    data['invoice'] = invoice;
    data['invoice_path'] = invoicePath;
    data['approved_date'] = approvedDate;
    data['setelled_date'] = setelledDate;
    data['rejected_date'] = rejectedDate;
    data['claiming_user_id'] = claimingUserId;
    data['insurance_status'] = insuranceStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['userpackage_id'] = userpackageId;
    if (insurance != null) {
      data['insurance'] = insurance!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (claim != null) {
      data['claim'] = claim!.toJson();
    }
    return data;
  }
}

class Insuranceee {
  int? id;
  int? packageId;
  int? insuranceTypeId;
  String? amount;
  String? createdAt;
  String? updatedAt;
  Insurancetypo? insurancetype;

  Insuranceee(
      {this.id,
      this.packageId,
      this.insuranceTypeId,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.insurancetype});

  Insuranceee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    insuranceTypeId = json['insurance_type_id'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    insurancetype = json['insurancetype'] != null
        ? Insurancetypo.fromJson(json['insurancetype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['insurance_type_id'] = insuranceTypeId;
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (insurancetype != null) {
      data['insurancetype'] = insurancetype!.toJson();
    }
    return data;
  }
}

class Insurancetypo {
  int? id;
  String? type;
  String? description;
  String? requiredPapers;
  int? isDeathInsurance;
  String? createdAt;
  String? updatedAt;

  Insurancetypo(
      {this.id,
      this.type,
      this.description,
      this.requiredPapers,
      this.isDeathInsurance,
      this.createdAt,
      this.updatedAt});

  Insurancetypo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
    requiredPapers = json['required_papers'];
    isDeathInsurance = json['is_death_insurance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['description'] = description;
    data['required_papers'] = requiredPapers;
    data['is_death_insurance'] = isDeathInsurance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Userrr {
  int? id;
  int? globalFormId;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? name;
  String? phone;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  int? isEnabled;
  int? phoneVerified;
  int? isSchool;
  String? createdAt;
  String? updatedAt;
  String? referralLink;

  Userrr(
      {this.id,
      this.globalFormId,
      this.userName,
      this.firstName,
      this.middleName,
      this.lastName,
      this.name,
      this.phone,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.isEnabled,
      this.phoneVerified,
      this.isSchool,
      this.createdAt,
      this.updatedAt,
      this.referralLink});

  Userrr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    name = json['name'];
    phone = json['phone'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    isEnabled = json['is_enabled'];
    phoneVerified = json['phone_verified'];
    isSchool = json['is_school'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['user_name'] = userName;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['phone'] = phone;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['is_enabled'] = isEnabled;
    data['phone_verified'] = phoneVerified;
    data['is_school'] = isSchool;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['referral_link'] = referralLink;
    return data;
  }
}

class Claimmm {
  int? id;
  int? globalFormId;
  String? userName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? name;
  String? phone;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  int? isEnabled;
  int? phoneVerified;
  int? isSchool;
  String? createdAt;
  String? updatedAt;
  String? referralLink;

  Claimmm(
      {this.id,
      this.globalFormId,
      this.userName,
      this.firstName,
      this.middleName,
      this.lastName,
      this.name,
      this.phone,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.isEnabled,
      this.phoneVerified,
      this.isSchool,
      this.createdAt,
      this.updatedAt,
      this.referralLink});

  Claimmm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    userName = json['user_name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    name = json['name'];
    phone = json['phone'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    isEnabled = json['is_enabled'];
    phoneVerified = json['phone_verified'];
    isSchool = json['is_school'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['user_name'] = userName;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['phone'] = phone;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['is_enabled'] = isEnabled;
    data['phone_verified'] = phoneVerified;
    data['is_school'] = isSchool;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['referral_link'] = referralLink;
    return data;
  }
}
