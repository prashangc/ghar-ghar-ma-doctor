import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';

Widget myDropDown2(
    BuildContext context,
    icon,
    Color iconColor,
    Color titleTextColor,
    width,
    hintText,
    List<GetIDNameModel> listItemData,
    Color bgColor,
    {required ValueChanged<GetIDNameModel>? onValueChanged}) {
  String? selectedValue;
  // if (hintText != null) {
  //   selectedValue = hintText;
  // }

  return DropdownButtonHideUnderline(
    child: DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: SizedBox(
          width: maxWidth(context),
          child: Row(
            children: [
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
                        Expanded(
                          child: Text(
                            item.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (dynamic value) {
          selectedValue = value.name;
          onValueChanged!(value);
        },

        icon: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black),
        ),
        dropdownOverButton: true,
        iconSize: 20,
        iconEnabledColor: myColor.primaryColorDark,
        iconDisabledColor: Colors.black,
        buttonHeight: 50,
        buttonWidth: width,
        buttonPadding: const EdgeInsets.only(left: 16),
        buttonElevation: 0,
        dropdownElevation: 0,
        // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          color: bgColor,
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
  );
}

Widget myDropDown2WithoutIcon(BuildContext context, hintText,
    List<GetIDNameModel> listItemData, Color bgColor,
    {required ValueChanged<GetIDNameModel>? onValueChanged}) {
  String? selectedValue;

  return DropdownButtonHideUnderline(
    child: DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Text(
          hintText,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
        ),
        items: listItemData
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.name.toString(),
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (dynamic value) {
          onValueChanged!(value);
        },
        icon: const Padding(
          padding: EdgeInsets.only(right: 14.0),
          child: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black),
        ),
        dropdownOverButton: true,
        iconSize: 20,
        iconEnabledColor: myColor.primaryColorDark,
        iconDisabledColor: Colors.black,
        buttonHeight: 50,
        buttonElevation: 0,
        dropdownElevation: 0,
        // buttonPadding: const EdgeInsets.only(left: 16),
        buttonDecoration: BoxDecoration(
          color: bgColor,
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
  );
}
