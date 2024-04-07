import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAppointmentsInDoctorSide.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  final GetAppointmentsInDoctorSide appointments;
  const DoctorAppointmentDetailsScreen({Key? key, required this.appointments})
      : super(key: key);

  @override
  State<DoctorAppointmentDetailsScreen> createState() =>
      _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState
    extends State<DoctorAppointmentDetailsScreen> {
  final TextEditingController examinationController = TextEditingController();
  final TextEditingController historyController = TextEditingController();
  final TextEditingController progressController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();

  File? myFile;
  DateTime selectedDate = NepaliDateTime.now();
  String? followUpDate;
  bool _isLoading = false;

  submitBtn() async {
    setState(() {
      _isLoading = true;
    });
    int statusCode;
    List<int> filesBytes = myFile!.readAsBytesSync();
    String base64File = "data:image/pdf;base64,${base64Encode(filesBytes)}";

    statusCode = await API().postData(
        context,
        UploadReportByDoctorModel(
          examination: examinationController.text,
          followUpDate: followUpDate.toString(),
          history: historyController.text,
          image: base64File,
          treatment: treatmentController.text,
          progress: progressController.text,
        ),
        'admin/booking-review/completed/${widget.appointments.id}');

    if (statusCode == 200) {
      mySnackbar.mySnackBar(context, 'Success: $statusCode', Colors.green);
      setState(() {
        _isLoading = false;
      });
    } else {
      mySnackbar.mySnackBar(context, 'Error: $statusCode', Colors.red);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: myColor.colorScheme.background,
        appBar: myCustomAppBar(
          title: 'Submit Report',
          color: myColor.colorScheme.background,
          borderRadius: 12.0,
        ),
        body: Container(
          height: maxHeight(context),
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox24(),
                Text(
                  'Follow Up',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                _myDatePicker(context, followUpDate, followUpDate,
                    Colors.white.withOpacity(0.4), onValueChanged: (value) {
                  setState(() {
                    followUpDate = value;
                  });
                }),
                const SizedBox16(),
                Text(
                  'Upload Reports',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                myFilePicker(
                  textValue: 'Upload files',
                  color: Colors.white.withOpacity(0.4),
                  onValueChanged: (value) {
                    myFile = value.file;
                  },
                ),
                const SizedBox16(),
                Text(
                  'History',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                _myTextArea(historyController,
                    'e.g: I experienced headache and fever for 2 days'),
                const SizedBox16(),
                Text(
                  'Examination',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                _myTextArea(examinationController,
                    'Enter any additional health information'),
                const SizedBox16(),
                Text(
                  'Treatment',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                _myTextArea(treatmentController,
                    'Enter any additional health information'),
                const SizedBox16(),
                Text(
                  'Progress',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                _myTextArea(progressController,
                    'Enter any additional health information'),
                const SizedBox8(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: myColor.dialogBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: _isLoading
              ? SizedBox(
                  height: 50.0,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: myColor.primaryColor,
                        backgroundColor: myColor.primaryColorDark),
                  ),
                )
              : SizedBox(
                  height: 50.0,
                  child: myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Submit',
                    kStyleNormal.copyWith(fontSize: 16.0, color: Colors.white),
                    () {
                      submitBtn();
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _myTextArea(myController, myHintText) {
    return SizedBox(
      width: maxWidth(context),
      child: TextField(
        controller: myController,
        maxLines: 4,
        style: kStyleNormal.copyWith(fontSize: 12.0),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: myColor.colorScheme.background, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          hintText: myHintText,
          hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
        ),
      ),
    );
  }

  Widget _myDatePicker(
      BuildContext context, dateValue, textValue, Color bgColor,
      {required ValueChanged<String>? onValueChanged}) {
    String? finalDate = dateValue;

    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: (String value) {
        onValueChanged!(value);
      },
      style: kStyleNormal.copyWith(
        fontSize: 12.0,
      ),
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
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
              firstDate: NepaliDateTime(2000),
              lastDate: NepaliDateTime(2090),
              initialDatePickerMode: DatePickerMode.day,
            );
            if (picked != null && picked != selectedDate) {
              String pickedDate = picked.toString().split(' ')[0];

              onChanged:
              (String value) {
                onValueChanged!(value);
              };
              onValueChanged:
              setState(() {
                finalDate = pickedDate.toString();
                print(finalDate);
                onValueChanged!(finalDate.toString());
              });
            }
          },
          child: Icon(
            Icons.date_range,
            size: 16.0,
            color: myColor.primaryColorDark,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: finalDate ?? 'Select Date',
        hintStyle: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
      onSaved: (v) {
        textValue = v;
      },
    );
  }
}
