import 'package:flutter/material.dart';

class SupportSettingsModel {
  final String title;
  final IconData icon;

  SupportSettingsModel({
    required this.title,
    required this.icon,
  });
}

List<SupportSettingsModel> supportSettingsList = [
  SupportSettingsModel(
    title: 'Report Your Problem',
    icon: Icons.message_outlined,
  ),
  SupportSettingsModel(
    title: 'Watch Tutorials',
    icon: Icons.video_collection_outlined,
  ),
  SupportSettingsModel(
    title: 'Emergency Call',
    icon: Icons.call_outlined,
  ),
  SupportSettingsModel(
    title: 'Add Feedback',
    icon: Icons.feedback_outlined,
  ),
  SupportSettingsModel(
    title: 'FAQ',
    icon: Icons.format_quote_outlined,
  ),
  SupportSettingsModel(
    title: 'Give Ratings',
    icon: Icons.star_border_outlined,
  ),
];
