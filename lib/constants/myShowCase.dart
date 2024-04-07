import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:showcaseview/showcaseview.dart';

myShowCase(context, i, key, myChild) {
  // final keyOne = GlobalKey();
  // final keyTwo = GlobalKey();
  // final keyThree = GlobalKey();
  // final keyFour = GlobalKey();
  // final keyFive = GlobalKey();
  // WidgetsBinding.instance.addPostFrameCallback(
  //   (_) => ShowCaseWidget.of(context)
  //       .startShowCase([keyOne, keyTwo, keyThree, keyFour, keyFive]),
  // );

  return Showcase(
    key: key,
    targetBorderRadius: const BorderRadius.all(Radius.circular(50.0)),
    title: i == 0
        ? 'Explore GD'
        : i == 1
            ? 'View GD Store'
            : i == 2
                ? 'View our packages'
                : i == 3
                    ? 'Get Notified'
                    : 'View your details',
    titleTextStyle:
        kStyleNormal.copyWith(fontSize: 12.0, fontWeight: FontWeight.bold),
    descTextStyle: kStyleNormal.copyWith(fontSize: 12.0),
    description: i == 0
        ? 'Scroll to view our services.'
        : i == 1
            ? 'Scroll to view our products.'
            : i == 2
                ? 'Tap here to view our packages'
                : i == 3
                    ? 'Tap here to view your notification'
                    : 'Tap here to view your details',
    titleAlignment: TextAlign.center,
    descriptionAlignment: TextAlign.center,
    blurValue: 0.5,
    tooltipBackgroundColor: myColor.dialogBackgroundColor,
    child: myChild,
  );
}

class MyShowCase extends StatelessWidget {
  final GlobalKey globalKey;
  final String title;
  final String desc;
  final Widget child;
  const MyShowCase({
    super.key,
    required this.globalKey,
    required this.title,
    required this.desc,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      targetBorderRadius: const BorderRadius.all(Radius.circular(50.0)),
      title: title,
      titleTextStyle:
          kStyleNormal.copyWith(fontSize: 12.0, fontWeight: FontWeight.bold),
      descTextStyle: kStyleNormal.copyWith(fontSize: 12.0),
      description: desc,
      titleAlignment: TextAlign.center,
      descriptionAlignment: TextAlign.center,
      blurValue: 0.5,
      tooltipBackgroundColor: myColor.dialogBackgroundColor,
      child: child,
    );
  }
}
