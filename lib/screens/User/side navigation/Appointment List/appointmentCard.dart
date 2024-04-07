import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorAppointmentListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/AppointmentList.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:intl/intl.dart';

Widget appointmentCard(BuildContext context, setState,
    DoctorAppointmentListModel doctorAppointmentListModel, showQueueCard) {
  final TextEditingController reviewController = TextEditingController();

  return GestureDetector(
    onTap: () {
      // if (doctorAppointmentListModel.bookingStatus == 'Completed') {
      //   goThere(
      //       context,
      //       ViewReportsByDoctor(
      //         doctorAppointmentListModel: doctorAppointmentListModel,
      //       ));
      // }
    },
    child: Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox8(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Appointment Date',
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      doctorAppointmentListModel.slot!.bookings!.date
                          .toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox2(),
              ],
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  60.0,
                  60.0,
                  doctorAppointmentListModel.doctorProfile!.imagePath
                      .toString(),
                  const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  BoxFit.cover,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorAppointmentListModel
                            .slot!.bookings!.doctor!.user!.name
                            .toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox2(),
                      const SizedBox2(),
                      Text(
                        doctorAppointmentListModel
                            .slot!.bookings!.doctor!.user!.phone
                            .toString(),
                        style: kStyleNormal.copyWith(
                          // fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox2(),
                      const SizedBox2(),
                      Text(
                        doctorAppointmentListModel.status == 0
                            ? 'Payment status: Unpaid'
                            : 'Payment status: Paid',
                        style: kStyleNormal.copyWith(
                          // fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox2(),
                      const SizedBox2(),
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
              ],
            ),
          ),
          showQueueCard != null
              ? queuedCard(context, doctorAppointmentListModel)
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Column(
              children: [
                const SizedBox2(),
                Divider(color: myColor.dialogBackgroundColor),
                const SizedBox2(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.clock,
                          size: 15.0,
                          color: myColor.primaryColorDark,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          doctorAppointmentListModel.slot!.slot.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: kStyleNormal.copyWith(
                            fontSize: 16.0,
                            color: myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    doctorAppointmentListModel.bookingStatus == 'Scheduled' ||
                            doctorAppointmentListModel.bookingStatus ==
                                'Not Scheduled'
                        ? Row(
                            children: [
                              doctorAppointmentListModel.status == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              myColor.colorScheme.background,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          builder: ((builder) =>
                                              cancelAppointmentBottomSheet(
                                                  context,
                                                  setState,
                                                  doctorAppointmentListModel)),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 6.0),
                                        decoration: BoxDecoration(
                                          color: kRed.withOpacity(0.9),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Cancel Appointment',
                                          textAlign: TextAlign.center,
                                          style: kStyleNormal.copyWith(
                                            fontSize: 12.0,
                                            color:
                                                myColor.scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(width: 8.0),
                              doctorAppointmentListModel.status == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: backgroundColor,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20))),
                                            builder: ((builder) =>
                                                payNowBottomModel(context,
                                                    doctorAppointmentListModel)));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 6.0),
                                        decoration: BoxDecoration(
                                          color: kGreen,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          'Proceed to Pay',
                                          textAlign: TextAlign.center,
                                          style: kStyleNormal.copyWith(
                                            fontSize: 12.0,
                                            color:
                                                myColor.scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        if (doctorAppointmentListModel
                                                .slot!.serviceType ==
                                            'In Video') {
                                          if (doctorAppointmentListModel
                                                  .meeting ==
                                              null) {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  myColor.dialogBackgroundColor,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              builder: ((builder) =>
                                                  meetingValidationBtnSheet(
                                                      context,
                                                      'Please wait ! Doctor has not started meeting yet.')),
                                            );
                                          } else {
                                            // joinMeeting(
                                            //   context,
                                            //   doctorAppointmentListModel
                                            //       .meeting!.meetingId,
                                            //   doctorAppointmentListModel
                                            //       .meeting!.meetingPassword,
                                            // );
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 6.0),
                                        decoration: BoxDecoration(
                                          color: myColor.primaryColorDark,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          doctorAppointmentListModel
                                                      .slot!.serviceType ==
                                                  'In Video'
                                              ? 'Join Meeting'
                                              : 'In Person',
                                          textAlign: TextAlign.center,
                                          style: kStyleNormal.copyWith(
                                            fontSize: 12.0,
                                            color:
                                                myColor.scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        : doctorAppointmentListModel.bookingStatus ==
                                'Completed'
                            ? GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                        myColor.colorScheme.background,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: ((builder) => addReviewBottomSheet(
                                        context,
                                        doctorAppointmentListModel,
                                        reviewController)),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: myColor.primaryColorDark,
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      'Add Reviews',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                  ],
                ),
                const SizedBox12(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget payNowBottomModel(context, DoctorAppointmentListModel appointment) {
  String? selectedPaymentMethod;
  payBtn(paymentType) {
    switch (selectedPaymentMethod) {
      case 'esewa':
        // myEsewa(context, widget.totalAmount.toString());
        break;

      case 'khalti':
        myKhalti(
          context,
          appointment.doctorProfile!.fee,
          paymentType,
          appointment.doctorProfile!.id,
          detailsModel: appointment,
        );
        break;

      case '2':
        // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
        break;

      case '3':
        // myKhalti(context, widget.totalAmount, 'isProductOrder');
        break;

      case '4':
        // goThere(context, const EsewaTestScreen());
        break;

      case '5':
        // myKhalti(context, widget.totalAmount, 'isProductOrder');
        break;

      default:
    }
  }

  return StatefulBuilder(builder: (context, setState) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox12(),
                paymentMethod(context, false, true, onValueChanged: (v) {
                  selectedPaymentMethod = v;
                }),
                SizedBox(
                  width: maxWidth(context),
                  height: 56.0,
                  child: myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Rs. ${appointment.doctorProfile!.fee.toString()}',
                    kStyleNormal.copyWith(fontSize: 16.0, color: Colors.white),
                    () {
                      payBtn('isDoctorBookingPaymentOnly');
                    },
                  ),
                ),
                const SizedBox12(),
              ])),
    );
  });
}

Widget meetingValidationBtnSheet(context, text) {
  return Wrap(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
        child: infoCard(
          context,
          kWhite.withOpacity(0.4),
          myColor.primaryColorDark,
          text,
        ),
      ),
    ],
  );
}

