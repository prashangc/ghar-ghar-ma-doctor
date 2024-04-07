class GetSymptomsModel {
  int? id;
  String? name;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  GetSymptomsModel(
      {this.id,
      this.name,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  GetSymptomsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
