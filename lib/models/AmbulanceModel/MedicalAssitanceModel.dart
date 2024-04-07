class MedicalAssitanceModel {
  int? id;
  String? title;
  int? price;
  String? createdAt;
  String? updatedAt;

  MedicalAssitanceModel(
      {this.id, this.title, this.price, this.createdAt, this.updatedAt});

  MedicalAssitanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
