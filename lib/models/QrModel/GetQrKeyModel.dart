class GetQrKeyModel {
  bool? success;
  String? key;
  String? type;
  String? platform;
  String? familyType;
  int? id;

  GetQrKeyModel({this.success, this.key, this.type, this.familyType, this.id});

  GetQrKeyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    key = json['key'];
    type = json['type'];
    platform = json['platform'];
    familyType = json['familyType'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['key'] = key;
    data['type'] = type;
    data['platform'] = platform;
    data['familyType'] = familyType;
    data['id'] = id;
    return data;
  }
}
