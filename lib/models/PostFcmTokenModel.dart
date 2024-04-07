class PostFcmTokenModel {
  String? deviceKey;
  String? platform;

  PostFcmTokenModel({this.deviceKey, this.platform});

  PostFcmTokenModel.fromJson(Map<String, dynamic> json) {
    deviceKey = json['device_key'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_key'] = deviceKey;
    data['platform'] = deviceKey;
    return data;
  }
}
