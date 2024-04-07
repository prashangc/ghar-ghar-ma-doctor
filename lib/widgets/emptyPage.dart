import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget emptyPage(context, title, subTitle, btnText, myTap,
    {testColor, dynamicHeight}) {
  double myHeight = dynamicHeight != null
      ? ((maxHeight(context) / 2.4) + 100)
      : maxHeight(context);

  return SizedBox(
    width: maxWidth(context),
    height: myHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: maxHeight(context) / 2.4,
          child: Image.asset(
            'assets/empty_basket.png',
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const SizedBox12(),
              Text(
                title,
                style: kStyleNormal.copyWith(
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox8(),
              Text(
                subTitle,
                style: kStyleNormal.copyWith(
                  color: testColor ?? kWhite,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox16(),
              btnText == ''
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        myTap();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                              color: myColor.primaryColorDark, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 18.0),
                        width: maxWidth(context) / 3,
                        height: 45,
                        child: Center(
                          child: Text(
                            btnText,
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
      ],
    ),
  );
}
