class AllHospitalModel {
  int? id;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  String? email;
  String? phone;
  String? image;
  String? imagePath;

  AllHospitalModel(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.email,
      this.phone,
      this.image,
      this.imagePath});

  AllHospitalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['image_path'] = this.imagePath;
    return data;
  }
}
