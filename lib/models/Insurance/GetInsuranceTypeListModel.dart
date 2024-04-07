class GetInsuranceTypeListModel {
  int? id;
  String? companyName;
  String? address;
  String? phone;
  String? slug;
  String? createdAt;
  String? updatedAt;
  MyInsurance? insurance;
  List<Coverage>? coverage;

  GetInsuranceTypeListModel(
      {this.id,
      this.companyName,
      this.address,
      this.phone,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.insurance,
      this.coverage});

  GetInsuranceTypeListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    address = json['address'];
    phone = json['phone'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    insurance = json['insurance'] != null
        ? MyInsurance.fromJson(json['insurance'])
        : null;
    if (json['coverage'] != null) {
      coverage = <Coverage>[];
      json['coverage'].forEach((v) {
        coverage!.add(Coverage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['address'] = address;
    data['phone'] = phone;
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (insurance != null) {
      data['insurance'] = insurance!.toJson();
    }
    if (coverage != null) {
      data['coverage'] = coverage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyInsurance {
  int? id;
  int? userId;
  int? userpackageId;
  int? status;
  String? createdAt;
  String? updatedAt;
  MyUserpackage? userpackage;

  MyInsurance(
      {this.id,
      this.userId,
      this.userpackageId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.userpackage});

  MyInsurance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userpackageId = json['userpackage_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userpackage = json['userpackage'] != null
        ? MyUserpackage.fromJson(json['userpackage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['userpackage_id'] = userpackageId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (userpackage != null) {
      data['userpackage'] = userpackage!.toJson();
    }
    return data;
  }
}

class MyUserpackage {
  int? id;
  String? slug;
  int? familynameId;
  int? memberId;
  int? packageId;
  int? familyId;
  int? status;
  String? packageStatus;
  int? renewStatus;
  String? bookedDate;
  String? expiryDate;
  int? gracePeriod;
  int? year;
  String? activatedDate;
  int? additonalMembers;
  String? createdAt;
  String? updatedAt;

  MyUserpackage(
      {this.id,
      this.slug,
      this.familynameId,
      this.memberId,
      this.packageId,
      this.familyId,
      this.status,
      this.packageStatus,
      this.renewStatus,
      this.bookedDate,
      this.expiryDate,
      this.gracePeriod,
      this.year,
      this.activatedDate,
      this.additonalMembers,
      this.createdAt,
      this.updatedAt});

  MyUserpackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    familynameId = json['familyname_id'];
    memberId = json['member_id'];
    packageId = json['package_id'];
    familyId = json['family_id'];
    status = json['status'];
    packageStatus = json['package_status'];
    renewStatus = json['renew_status'];
    bookedDate = json['booked_date'];
    expiryDate = json['expiry_date'];
    gracePeriod = json['grace_period'];
    year = json['year'];
    activatedDate = json['activated_date'];
    additonalMembers = json['additonal_members'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['familyname_id'] = familynameId;
    data['member_id'] = memberId;
    data['package_id'] = packageId;
    data['family_id'] = familyId;
    data['status'] = status;
    data['package_status'] = packageStatus;
    data['renew_status'] = renewStatus;
    data['booked_date'] = bookedDate;
    data['expiry_date'] = expiryDate;
    data['grace_period'] = gracePeriod;
    data['year'] = year;
    data['activated_date'] = activatedDate;
    data['additonal_members'] = additonalMembers;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Coverage {
  int? id;
  int? packageId;
  int? insuranceTypeId;
  String? amount;
  String? createdAt;
  String? updatedAt;
  Insurancetype? insurancetype;

  Coverage(
      {this.id,
      this.packageId,
      this.insuranceTypeId,
      this.amount,
      this.createdAt,
      this.updatedAt,
      this.insurancetype});

  Coverage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    insuranceTypeId = json['insurance_type_id'];
    amount = json['amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    insurancetype = json['insurancetype'] != null
        ? Insurancetype.fromJson(json['insurancetype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['insurance_type_id'] = insuranceTypeId;
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (insurancetype != null) {
      data['insurancetype'] = insurancetype!.toJson();
    }
    return data;
  }
}

class Insurancetype {
  int? id;
  String? type;
  String? description;
  String? requiredPapers;
  int? isDeathInsurance;
  String? createdAt;
  String? updatedAt;

  Insurancetype(
      {this.id,
      this.type,
      this.description,
      this.requiredPapers,
      this.isDeathInsurance,
      this.createdAt,
      this.updatedAt});

  Insurancetype.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
    requiredPapers = json['required_papers'];
    isDeathInsurance = json['is_death_insurance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['description'] = description;
    data['required_papers'] = requiredPapers;
    data['is_death_insurance'] = isDeathInsurance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
