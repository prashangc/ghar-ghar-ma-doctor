class ForceUpdateModel {
  int? id;
  String? version;
  String? updatedDate;
  int? status;
  String? createdAt;
  String? updatedAt;

  ForceUpdateModel(
      {this.id,
      this.version,
      this.updatedDate,
      this.status,
      this.createdAt,
      this.updatedAt});

  ForceUpdateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    version = json['version'];
    updatedDate = json['updated_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['version'] = version;
    data['updated_date'] = updatedDate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
