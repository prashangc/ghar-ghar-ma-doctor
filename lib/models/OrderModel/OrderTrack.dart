import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderTrackingModel {
  final int id;
  final String title;
  final String status;
  final IconData iconData;

  OrderTrackingModel({
    required this.id,
    required this.title,
    required this.status,
    required this.iconData,
  });
}

List<OrderTrackingModel> orderTrackingList = [
  OrderTrackingModel(
    id: 1,
    title: 'Pending',
    status: 'pending',
    iconData: FontAwesomeIcons.clockRotateLeft,
  ),
  OrderTrackingModel(
    id: 2,
    status: 'confirmed',
    title: 'Verified',
    iconData: FontAwesomeIcons.checkToSlot,
  ),
  OrderTrackingModel(
    id: 3,
    status: 'processing',
    title: 'Processing',
    iconData: FontAwesomeIcons.truckRampBox,
  ),
  OrderTrackingModel(
    status: 'on_the_way',
    id: 4,
    title: 'On the Way',
    iconData: FontAwesomeIcons.personBiking,
  ),
  OrderTrackingModel(
    status: 'delivered',
    id: 5,
    title: 'Delivered',
    iconData: FontAwesomeIcons.peopleCarryBox,
  ),
];
