class GetListOfUserRequestModel {
  DriverDetails? driverDetails;
  Fcm? fcm;

  GetListOfUserRequestModel({this.driverDetails, this.fcm});

  GetListOfUserRequestModel.fromJson(Map<String, dynamic> json) {
    driverDetails = json['driver_details'] != null
        ? DriverDetails.fromJson(json['driver_details'])
        : null;
    fcm = json['fcm'] != null ? Fcm.fromJson(json['fcm']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (driverDetails != null) {
      data['driver_details'] = driverDetails!.toJson();
    }
    if (fcm != null) {
      data['fcm'] = fcm!.toJson();
    }
    return data;
  }
}

class DriverDetails {
  int? id;
  int? userId;
  int? driverId;
  String? title;
  String? body;
  String? pickUpLongitude;
  String? pickUpLatitude;
  String? status;
  String? createdAt;
  String? updatedAt;
  UserProfile? userProfile;

  DriverDetails(
      {this.id,
      this.userId,
      this.driverId,
      this.title,
      this.body,
      this.pickUpLongitude,
      this.pickUpLatitude,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userProfile});

  DriverDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    driverId = json['driver_id'];
    title = json['title'];
    body = json['body'];
    pickUpLongitude = json['pick_up_longitude'];
    pickUpLatitude = json['pick_up_latitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userProfile = json['user_profile'] != null
        ? UserProfile.fromJson(json['user_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['driver_id'] = driverId;
    data['title'] = title;
    data['body'] = body;
    data['pick_up_longitude'] = pickUpLongitude;
    data['pick_up_latitude'] = pickUpLatitude;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userProfile != null) {
      data['user_profile'] = userProfile!.toJson();
    }
    return data;
  }
}

class UserProfile {
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
  String? stepsCount;
  String? createdAt;
  String? updatedAt;
  User? user;

  UserProfile(
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

  UserProfile.fromJson(Map<String, dynamic> json) {
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

class Fcm {
  int? id;
  String? userId;
  String? deviceKey;
  String? createdAt;
  String? updatedAt;

  Fcm({this.id, this.userId, this.deviceKey, this.createdAt, this.updatedAt});

  Fcm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceKey = json['device_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['device_key'] = deviceKey;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
