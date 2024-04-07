import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    primaryColor: const Color(0xFF57C7F7),
    primaryColorDark: const Color(0xFF0259A7),
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: const Color(0xFFC6DFF6),
    fontFamily: 'Futura',
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown)
        .copyWith(background: const Color(0xFFE9ECF4)),
  );
}

final myColor = theme();
Color backgroundColor = const Color(0xFFE9ECF4);
Color kWhite = Colors.white;
Color kTransparent = Colors.transparent;
Color kRed = Colors.red;
Color kGrey = Colors.grey;
Color kGreen = Colors.green;
Color kAmber = Colors.amber;
Color kOrange = Colors.orange;
Color kBlue = Colors.blue;
Color kBlack = Colors.black;
Color kPurple = Colors.purple;
