import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConsultationTypeModel {
  IconData? icon;
  String? type;

  ConsultationTypeModel({this.icon, this.type});
}

List<ConsultationTypeModel> consultationTypeList = [
  ConsultationTypeModel(icon: FontAwesomeIcons.video, type: 'In Video'),
  ConsultationTypeModel(icon: Icons.person, type: 'In Person'),
];