Widget addReviewBottomSheet(context,
    DoctorAppointmentListModel doctorAppointmentListModel, reviewController) {
  double rating = 5;
  String ratingsText = 'Excellent';
  submitReviewBtn() async {
    int statusCode;
    if (reviewController.text.toString().isEmpty) {
      myToast.toast('empty');
    } else {
      statusCode = await API().postData(
        context,
        PostDoctorReviewModel(
          appointmentID: doctorAppointmentListModel.id,
          doctorId: doctorAppointmentListModel.doctorId,
          comment: reviewController.text.toString(),
          rating: rating.toString().substring(0, 1),
        ),
        endpoints.postDoctorReviewEndpoint,
      );
      if (statusCode == 200) {
        Navigator.pop(context);
        mySnackbar.mySnackBar(context, 'no Error: $statusCode', Colors.green);
      }
    }
  }

  return StatefulBuilder(builder: (context, setState) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox12(),
                Text(
                  'Give Ratings',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                Container(
                  width: maxWidth(context),
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                              minRating: 1,
                              itemBuilder: (context, _) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              },
                              initialRating: rating,
                              updateOnDrag: true,
                              itemSize: 30.0,
                              itemPadding: const EdgeInsets.only(right: 5),
                              onRatingUpdate: (newRatingValue) {
                                setState(() {
                                  rating = newRatingValue;
                                  rating == 1
                                      ? ratingsText = 'Satisfactory'
                                      : rating == 2
                                          ? ratingsText = 'Good'
                                          : rating == 3
                                              ? ratingsText = 'Average'
                                              : rating == 4
                                                  ? ratingsText = 'Best'
                                                  : rating == 5
                                                      ? ratingsText =
                                                          'Excellent'
                                                      : 'Excellent';
                                });
                              }),
                          const SizedBox(width: 10.0),
                          Text(
                            '${rating.toString()}  ( $ratingsText )',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox12(),
                Text(
                  'Write a Review',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox16(),
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom / 1.4),
                  width: 400.0,
                  child: TextField(
                    style: kStyleNormal.copyWith(fontSize: 12.0),
                    controller: reviewController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                            color: myColor.primaryColorDark, width: 1.5),
                      ),
                      hintText:
                          'Would you like to write anything about this product?',
                      hintStyle: kStyleNormal.copyWith(
                          fontSize: 12.0, color: Colors.grey[400]),
                    ),
                  ),
                ),
                const SizedBox16(),
                SizedBox(
                  width: maxWidth(context),
                  height: 50.0,
                  child: myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Submit Review',
                    kStyleNormal.copyWith(color: Colors.white, fontSize: 14.0),
                    () {
                      submitReviewBtn();
                    },
                  ),
                ),
                const SizedBox12(),
              ])),
    );
  });
}

