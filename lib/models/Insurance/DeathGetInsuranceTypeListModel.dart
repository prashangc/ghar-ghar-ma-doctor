class DeathGetInsuranceTypeListModel {
  List<Members>? members;
  List<InsuranceTypes>? insuranceTypes;

  DeathGetInsuranceTypeListModel({this.members, this.insuranceTypes});

  DeathGetInsuranceTypeListModel.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    if (json['insurance_types'] != null) {
      insuranceTypes = <InsuranceTypes>[];
      json['insurance_types'].forEach((v) {
        insuranceTypes!.add(InsuranceTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    if (insuranceTypes != null) {
      data['insurance_types'] = insuranceTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  int? id;
  int? memberId;
  String? gdId;
  String? gender;
  String? address;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? dob;
  String? bloodGroup;
  String? country;
  String? weight;
  String? height;
  String? slug;
  String? memberType;
  String? createdAt;
  String? updatedAt;
  Userr? user;

  Members(
      {this.id,
      this.memberId,
      this.gdId,
      this.gender,
      this.address,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.dob,
      this.bloodGroup,
      this.country,
      this.weight,
      this.height,
      this.slug,
      this.memberType,
      this.createdAt,
      this.updatedAt,
      this.user});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    gdId = json['gd_id'];
    gender = json['gender'];
    address = json['address'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    dob = json['dob'];
    bloodGroup = json['blood_group'];
    country = json['country'];
    weight = json['weight'];
    height = json['height'];
    slug = json['slug'];
    memberType = json['member_type'];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? Userr.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['gd_id'] = gdId;
    data['gender'] = gender;
    data['address'] = address;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['dob'] = dob;
    data['blood_group'] = bloodGroup;
    data['country'] = country;
    data['weight'] = weight;
    data['height'] = height;
    data['slug'] = slug;
    data['member_type'] = memberType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Userr {
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

  Userr(
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

  Userr.fromJson(Map<String, dynamic> json) {
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

class InsuranceTypes {
  int? id;
  int? packageId;
  int? insuranceTypeId;
  String? amount;
  String? createdAt;
  String? updatedAt;
  Insurancetypee? insurancetype;

  InsuranceTypes(
      {this.id,
      this.packageId,
      this.insuranceTypeId,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.insurancetype});

  InsuranceTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    insuranceTypeId = json['insurance_type_id'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    insurancetype = json['insurancetype'] != null
        ? Insurancetypee.fromJson(json['insurancetype'])
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

class Insurancetypee {
  int? id;
  String? type;
  String? description;
  String? requiredPapers;
  int? isDeathInsurance;
  String? createdAt;
  String? updatedAt;

  Insurancetypee(
      {this.id,
      this.type,
      this.description,
      this.requiredPapers,
      this.isDeathInsurance,
      this.createdAt,
      this.updatedAt});

  Insurancetypee.fromJson(Map<String, dynamic> json) {
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
