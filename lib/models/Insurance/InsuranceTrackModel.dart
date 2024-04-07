import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InsuranceTrackModel {
  final int id;
  final String title;
  final List<String> status;
  final IconData iconData;

  InsuranceTrackModel({
    required this.id,
    required this.title,
    required this.status,
    required this.iconData,
  });
}

List<InsuranceTrackModel> insuranceTrackList = [
  InsuranceTrackModel(
    id: 1,
    title: 'Pending',
    status: ['Pending'],
    iconData: FontAwesomeIcons.clockRotateLeft,
  ),
  InsuranceTrackModel(
    id: 2,
    status: ['Approved'],
    title: 'Approved',
    iconData: FontAwesomeIcons.checkToSlot,
  ),
  InsuranceTrackModel(
    id: 3,
    status: [
      'Processing(Insurance Partner)',
      'Processing(Insurance Company)',
      'Processing(Claim Department)',
      'Processing(Finance Department)',
      'Processing(Forward To GD)'
    ],
    title: 'Processing',
    iconData: FontAwesomeIcons.barsProgress,
  ),
  InsuranceTrackModel(
    status: ['Claim Settelled'],
    id: 4,
    title: 'Claimed',
    iconData: FontAwesomeIcons.handHoldingHeart,
  ),
  InsuranceTrackModel(
    status: ['Rejected'],
    id: 5,
    title: 'Rejected',
    iconData: FontAwesomeIcons.ban,
  ),
];
