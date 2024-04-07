import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAppointmentsInDoctorSide.dart';
import 'package:ghargharmadoctor/models/ZoomMeeting/PostCreateMeetingModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/DoctorAppointmentDetailsScreen.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/ViewReportsByDoctor.dart';
import 'package:intl/intl.dart';

Widget doctorAppointmentCard(BuildContext context,
    GetAppointmentsInDoctorSide doctorAppointmentListModel, setState,
    {isHomepage}) {
  return GestureDetector(
    onTap: () {
      if (doctorAppointmentListModel.bookingStatus == 'Scheduled') {
        goThere(
            context,
            DoctorAppointmentDetailsScreen(
                appointments: doctorAppointmentListModel));
      }

      if (doctorAppointmentListModel.bookingStatus == 'Completed') {
        goThere(
            context,
            ViewReportsByDoctor(
              appointment: doctorAppointmentListModel,
            ));
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: isHomepage != null
            ? myColor.dialogBackgroundColor
            : myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      margin: isHomepage != null
          ? const EdgeInsets.only(bottom: 12.0)
          : const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
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
                  doctorAppointmentListModel.member!.imagePath.toString(),
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
                        doctorAppointmentListModel.member!.user!.name
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
                        doctorAppointmentListModel.member!.user!.phone
                            .toString(),
                        style: kStyleNormal.copyWith(
                          fontSize: 11.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox2(),
                      const SizedBox2(),
                      Text(
                        'Payment method:  ${doctorAppointmentListModel.paymentMethod.toString()}',
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
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: backgroundColor,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: ((builder) =>
                                          createMeetingBottomSheet(
                                              context, setState)));
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
                                    'Create Meeting',
                                    textAlign: TextAlign.center,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      color: myColor.scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: backgroundColor,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
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
                                    color: Colors.red.withOpacity(0.9),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel Appointment',
                                    textAlign: TextAlign.center,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      color: myColor.scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

Widget cancelAppointmentBottomSheet(
    context, myState, GetAppointmentsInDoctorSide doctorAppointmentListModel) {
  return StatefulBuilder(builder: (builder, setState) {
    bool isLoading = false;
    String? reason;
    cancelAppointmentBtn(
        GetAppointmentsInDoctorSide doctorAppointmentListModel) async {
      int statusCode;
      FocusManager.instance.primaryFocus?.unfocus();
      statusCode = await API().postData(
          context,
          PostCancelAppointmentModel(
            cancelReason: reason,
          ),
          'admin/booking-review/cancle/${doctorAppointmentListModel.id}');

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

Widget createMeetingBottomSheet(context, myState) {
  print('a');
  return StatefulBuilder(builder: (builder, setState) {
    String? topic, agenda;

    createZoomMeeting() async {
      int statusCode;
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
      FocusManager.instance.primaryFocus?.unfocus();
      statusCode = await API().postData(
          context,
          PostCreateMeetingModel(
            agenda: agenda.toString(),
            startTime: formattedDate.toString(),
            topic: topic.toString(),
          ),
          endpoints.postCreateMeeting);

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
                  "Create Meeting",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox16(),
              Column(
                children: [
                  const SizedBox12(),
                  mytextFormField(
                    context,
                    'Topic',
                    topic,
                    'Enter your topic',
                    topic,
                    onValueChanged: (value) {
                      topic = value;
                    },
                  ),
                  const SizedBox12(),
                  mytextFormField(
                    context,
                    'Agenda',
                    agenda,
                    'Enter your agenda',
                    agenda,
                    onValueChanged: (value) {
                      agenda = value;
                    },
                  ),
                  const SizedBox16(),
                  SizedBox(
                    width: maxWidth(context),
                    height: 50,
                    child: myCustomButton(
                        context,
                        myColor.primaryColorDark,
                        'Start',
                        kStyleNormal.copyWith(
                          color: Colors.white,
                          fontSize: 14.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w300,
                        ), () {
                      createZoomMeeting();
                    }),
                  ),
                ],
              ),
              const SizedBox16(),
            ],
          ),
        ),
      ),
    );
  });
}
