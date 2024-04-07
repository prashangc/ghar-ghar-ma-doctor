class ListOfFamilyModel {
  int? id;
  int? familyId;
  int? memberId;
  String? familyRelation;
  int? approved;
  int? primaryRequest;
  String? createdAt;
  String? updatedAt;
  int? paymentStatus;
  Familyname? familyname;
  Member? member;
  List<Remove>? remove;
  List<Leave>? leave;
  ListOfFamilyModel(
      {this.id,
      this.familyId,
      this.memberId,
      this.familyRelation,
      this.approved,
      this.primaryRequest,
      this.createdAt,
      this.updatedAt,
      this.paymentStatus,
      this.familyname,
      this.member,
      this.remove,
      this.leave});

  ListOfFamilyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    familyId = json['family_id'];
    memberId = json['member_id'];
    familyRelation = json['family_relation'];
    approved = json['approved'];
    primaryRequest = json['primary_request'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentStatus = json['payment_status'];
    familyname = json['familyname'] != null
        ? Familyname.fromJson(json['familyname'])
        : null;
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    if (json['remove'] != null) {
      remove = <Remove>[];
      json['remove'].forEach((v) {
        remove!.add(Remove.fromJson(v));
      });
    }
    if (json['leave'] != null) {
      leave = <Leave>[];
      json['leave'].forEach((v) {
        leave!.add(Leave.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['family_id'] = familyId;
    data['member_id'] = memberId;
    data['family_relation'] = familyRelation;
    data['approved'] = approved;
    data['primary_request'] = primaryRequest;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payment_status'] = paymentStatus;
    if (familyname != null) {
      data['familyname'] = familyname!.toJson();
    }
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (remove != null) {
      data['remove'] = remove!.map((v) => v.toJson()).toList();
    }
    if (leave != null) {
      data['leave'] = leave!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leave {
  int? id;
  int? memberId;
  int? familyId;
  String? leaveReason;
  int? status;
  String? rejectReason;
  String? createdAt;
  String? updatedAt;

  Leave(
      {this.id,
      this.memberId,
      this.familyId,
      this.leaveReason,
      this.status,
      this.rejectReason,
      this.createdAt,
      this.updatedAt});

  Leave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    familyId = json['family_id'];
    leaveReason = json['leave_reason'];
    status = json['status'];
    rejectReason = json['reject_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}

class Familyname {
  int? id;
  int? primaryMemberId;
  String? familyName;
  String? createdAt;
  String? updatedAt;
  Primary? primary;

  Familyname(
      {this.id,
      this.primaryMemberId,
      this.familyName,
      this.createdAt,
      this.updatedAt,
      this.primary});

  Familyname.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    primaryMemberId = json['primary_member_id'];
    familyName = json['family_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    primary =
        json['primary'] != null ? Primary.fromJson(json['primary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['primary_member_id'] = primaryMemberId;
    data['family_name'] = familyName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (primary != null) {
      data['primary'] = primary!.toJson();
    }
    return data;
  }
}

class Primary {
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

  Primary(
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

  Primary.fromJson(Map<String, dynamic> json) {
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
  int? subrole;
  String? referralLink;
  List<Roles>? roles;

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

class Remove {
  int? id;
  int? memberId;
  int? familyId;
  String? removeReason;
  int? status;
  String? rejectReason;
  String? createdAt;
  String? updatedAt;

  Remove(
      {this.id,
      this.memberId,
      this.familyId,
      this.removeReason,
      this.status,
      this.rejectReason,
      this.createdAt,
      this.updatedAt});

  Remove.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    familyId = json['family_id'];
    removeReason = json['remove_reason'];
    status = json['status'];
    rejectReason = json['reject_reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['member_id'] = memberId;
    data['family_id'] = familyId;
    data['remove_reason'] = removeReason;
    data['status'] = status;
    data['reject_reason'] = rejectReason;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
