import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAppointmentsInDoctorSide.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/doctorAppointmentCard.dart';

class DoctorSideAppoinmentTabBarView extends StatefulWidget {
  final List<GetAppointmentsInDoctorSide> doctorAppointmentListModel;
  final bool? isHomepage;
  const DoctorSideAppoinmentTabBarView(
      {Key? key, required this.doctorAppointmentListModel, this.isHomepage})
      : super(key: key);

  @override
  State<DoctorSideAppoinmentTabBarView> createState() =>
      _DoctorSideAppoinmentTabBarViewState();
}

class _DoctorSideAppoinmentTabBarViewState
    extends State<DoctorSideAppoinmentTabBarView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: widget.isHomepage != null
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: widget.doctorAppointmentListModel.length,
        shrinkWrap: true,
        itemBuilder: (crx, i) {
          return doctorAppointmentCard(
            context,
            widget.doctorAppointmentListModel[i],
            setState,
            isHomepage: widget.isHomepage,
          );
        });
  }
}
