class VendorProfileModel {
  int? id;
  int? vendorId;
  String? storeName;
  int? vendorType;
  int? isExculsive;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? agreementFile;
  String? agreementFilePath;
  String? address;
  int? totalRating;
  int? averageRating;
  String? followerCount;
  String? slug;
  String? tax;
  String? taxPath;
  String? ird;
  String? irdPath;
  String? createdAt;
  String? updatedAt;
  Types? types;
  UserVendor? user;

  VendorProfileModel(
      {this.id,
      this.vendorId,
      this.storeName,
      this.vendorType,
      this.isExculsive,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.agreementFile,
      this.agreementFilePath,
      this.address,
      this.totalRating,
      this.averageRating,
      this.followerCount,
      this.slug,
      this.tax,
      this.taxPath,
      this.ird,
      this.irdPath,
      this.createdAt,
      this.updatedAt,
      this.types,
      this.user});

  VendorProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    storeName = json['store_name'];
    vendorType = json['vendor_type'];
    isExculsive = json['is_exculsive'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    agreementFile = json['agreement_file'];
    agreementFilePath = json['agreement_file_path'];
    address = json['address'];
    totalRating = json['total_rating'];
    averageRating = json['averageRating'];
    followerCount = json['follower_count'];
    slug = json['slug'];
    tax = json['tax'];
    taxPath = json['tax_path'];
    ird = json['ird'];
    irdPath = json['ird_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    types = json['types'] != null ? Types.fromJson(json['types']) : null;
    user = json['user'] != null ? UserVendor.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['store_name'] = storeName;
    data['vendor_type'] = vendorType;
    data['is_exculsive'] = isExculsive;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['file'] = file;
    data['file_path'] = filePath;
    data['agreement_file'] = agreementFile;
    data['agreement_file_path'] = agreementFilePath;
    data['address'] = address;
    data['total_rating'] = totalRating;
    data['averageRating'] = averageRating;
    data['follower_count'] = followerCount;
    data['slug'] = slug;
    data['tax'] = tax;
    data['tax_path'] = taxPath;
    data['ird'] = ird;
    data['ird_path'] = irdPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (types != null) {
      data['types'] = types!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Types {
  int? id;
  String? vendorType;
  String? createdAt;
  String? updatedAt;

  Types({this.id, this.vendorType, this.createdAt, this.updatedAt});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorType = json['vendor_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_type'] = vendorType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UserVendor {
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

  UserVendor(
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

  UserVendor.fromJson(Map<String, dynamic> json) {
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
