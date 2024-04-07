class GetWardModel {
  int? id;
  int? municipalitiesId;
  String? wardName;
  String? createdAt;
  String? updatedAt;

  GetWardModel(
      {this.id,
      this.municipalitiesId,
      this.wardName,
      this.createdAt,
      this.updatedAt});

  GetWardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    municipalitiesId = json['municipalities_id'];
    wardName = json['ward_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['municipalities_id'] = municipalitiesId;
    data['ward_name'] = wardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
