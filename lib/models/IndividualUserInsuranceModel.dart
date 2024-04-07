class IndividualUserInsuranceModel {
  int? id;
  int? userId;
  int? insuranceId;
  String? slug;
  String? document;
  String? documentLink;
  String? createdAt;
  String? updatedAt;
  Insurance? insurance;
  User? user;

  IndividualUserInsuranceModel(
      {this.id,
      this.userId,
      this.insuranceId,
      this.slug,
      this.document,
      this.documentLink,
      this.createdAt,
      this.updatedAt,
      this.insurance,
      this.user});

  IndividualUserInsuranceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    insuranceId = json['insurance_id'];
    slug = json['slug'];
    document = json['document'];
    documentLink = json['document_link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    insurance = json['insurance'] != null
        ? Insurance.fromJson(json['insurance'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['insurance_id'] = insuranceId;
    data['slug'] = slug;
    data['document'] = document;
    data['document_link'] = documentLink;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (insurance != null) {
      data['insurance'] = insurance!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Insurance {
  int? id;
  String? insuranceType;
  String? companyName;
  String? description;
  String? requiredPapers;
  String? slug;
  String? createdAt;
  String? updatedAt;

  Insurance(
      {this.id,
      this.insuranceType,
      this.companyName,
      this.description,
      this.requiredPapers,
      this.slug,
      this.createdAt,
      this.updatedAt});

  Insurance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    insuranceType = json['insurance_type'];
    companyName = json['company_name'];
    description = json['description'];
    requiredPapers = json['required_papers'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['insurance_type'] = insuranceType;
    data['company_name'] = companyName;
    data['description'] = description;
    data['required_papers'] = requiredPapers;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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

  User(
      {this.id,
      this.name,
      this.phone,
      this.role,
      this.isVerified,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

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
