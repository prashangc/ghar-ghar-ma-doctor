class PackageResponseForBookingModel {
  int? memberId;
  int? packageId;
  int? familyId;
  int? renewStatus;
  String? slug;
  String? updatedAt;
  String? createdAt;
  int? id;

  PackageResponseForBookingModel(
      {this.memberId,
      this.packageId,
      this.familyId,
      this.renewStatus,
      this.slug,
      this.updatedAt,
      this.createdAt,
      this.id});

  PackageResponseForBookingModel.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    packageId = json['package_id'];
    familyId = json['family_id'];
    renewStatus = json['renew_status'];
    slug = json['slug'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['member_id'] = memberId;
    data['package_id'] = packageId;
    data['family_id'] = familyId;
    data['renew_status'] = renewStatus;
    data['slug'] = slug;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
