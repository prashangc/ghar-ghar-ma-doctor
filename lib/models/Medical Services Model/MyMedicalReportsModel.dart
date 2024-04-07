class MyMedicalReportsModel {
  int? id;
  String? slug;
  String? serviceName;
  String? description;
  String? price;
  String? image;
  String? imagePath;
  String? testResultType;
  String? createdAt;
  String? updatedAt;

  MyMedicalReportsModel(
      {this.id,
      this.slug,
      this.serviceName,
      this.description,
      this.price,
      this.image,
      this.imagePath,
      this.testResultType,
      this.createdAt,
      this.updatedAt});

  MyMedicalReportsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    serviceName = json['service_name'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    imagePath = json['image_path'];
    testResultType = json['test_result_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['service_name'] = serviceName;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['test_result_type'] = testResultType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
