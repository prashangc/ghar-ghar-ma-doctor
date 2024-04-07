import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmergencyPhoneNumberModel {
  final String number;
  final String? image;
  final IconData icon;
  final double size;
  final String title;

  EmergencyPhoneNumberModel({
    required this.number,
    this.image,
    required this.size,
    required this.icon,
    required this.title,
  });
}

List<EmergencyPhoneNumberModel> emergencyPhoneNumberList = [
  EmergencyPhoneNumberModel(
    number: '102',
    size: 12.0,
    icon: FontAwesomeIcons.truckMedical,
    title: 'Ambulance',
  ),
  EmergencyPhoneNumberModel(
    number: '100',
    icon: Icons.local_police_outlined,
    size: 16.0,
    title: 'Nepal Police',
  ),
  EmergencyPhoneNumberModel(
    number: '101',
    size: 12.0,
    icon: FontAwesomeIcons.truckDroplet,
    title: 'Fire Brigade',
  ),
  EmergencyPhoneNumberModel(
    number: '015917322',
    image: 'assets/logo.png',
    size: 12.0,
    icon: FontAwesomeIcons.truckMedical,
    title: 'GD',
  ),
];
