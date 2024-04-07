import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class myCountryPicker extends StatefulWidget {
  final String? titleText;
  final String? initialCountry;
  final ValueChanged<String>? onValueChanged;
  const myCountryPicker(
      {Key? key,
      required this.titleText,
      this.initialCountry,
      this.onValueChanged})
      : super(key: key);

  @override
  State<myCountryPicker> createState() => _myCountryPickerState();
}

class _myCountryPickerState extends State<myCountryPicker> {
  String? countryValue;

  @override
  void initState() {
    super.initState();
    countryValue = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.titleText.toString(),
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: maxWidth(context),
              decoration: BoxDecoration(
                color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: 50,
            ),
            Positioned(
              top: 7.0,
              left: 5.0,
              child: SizedBox(
                width: maxWidth(context) - 155,
                height: 52.0,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(
                      color: Colors.black,
                      size: 21.0,
                    ),
                  ),
                  child: CSCPicker(
                    showCities: false,
                    showStates: false,
                    flagState: CountryFlag.ENABLE,
                    dropdownDecoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.transparent,
                    ),
                    countrySearchPlaceholder: "Search Country",
                    countryDropdownLabel: countryValue ?? '🇳🇵    Nepal',
                    // defaultCountry: widget.initialCountry as DefaultCountry,
                    selectedItemStyle: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                    dropdownHeadingStyle: kStyleNormal.copyWith(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    dropdownItemStyle: kStyleNormal.copyWith(
                      color: Colors.black,
                    ),
                    dropdownDialogRadius: 10.0,
                    searchBarRadius: 10.0,
                    onCountryChanged: (String value) {
                      setState(() {
                        countryValue = value;
                      });
                      widget.onValueChanged!(value);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

Widget myCountryCodePicker(
    {required hintText,
    required bgColor,
    isEditable,
    required ValueChanged<String>? onValueChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.only(left: 11.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            InternationalPhoneNumberInput(
              isEnabled: isEditable ?? true,
              textStyle: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  // color: focusNode.hasFocus ? Colors.black : Colors.grey[400]),
                  color: Colors.black),
              inputDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 16.0),
                hintText: hintText.replaceAll('+977', ''),
                hintStyle:
                    kStyleNormal.copyWith(fontSize: 12.0, color: Colors.black),
                border: InputBorder.none,
              ),

              errorMessage: 'Invalid Phone number',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Enter your phone number';
                }
                if (v.length != 10) {
                  return 'Mobile Number must be of 10 digit';
                }

                if (v.length > 10) {
                  return "Phone number is more than 10 digits";
                }
                return null;
              },
              // onSaved: (PhoneNumber number) {
              //   print('On Saved: $number');
              //   // _phone = number.toString();
              // },

              onInputChanged: (PhoneNumber number) {
                // borderColor = myColor.primaryColorDark;
                print(number.phoneNumber);
                onValueChanged!(number.phoneNumber.toString());
              },
              // onInputValidated: (bool value) {
              //   print(value);
              // },

              selectorConfig: const SelectorConfig(
                useEmoji: true,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              spaceBetweenSelectorAndTextField: 0,
              selectorTextStyle: const TextStyle(color: Colors.black),
              initialValue: PhoneNumber(
                isoCode: 'NP',
              ),
              // textFieldController: controller,
              formatInput: false,
              // countries: const ["Nepal", "India"],
              maxLength: 10,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
            ),
            Positioned(
              left: 90,
              top: 8,
              child: Container(
                height: 35,
                width: 1,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      const SizedBox16(),
    ],
  );
}
