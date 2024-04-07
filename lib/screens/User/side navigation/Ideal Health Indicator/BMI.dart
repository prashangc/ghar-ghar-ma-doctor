import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/constants/graph.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  String? _gender;
  int weight = 60;
  int age = 22;
  int? heightInFt, heightInch;
  double? totalHeight, bmi;
  Timer? _timer;

  calculateBMI() {
    double heightSqaure = totalHeight! * totalHeight!;
    setState(() {
      bmi = weight / heightSqaure;
    });
  }

  saveBMI() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: bmi == null ? 'BMI Calculator' : 'BMI Details',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          height: maxHeight(context),
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              bmi == null
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox12(),
                            myGender(
                                context,
                                kStyleNormal.copyWith(
                                    color: kBlack, fontWeight: FontWeight.bold),
                                kWhite.withOpacity(0.4),
                                _gender, onValueChanged: (v) {
                              _gender = v;
                            }),
                            const SizedBox16(),
                            myHeightCard(
                              context,
                              onValueChanged: (v) {
                                totalHeight = v;
                              },
                            ),
                            Row(
                              children: [
                                myAgePicker('Weight ( in kg )', weight),
                                const SizedBox(width: 12.0),
                                myAgePicker('Age', age),
                              ],
                            ),
                            const SizedBox16(),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox12(),
                            Text(
                              '$bmi kg/m²',
                              style: kStyleTitle2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: myColor.primaryColorDark,
                              ),
                            ),
                            const SizedBox8(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.trending_up,
                                  size: 15.0,
                                  color: Color(0xFFEB5757),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  '10% Higher than Last Month',
                                  style: kStyleNormal.copyWith(
                                    color: kBlack,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox16(),
                            Text(
                              'BMI Graph',
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox12(),
                            myGraph(context),
                          ],
                        ),
                      ),
                    ),
              Column(
                children: [
                  bmi == null
                      ? SizedBox(
                          width: maxWidth(context),
                          height: 50.0,
                          child: myCustomButton(
                            context,
                            myColor.primaryColorDark,
                            'Calculate',
                            kStyleNormal.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                            ),
                            () {
                              calculateBMI();
                            },
                          ),
                        )
                      : SizedBox(
                          width: maxWidth(context),
                          height: 50.0,
                          child: myCustomButton(
                            context,
                            myColor.primaryColorDark,
                            'Save Results',
                            kStyleNormal.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                            ),
                            () {
                              saveBMI();
                            },
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myAgePicker(title, value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kStyleNormal.copyWith(
                color: kBlack, fontWeight: FontWeight.bold),
          ),
          const SizedBox16(),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
            width: maxWidth(context),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox12(),
                Text(
                  value.toString(),
                  style: kStyleTitle.copyWith(
                    fontWeight: FontWeight.bold,
                    // fontSize: 18.0,
                    color: myColor.primaryColorDark,
                  ),
                ),
                const SizedBox12(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    myCircleContainer(Icons.remove, title),
                    myCircleContainer(Icons.add, title),
                  ],
                ),
                const SizedBox12(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myCircleContainer(icon, type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (type == 'Age') {
            if (icon == Icons.add) {
              age = age + 1;
            } else {
              age = age - 1;
            }
          } else {
            if (icon == Icons.add) {
              weight = weight + 1;
            } else {
              weight = weight - 1;
            }
          }
        });
      },
      onTapDown: (TapDownDetails details) {
        _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
          setState(() {
            if (type == 'Age') {
              if (icon == Icons.add) {
                age = age + 1;
              } else {
                age = age - 1;
              }
            } else {
              if (icon == Icons.add) {
                weight = weight + 1;
              } else {
                weight = weight - 1;
              }
            }
          });
        });
      },
      onTapUp: (TapUpDetails details) {
        _timer!.cancel();
      },
      onTapCancel: () {
        _timer!.cancel();
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kTransparent,
            border: Border.all(color: myColor.primaryColorDark)),
        child: Icon(
          icon,
          size: 14.0,
          color: myColor.primaryColorDark,
        ),
      ),
    );
  }
}
