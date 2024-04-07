class AboutUsModel {
  int? id;
  String? name;
  String? phoneNo;
  String? address;
  String? email;
  String? website;
  String? facebook;
  String? latitude;
  String? longitude;
  String? whatWeDo;
  String? mission;
  String? goal;
  String? createdAt;
  String? updatedAt;

  AboutUsModel(
      {this.id,
      this.name,
      this.phoneNo,
      this.address,
      this.email,
      this.website,
      this.facebook,
      this.latitude,
      this.longitude,
      this.whatWeDo,
      this.mission,
      this.goal,
      this.createdAt,
      this.updatedAt});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNo = json['phone_no'];
    address = json['address'];
    email = json['email'];
    website = json['website'];
    facebook = json['facebook'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    whatWeDo = json['what_we_do'];
    mission = json['mission'];
    goal = json['goal'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_no'] = phoneNo;
    data['address'] = address;
    data['email'] = email;
    data['website'] = website;
    data['facebook'] = facebook;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['what_we_do'] = whatWeDo;
    data['mission'] = mission;
    data['goal'] = goal;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
