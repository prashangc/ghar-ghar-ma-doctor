import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/NurseModel/GetAppointmentListOfNurseInUserSide.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/NurseAppointmentList/appointmentCardOfNurse.dart';

class NurseAppointmentTab extends StatefulWidget {
  List<GetAppointmentListOfNurseInUserSide> appointment;
  NurseAppointmentTab({Key? key, required this.appointment}) : super(key: key);

  @override
  State<NurseAppointmentTab> createState() => _NurseAppointmentTabState();
}

class _NurseAppointmentTabState extends State<NurseAppointmentTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.appointment.length,
        shrinkWrap: true,
        itemBuilder: (crx, i) {
          return Container(
            margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            child: appointmentCardOfNurse(
              context,
              setState,
              widget.appointment[i],
            ),
          );
        });
  }
}
