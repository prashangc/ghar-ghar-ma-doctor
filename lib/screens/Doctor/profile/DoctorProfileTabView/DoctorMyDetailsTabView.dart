import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/main/mainHomePageDoctor.dart';
import 'package:ghargharmadoctor/screens/Doctor/side%20navigation/Schedule/DoctorTimings.dart';
import 'package:ghargharmadoctor/screens/Doctor/side%20navigation/kyd/kyd.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/myTavBarViewCard.dart';

class DoctorMyDetailsTabView extends StatefulWidget {
  final DoctorProfileModel profileModel;

  const DoctorMyDetailsTabView({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<DoctorMyDetailsTabView> createState() => _DoctorMyDetailsTabViewState();
}

class _DoctorMyDetailsTabViewState extends State<DoctorMyDetailsTabView> {
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
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: myColor.primaryColorDark,
                primaryColor: myColor.primaryColorDark,
                dividerColor: Colors.transparent,
              ),
              child: ListTileTheme(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                dense: true,
                horizontalTitleGap: 0.0,
                // minVerticalPadding: 0.0,
                minLeadingWidth: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 11),
                  child: ExpansionTile(
                      iconColor: myColor.primaryColorDark,
                      tilePadding: EdgeInsets.zero,
                      title: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          width: maxWidth(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.local_hospital_outlined,
                                size: 18.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  'Hospital',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 12.0),
                          decoration: BoxDecoration(
                            color: myColor.dialogBackgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                height: 53.0,
                                width: maxWidth(context),
                                child: const Text(
                                    'widget.profileModel.hospital![0]'),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            const Divider(),
            myCard(
              context,
              Icons.calendar_month_outlined,
              'My Appointments',
              () {
                goThere(
                    context,
                    const MainHomePageDoctor(
                      index: 0,
                    ));
              },
            ),
            const Divider(),
            myCard(
              context,
              Icons.timer_outlined,
              'My Schedule',
              () {
                goThere(context, const DoctorTimings());
              },
            ),
            const Divider(),
            myCard(
              context,
              Icons.perm_identity,
              'KYD',
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
