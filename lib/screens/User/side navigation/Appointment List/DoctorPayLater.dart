import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorAppointmentListModel.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class DoctorPayLater extends StatefulWidget {
  final DoctorAppointmentListModel? doctorAppointmentListModel;
  const DoctorPayLater({Key? key, required this.doctorAppointmentListModel})
      : super(key: key);

  @override
  State<DoctorPayLater> createState() => _DoctorPayLaterState();
}

class _DoctorPayLaterState extends State<DoctorPayLater> {
  String? engDate, nepDate, time;
  int? fee;
  String payment = 'esewa';
  DateTime selectedDate = DateTime.now();
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fee = widget.doctorAppointmentListModel!.doctorProfile!.fee;
  }

  payBtn() {
    switch (payment) {
      case 'esewa':
        // myEsewa(context, fee.toString());
        break;

      case 'khalti':
        myKhalti(
            context,
            widget.doctorAppointmentListModel!.doctorProfile!.fee,
            'isDoctorBookingPaymentOnly',
            widget.doctorAppointmentListModel!.doctorProfile!.id);
        break;

      case 'fonepay':
        // myKhalti(context, fee.toString(), 'isDoctorBooking');
        break;

      case 'ime':
        // myKhalti(context, fee.toString(), 'isDoctorBooking');
        break;

      case 'connectIPS':
        // myKhalti(context, fee.toString(), 'isDoctorBooking');
        break;

      case 'prabhu':
        // myKhalti(context, fee.toString(), 'isDoctorBooking');
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Payment',
          color: backgroundColor,
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
                  'Payment Method',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                paymentMethod(context, false, true, onValueChanged: (v) {
                  payment = v;
                })
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: myColor.dialogBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          width: maxWidth(context),
          height: 85.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox8(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Price',
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Rs  ',
                              style: kStyleNormal.copyWith(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.doctorAppointmentListModel!
                                      .doctorProfile!.fee
                                      .toString(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _isLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: myColor.dialogBackgroundColor,
                                  backgroundColor: myColor.primaryColorDark),
                            ),
                          )
                        : SizedBox(
                            height: 50.0,
                            child: myCustomButton(
                              context,
                              myColor.primaryColorDark,
                              'Pay  Now',
                              kStyleNormal.copyWith(
                                  fontSize: 14.0, color: Colors.white),
                              () {
                                payBtn();
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
