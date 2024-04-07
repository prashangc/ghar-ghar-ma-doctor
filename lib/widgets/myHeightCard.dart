import 'package:flutter/cupertino.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget myHeightCard(
  context, {
  ValueChanged<double>? onValueChanged,
  ValueChanged<String>? onValueChangedFt,
  ValueChanged<String>? onValueChangedIn,
  initialFeet,
  initialInch,
  readOnly,
}) {
  int heightInFt =
      listOfHeightsFt.indexOf(initialFeet ?? listOfHeightsFt[0]) + 1;
  int heightInch = listOfHeightsIn.indexOf(initialInch ?? listOfHeightsIn[0]);
  double? totalHeight;
  void heightFeetToMeter() {
    double heightFeetIntoMeter = double.parse(heightInFt.toString()) * 0.3048;
    double heightInchIntoMeter = double.parse(heightInch.toString()) * 0.0254;
    totalHeight = heightFeetIntoMeter + heightInchIntoMeter;
    onValueChanged!(totalHeight!);
    onValueChangedFt!(heightInFt.toString());
    onValueChangedIn!(heightInch.toString());
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Height',
        style:
            kStyleNormal.copyWith(color: kBlack, fontWeight: FontWeight.bold),
      ),
      const SizedBox16(),
      Row(children: [
        myCupertinoPicker(
          context,
          listOfHeightsFt,
          onValueChanged: (v) {
            heightInFt = v + 1;
            heightFeetToMeter();
          },
          initialFeet: initialFeet,
          type: 'feet',
          readOnly: readOnly,
        ),
        const SizedBox(width: 12.0),
        myCupertinoPicker(
          context,
          listOfHeightsIn,
          onValueChanged: (v) {
            heightInch = v;
            heightFeetToMeter();
          },
          initialInch: initialInch,
          type: 'inch',
          readOnly: readOnly,
        ),
      ]),
      const SizedBox16()
    ],
  );
}

Widget myCupertinoPicker(
  context,
  List<String> list, {
  ValueChanged<int>? onValueChanged,
  initialFeet,
  initialInch,
  type,
  readOnly,
}) {
  int startingFeetIndex = 0;
  if (type == 'feet') {
    if (initialFeet != null) {
      startingFeetIndex = list.indexOf(initialFeet);
    }
  } else if (type == 'inch') {
    if (initialInch != null) {
      startingFeetIndex = list.indexOf(initialInch);
    }
  }
  FixedExtentScrollController scrollableController =
      FixedExtentScrollController(
    initialItem: startingFeetIndex,
  );
  FixedExtentScrollController unScrollableController =
      FixedExtentScrollController(
    initialItem: startingFeetIndex,
  );
  return Expanded(
    child: SizedBox(
      height: 150.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CupertinoPicker(
          scrollController:
              readOnly == false ? scrollableController : unScrollableController
                ..addListener(() {
                  unScrollableController.jumpToItem(startingFeetIndex);
                }),
          backgroundColor: kWhite.withOpacity(0.4),
          itemExtent: 64,
          looping: true,
          selectionOverlay: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1.0, color: myColor.dialogBackgroundColor),
                bottom: BorderSide(
                    width: 1.0, color: myColor.dialogBackgroundColor),
              ),
            ),
          ),
          onSelectedItemChanged: (v) {
            onValueChanged!(v);
          },
          children: list
              .map(
                (e) => Center(
                    child: Text(
                  list == listOfHeightsIn ? '$e  In.' : '$e  Ft.',
                  style: kStyleNormal.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: myColor.primaryColorDark,
                  ),
                )),
              )
              .toList(),
        ),
      ),
    ),
  );
}
