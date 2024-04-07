import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/constants/colors.dart';
import 'package:ghargharmadoctor/constants/dateValidator.dart';
import 'package:ghargharmadoctor/constants/textStyle.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

Widget widgetDatePicker(BuildContext context, style, dateValue, textValue,
    initialIcon, Color bgColor,
    {required ValueChanged<MyDate>? onValueChanged,
    disableDateType,
    mergeTimePicker,
    language}) {
  String? finalDate = dateValue;

  DateTime selectedDate = NepaliDateTime.now();

  return StatefulBuilder(builder: (context, setState) {
    return TextFormField(
      inputFormatters: const [
        // DateInputFormatter(),
      ],
      onChanged: (dynamic value) {
        // onValueChanged!(value);
      },
      style: kStyleNormal.copyWith(
        fontSize: 12.0,
      ),
      readOnly: true,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        filled: true,
        fillColor: bgColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: bgColor, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
        prefixIcon: initialIcon == null
            ? null
            : Icon(
                initialIcon,
                size: 16.0,
                color: Colors.black,
              ),
        suffixIcon: GestureDetector(
          onTap: () async {
            if (language != null) {
              DateTime? picked = await showDatePicker(
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
                          foregroundColor:
                              myColor.primaryColorDark, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
                context: context,
                cancelText: 'Back',
                confirmText: 'Confirm',
                initialDate: DateTime.now(),
                firstDate: DateTime(1800),
                lastDate: disableDateType == 'future'
                    ? DateTime.now()
                    : DateTime(1990),
                initialDatePickerMode: DatePickerMode.day,
              );

              if (picked != null && picked != selectedDate) {
                setState(() {
                  String pickedEngDate = picked.toString().split(' ')[0];
                  String pickedNepaliDate =
                      picked.toNepaliDateTime().toString().split(' ')[0];
                  onValueChanged:
                  onValueChanged!(MyDate(
                      nepaliDate: pickedNepaliDate,
                      englishDate: pickedEngDate));
                });
              }
            } else {
              NepaliDateTime? picked = await picker.showMaterialDatePicker(
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
                          foregroundColor:
                              myColor.primaryColorDark, // button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
                context: context,
                cancelText: 'Back',
                confirmText: 'Confirm',
                initialDate: NepaliDateTime.now(),
                firstDate: NepaliDateTime(1969),
                lastDate: disableDateType == 'future'
                    ? NepaliDateTime.now()
                    : NepaliDateTime(2090),
                initialDatePickerMode: DatePickerMode.day,
              );
              if (picked != null && picked != selectedDate) {
                if (mergeTimePicker != null) {
                  final time = await showTimePicker(
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
                  if (time != null) {
                    setState(() {
                      // DateTime parsedTime = DateFormat.jm()
                      //     .parse(time.format(context).toString());
                      // String formattedTime =
                      //     DateFormat('HH:mm:ss').format(parsedTime);
                      String pickedNepaliDate = picked.toString().split(' ')[0];
                      String pickedDate =
                          picked.toDateTime().toString().split(' ')[0];
                      onValueChanged:
                      onValueChanged!(MyDate(
                          nepaliDate:
                              '$pickedNepaliDate ${time.format(context)}',
                          englishDate: '$pickedDate ${time.format(context)}'));
                    });
                  }
                } else {
                  setState(() {
                    String pickedNepaliDate = picked.toString().split(' ')[0];
                    String pickedDate =
                        picked.toDateTime().toString().split(' ')[0];
                    onValueChanged:
                    onValueChanged!(MyDate(
                        nepaliDate: pickedNepaliDate, englishDate: pickedDate));
                  });
                }
              }
            }
          },
          child: Icon(
            Icons.date_range,
            color: myColor.primaryColorDark,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: finalDate,
        hintStyle: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
      validator: (v) {
        if (finalDate!.isEmpty) {
          return 'Select Date';
        }
        return null;
      },
      onSaved: (v) {
        textValue = v;
      },
    );
  });
}

Widget widgetDatePickerWithoutPrefixIcon(
    BuildContext context, style, dateValue, Color bgColor, iconSize,
    {required ValueChanged<MyDate>? onValueChanged, disableDateType}) {
  String? finalDate = dateValue;

  DateTime selectedDate = NepaliDateTime.now();

  return StatefulBuilder(builder: (context, setState) {
    return TextFormField(
      inputFormatters: [
        MyDateInputFormatter(),
        LengthLimitingTextInputFormatter(10),
        FilteringTextInputFormatter.singleLineFormatter,
        // DateInputFormatter(),
      ],
      onChanged: (dynamic value) {
        onValueChanged!(value);
      },
      style: kStyleNormal.copyWith(
        fontSize: 12.0,
      ),
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        filled: true,
        fillColor: bgColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: bgColor, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
        suffixIcon: GestureDetector(
          onTap: () async {
            NepaliDateTime? picked = await picker.showMaterialDatePicker(
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary:
                          myColor.primaryColorDark, // header background color
                      onPrimary: Colors.white, // header text color
                      onSurface: Colors.black, // body text color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            myColor.primaryColorDark, // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
              context: context,
              initialDate: NepaliDateTime.now(),
              firstDate: NepaliDateTime(1969),
              lastDate: disableDateType != null && disableDateType == 'future'
                  ? NepaliDateTime.now()
                  : NepaliDateTime(2090),
              initialDatePickerMode: DatePickerMode.day,
            );
            if (picked != null && picked != selectedDate) {
              String pickedNepaliDate = picked.toString().split(' ')[0];
              String pickedDate = picked.toDateTime().toString().split(' ')[0];
              // String year = pickedNepaliDate.substring(0, 4);
              // print(year);
              // String month = pickedNepaliDate.substring(5, 7);
              // print(month);
              // String day = pickedNepaliDate.substring(8, 10);
              // print(day);
              var formatter = DateFormat('yyyy-MM-dd');
              String todaysDate = formatter.format(selectedDate);
              print(todaysDate);
              onChanged:
              (dynamic value) {
                onValueChanged!(value);
              };
              onValueChanged:
              setState(() {
                // finalDate = pickedDate.toString();
                onValueChanged!(MyDate(
                    nepaliDate: pickedNepaliDate, englishDate: pickedDate));
              });
            }
          },
          child: Icon(
            Icons.date_range,
            size: iconSize,
            color: myColor.primaryColorDark,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: finalDate ?? 'YYYY-MM-DD',
        hintStyle: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
      validator: (v) {
        if (finalDate == null && v!.isEmpty) {
          return 'Select Date';
        }
        return null;
      },
    );
  });
}
