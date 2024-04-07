import 'dart:io';

class MyFileModel {
  File? file;
  String? base64String;
  List<String>? listOfBase64Images;

  MyFileModel({required this.file, this.base64String, this.listOfBase64Images});
}
