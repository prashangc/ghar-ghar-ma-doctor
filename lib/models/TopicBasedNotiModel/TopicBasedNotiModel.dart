class TopicBasedNotiModel {
  String? deviceKey;

  TopicBasedNotiModel({this.deviceKey});

  TopicBasedNotiModel.fromJson(Map<String, dynamic> json) {
    deviceKey = json['device_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device_key'] = deviceKey;
    return data;
  }
}
