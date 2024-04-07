class SecondaryMemberGetPrimaryMemberRequestModel {
  int? id;
  int? familyId;
  int? memberId;
  int? newmemberId;
  String? familyRelation;
  String? changeReason;
  int? status;
  String? rejectReason;
  int? deathCase;
  String? deathCertificate;
  String? deathCertificatePath;
  String? createdAt;
  String? updatedAt;
  Familyname? familyname;
  Primary? primary;
  Newprimary? newprimary;

  SecondaryMemberGetPrimaryMemberRequestModel(
      {this.id,
      this.familyId,
      this.memberId,
      this.newmemberId,
      this.familyRelation,
      this.changeReason,
      this.status,
      this.rejectReason,
      this.deathCase,
      this.deathCertificate,
      this.deathCertificatePath,
      this.createdAt,
      this.updatedAt,
      this.familyname,
      this.primary,
      this.newprimary});

  SecondaryMemberGetPrimaryMemberRequestModel.fromJson(
      Map<String, dynamic> json) {
    id = json['id'];
    familyId = json['family_id'];
    memberId = json['member_id'];
    newmemberId = json['newmember_id'];
    familyRelation = json['family_relation'];
    changeReason = json['change_reason'];
    status = json['status'];
    rejectReason = json['reject_reason'];
    deathCase = json['death_case'];
    deathCertificate = json['death_certificate'];
    deathCertificatePath = json['death_certificate_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    familyname = json['familyname'] != null
        ? Familyname.fromJson(json['familyname'])
        : null;
    primary =
        json['primary'] != null ? Primary.fromJson(json['primary']) : null;
    newprimary = json['newprimary'] != null
        ? Newprimary.fromJson(json['newprimary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['family_id'] = familyId;
    data['member_id'] = memberId;
    data['newmember_id'] = newmemberId;
    data['family_relation'] = familyRelation;
    data['change_reason'] = changeReason;
    data['status'] = status;
    data['reject_reason'] = rejectReason;
    data['death_case'] = deathCase;
    data['death_certificate'] = deathCertificate;
    data['death_certificate_path'] = deathCertificatePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (familyname != null) {
      data['familyname'] = familyname!.toJson();
    }
    if (primary != null) {
      data['primary'] = primary!.toJson();
    }
    if (newprimary != null) {
      data['newprimary'] = newprimary!.toJson();
    }
    return data;
  }
}

class Familyname {
  int? id;
  int? primaryMemberId;
  String? familyName;
  int? onlineConsultation;
  String? createdAt;
  String? updatedAt;

  Familyname(
      {this.id,
      this.primaryMemberId,
      this.familyName,
      this.onlineConsultation,
      this.createdAt,
      this.updatedAt});

  Familyname.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    primaryMemberId = json['primary_member_id'];
    familyName = json['family_name'];
    onlineConsultation = json['online_consultation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['primary_member_id'] = primaryMemberId;
    data['family_name'] = familyName;
    data['online_consultation'] = onlineConsultation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Primary {
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
  String? bp;
  String? bpUpdatedDate;
  String? heartRate;
  String? stepsCount;
  String? createdAt;
  String? updatedAt;
  String? heightFeet;
  String? heightInch;

  Primary(
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
      this.bp,
      this.bpUpdatedDate,
      this.heartRate,
      this.stepsCount,
      this.createdAt,
      this.updatedAt,
      this.heightFeet,
      this.heightInch});

  Primary.fromJson(Map<String, dynamic> json) {
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
    bp = json['bp'];
    bpUpdatedDate = json['bp_updated_date'];
    heartRate = json['heart_rate'];
    stepsCount = json['steps_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    heightFeet = json['height_feet'];
    heightInch = json['height_inch'];
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
    data['bp'] = bp;
    data['bp_updated_date'] = bpUpdatedDate;
    data['heart_rate'] = heartRate;
    data['steps_count'] = stepsCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['height_feet'] = heightFeet;
    data['height_inch'] = heightInch;
    return data;
  }
}

class Newprimary {
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
  String? bp;
  String? bpUpdatedDate;
  String? heartRate;
  String? stepsCount;
  String? createdAt;
  String? updatedAt;
  String? heightFeet;
  String? heightInch;
  WhatUser? user;

  Newprimary(
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
      this.bp,
      this.bpUpdatedDate,
      this.heartRate,
      this.stepsCount,
      this.createdAt,
      this.updatedAt,
      this.heightFeet,
      this.heightInch,
      this.user});

  Newprimary.fromJson(Map<String, dynamic> json) {
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
    bp = json['bp'];
    bpUpdatedDate = json['bp_updated_date'];
    heartRate = json['heart_rate'];
    stepsCount = json['steps_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    heightFeet = json['height_feet'];
    heightInch = json['height_inch'];
    user = json['user'] != null ? WhatUser.fromJson(json['user']) : null;
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
    data['bp'] = bp;
    data['bp_updated_date'] = bpUpdatedDate;
    data['heart_rate'] = heartRate;
    data['steps_count'] = stepsCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['height_feet'] = heightFeet;
    data['height_inch'] = heightInch;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class WhatUser {
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

  WhatUser(
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

  WhatUser.fromJson(Map<String, dynamic> json) {
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
