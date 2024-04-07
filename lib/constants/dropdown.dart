import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/colors.dart';
import 'package:ghargharmadoctor/constants/sizedBoxes.dart';
import 'package:ghargharmadoctor/constants/textStyle.dart';

Widget myDropDown(BuildContext context, titleText, Color titleTextColor, width,
    hintText, List<String> listItemData,
    {required ValueChanged<String>? onValueChanged}) {
  String? value;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      titleText == null
          ? Container()
          : Text(
              titleText,
              style: kStyleNormal.copyWith(
                // fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: titleTextColor,
              ),
            ),
      titleText == null ? Container() : const SizedBox8(),
      Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: Container(
            decoration: BoxDecoration(
              color: myColor.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButton<String>(
              hint: Text(hintText,
                  style: kStyleNormal.copyWith(color: Colors.grey[400])),
              iconEnabledColor: Colors.black,
              value: value,
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              items: listItemData.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                onValueChanged!(value!);
              },
            ),
          ),
        ),
      ),
      const SizedBox8(),
    ],
  );
}

Widget myDropDownDynamic(
    BuildContext context,
    titleText,
    Color titleTextColor,
    width,
    hintText,
    List<dynamic> listItemData,
    dynamicIDValue,
    dynamicNameValue,
    {ValueChanged<String>? onValueChanged}) {
  String? value;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          color: titleTextColor,
        ),
      ),
      const SizedBox8(),
      Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: Container(
            decoration: BoxDecoration(
              color: myColor.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButton<String>(
              hint: Text(hintText,
                  style: kStyleNormal.copyWith(color: Colors.grey[400])),
              iconEnabledColor: Colors.black,
              value: value,
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              items: listItemData.map((value) {
                return DropdownMenuItem<String>(
                  value: dynamicIDValue,
                  child: Text(dynamicNameValue),
                );
              }).toList(),
              onChanged: (value) {
                onValueChanged!(value!);
                print('blood group: $value');
              },
            ),
          ),
        ),
      ),
      const SizedBox8(),
    ],
  );
}
