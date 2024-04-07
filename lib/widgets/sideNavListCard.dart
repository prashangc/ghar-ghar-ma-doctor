import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget sideNavList(initialIcon, text, size, Function myTap, {showDivider}) {
  return Column(
    children: [
      GestureDetector(
        onTap: () {
          myTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(width: 10.0),
              Icon(
                initialIcon,
                size: size,
                color: kBlack,
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  text,
                  style: kStyleNormal.copyWith(color: kBlack, fontSize: 13.0),
                ),
              ),
              const SizedBox(width: 14.0),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: size,
                color: kBlack,
              ),
            ],
          ),
        ),
      ),
      showDivider == false ? Container(height: 6) : const Divider(),
    ],
  );
}
