class NurseProfileModel {
  int? id;
  String? slug;
  int? nurseId;
  String? nncNo;
  String? gender;
  String? qualification;
  String? yearPracticed;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? agreementFile;
  String? agreementFilePath;
  String? address;
  int? fee;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  User? user;
  NurseProfileModel(
      {this.id,
      this.slug,
      this.nurseId,
      this.nncNo,
      this.gender,
      this.qualification,
      this.yearPracticed,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.agreementFile,
      this.agreementFilePath,
      this.address,
      this.fee,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.user});

  NurseProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    nurseId = json['nurse_id'];
    nncNo = json['nnc_no'];
    gender = json['gender'];
    qualification = json['qualification'];
    yearPracticed = json['year_practiced'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    agreementFile = json['agreement_file'];
    agreementFilePath = json['agreement_file_path'];
    address = json['address'];
    fee = json['fee'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['nurse_id'] = nurseId;
    data['nnc_no'] = nncNo;
    data['gender'] = gender;
    data['qualification'] = qualification;
    data['year_practiced'] = yearPracticed;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['agreement_file'] = agreementFile;
    data['agreement_file_path'] = agreementFilePath;
    data['address'] = address;
    data['fee'] = fee;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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
