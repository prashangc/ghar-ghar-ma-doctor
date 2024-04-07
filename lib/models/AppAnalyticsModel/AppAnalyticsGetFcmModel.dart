class AppAnalyticsGetFcmModel {
  int? id;
  String? fcmToken;
  String? platform;
  String? createdAt;
  String? updatedAt;

  AppAnalyticsGetFcmModel(
      {this.id, this.fcmToken, this.platform, this.createdAt, this.updatedAt});

  AppAnalyticsGetFcmModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fcmToken = json['fcm_token'];
    platform = json['platform'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fcm_token'] = fcmToken;
    data['platform'] = platform;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
