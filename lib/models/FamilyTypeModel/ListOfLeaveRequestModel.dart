class ListOfLeaveRequestModel {
  int? id;
  int? memberId;
  int? familyId;
  String? leaveReason;
  int? status;
  String? rejectReason;
  String? createdAt;
  String? updatedAt;
  Member? member;

  ListOfLeaveRequestModel(
      {this.id,
      this.memberId,
      this.familyId,
      this.leaveReason,
      this.status,
      this.rejectReason,
      this.createdAt,
      this.updatedAt,
      this.member});

  ListOfLeaveRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    familyId = json['family_id'];
    leaveReason = json['leave_reason'];
    status = json['status'];
    rejectReason = json['reject_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['family_id'] = familyId;
    data['leave_reason'] = leaveReason;
    data['status'] = status;
    data['reject_reason'] = rejectReason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    return data;
  }
}

class Member {
  int? id;
  int? memberId;
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
  int? stepsCount;
  String? createdAt;
  String? updatedAt;
  User? user;

  Member(
      {this.id,
      this.memberId,
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
      this.user});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
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
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  int? globalFormId;
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  Subrole? subrole;
  String? referralLink;

  User(
      {this.id,
      this.globalFormId,
      this.name,
      this.phone,
      this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.createdAt,
      this.updatedAt,
      this.subrole,
      this.referralLink});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subrole = json['subrole'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['name'] = name;
    data['phone'] = phone;
    data['role'] = role;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['subrole'] = subrole;
    data['referral_link'] = referralLink;
    return data;
  }
}

class Subrole {
  int? id;
  String? roleType;
  String? createdAt;
  String? updatedAt;

  Subrole({this.id, this.roleType, this.createdAt, this.updatedAt});

  Subrole.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleType = json['role_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_type'] = roleType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
