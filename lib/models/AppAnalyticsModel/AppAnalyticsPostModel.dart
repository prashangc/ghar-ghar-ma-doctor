class AppAnalyticsPostModel {
  String? fcmToken;
  String? platform;

  AppAnalyticsPostModel({this.fcmToken, this.platform});

  AppAnalyticsPostModel.fromJson(Map<String, dynamic> json) {
    fcmToken = json['fcm_token'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fcm_token'] = fcmToken;
    data['platform'] = platform;
    return data;
  }
}
