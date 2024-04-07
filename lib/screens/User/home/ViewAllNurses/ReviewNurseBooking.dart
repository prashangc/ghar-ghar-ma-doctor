import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/AlNurseModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/NurseAppointmentList/NurseAppointmentList.dart';
import 'package:ghargharmadoctor/widgets/SucessScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ReviewNurseBooking extends StatefulWidget {
  final AllNurseModel allNurseModel;
  final String yourProblem;
  final String dateValue;
  final String shiftValue;
  final String totalAmount;
  final int selectedTimeShiftID;

  const ReviewNurseBooking({
    Key? key,
    required this.allNurseModel,
    required this.dateValue,
    required this.selectedTimeShiftID,
    required this.yourProblem,
    required this.shiftValue,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<ReviewNurseBooking> createState() => _ReviewNurseBookingState();
}

class _ReviewNurseBookingState extends State<ReviewNurseBooking> {
  String? _weight, _height, selectedPaymentMethod;
  int selectedIndexs = 0;
  bool isSwitched = false;
  File? myFile;
  bool _isLoading = false;
  final bool _isChecked = false;
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  PostNurseBookingReview? postNurseBookingReview;
  void btnPost(context) async {
    if (isSwitched == true) {
      setState(() {
        _isLoading = true;
      });
      int statusCode;
      String? userID = sharedPrefs.getUserID('userID');
      statusCode = await API().postData(
          context,
          PostNurseBookingReview(
            status: 0,
            messages: widget.yourProblem,
            nurseshiftId: widget.selectedTimeShiftID,
          ),
          endpoints.postNurseBookingEndpoint);

      if (statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);
        goThere(
            context,
            SucessScreen(
              btnText: 'View Appointment',
              screen: const NurseAppointmentList(),
              subTitle: 'Tap View Appointment Button to find more details.',
              title: 'Appointment Booked',
              model: widget.allNurseModel,
            ));
      } else {
        mySnackbar.mySnackBar(context, 'Error: $statusCode', Colors.red);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      postNurseBookingReview = PostNurseBookingReview(
        status: 0,
        messages: widget.yourProblem,
        nurseshiftId: widget.selectedTimeShiftID,
      );

      switch (selectedPaymentMethod) {
        case 'esewa':
          // myEsewa(context, widget.totalAmount.toString());
          break;

        case 'khalti':
          myKhalti(
            context,
            widget.totalAmount,
            'isNurseBooking',
            postNurseBookingReview,
            detailsModel: widget.allNurseModel,
          );
          break;

        case 'fonePay':
          // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
          break;

        case 'imePay':
          // myKhalti(context, widget.totalAmount, 'isNurseBooking');
          break;

        case 'connectIPS':
          // goThere(context, const EsewaTestScreen());
          break;

        case 'prabhuPay':
          // myKhalti(context, widget.totalAmount, 'isNurseBooking');
          break;

        default:
      }
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
          title: 'Booking Reviews',
          color: myColor.colorScheme.background,
          borderRadius: 12.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nurseInformationCard(),
                // _patientInformationCard(),
                isSwitched == true
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(top: 12.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox8(),
                            Text(
                              'Select Payment Method',
                              style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark),
                            ),
                            const SizedBox16(),

                            // _patientInformationCard(),
                            paymentMethod(context, false, true,
                                onValueChanged: (String value) {
                              selectedPaymentMethod = value;
                            }),
                          ],
                        ),
                      ),
                const SizedBox12(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(14.0, 2.0, 2.0, 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pay Later',
                        style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: myColor.primaryColorDark),
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) async {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeTrackColor:
                            myColor.primaryColorDark.withOpacity(0.3),
                        activeColor: myColor.primaryColorDark,
                        inactiveTrackColor: Colors.grey[200],
                      ),
                    ],
                  ),
                ),
                const SizedBox12(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          height: 55,
          child: _isLoading
              ? myCircularIndicator()
              : SizedBox(
                  width: maxWidth(context) * 0.4,
                  child: myButton(
                      context, myColor.primaryColorDark, 'Book Appointment',
                      () {
                    btnPost(context);
                  })),
        ),
      ),
    );
  }

  Widget _nurseInformationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      width: maxWidth(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nurse\'s Information',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox12(),
          Row(
            children: [
              myCachedNetworkImageCircle(
                90.0,
                90.0,
                widget.allNurseModel.imagePath.toString(),
                BoxFit.contain,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.allNurseModel.address.toString().capitalize()} ${widget.allNurseModel.user!.name.toString().capitalize()}',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox2(),
                    Text(
                      widget.allNurseModel.fee.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            'Appointment Date & Type',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox12(),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: maxWidth(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: myColor.colorScheme.background.withOpacity(0.4),
            ),
            child: Column(
              children: [
                _appointmentDataTimeRowWidget(
                  Icons.timer,
                  'Appointment Date: ${widget.dateValue.toString()}',
                ),
                const SizedBox8(),
                _appointmentDataTimeRowWidget(
                  Icons.timer,
                  'Appointment Time:  ${widget.shiftValue.toString()}',
                ),
                const SizedBox8(),
                _appointmentDataTimeRowWidget(
                  Icons.timer,
                  'Consultation Type:  Video',
                ),
              ],
            ),
          ),
          const SizedBox8(),
        ],
      ),
    );
  }

  Widget _patientInformationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      width: maxWidth(context),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient\'s Information',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox8(),
          Text(
            'Who is the patient?',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
            ),
          ),
          // Row(
          //   children: [
          //     myCheckBox(context, _isChecked, 'Myself',
          //         onValueChanged: (bool? newValue) {
          //       setState(() {
          //         _isChecked = newValue!;
          //       });
          //     }),
          //     myCheckBox(context, _isChecked, 'Someone else',
          //         onValueChanged: (bool? newValue) {
          //       setState(() {
          //         _isChecked = newValue!;
          //       });
          //     }),
          //   ],
          // ),
          Text(
            'Symptoms (optional)',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          const SizedBox8(),
          _myTextArea(_symptomsController,
              'e.g: I experienced headache and fever for 2 days'),
          const SizedBox8(),
          Text(
            'Your Query (optional)',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          const SizedBox8(),
          _myTextArea(
              _queryController, 'Enter any additional health information'),
          const SizedBox8(),
          Text(
            'Your old reports (If any)',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          const SizedBox12(),
          myFilePicker(
            textValue: 'Upload files',
            color: Colors.white,
            onValueChanged: (value) {
              myFile = value.file;
            },
          ),
          const SizedBox8(),
          Text(
            'File size should not exceed 10MB',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myTextArea(myController, myHintText) {
    return SizedBox(
      width: maxWidth(context),
      child: TextField(
        controller: myController,
        maxLines: 4,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          filled: true,
          fillColor: Colors.white,
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
          hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _appointmentDataTimeRowWidget(icon, text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 14.0,
          color: myColor.primaryColorDark,
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
