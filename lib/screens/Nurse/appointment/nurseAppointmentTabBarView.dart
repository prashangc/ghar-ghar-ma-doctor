import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/NurseModel/GetAppointmentsInNurseSideModel.dart';
import 'package:ghargharmadoctor/screens/Nurse/appointment/nurseAppointmentCard.dart';

class NurseSideAppoinmentTabBarView extends StatefulWidget {
  final List<GetAppointmentsInNurseSideModel> nurseAppointmentListModel;
  final bool? isHomepage;
  const NurseSideAppoinmentTabBarView(
      {Key? key, required this.nurseAppointmentListModel, this.isHomepage})
      : super(key: key);

  @override
  State<NurseSideAppoinmentTabBarView> createState() =>
      _NurseSideAppoinmentTabBarViewState();
}

class _NurseSideAppoinmentTabBarViewState
    extends State<NurseSideAppoinmentTabBarView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.nurseAppointmentListModel.length,
        shrinkWrap: true,
        itemBuilder: (crx, i) {
          return nurseAppointmentCard(
            context,
            widget.nurseAppointmentListModel[i],
            setState,
            isHomepage: widget.isHomepage,
          );
        });
  }
}
