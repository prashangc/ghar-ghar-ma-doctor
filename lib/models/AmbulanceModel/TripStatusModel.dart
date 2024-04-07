class TripStatusModel {
  UserDetails? userDetails;

  TripStatusModel({this.userDetails});

  TripStatusModel.fromJson(Map<String, dynamic> json) {
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
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
  DriverProfile? driverProfile;

  UserDetails(
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
      this.driverProfile});

  UserDetails.fromJson(Map<String, dynamic> json) {
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
    driverProfile = json['driver_profile'] != null
        ? DriverProfile.fromJson(json['driver_profile'])
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
    if (driverProfile != null) {
      data['driver_profile'] = driverProfile!.toJson();
    }
    return data;
  }
}

class DriverProfile {
  int? id;
  String? slug;
  int? driverId;
  String? address;
  String? salary;
  String? status;
  String? activeStatus;
  String? latitude;
  String? longitude;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  Driver? driver;

  DriverProfile(
      {this.id,
      this.slug,
      this.driverId,
      this.address,
      this.salary,
      this.status,
      this.activeStatus,
      this.latitude,
      this.longitude,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.createdAt,
      this.updatedAt,
      this.driver});

  DriverProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    driverId = json['driver_id'];
    address = json['address'];
    salary = json['salary'];
    status = json['status'];
    activeStatus = json['activeStatus'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['driver_id'] = driverId;
    data['address'] = address;
    data['salary'] = salary;
    data['status'] = status;
    data['activeStatus'] = activeStatus;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    return data;
  }
}

class Driver {
  int? id;
  int? globalFormId;
  String? name;
  String? phone;
  // Null? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  // Null? subrole;
  String? referralLink;

  Driver(
      {this.id,
      this.globalFormId,
      this.name,
      this.phone,
      // this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.referrerId,
      this.createdAt,
      this.updatedAt,
      // this.subrole,
      this.referralLink});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    globalFormId = json['global_form_id'];
    name = json['name'];
    phone = json['phone'];
    // role = json['role'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    referrerId = json['referrer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // subrole = json['subrole'];
    referralLink = json['referral_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['global_form_id'] = globalFormId;
    data['name'] = name;
    data['phone'] = phone;
    // data['role'] = this.role;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['referrer_id'] = referrerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    // data['subrole'] = this.subrole;
    data['referral_link'] = referralLink;
    return data;
  }
}
