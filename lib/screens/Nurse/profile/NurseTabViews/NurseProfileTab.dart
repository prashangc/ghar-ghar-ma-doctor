import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/editNurseProfile.dart';
import 'package:ghargharmadoctor/screens/Nurse/sideNavigation/myShifts/MyShifts.dart';

StateHandlerBloc refreshNurseProfileBloc = StateHandlerBloc();

class NurseProfileTab extends StatefulWidget {
  final NurseProfileModel profileModel;
  const NurseProfileTab({super.key, required this.profileModel});

  @override
  State<NurseProfileTab> createState() => _NurseProfileTabState();
}

class _NurseProfileTabState extends State<NurseProfileTab> {
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
              EditNurseProfileScreen(
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
        stream: refreshNurseProfileBloc.stateStream,
        builder: (c, s) {
          return Column(
            children: [
              myRow('NMC Number:', s.data.nncNo ?? ''),
              myRow('Email:', s.data.user!.email ?? ''),
              myRow('Phone:', s.data.user!.phone ?? ''),
              myRow('Type:', 'Homecare Nurse'),
              myRow('Qualification:', s.data.qualification ?? ''),
              myRow('Years Practised:', s.data.yearPracticed ?? ''),
              myRow('Gender:', s.data.gender ?? ''),
              myRow('Fee:',
                  s.data.fee == null ? '' : 'Rs. ${widget.profileModel.fee}'),
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
        goThere(context, const MyShifts());
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
