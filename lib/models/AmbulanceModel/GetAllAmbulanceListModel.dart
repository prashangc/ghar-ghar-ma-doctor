class GetAllAmbulanceListModel {
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
  String? agreementFile;
  String? agreementFilePath;
  String? createdAt;
  String? updatedAt;
  Driver? driver;

  GetAllAmbulanceListModel(
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
      this.agreementFile,
      this.agreementFilePath,
      this.createdAt,
      this.updatedAt,
      this.driver});

  GetAllAmbulanceListModel.fromJson(Map<String, dynamic> json) {
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
    agreementFile = json['agreement_file'];
    agreementFilePath = json['agreement_file_path'];
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
    data['agreement_file'] = agreementFile;
    data['agreement_file_path'] = agreementFilePath;
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
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  int? referrerId;
  String? createdAt;
  String? updatedAt;
  int? subrole;
  String? referralLink;

  Driver(
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

  Driver.fromJson(Map<String, dynamic> json) {
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
