class DepartmentModel {
  int? id;
  String? department;
  String? image;
  String? imagePath;

  DepartmentModel({
    this.id,
    this.department,
    this.image,
    this.imagePath,
  });

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    image = json['image'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['department'] = department;
    data['image'] = image;
    data['image_path'] = imagePath;
    return data;
  }
}
