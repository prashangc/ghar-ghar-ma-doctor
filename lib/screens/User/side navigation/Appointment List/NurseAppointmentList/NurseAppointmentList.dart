import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/GetAppointmentListOfNurseInUserSide.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/NurseAppointmentList/NurseAppointmentTab.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class NurseAppointmentList extends StatefulWidget {
  const NurseAppointmentList({Key? key}) : super(key: key);

  @override
  State<NurseAppointmentList> createState() => _NurseAppointmentListState();
}

class _NurseAppointmentListState extends State<NurseAppointmentList> {
  ApiHandlerBloc? appointmentListBloc;
  TabController? _tabController;
  List<GetAppointmentListOfNurseInUserSide> appointmentList = [],
      scheduledModel = [],
      completedModel = [],
      cancelledModel = [];
  @override
  void initState() {
    appointmentListBloc = ApiHandlerBloc();
    appointmentListBloc!
        .fetchAPIList(endpoints.getNurseAppointmentBookingDetails);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Appointment List',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
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
                margin: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 15.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          'Pending',
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
              StreamBuilder<ApiResponse<dynamic>>(
                stream: appointmentListBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return SizedBox(
                          width: maxWidth(context),
                          height: maxHeight(context) / 3,
                          child: const Center(
                            child: AnimatedLoading(),
                          ),
                        );
                      case Status.COMPLETED:
                        if (snapshot.data!.data.isEmpty) {
                          return Container(
                              height: 140,
                              margin: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                  child: Text('No any appointments')));
                        }
                        appointmentList =
                            List<GetAppointmentListOfNurseInUserSide>.from(
                                snapshot.data!.data.map((i) =>
                                    GetAppointmentListOfNurseInUserSide
                                        .fromJson(i)));
                        scheduledModel = appointmentList
                            .where((element) =>
                                element.bookingStatus == "Not Scheduled" ||
                                element.bookingStatus == "Scheduled")
                            .toList();
                        completedModel = appointmentList
                            .where((element) =>
                                element.bookingStatus == 'Completed')
                            .toList();
                        cancelledModel = appointmentList
                            .where((element) =>
                                element.bookingStatus == 'Cancelled')
                            .toList();
                        print('here $scheduledModel');
                        return buildTabbarView();
                      case Status.ERROR:
                        return Container(
                          width: maxWidth(context),
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
          NurseAppointmentTab(
            appointment: scheduledModel,
          ),
          NurseAppointmentTab(
            appointment: completedModel,
          ),
          NurseAppointmentTab(
            appointment: cancelledModel,
          ),
        ],
      ),
    );
  }
}
