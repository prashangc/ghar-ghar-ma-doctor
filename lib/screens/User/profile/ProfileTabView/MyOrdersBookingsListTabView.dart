import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/refreshMethod.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/AppointmentList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/NurseAppointmentList/NurseAppointmentList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Credit/MyCredit.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/ExternalMedicalReport/ExternalMedicalReport.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Insurance/ClaimInsuranceListPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Wishlist/MyWishlist.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/LabReports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/MyLabs.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/MyOrders.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/PaymentStatements/PaymentStatements.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class MyOrdersBookingsListTabView extends StatefulWidget {
  final ProfileModel profileModel;
  const MyOrdersBookingsListTabView({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<MyOrdersBookingsListTabView> createState() =>
      _MyOrdersBookingsListTabViewState();
}

class _MyOrdersBookingsListTabViewState
    extends State<MyOrdersBookingsListTabView> {
  String? biometricUserID;
  bool? isBiometricSupported, showBiometric;
  @override
  void initState() {
    super.initState();
    myCheckBiometricSupport();
  }

  myCheckBiometricSupport() async {
    isBiometricSupported = await checkBiometricSupport();
    if (isBiometricSupported == true) {
      checkBiometricsStatus();
    }
  }

  checkBiometricsStatus() {
    biometricUserID = sharedPrefs.getFromDevice('biometricUserID');
    if (biometricUserID != null &&
        biometricUserID == widget.profileModel.member!.id.toString()) {
      showBiometric = true;
    } else {
      showBiometric = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        edgeOffset: 0,
        strokeWidth: 2.0,
        color: kWhite,
        backgroundColor: myColor.primaryColorDark,
        onRefresh: () async {
          await refresh(context);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                _reportsCard(context),
                const SizedBox12(),
                _servicesCard(context),
                const SizedBox12(),
                _vendorCard(context),
                const SizedBox16(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reportsCard(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Text(
            'Reports',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          sideNavList(
            FontAwesomeIcons.userDoctor,
            'Doctor Appointments',
            14.0,
            () {
              goThere(context, const AppointmentList(tabIndex: 0));
            },
          ),
          sideNavList(
            FontAwesomeIcons.userNurse,
            'Nurse Appointments',
            14.0,
            () {
              goThere(context, const NurseAppointmentList());
            },
          ),
          sideNavList(
            Icons.local_hospital,
            'External Medical Reports',
            16.0,
            () {
              goThere(context, const ExternalMedicalReportPage());
            },
          ),
          sideNavList(
            FontAwesomeIcons.flask,
            'My Labs',
            14.0,
            () {
              goThere(context, const MyLabs());
            },
          ),
          sideNavList(
            FontAwesomeIcons.fileContract,
            'Lab Reports',
            14.0,
            () {
              goThere(context, const LabReports());
            },
          ),
          sideNavList(
            FontAwesomeIcons.solidFilePdf,
            'Payment Statements',
            14.0,
            () {
              goThere(context, const PaymentStatements());
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _servicesCard(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Text(
            'Services',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          sideNavList(
            FontAwesomeIcons.box,
            'My Packages',
            14.0,
            () {
              goThere(
                  context,
                  const MainHomePage(
                    index: 2,
                    tabIndex: 0,
                  ));
            },
          ),
          sideNavList(
            FontAwesomeIcons.truckMedical,
            'Ambulance History',
            14.0,
            () {
              goThere(context, const MyOrders());
            },
          ),
          sideNavList(
            FontAwesomeIcons.handHoldingHeart,
            'Claim Insurance Settlement',
            14.0,
            () {
              goThere(context, const ClaimInsuranceListPage());
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _vendorCard(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Text(
            'Vendors',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          sideNavList(
            Icons.add_box,
            'My Orders',
            16.0,
            () {
              goThere(context, const MyOrders());
            },
          ),
          sideNavList(
            Icons.shopping_cart,
            'My Cart',
            16.0,
            () {
              goThere(context, const MyCart());
            },
          ),
          sideNavList(
            FontAwesomeIcons.heart,
            'My Wishlist',
            14.0,
            () {
              goThere(context, const MyWishlist());
            },
          ),
          sideNavList(
            FontAwesomeIcons.heart,
            'My Credit',
            14.0,
            () {
              goThere(context, const MyCredit());
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
