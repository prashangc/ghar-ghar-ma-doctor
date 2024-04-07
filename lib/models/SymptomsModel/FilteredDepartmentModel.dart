class FilteredDepartmentModel {
  int? id;
  String? department;
  List<String>? symptoms;
  String? image;
  String? imagePath;
  String? createdAt;
  String? updatedAt;

  FilteredDepartmentModel(
      {this.id,
      this.department,
      this.symptoms,
      this.image,
      this.imagePath,
      this.createdAt,
      this.updatedAt});

  FilteredDepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    symptoms = json['symptoms'] == null
        ? []
        : List<String>.from(json["symptoms"].map((x) => x));
    image = json['image'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department'] = department;
    data['symptoms'] = symptoms;
    data['image'] = image;
    data['image_path'] = imagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
