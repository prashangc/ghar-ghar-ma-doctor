import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget noAnyNotificationCard() {
  return Column(
    children: [
      const SizedBox16(),
      Image.asset(
        'assets/empty_basket.png',
      ),
      const SizedBox32(),
      Text(
        'No any notification',
        style: kStyleNormal.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: myColor.primaryColorDark,
        ),
      ),
    ],
  );
}
