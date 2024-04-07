import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NurseTrackStaticModel {
  final int id;
  final String title;
  final String status;
  final IconData iconData;

  NurseTrackStaticModel({
    required this.id,
    required this.title,
    required this.status,
    required this.iconData,
  });
}

List<NurseTrackStaticModel> nurseTrackingList = [
  NurseTrackStaticModel(
    id: 1,
    title: 'Scheduled',
    status: 'Scheduled',
    iconData: FontAwesomeIcons.clockRotateLeft,
  ),
  NurseTrackStaticModel(
    id: 2,
    status: 'on_the_way',
    title: 'On the Way',
    iconData: FontAwesomeIcons.personBiking,
  ),
  NurseTrackStaticModel(
    id: 3,
    status: 'waiting_for_report',
    title: 'Wating For Report',
    iconData: FontAwesomeIcons.truckRampBox,
  ),
];
