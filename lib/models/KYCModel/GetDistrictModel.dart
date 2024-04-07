class GetDistrictModel {
  int? id;
  int? provinceId;
  String? nepaliName;
  String? englishName;
  String? createdAt;
  String? updatedAt;

  GetDistrictModel(
      {this.id,
      this.provinceId,
      this.nepaliName,
      this.englishName,
      this.createdAt,
      this.updatedAt});

  GetDistrictModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provinceId = json['province_id'];
    nepaliName = json['nepali_name'];
    englishName = json['english_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['province_id'] = provinceId;
    data['nepali_name'] = nepaliName;
    data['english_name'] = englishName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
