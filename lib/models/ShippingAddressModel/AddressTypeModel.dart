import 'package:flutter/material.dart';

class AddressTypeModel {
  final String title;
  final IconData iconData;

  AddressTypeModel({
    required this.title,
    required this.iconData,
  });
}

List<AddressTypeModel> addressTypeList = [
  AddressTypeModel(
    title: 'Home',
    iconData: Icons.home,
  ),
  AddressTypeModel(
    title: 'Office',
    iconData: Icons.local_post_office,
  ),
  AddressTypeModel(
    title: 'Others',
    iconData: Icons.add,
  ),
];
