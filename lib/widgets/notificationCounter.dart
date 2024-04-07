import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget myIconStack(
  icon,
  size,
  color,
  bloc,
) {
  int notificationCount =
      sharedPrefs.getIntFromDevice("notificationCount") ?? 0;
  return StreamBuilder<dynamic>(
      initialData: notificationCount,
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        return Stack(
          children: [
            Icon(icon, color: color, size: size),
            snapshot.data == 0
                ? Positioned(top: 5.0, right: 2.0, child: Container())
                : Positioned(
                    top: 2.0,
                    right: 0.0,
                    child: notificationCounter(snapshot.data),
                  ),
          ],
        );
      });
}

Widget notificationCounter(value) {
  return CircleAvatar(
      radius: 6.0,
      backgroundColor: kRed,
      child: Text(
        value.toString(),
        style: kStyleNormal.copyWith(
          fontSize: 8.0,
          color: kWhite,
        ),
      ));
}
