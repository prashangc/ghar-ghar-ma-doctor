import 'package:flutter/material.dart';

class UserTypeModel {
  int? id;
  String? roleId;
  String? name;
  Widget? image;

  UserTypeModel({
    required this.id,
    required this.name,
    required this.roleId,
    required this.image,
  });
}

List<UserTypeModel> userTypeList = [
  UserTypeModel(
    id: 1,
    name: 'Doctor',
    roleId: '4',
    image: Image.asset(
      'assets/doctor.png',
      fit: BoxFit.contain,
    ),
  ),
  UserTypeModel(
    id: 2,
    name: 'Nurse',
    roleId: '7',
    image: Image.asset(
      'assets/logo.png',
      fit: BoxFit.contain,
    ),
  ),
  UserTypeModel(
    id: 3,
    name: 'Vendor',
    roleId: '5',
    image: Image.asset(
      'assets/logo.png',
      fit: BoxFit.contain,
    ),
  ),
  UserTypeModel(
    id: 4,
    name: 'Driver',
    roleId: '9',
    image: Image.asset(
      'assets/ambulanceIcon.png',
      fit: BoxFit.contain,
    ),
  ),
  UserTypeModel(
    id: 4,
    name: 'RO',
    roleId: '8',
    image: Image.asset(
      'assets/logo.png',
      fit: BoxFit.contain,
    ),
  ),
];
