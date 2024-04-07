import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';

Widget myDropDown2Loading(
    BuildContext context,
    titleText,
    icon,
    Color iconColor,
    Color titleTextColor,
    width,
    hintText,
    List<GetIDNameModel> listItemData,
    {required ValueChanged<GetIDNameModel>? onValueChanged}) {
  String? selectedValue;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13.0,
          color: titleTextColor,
        ),
      ),
      const SizedBox16(),
      DropdownButtonHideUnderline(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: SizedBox(
              width: maxWidth(context),
              child: Row(
                children: [
                  const SizedBox(width: 8.0),
                  Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      hintText,
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            items: listItemData
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: SizedBox(
                        width: maxWidth(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.perm_identity,
                              size: 16,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              item.name.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
            value: selectedValue,
            onChanged: (dynamic value) {
              onValueChanged!(value);
            },

            icon: Container(
              width: 15.0,
              height: 15.0,
              margin: const EdgeInsets.only(right: 10.0),
              child: CircularProgressIndicator(
                backgroundColor: myColor.primaryColorDark,
                color: myColor.dialogBackgroundColor,
                strokeWidth: 1.5,
              ),
            ),
            dropdownOverButton: true,
            iconSize: 20,
            iconEnabledColor: myColor.primaryColorDark,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,
            buttonWidth: width,
            buttonPadding: const EdgeInsets.only(left: 8),
            buttonElevation: 0,
            dropdownElevation: 0,
            // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8.0),
            ),
            itemHeight: 40,
            itemPadding: const EdgeInsets.symmetric(horizontal: 14),
            dropdownMaxHeight: 180,
            dropdownPadding: const EdgeInsets.symmetric(horizontal: 3),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 3,
            scrollbarAlwaysShow: false,
            offset: const Offset(0, 0),
          ),
        ),
      ),
    ],
  );
}
