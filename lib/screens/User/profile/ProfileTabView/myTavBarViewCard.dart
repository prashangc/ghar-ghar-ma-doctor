import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget myCard(BuildContext context, IconData myIcon, myTitle, myTap) =>
    Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      width: maxWidth(context),
      child: GestureDetector(
        onTap: () {
          myTap();
        },
        child: Row(
          children: [
            Icon(
              myIcon,
              color: myColor.primaryColorDark,
              size: 17.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                myTitle,
                style: kStyleNormal.copyWith(),
              ),
            ),
            const SizedBox(width: 10.0),
            Icon(
              Icons.keyboard_arrow_right_outlined,
              color: myColor.primaryColorDark,
            ),
          ],
        ),
      ),
    );
