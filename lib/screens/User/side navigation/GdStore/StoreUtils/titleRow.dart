import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget titleCard(leading, trailing, myTap) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox12(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leading,
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            GestureDetector(
              onTap: () {
                myTap();
              },
              child: Text(
                trailing,
                style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: myColor.primaryColorDark),
              ),
            ),
          ],
        ),
        const SizedBox12(),
      ],
    ),
  );
}
