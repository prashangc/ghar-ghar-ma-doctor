import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/screens/Doctor/side%20navigation/kyd/kyd.dart';
import 'package:ghargharmadoctor/screens/Nurse/main/mainHomePageNurse.dart';
import 'package:ghargharmadoctor/screens/Nurse/sideNavigation/myShifts/MyShifts.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/myTavBarViewCard.dart';

class NurseMyDetailsTab extends StatefulWidget {
  final NurseProfileModel profileModel;
  const NurseMyDetailsTab({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<NurseMyDetailsTab> createState() => _NurseMyDetailsTabState();
}

class _NurseMyDetailsTabState extends State<NurseMyDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 50.0),
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: maxWidth(context),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            myCard(
              context,
              Icons.calendar_month_outlined,
              'My Appointments',
              () {
                goThere(
                    context,
                    const MainHomePageNurse(
                      index: 0,
                    ));
              },
            ),
            const Divider(),
            myCard(
              context,
              Icons.timer_outlined,
              'My Shifts',
              () {
                goThere(context, const MyShifts());
              },
            ),
            const Divider(),
            myCard(
              context,
              Icons.perm_identity,
              'KYN',
              () {
                goThere(context, const kyd());
              },
            ),
          ],
        ),
      ),
    );
  }
}
