class GetHospitalOfIndividualDoctor {
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

  GetHospitalOfIndividualDoctor(
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

  GetHospitalOfIndividualDoctor.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['image_path'] = imagePath;
    return data;
  }
}
