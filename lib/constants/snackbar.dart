import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class MySnackBar {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBar(
      BuildContext context, textValue, color,
      {duration}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: duration != null
          ? Duration(days: duration)
          : const Duration(seconds: 2),
      content: duration != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  textValue,
                  style: kStyleNormal.copyWith(color: kWhite),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  textValue,
                  style: kStyleNormal.copyWith(
                      color: myColor.scaffoldBackgroundColor),
                ),
              ],
            ),
      backgroundColor: color,
    ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      mySnackBarCustomized(BuildContext context, initialText, finalText,
          Function myTap, bgColor) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(days: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            initialText,
            style: kStyleNormal.copyWith(color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                myTap();
              },
              child: Text(
                finalText,
                style:
                    kStyleNormal.copyWith(color: myColor.dialogBackgroundColor),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
    ));
  }
}

final mySnackbar = MySnackBar();
