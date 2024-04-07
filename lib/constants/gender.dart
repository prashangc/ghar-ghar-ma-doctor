import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/GenderModel.dart';

Widget myGender(BuildContext context, style, Color bgColor, genderValue,
    {required ValueChanged<String>? onValueChanged, readOnly}) {
  String myGender = genderValue ?? 'Test';
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 3.0,
        ),
        Text(
          'Gender',
          style: style,
        ),
        const SizedBox16(),
        SizedBox(
          width: maxWidth(context),
          height: 100.0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: genders.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (readOnly == false || readOnly == null) {
                    setState(() {
                      myGender = genders[index].genderName.toString();
                    });
                    onValueChanged:
                    onValueChanged!(myGender.toString());
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  width: 100,
                  decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                              myGender == genders[index].genderName.toString()
                                  ? myColor.primaryColorDark
                                  : bgColor)),
                  child: Column(
                    children: [
                      Container(
                        child: genders[index].genderIcon,
                      ),
                      const SizedBox8(),
                      Text(
                        genders[index].genderName.toString(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  });
}
