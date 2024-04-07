class PostPhoneQrModel {
  int? id;
  String? phone;

  PostPhoneQrModel({this.id, this.phone});

  PostPhoneQrModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    return data;
  }
}
