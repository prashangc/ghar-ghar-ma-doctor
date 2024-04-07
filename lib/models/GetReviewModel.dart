class GetReviewModel {
  int? userId;
  int? productId;
  int? rating;
  String? comment;
  String? updatedAt;
  Member? member;

  GetReviewModel(
      {this.userId,
      this.productId,
      this.rating,
      this.comment,
      this.updatedAt,
      this.member});

  GetReviewModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    productId = json['product_id'];
    rating = json['rating'];
    comment = json['comment'];
    updatedAt = json['updated_at'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['rating'] = rating;
    data['comment'] = comment;
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
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? deviceKey;

  User(
      {this.id,
      this.name,
      this.phone,
      this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.deviceKey});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deviceKey = json['device_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['role'] = role;
    data['is_verified'] = isVerified;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['device_key'] = deviceKey;
    return data;
  }
}
