import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyLabsModel/MyLabsModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/LabsTabView.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class MyLabs extends StatefulWidget {
  const MyLabs({Key? key}) : super(key: key);

  @override
  State<MyLabs> createState() => _MyLabsState();
}

class _MyLabsState extends State<MyLabs> {
  ApiHandlerBloc? myLabsBloc;
  TabController? _tabController;
  List<MyLabsModel> scheduledModel = [],
      completedModel = [],
      notScheduledModel = [];
  @override
  void initState() {
    myLabsBloc = ApiHandlerBloc();
    myLabsBloc!.fetchAPIList(endpoints.getMyLabBookedEndpoint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Lab Appointments',
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
                    horizontal: 12.0, vertical: 12.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TabBar(
                    labelColor: Colors.white,
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
                    ],
                  ),
                ),
              ),
              StreamBuilder<ApiResponse<dynamic>>(
                stream: myLabsBloc!.apiListStream,
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
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                  child: Text('No any lab booked')));
                        }
                        List<MyLabsModel> myLabsModel = List<MyLabsModel>.from(
                            snapshot.data!.data
                                .map((i) => MyLabsModel.fromJson(i)));
                        notScheduledModel = myLabsModel
                            .where((element) =>
                                element.bookingStatus == 'Not Scheduled')
                            .toList();
                        scheduledModel = myLabsModel
                            .where((element) =>
                                element.bookingStatus == 'Scheduled' ||
                                element.bookingStatus == 'Sample Collected')
                            .toList();
                        completedModel = myLabsModel
                            .where((element) =>
                                element.bookingStatus == 'Completed')
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
          LabsTabView(
            myLabsModel: notScheduledModel,
          ),
          LabsTabView(
            myLabsModel: scheduledModel,
          ),
          LabsTabView(
            myLabsModel: completedModel,
          ),
        ],
      ),
    );
  }
}
