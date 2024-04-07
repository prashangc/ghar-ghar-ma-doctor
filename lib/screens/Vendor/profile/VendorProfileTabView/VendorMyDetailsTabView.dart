import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/myTavBarViewCard.dart';

class VendorMyDetailsTabView extends StatefulWidget {
  final VendorProfileModel profileModel;

  const VendorMyDetailsTabView({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<VendorMyDetailsTabView> createState() => _VendorMyDetailsTabViewState();
}

class _VendorMyDetailsTabViewState extends State<VendorMyDetailsTabView> {
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
              () {},
            ),
            const Divider(),
            myCard(
              context,
              Icons.timer_outlined,
              'My Schedule',
              () {},
            ),
            const Divider(),
            myCard(
              context,
              Icons.perm_identity,
              'KYD',
              () {},
            ),
          ],
        ),
      ),
    );
  }
}
