class AllVendorsModel {
  int? id;
  int? vendorId;
  String? storeName;
  int? vendorType;
  int? isExculsive;
  String? image;
  String? imagePath;
  String? file;
  String? filePath;
  String? address;
  int? totalRating;
  int? averageRating;
  String? followerCount;
  String? slug;
  String? createdAt;
  String? updatedAt;
  VendorUser? user;

  AllVendorsModel(
      {this.id,
      this.vendorId,
      this.storeName,
      this.vendorType,
      this.isExculsive,
      this.image,
      this.imagePath,
      this.file,
      this.filePath,
      this.address,
      this.totalRating,
      this.averageRating,
      this.followerCount,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.user});

  AllVendorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    storeName = json['store_name'];
    vendorType = json['vendor_type'];
    isExculsive = json['is_exculsive'];
    image = json['image'];
    imagePath = json['image_path'];
    file = json['file'];
    filePath = json['file_path'];
    address = json['address'];
    totalRating = json['total_rating'];
    averageRating = json['averageRating'];
    followerCount = json['follower_count'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? VendorUser.fromJson(json['user']) : null;
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
    data['address'] = address;
    data['total_rating'] = totalRating;
    data['averageRating'] = averageRating;
    data['follower_count'] = followerCount;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class VendorUser {
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

  VendorUser(
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

  VendorUser.fromJson(Map<String, dynamic> json) {
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
