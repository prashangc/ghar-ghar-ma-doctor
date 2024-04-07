class Check2FactorModel {
  bool? isEnabled;
  bool? fcmStored;

  Check2FactorModel({this.isEnabled, this.fcmStored});

  Check2FactorModel.fromJson(Map<String, dynamic> json) {
    isEnabled = json['is_enabled'];
    fcmStored = json['fcm_stored'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_enabled'] = isEnabled;
    data['fcm_stored'] = fcmStored;
    return data;
  }
}
