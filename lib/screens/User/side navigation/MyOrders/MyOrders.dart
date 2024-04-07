import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyOrdersModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/OrderTabView.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  ApiHandlerBloc? myOrdersBloc;
  TabController? _tabController;
  List<MyOrdersModel> scheduledModel = [],
      completedModel = [],
      cancelledModel = [];
  @override
  void initState() {
    myOrdersBloc = ApiHandlerBloc();
    myOrdersBloc!.fetchAPIList(endpoints.getMyOrderEndpoint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'My Orders',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
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
                stream: myOrdersBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return SizedBox(
                          width: maxWidth(context),
                          height: 400,
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
                              child:
                                  const Center(child: Text('No any orders')));
                        }
                        List<MyOrdersModel> myOrdersModel =
                            List<MyOrdersModel>.from(snapshot.data!.data
                                .map((i) => MyOrdersModel.fromJson(i)));
                        scheduledModel = myOrdersModel
                            .where((element) =>
                                element.status == 'pending' ||
                                element.status == 'confirmed' ||
                                element.status == 'processing' ||
                                element.status == 'on_the_way' ||
                                element.status == 'delivered')
                            .toList();
                        completedModel = myOrdersModel
                            .where((element) => element.status == 'completed')
                            .toList();
                        cancelledModel = myOrdersModel
                            .where((element) => element.status == 'cancelled')
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
          OrdersTabView(
            myOrdersModel: scheduledModel,
            showCancelOrderAndTrackStatus: true,
          ),
          OrdersTabView(
            myOrdersModel: completedModel,
            showCancelOrderAndTrackStatus: false,
          ),
          OrdersTabView(
            myOrdersModel: cancelledModel,
            showCancelOrderAndTrackStatus: false,
          ),
        ],
      ),
    );
  }
}
