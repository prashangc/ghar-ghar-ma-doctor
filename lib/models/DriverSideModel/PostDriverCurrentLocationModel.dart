class PostDriverCurrentLocationModel {
  double? longitude;
  double? latitude;
  String? deviceKey;

  PostDriverCurrentLocationModel(
      {this.longitude, this.latitude, this.deviceKey});

  PostDriverCurrentLocationModel.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    deviceKey = json['notification_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['notification_id'] = deviceKey;
    return data;
  }
}
