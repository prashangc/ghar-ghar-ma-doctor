class GetMunicipalityModel {
  int? id;
  int? districtId;
  String? nepaliName;
  String? englishName;
  String? createdAt;
  String? updatedAt;

  GetMunicipalityModel(
      {this.id,
      this.districtId,
      this.nepaliName,
      this.englishName,
      this.createdAt,
      this.updatedAt});

  GetMunicipalityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtId = json['district_id'];
    nepaliName = json['nepali_name'];
    englishName = json['english_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['district_id'] = districtId;
    data['nepali_name'] = nepaliName;
    data['english_name'] = englishName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
