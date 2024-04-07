import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget customSwitch(value, finalIcon, {ValueChanged<bool>? onValueChanged}) {
  return StatefulBuilder(builder: (context, s) {
    return GestureDetector(
      onTap: () {
        s(() {
          value = !value;
        });
        onValueChanged!(value);
      },
      child: Container(
        width: 45.0,
        height: 18.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: value ? myColor.primaryColorDark : kWhite.withOpacity(0.4),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 25.0 : 0.0,
              top: -3,
              child: CircleAvatar(
                radius: 12.0,
                backgroundColor: kWhite,
                child: Icon(
                  value ? finalIcon : FontAwesomeIcons.user,
                  size: 12.0,
                  color: myColor.primaryColorDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
