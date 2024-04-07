import 'package:flutter_svg/flutter_svg.dart';

class GenderModel {
  final int id;
  final String genderName;
  final SvgPicture genderIcon;

  GenderModel(
      {required this.id, required this.genderName, required this.genderIcon});
}

List<GenderModel> genders = [
  GenderModel(
    id: 1,
    genderName: 'Male',
    genderIcon: SvgPicture.asset(
      'assets/male.svg',
      // height: 30,
    ),
  ),
  GenderModel(
    id: 2,
    genderName: 'Female',
    genderIcon: SvgPicture.asset(
      'assets/female.svg',
      // height: 30,
    ),
  ),
  GenderModel(
    id: 3,
    genderName: 'Other',
    genderIcon: SvgPicture.asset(
      'assets/other.svg',
      // height: 30,
    ),
  ),
];
