import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PackageDescTimelineList {
  final String title;
  final String desc;
  final IconData icon;

  PackageDescTimelineList({
    required this.title,
    required this.icon,
    required this.desc,
  });
}

List<PackageDescTimelineList> packageDescTimelineList = [
  PackageDescTimelineList(
    title: 'family',
    icon: Icons.groups_2_outlined,
    desc: 'Member per Package',
  ),
  PackageDescTimelineList(
    title: 'test',
    icon: Icons.science_outlined,
    desc: 'Tests per Visit',
  ),
  PackageDescTimelineList(
    title: 'visit',
    icon: Icons.home,
    desc: 'Number of Home Visits',
  ),
  PackageDescTimelineList(
    title: 'consultation',
    icon: Icons.video_call_outlined,
    desc: 'Online Consultation',
  ),
  PackageDescTimelineList(
    title: 'ambulance',
    icon: FontAwesomeIcons.truckMedical,
    desc: 'Amubulance Service',
  ),
  PackageDescTimelineList(
    title: 'insurance',
    icon: FontAwesomeIcons.handHoldingHeart,
    desc: 'Insurance Coverage',
  ),
];
