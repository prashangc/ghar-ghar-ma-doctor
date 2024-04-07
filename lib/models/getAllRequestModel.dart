class GetAllRequestModel {
  int? id;
  int? userId;
  int? familyId;
  int? rejected;
  String? createdAt;
  String? updatedAt;
  User1? user1;
  User1? user2;

  GetAllRequestModel(
      {this.id,
      this.userId,
      this.familyId,
      this.rejected,
      this.createdAt,
      this.updatedAt,
      this.user1,
      this.user2});

  GetAllRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    familyId = json['family_id'];
    rejected = json['rejected'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user1 = json['user_1'] != null ? User1.fromJson(json['user_1']) : null;
    user2 = json['user_2'] != null ? User1.fromJson(json['user_2']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['family_id'] = familyId;
    data['rejected'] = rejected;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user1 != null) {
      data['user_1'] = user1!.toJson();
    }
    if (user2 != null) {
      data['user_2'] = user2!.toJson();
    }
    return data;
  }
}

class User1 {
  int? id;
  String? name;
  String? phone;
  int? role;
  int? isVerified;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User1(
      {this.id,
      this.name,
      this.phone,
      this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  User1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    isVerified = json['is_verified'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
