class GetProvinceModel {
  int? id;
  String? nepaliName;
  String? englishName;
  String? createdAt;
  String? updatedAt;

  GetProvinceModel(
      {this.id,
      this.nepaliName,
      this.englishName,
      this.createdAt,
      this.updatedAt});

  GetProvinceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nepaliName = json['nepali_name'];
    englishName = json['english_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nepali_name'] = nepaliName;
    data['english_name'] = englishName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
