class PostDoctorLocationModel {
  double? longitude;
  double? latitude;

  PostDoctorLocationModel({this.longitude, this.latitude});

  PostDoctorLocationModel.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
