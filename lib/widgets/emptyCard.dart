import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget emptyCard(
  context,
  myMethod,
) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: SizedBox(
      width: maxWidth(context),
      height: maxHeight(context) / 1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            size: 100.0,
            color: myColor.primaryColorDark,
          ),
          const SizedBox32(),
          Text(
            'You haven\'t set your schedule',
            style: kStyleNormal.copyWith(
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox8(),
          Text(
            'Add appointment timings to receive appointments.',
            style: kStyleNormal.copyWith(
              color: Colors.grey[400],
              fontSize: 12.0,
            ),
          ),
          const SizedBox16(),
          GestureDetector(
            onTap: () {
              myMethod();
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: myColor.primaryColorDark, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 18.0),
              width: maxWidth(context) / 3,
              height: 45,
              child: Center(
                child: Text(
                  'Set Time',
                  style: kStyleNormal.copyWith(
                    color: myColor.primaryColorDark,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
