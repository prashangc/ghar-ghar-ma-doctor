import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/DoctorAppointmentListModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/appointmentCard.dart';

class AppointmentTabView extends StatefulWidget {
  List<DoctorAppointmentListModel> doctorAppointmentListModel;
  bool? showQueueCard;
  AppointmentTabView(
      {Key? key, this.showQueueCard, required this.doctorAppointmentListModel})
      : super(key: key);

  @override
  State<AppointmentTabView> createState() => _AppointmentTabViewState();
}

class _AppointmentTabViewState extends State<AppointmentTabView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.doctorAppointmentListModel.length,
        shrinkWrap: true,
        itemBuilder: (crx, i) {
          return Container(
            margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            child: appointmentCard(
              context,
              setState,
              widget.doctorAppointmentListModel[i],
              widget.showQueueCard,
            ),
          );
        });
  }
}
