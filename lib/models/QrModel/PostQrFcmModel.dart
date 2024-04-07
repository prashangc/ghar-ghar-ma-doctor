class PostQrFcmModel {
  String? fcm;

  PostQrFcmModel({this.fcm});

  PostQrFcmModel.fromJson(Map<String, dynamic> json) {
    fcm = json['fcm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fcm'] = fcm;
    return data;
  }
}
