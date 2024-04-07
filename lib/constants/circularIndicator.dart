import 'package:flutter/material.dart';

import 'constants_imports.dart';

Widget myCircularIndicator() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Center(
      child: CircularProgressIndicator(
          color: backgroundColor,
          backgroundColor: myColor.primaryColorDark),
    ),
  );
}

Widget myBtnLoading(context, height) {
  return SizedBox(
    width: maxWidth(context),
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: myColor.primaryColorDark,
        elevation: 0.0,
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      onPressed: () {},
      child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: myColor.primaryColor,
          backgroundColor: kWhite),
    ),
  );
}
