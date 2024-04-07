import 'package:flutter/material.dart';
import 'constants_imports.dart';

Widget myButton(
    BuildContext context, color, textValue, Function onClickMethod) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      // primary: color,
      backgroundColor: color,
      elevation: 0.0,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    onPressed: () async {
      bool connection = await checkInternetConnection();
      if (connection == true) {
        onClickMethod();
      } else {
        mySnackbar.mySnackBar(context, 'No internet connection', kRed);
      }
    },
    child: Text(
      textValue,
      style: kStyleButton,
    ),
  );
}

Widget myCustomButton(
    BuildContext context, color, textValue, textStyle, Function onClickMethod) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      elevation: 0.0,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    onPressed: () async {
      bool connection = await checkInternetConnection();
      if (connection == true) {
        onClickMethod();
      } else {
        mySnackbar.mySnackBar(context, 'No internet connection', kRed);
      }
    },
    child: Text(
      textValue,
      style: textStyle,
    ),
  );
}

Widget myWhiteButton(
    BuildContext context, color, textValue, textStyle, Function onClickMethod) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      elevation: 0.0,
      padding: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: myColor.primaryColorDark),
      ),
    ),
    onPressed: () {
      onClickMethod();
    },
    child: Text(
      textValue,
      style: textStyle,
    ),
  );
}
