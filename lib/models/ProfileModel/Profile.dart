class ProfileModel {
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
  String? familyname;
  String? createdAt;
  String? updatedAt;
  String? heightFeet;
  String? heightInch;
  Member? member;
  SchoolProfile? schoolProfile;

  ProfileModel({
    this.id,
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
    this.heightFeet,
    this.heightInch,
    this.slug,
    this.memberType,
    this.bp,
    this.bpUpdatedDate,
    this.heartRate,
    this.stepsCount,
    this.familyname,
    this.createdAt,
    this.updatedAt,
    this.member,
    this.schoolProfile,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
    heightFeet = json['height_feet'];
    heightInch = json['height_inch'];
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
    familyname = json['familyname'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    schoolProfile = json['school_profile'] != null
        ? SchoolProfile.fromJson(json['school_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['gd_id'] = gdId;
    data['gender'] = gender;
    data['address'] = address;
    data['image'] = image;
    data['height_feet'] = heightFeet;
    data['height_inch'] = heightInch;
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
    data['familyname'] = familyname;
    data['updated_at'] = updatedAt;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (schoolProfile != null) {
      data['school_profile'] = schoolProfile!.toJson();
    }
    return data;
  }
}

class Member {
  int? id;
  int? globalFormId;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  int? role;
  int? isVerified;
  int? phoneVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  int? subrole;
  String? referralLink;
  List<Roles>? roles;

  Member(
      {this.id,
      this.globalFormId,
      this.name,
      this.firstName,
      this.lastName,
      this.middleName,
      this.phone,
      this.role,
      this.isVerified,
      this.phoneVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.createdAt,
      this.updatedAt,
      this.subrole,
      this.referralLink,
      this.roles});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    name = json['name'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    role = json['role'];
    isVerified = json['is_verified'];
    phoneVerified = json['phone_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subrole = json['subrole'];
    referralLink = json['referral_link'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['name'] = name;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['role'] = role;
    data['is_verified'] = isVerified;
    data['phone_verified'] = phoneVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['subrole'] = subrole;
    data['referral_link'] = referralLink;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? roleType;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles({this.id, this.roleType, this.createdAt, this.updatedAt, this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleType = json['role_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_type'] = roleType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? roleId;

  Pivot({this.userId, this.roleId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['role_id'] = roleId;
    return data;
  }
}

class SchoolProfile {
  int? id;
  int? memberId;
  String? ownerName;
  String? companyName;
  String? companyAddress;
  String? companyStartDate;
  String? description;
  String? panNumber;
  String? contactNumber;
  String? companyImage;
  String? companyImagePath;
  String? paperWorkPdf;
  String? paperWorkPdfPath;
  String? types;
  String? userName;
  String? createdAt;
  String? updatedAt;
  String? status;

  SchoolProfile({
    this.id,
    this.memberId,
    this.ownerName,
    this.companyName,
    this.companyAddress,
    this.companyStartDate,
    this.description,
    this.panNumber,
    this.contactNumber,
    this.companyImage,
    this.companyImagePath,
    this.paperWorkPdf,
    this.paperWorkPdfPath,
    this.types,
    this.userName,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  SchoolProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    ownerName = json['owner_name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyStartDate = json['company_start_date'];
    description = json['description'];
    panNumber = json['pan_number'];
    contactNumber = json['contact_number'];
    companyImage = json['company_image'];
    companyImagePath = json['company_image_path'];
    paperWorkPdf = json['paper_work_pdf'];
    paperWorkPdfPath = json['paper_work_pdf_path'];
    types = json['types'];
    userName = json['user_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['owner_name'] = ownerName;
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['company_start_date'] = companyStartDate;
    data['description'] = description;
    data['pan_number'] = panNumber;
    data['contact_number'] = contactNumber;
    data['company_image'] = companyImage;
    data['company_image_path'] = companyImagePath;
    data['paper_work_pdf'] = paperWorkPdf;
    data['paper_work_pdf_path'] = paperWorkPdfPath;
    data['types'] = types;
    data['user_name'] = userName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    return data;
  }
}
