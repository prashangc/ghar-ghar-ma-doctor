import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListofStaticCategoryModel {
  int? id;
  String? name;
  IconData? icon;

  ListofStaticCategoryModel({
    this.id,
    required this.name,
    required this.icon,
  });
}

List<ListofStaticCategoryModel> listofStaticCategory = [
  ListofStaticCategoryModel(
    id: 0,
    name: 'Store',
    icon: FontAwesomeIcons.shopify,
  ),
  ListofStaticCategoryModel(
    id: 1,
    name: 'Healthy\nFood',
    icon: FontAwesomeIcons.seedling,
  ),
  ListofStaticCategoryModel(
    id: 2,
    name: 'Pharmacy',
    icon: FontAwesomeIcons.syringe,
  ),
  ListofStaticCategoryModel(
    id: 3,
    name: 'Fitness\nCenter',
    icon: FontAwesomeIcons.dumbbell,
  ),
];
