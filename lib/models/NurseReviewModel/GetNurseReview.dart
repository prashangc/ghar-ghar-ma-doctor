class GetNurseReview {
  int? id;
  int? userId;
  int? nurseId;
  int? rating;
  String? comment;
  int? status;
  String? createdAt;
  String? updatedAt;
  Member? member;

  GetNurseReview(
      {this.id,
      this.userId,
      this.nurseId,
      this.rating,
      this.comment,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.member});

  GetNurseReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    nurseId = json['nurse_id'];
    rating = json['rating'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['nurse_id'] = nurseId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['status'] = status;
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
  String? familyName;
  String? bp;
  String? bpUpdatedDate;
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
      this.familyName,
      this.bp,
      this.bpUpdatedDate,
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
    familyName = json['family_name'];
    bp = json['bp'];
    bpUpdatedDate = json['bp_updated_date'];
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
    data['family_name'] = familyName;
    data['bp'] = bp;
    data['bp_updated_date'] = bpUpdatedDate;
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
  int? kycId;
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  String? subrole;
  String? referralLink;

  User(
      {this.id,
      this.kycId,
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
    kycId = json['kyc_id'];
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
    data['kyc_id'] = kycId;
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
