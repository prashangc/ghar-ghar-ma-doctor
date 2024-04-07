import 'package:flutter/material.dart';

class ChatbotModel {
  String? title;

  List<MyData>? data;
  bool? isFirst;
  bool? loading;
  bool? isSelectable;
  String? disclaimer;
  ChatbotModel(
      {this.title,
      this.isFirst,
      this.loading,
      this.data,
      this.isSelectable,
      this.disclaimer});
}

class MyData {
  int? id;
  String? service;
  String? answer;
  Function? apiFunc;
  Widget? screen;

  MyData({this.service, this.apiFunc, this.screen, this.id, this.answer});
}