Widget cancelAppointmentBottomSheet(
    context, myState, DoctorAppointmentListModel doctorAppointmentListModel) {
  StateHandlerBloc? btnBloc;
  bool isLoading = false;
  btnBloc = StateHandlerBloc();
  return StatefulBuilder(builder: (builder, setState) {
    String? reason;
    cancelAppointmentBtn(
        DoctorAppointmentListModel doctorAppointmentListModel) async {
      btnBloc!.storeData(!isLoading);
      int statusCode;
      FocusManager.instance.primaryFocus?.unfocus();
      statusCode = await API().postData(
          context,
          PostCancelAppointmentModel(
            cancelReason: reason,
          ),
          'admin/booking-review/canclebyuser/${doctorAppointmentListModel.id}');

      if (statusCode == 200) {
        btnBloc.storeData(isLoading);
        Navigator.pop(context);
        Navigator.pop(context);
        goThere(context, const AppointmentList(tabIndex: 2));
      } else {
        btnBloc.storeData(isLoading);

        mySnackbar.mySnackBar(
            context, 'Can\'t refer! Error: $statusCode', Colors.red);
      }
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5.0),
              Center(
                child: Text(
                  "Cancel Reason",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox16(),
              myTextArea(context, kWhite.withOpacity(0.4),
                  'Why do you want to cancel this appointment?',
                  onValueChanged: (v) {
                setState(() {
                  reason = v;
                });
              }),
              const SizedBox16(),
              StreamBuilder<dynamic>(
                initialData: isLoading,
                stream: btnBloc!.stateStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data) {
                      case true:
                        return myCircularIndicator();
                      case false:
                        return SizedBox(
                          width: maxWidth(context),
                          height: 50,
                          child: myCustomButton(
                              context,
                              Colors.red,
                              'Remove',
                              kStyleNormal.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w300,
                              ), () {
                            cancelAppointmentBtn(doctorAppointmentListModel);
                          }),
                        );
                    }
                  }
                  return const SizedBox();
                }),
              ),
              const SizedBox12(),
            ],
          ),
        ),
      ),
    );
  });
}

Widget queuedCard(BuildContext context,
    DoctorAppointmentListModel doctorAppointmentListModel) {
  String appointmentDateTime =
      '${doctorAppointmentListModel.slot!.bookings!.date} ${doctorAppointmentListModel.slot!.slot.toString().substring(0, doctorAppointmentListModel.slot!.slot!.length - 3)}';
  DateTime parsedAppointmentDateTime =
      DateFormat("yyyy-MM-dd h:mm").parse(appointmentDateTime);
  DateTime currentDateTime = DateTime.now();
  return parsedAppointmentDateTime.isAfter(currentDateTime)
      ? Container(
          margin: const EdgeInsets.only(top: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  "Your appointment schedule has been queued. Please wait until the doctor reschedules your appointment.",
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Icon(Icons.error_outline_outlined, size: 24.0, color: kRed),
              const SizedBox(width: 12.0),
            ],
          ),
        )
      : Container();
}
