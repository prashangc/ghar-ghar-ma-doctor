import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/GetAppointmentListOfNurseInUserSide.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Loading/loading_imports.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';

Widget appointmentCardOfNurse(BuildContext context, setState,
    GetAppointmentListOfNurseInUserSide appointment) {
  final TextEditingController reviewController = TextEditingController();

  return Container(
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
                    appointment.shift!.date.toString(),
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
                appointment.shift!.nurse!.imagePath.toString(),
                const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                BoxFit.contain,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.shift!.nurse!.user!.name.toString(),
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
                      appointment.shift!.nurse!.user!.phone.toString(),
                      style: kStyleNormal.copyWith(
                        // fontWeight: FontWeight.bold,
                        fontSize: 11.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox2(),
                    const SizedBox2(),
                    Text(
                      appointment.status == 0
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
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.clock,
                          size: 15.0,
                          color: myColor.primaryColorDark,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          appointment.shift!.shift.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: kStyleNormal.copyWith(
                            fontSize: 16.0,
                            color: myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        appointment.bookingStatus == 'Scheduled' ||
                                appointment.bookingStatus == 'Not Scheduled'
                            ? Row(
                                children: [
                                  appointment.status == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: backgroundColor,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              builder: ((builder) =>
                                                  cancelAppointmentBottomSheet(
                                                      context,
                                                      setState,
                                                      appointment)),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 6.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.9),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                'Cancel Appointment',
                                                textAlign: TextAlign.center,
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                  color: myColor
                                                      .scaffoldBackgroundColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(width: 8.0),
                                  appointment.status == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    backgroundColor,
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20))),
                                                builder: ((builder) =>
                                                    payNowBottomModel(
                                                        context, appointment)));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 6.0),
                                            decoration: const BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                'Proceed to Pay',
                                                textAlign: TextAlign.center,
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                  color: myColor
                                                      .scaffoldBackgroundColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor: backgroundColor,
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      20))),
                                              builder: ((builder) =>
                                                  trackingNurseBottomSheet(
                                                      appointment)),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 6.0),
                                            decoration: BoxDecoration(
                                              color: myColor.primaryColorDark,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Text(
                                              'Track Nurse',
                                              textAlign: TextAlign.center,
                                              style: kStyleNormal.copyWith(
                                                fontSize: 12.0,
                                                color: myColor
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            : appointment.bookingStatus == 'Completed'
                                ? GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: backgroundColor,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        builder: ((builder) =>
                                            addReviewBottomSheet(context,
                                                appointment, reviewController)),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                : Container(),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox12(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget payNowBottomModel(
    context, GetAppointmentListOfNurseInUserSide appointment) {
  String? selectedPaymentMethod;
  payBtn(paymentType) {
    switch (selectedPaymentMethod) {
      case 'esewa':
        // myEsewa(context, widget.totalAmount.toString());
        break;

      case 'khalti':
        myKhalti(
          context,
          appointment.shift!.nurse!.fee!.round(),
          paymentType,
          appointment.id,
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
                    'Rs. ${appointment.shift!.nurse!.fee}',
                    kStyleNormal.copyWith(fontSize: 16.0, color: Colors.white),
                    () {
                      payBtn('isNurseBookingPaymentOnly');
                    },
                  ),
                ),
                const SizedBox12(),
              ])),
    );
  });
}

Widget addReviewBottomSheet(context,
    GetAppointmentListOfNurseInUserSide appointment, reviewController) {
  double rating = 5;
  String ratingsText = 'Excellent';
  submitReviewBtn() async {
    int statusCode;
    if (reviewController.text.toString().isEmpty) {
      myToast.toast('empty');
    } else {
      statusCode = await API().postData(
        context,
        PostNurseReviewModel(
          appointmentId: appointment.id,
          nurseId: appointment.id,
          comment: reviewController.text.toString(),
          rating: rating.toString().substring(0, 1),
        ),
        endpoints.postNurseReviewEndpoint,
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

Widget cancelAppointmentBottomSheet(context, myState,
    GetAppointmentListOfNurseInUserSide doctorAppointmentListModel) {
  return StatefulBuilder(builder: (builder, setState) {
    bool isLoading = false;
    String? reason;
    cancelAppointmentBtn(
        GetAppointmentListOfNurseInUserSide doctorAppointmentListModel) async {
      int statusCode;
      FocusManager.instance.primaryFocus?.unfocus();
      statusCode = await API().postData(
          context,
          PostCancelAppointmentModel(
            cancelReason: reason,
          ),
          'admin/booking-review/canclebyuser/${doctorAppointmentListModel.id}');

      if (statusCode == 200) {
        mySnackbar.mySnackBar(context, 'no Error: $statusCode', Colors.green);
      } else {
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
        child: Container(
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
              SizedBox(
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
              ),
              const SizedBox12(),
            ],
          ),
        ),
      ),
    );
  });
}

Widget trackingNurseBottomSheet(
    GetAppointmentListOfNurseInUserSide appointment) {
  ApiHandlerBloc? nurseBloc;
  nurseBloc = ApiHandlerBloc();
  nurseBloc.fetchAPIList('admin/nurses/bookings?slug=${appointment.slug}');

  return StreamBuilder<ApiResponse<dynamic>>(
    stream: nurseBloc.apiListStream,
    builder: ((context, snapshot) {
      if (snapshot.hasData) {
        switch (snapshot.data!.status) {
          case Status.LOADING:
            return const NurseTrackLoadingShimmer();
          case Status.COMPLETED:
            if (snapshot.data!.data.isEmpty) {
              return Container(
                  height: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('No image added')));
            }
            NurseTrackModel nurseTrackModel =
                NurseTrackModel.fromJson(snapshot.data!.data);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: maxWidth(context),
                  height: 100.0,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 40.0,
                        right: 40.0,
                        top: 40.0,
                        child: Container(
                          color: myColor.dialogBackgroundColor.withOpacity(0.8),
                          width: maxWidth(context),
                          height: 2.0,
                        ),
                      ),
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: nurseTrackingList.length,
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: [
                                const SizedBox16(),
                                Container(
                                  width: maxWidth(context) / 3,
                                  height: 50.0,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 205, 226, 247),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    orderTrackingList[i].iconData,
                                    size: 20.0,
                                    color: nurseTrackModel.bookingStatus ==
                                            nurseTrackingList[i].status
                                        ? myColor.primaryColorDark
                                        : myColor.primaryColorDark
                                            .withOpacity(0.3),
                                  ),
                                ),
                                const SizedBox8(),
                                Text(
                                  nurseTrackingList[i].title.toString(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 10.0,
                                    color: nurseTrackModel.bookingStatus ==
                                            nurseTrackingList[i].status
                                        ? myColor.primaryColorDark
                                        : myColor.primaryColorDark
                                            .withOpacity(0.6),
                                  ),
                                )
                              ],
                            );
                          }),
                    ],
                  ),
                )
              ],
            );

          case Status.ERROR:
            return Center(
              child: Text('Server Error',
                  style: kStyleNormal.copyWith(fontSize: 12.0)),
            );
        }
      }
      return SizedBox(
        width: maxWidth(context),
      );
    }),
  );
}
