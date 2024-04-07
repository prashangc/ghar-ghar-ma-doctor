import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAppointmentsInDoctorSide.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/appointmentTabBarView/DoctorSideAppointmentListTabView.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class DotorListOfAppointmentScreen extends StatefulWidget {
  const DotorListOfAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<DotorListOfAppointmentScreen> createState() =>
      _DotorListOfAppointmentScreenState();
}

class _DotorListOfAppointmentScreenState
    extends State<DotorListOfAppointmentScreen> {
  ApiHandlerBloc? appointmentBloc;
  TabController? _tabController;
  List<GetAppointmentsInDoctorSide> getAppointmentsInDoctorSide = [],
      pendingModel = [],
      cancelledModel = [],
      completedModel = [];
  @override
  void initState() {
    appointmentBloc = ApiHandlerBloc();
    appointmentBloc!.fetchAPIList(endpoints.getAppointmentsInDoctorSide);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Appointments',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBar(
                    labelColor: Colors.white, //<-- selected text color
                    unselectedLabelColor: Colors.black,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: myColor.primaryColorDark,
                    ),
                    tabs: [
                      Tab(
                        child: Text(
                          'Scheduled',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Completed',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Cancelled',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox12(),
              StreamBuilder<ApiResponse<dynamic>>(
                stream: appointmentBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return SizedBox(
                          width: maxWidth(context),
                          height: maxHeight(context) / 2,
                          child: const Center(
                            child: AnimatedLoading(),
                          ),
                        );
                      case Status.COMPLETED:
                        if (snapshot.data!.data.isEmpty) {
                          return Container(
                              height: 140,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                  child: Text('No any appointments')));
                        }
                        getAppointmentsInDoctorSide =
                            List<GetAppointmentsInDoctorSide>.from(
                                snapshot.data!.data.map((i) =>
                                    GetAppointmentsInDoctorSide.fromJson(i)));
                        pendingModel = getAppointmentsInDoctorSide
                            .where((element) =>
                                element.bookingStatus == 'Scheduled')
                            .toList();
                        completedModel = getAppointmentsInDoctorSide
                            .where((element) =>
                                element.bookingStatus == 'Completed')
                            .toList();
                        cancelledModel = getAppointmentsInDoctorSide
                            .where((element) =>
                                element.bookingStatus == 'Rejected')
                            .toList();
                        return buildTabbarView();
                      case Status.ERROR:
                        return Container(
                          width: maxWidth(context),
                          height: 135.0,
                          margin: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text('Server Error'),
                          ),
                        );
                    }
                  }
                  return SizedBox(
                    width: maxWidth(context),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabbarView() {
    return Expanded(
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          DoctorSideAppoinmentTabBarView(
            doctorAppointmentListModel: pendingModel,
          ),
          DoctorSideAppoinmentTabBarView(
            doctorAppointmentListModel: completedModel,
          ),
          DoctorSideAppoinmentTabBarView(
            doctorAppointmentListModel: cancelledModel,
          ),
        ],
      ),
    );
  }
}
