import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/editDoctorProfile.dart';
import 'package:ghargharmadoctor/screens/Doctor/side%20navigation/Schedule/DoctorTimings.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc refreshDoctorProfileBloc = StateHandlerBloc();

class DoctorProfileTabView extends StatefulWidget {
  final DoctorProfileModel profileModel;
  const DoctorProfileTabView({super.key, required this.profileModel});

  @override
  State<DoctorProfileTabView> createState() => _DoctorProfileTabViewState();
}

class _DoctorProfileTabViewState extends State<DoctorProfileTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 50.0),
      width: maxWidth(context),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: myContainer(profileCard()),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: myContainer(appointmentCard()),
                        ),
                        const SizedBox12(),
                        Expanded(
                          child: myContainer(timingCard()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox16(),
            const SizedBox16(),
            logout(context),
          ],
        ),
      ),
    );
  }

  Widget myContainer(Widget myWidget) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: myWidget,
    );
  }

  Widget myRow(title, value) {
    return GestureDetector(
      onTap: () {
        if (value == '') {
          goThere(
              context,
              EditDoctorProfileScreen(
                profileModel: widget.profileModel,
              ));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  color: value == '' ? kRed : kBlack,
                ),
              ),
              value == ''
                  ? Icon(Icons.error_outline_outlined, size: 11.0, color: kRed)
                  : Text(
                      value.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: myColor.primaryColorDark,
                      ),
                    ),
            ],
          ),
          const SizedBox8(),
        ],
      ),
    );
  }

  Widget profileCard() {
    return StreamBuilder<dynamic>(
        initialData: widget.profileModel,
        stream: refreshDoctorProfileBloc.stateStream,
        builder: (c, s) {
          return Column(
            children: [
              myRow('NMC Number:', s.data.nmcNo ?? ''),
              myRow('Salution:', s.data.salutation ?? ''),
              myRow('Qualification:', s.data.qualification ?? ''),
              myRow('Specialization:', s.data.specialization ?? ''),
              myRow('Department:', s.data.department ?? ''),
              myRow('Years Practised:', s.data.yearPracticed ?? ''),
              myRow('Hospital:', s.data.hospital ?? ''),
              myRow('Gender:', s.data.gender ?? ''),
              myRow('Fee:', s.data.fee == null ? '' : 'Rs. ${s.data.fee}'),
            ],
          );
        });
  }

  Widget appointmentCard() {
    return Container();
  }

  Widget timingCard() {
    return GestureDetector(
      onTap: () {
        goThere(context, const DoctorTimings());
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'View',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: myColor.primaryColorDark,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: myColor.primaryColorDark,
                size: 16.0,
              ),
            ],
          ),
          const SizedBox12(),
          Icon(
            Icons.timer,
            color: myColor.primaryColorDark,
          ),
          const SizedBox12(),
          Text(
            "Schedule",
            style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
