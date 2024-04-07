import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget myTimePicker(
    BuildContext context, timeValue, hintText, Color bgColor, validator,
    {required ValueChanged<String>? onValueChanged}) {
  String? finalDate = timeValue;

  DateTime selectedDate = DateTime.now();

  return StatefulBuilder(builder: (context, setState) {
    return TextFormField(
      style: kStyleNormal.copyWith(
        fontSize: 12.0,
      ),
      onChanged: (String value) {
        onValueChanged!(value);
      },
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: myColor.primaryColorDark,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: myColor.primaryColorDark,
                  ),
                ),
              ),
              child: child!,
            );
          },
          initialTime: TimeOfDay.now(),
          context: context,
        );

        if (pickedTime != null) {
          try {
            String formattedTime = pickedTime.format(context);

            onChanged:
            (String value) {
              onValueChanged!(value);
            };
            setState(() {
              finalDate = formattedTime;
              onValueChanged!(finalDate.toString());
            });
          } catch (e) {
            if (kDebugMode) {
              print("error selecting time => $e");
            }
          }
        } else {
          if (kDebugMode) {
            print("Time is not selected");
          }
        }
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        filled: true,
        fillColor: Colors.white.withOpacity(0.4),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.4), width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(
            color: const Color.fromRGBO(244, 67, 54, 1), fontSize: 12.0),
        suffixIcon: Icon(
          FontAwesomeIcons.clock,
          size: 14,
          color: myColor.primaryColorDark,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: finalDate ?? hintText,
        hintStyle: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
      validator: (v) {
        if (finalDate == null) {
          return validator;
        }
        return null;
      },
    );
  });
}
