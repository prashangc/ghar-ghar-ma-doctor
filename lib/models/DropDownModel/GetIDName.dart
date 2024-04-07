import 'dart:io';

class GetIDNameModel {
  String? id;
  String? name;
  File? file;

  GetIDNameModel({this.id, this.name, this.file});

  GetIDNameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
