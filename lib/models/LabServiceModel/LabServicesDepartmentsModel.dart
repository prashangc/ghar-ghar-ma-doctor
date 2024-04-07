class LabServicesDepartmentsModel {
  int? id;
  String? department;
  String? createdAt;
  String? updatedAt;

  LabServicesDepartmentsModel(
      {this.id, this.department, this.createdAt, this.updatedAt});

  LabServicesDepartmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['department'] = department;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
