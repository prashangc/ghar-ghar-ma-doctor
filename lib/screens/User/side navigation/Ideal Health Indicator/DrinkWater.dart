import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/WaterCupDBModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DrinkWater extends StatefulWidget {
  const DrinkWater({super.key});

  @override
  State<DrinkWater> createState() => _DrinkWaterState();
}

class _DrinkWaterState extends State<DrinkWater> {
  int weight = 60;
  PageController controller = PageController();
  int age = 22;
  int? heightInFt, heightInch;
  int currentStep = 0;
  String? startTime,
      endTime,
      myWaterConfirmation,
      unit,
      interval,
      waterToDrinkDaily,
      userID,
      _waterCupText;
  StateHandlerBloc? showBottomNavBloc,
      loadingBloc,
      notificationSwitchBloc,
      settingsBloc,
      formBloc,
      refreshDrinkWaterBloc,
      postTimingLoadingBloc,
      showCupErrorBloc,
      pageViewBloc,
      staticAnimationBloc;
  ApiHandlerBloc? drinkWaterBloc;
  int dayIndex = 0;
  List<GetDrinkWaterModel> getDrinkWaterModel = [];
  double? waterToAdd;
  List<MyWaterDatabaseModel> myWaterDatabaseModel = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final bool _formChanged = false;
  final PageStorageBucket _bucket = PageStorageBucket();
  final PageStorageKey _key = const PageStorageKey('myEndDrawer');
  @override
  void initState() {
    super.initState();
    loadingBloc = StateHandlerBloc();
    showBottomNavBloc = StateHandlerBloc();
    postTimingLoadingBloc = StateHandlerBloc();
    refreshDrinkWaterBloc = StateHandlerBloc();
    staticAnimationBloc = StateHandlerBloc();
    notificationSwitchBloc = StateHandlerBloc();
    formBloc = StateHandlerBloc();
    pageViewBloc = StateHandlerBloc();
    showCupErrorBloc = StateHandlerBloc();
    settingsBloc = StateHandlerBloc();
    drinkWaterBloc = ApiHandlerBloc();
    drinkWaterBloc!.fetchAPIList(endpoints.getDrinkWaterEndpoint);
    waterToDrinkDaily = sharedPrefs.getFromDevice("waterToDrinkDaily") ?? '0';
    waterCupLocalDB();
  }

  waterCupLocalDB() async {
    userID = sharedPrefs.getUserID('userID');
    myWaterDatabaseModel = await MyDatabase.instance.fetchWaterCupData(userID);
    if (myWaterDatabaseModel.isEmpty) {
      await addWaterCupInDatabase();
      getSelectedWater();
      myWaterDatabaseModel =
          await MyDatabase.instance.fetchWaterCupData(userID);
    } else {
      getSelectedWater();
      myWaterDatabaseModel =
          await MyDatabase.instance.fetchWaterCupData(userID);
    }
  }

  updateWaterCup(rowID, state) async {
    await MyDatabase.instance.updateStatusForUser(userID!, rowID.toString());
    myWaterDatabaseModel = await MyDatabase.instance.fetchWaterCupData(userID);
    myWaterConfirmation = await MyDatabase.instance.getWaterValue(userID);
    print('myWaterConfirmation $myWaterConfirmation');
    state(() {});
    setState(() {});
  }

  getSelectedWater() async {
    myWaterConfirmation = await MyDatabase.instance.getWaterValue(userID);
    print('myWaterConfirmation $myWaterConfirmation');
  }

  addWaterCupInDatabase() {
    List<MyWaterDatabaseModel> staticWaterModelList = [];
    staticWaterModelList.clear();
    staticWaterModelList = [
      MyWaterDatabaseModel(userID: userID, water: '100', status: '1'),
      MyWaterDatabaseModel(userID: userID, water: '250', status: '0'),
      MyWaterDatabaseModel(userID: userID, water: '1000', status: '0'),
    ];
    for (int i = 0; i < staticWaterModelList.length; i++) {
      MyDatabase.instance.addWaterToLocalDB(staticWaterModelList[i]);
    }
  }

  String getCurrentDay() {
    DateTime now = DateTime.now();
    String dayOfWeek = DateFormat('EEEE').format(now);
    return dayOfWeek;
  }

  double percentConverter(
    maxIntake,
    valueIntake,
  ) {
    double percentage = (valueIntake / maxIntake) * 100;
    double percentValue = percentage / 100;
    return percentValue > 1 ? 1 : percentValue;
  }

  postWaterIntakeBtn(double water) async {
    loadingBloc!.storeData(1);
    int? statusCode;
    statusCode = await API().postData(
        context,
        PostDrinkWaterIntakeModel(
          intake: water,
        ),
        'admin/water-intake/update-intake/${getDrinkWaterModel[getDrinkWaterModel.length - 1].days![dayIndex].id}');
    if (statusCode == 200) {
      staticAnimationBloc!.storeData(StaticDataModelForAnimation(
        percent: percentConverter(
            getDrinkWaterModel[getDrinkWaterModel.length - 1].waterIntake!,
            water),
        remainingWaterIntake: formatNumber(double.parse(
            (getDrinkWaterModel[getDrinkWaterModel.length - 1].waterIntake! -
                    water)
                .toString())),
        waterIntake: formatNumber(double.parse(water.toString())),
      ));
      loadingBloc!.storeData(0);
      sharedPrefs.storeToDevice(
          "waterDrankToday", formatNumber(double.parse(water.toString())));
      sharedPrefs.storeToDevice(
          "dailyWaterToDrinkPercent",
          percentConverter(
                  getDrinkWaterModel[getDrinkWaterModel.length - 1]
                      .waterIntake!,
                  water)
              .toString());
    } else {
      loadingBloc!.storeData(0);
    }
  }

  String formatNumber(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isEndDrawerOpen == true) {
          _scaffoldKey.currentState!.closeEndDrawer();
        } else {
          goThere(
              context,
              const MainHomePage(
                index: 4,
                tabIndex: 0,
              ));
        }
        return false;
      },
      child: GestureDetector(
        onTap: () => myfocusRemover(context),
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: settingsDrawer(),
          backgroundColor: backgroundColor,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            backgroundColor: backgroundColor,
          ),
          body: SizedBox(
            height: maxHeight(context),
            width: maxWidth(context),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: maxWidth(context),
                      height: 70,
                      child: Center(
                        child: Text(
                          'Water Intake',
                          textAlign: TextAlign.center,
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12.0,
                      right: 12.0,
                      child: StreamBuilder<dynamic>(
                          initialData: 0,
                          stream: settingsBloc!.stateStream,
                          builder: (context, snapshot) {
                            return snapshot.data == 0
                                ? Tooltip(
                                    decoration: BoxDecoration(
                                      color: myColor.primaryColorDark,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0),
                                      ),
                                    ),
                                    textStyle: kStyleNormal.copyWith(
                                        fontSize: 12.0, color: kWhite),
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: 'Enabled after timings set',
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        height: 50.0,
                                        child: Icon(
                                          Icons.settings,
                                          color: myColor.primaryColorDark,
                                          size: 25.0,
                                        )),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (getDrinkWaterModel.isNotEmpty) {
                                        _scaffoldKey.currentState!
                                            .openEndDrawer();
                                      }
                                    },
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        height: 50.0,
                                        child: Icon(
                                          Icons.settings,
                                          color: myColor.primaryColorDark,
                                          size: 25.0,
                                        )),
                                  );
                          }),
                    ),
                    Positioned(
                      bottom: 12.0,
                      left: 12.0,
                      child: SizedBox(
                        width: 65,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainHomePage(
                                        index: 4, tabIndex: 0)),
                                (route) => false);
                          },
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: myColor.scaffoldBackgroundColor,
                              ),
                              margin:
                                  const EdgeInsets.only(right: 15.0, top: 12),
                              child: const Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.black,
                                size: 35.0,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      child: StreamBuilder<dynamic>(
                          initialData: 0,
                          stream: refreshDrinkWaterBloc!.stateStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == 'refresh') {
                              drinkWaterBloc!.fetchAPIList(
                                  endpoints.getDrinkWaterEndpoint);
                            }
                            return StreamBuilder<ApiResponse<dynamic>>(
                                stream: drinkWaterBloc!.apiListStream,
                                builder: (context, snapshot) {
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
                                          return settingsCard(data: null);
                                        } else {
                                          getDrinkWaterModel =
                                              List<GetDrinkWaterModel>.from(
                                                  snapshot.data!.data.map((i) =>
                                                      GetDrinkWaterModel
                                                          .fromJson(i)));
                                          var data = getDrinkWaterModel[
                                              getDrinkWaterModel.length - 1];
                                          String dayName = getCurrentDay();
                                          for (int i = 0;
                                              i <
                                                  getDrinkWaterModel[
                                                          getDrinkWaterModel
                                                                  .length -
                                                              1]
                                                      .days!
                                                      .length;
                                              i++) {
                                            if (getDrinkWaterModel[
                                                        getDrinkWaterModel
                                                                .length -
                                                            1]
                                                    .days![i]
                                                    .day ==
                                                dayName) {
                                              dayIndex = i;
                                            }
                                          }

                                          String remainingWaterIntake =
                                              (getDrinkWaterModel[
                                                              getDrinkWaterModel
                                                                      .length -
                                                                  1]
                                                          .waterIntake! -
                                                      getDrinkWaterModel[
                                                              getDrinkWaterModel
                                                                      .length -
                                                                  1]
                                                          .days![dayIndex]
                                                          .intake!)
                                                  .toString();
                                          showBottomNavBloc!.storeData(true);
                                          settingsBloc!.storeData(1);
                                          sharedPrefs.storeToDevice(
                                              'showWaterNotification', 'show');
                                          return SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox16(),
                                                waterCircularPercentIndicator(
                                                  getDrinkWaterModel[
                                                          getDrinkWaterModel
                                                                  .length -
                                                              1]
                                                      .days![dayIndex]
                                                      .intake!,
                                                  getDrinkWaterModel[
                                                          getDrinkWaterModel
                                                                  .length -
                                                              1]
                                                      .waterIntake,
                                                ),
                                                Text(
                                                  '${data.waterIntake} ml',
                                                  style: kStyleTitle2.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: myColor
                                                        .primaryColorDark,
                                                  ),
                                                ),
                                                const SizedBox8(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0),
                                                  child: StreamBuilder<dynamic>(
                                                      initialData:
                                                          StaticDataModelForAnimation(
                                                        remainingWaterIntake:
                                                            formatNumber(double.parse(
                                                                remainingWaterIntake
                                                                    .toString())),
                                                      ),
                                                      stream:
                                                          staticAnimationBloc!
                                                              .stateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (double.parse(snapshot
                                                                .data
                                                                .remainingWaterIntake
                                                                .toString()) <
                                                            0) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.check,
                                                                size: 18.0,
                                                                color: kGreen,
                                                              ),
                                                              const SizedBox(
                                                                  width: 6.0),
                                                              Text(
                                                                'Daily water target met',
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  color: kBlack,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .water_drop_outlined,
                                                                    size: 15.0,
                                                                    color:
                                                                        kBlue,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          6.0),
                                                                  Text(
                                                                    'You should drink ${formatNumber(double.parse(snapshot.data.remainingWaterIntake.toString()))} ml more water today',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                    style: kStyleNormal
                                                                        .copyWith(
                                                                      color:
                                                                          kBlack,
                                                                      fontSize:
                                                                          12.0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox2(),
                                                              Text(
                                                                'Drinking ${formatNumber(getDrinkWaterModel[getDrinkWaterModel.length - 1].waterIntake! / 12)} ml / hour is best for you.',
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  color: kBlack,
                                                                  fontSize:
                                                                      11.0,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      }),
                                                ),
                                                const SizedBox24(),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0),
                                                  width: maxWidth(context),
                                                  child: StreamBuilder<dynamic>(
                                                      initialData: 0,
                                                      stream: pageViewBloc!
                                                          .stateStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.data ==
                                                            0) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  controller.nextPage(
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      curve: Curves
                                                                          .easeInOut);
                                                                  pageViewBloc!
                                                                      .storeData(
                                                                          0);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .keyboard_arrow_left_outlined,
                                                                        size:
                                                                            18.0,
                                                                        color: myColor
                                                                            .primaryColorDark),
                                                                    const SizedBox(
                                                                        width:
                                                                            5.0),
                                                                    Text(
                                                                      'Last Week',
                                                                      style: kStyleNormal
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12.0,
                                                                        color: myColor
                                                                            .primaryColorDark,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(
                                                                'This Week',
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Last Week',
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  controller.previousPage(
                                                                      duration: const Duration(
                                                                          milliseconds:
                                                                              400),
                                                                      curve: Curves
                                                                          .easeInOut);

                                                                  pageViewBloc!
                                                                      .storeData(
                                                                          1);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'This Week',
                                                                      style: kStyleNormal
                                                                          .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12.0,
                                                                        color: myColor
                                                                            .primaryColorDark,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5.0),
                                                                    Icon(
                                                                        Icons
                                                                            .keyboard_arrow_right_outlined,
                                                                        size:
                                                                            18.0,
                                                                        color: myColor
                                                                            .primaryColorDark),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      }),
                                                ),
                                                const SizedBox12(),
                                                SizedBox(
                                                  height: 200.0,
                                                  width: maxWidth(context),
                                                  child: PageView.builder(
                                                    reverse: true,
                                                    controller: controller,
                                                    itemCount: 2,
                                                    onPageChanged: (i) {
                                                      pageViewBloc!
                                                          .storeData(i);
                                                    },
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 12),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 16.0),
                                                        height: 200.0,
                                                        width:
                                                            maxWidth(context),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kWhite
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                12.0),
                                                          ),
                                                        ),
                                                        child: ListView.builder(
                                                            itemCount: data
                                                                .days!.length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            padding:
                                                                EdgeInsets.zero,
                                                            itemBuilder:
                                                                (context, i) {
                                                              return StreamBuilder<
                                                                      dynamic>(
                                                                  initialData:
                                                                      StaticDataModelForAnimation(
                                                                    percent: percentConverter(
                                                                        getDrinkWaterModel[getDrinkWaterModel.length -
                                                                                1]
                                                                            .waterIntake!,
                                                                        data.days![i]
                                                                            .intake!),
                                                                    waterIntake:
                                                                        formatNumber(data
                                                                            .days![i]
                                                                            .intake!),
                                                                  ),
                                                                  stream: staticAnimationBloc!
                                                                      .stateStream,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    return SizedBox(
                                                                      width:
                                                                          (maxWidth(context) / 7) -
                                                                              6,
                                                                      // margin: const EdgeInsets.only(right: 16),
                                                                      child:
                                                                          RotatedBox(
                                                                        quarterTurns:
                                                                            1,
                                                                        child:
                                                                            myLinearProgressIndicator(
                                                                          index == 1
                                                                              ? formatNumber(data.days![i].lastWeekIntake!)
                                                                              : i == dayIndex
                                                                                  ? snapshot.data.waterIntake
                                                                                  : formatNumber(data.days![i].intake!),
                                                                          index == 1
                                                                              ? percentConverter(getDrinkWaterModel[getDrinkWaterModel.length - 1].waterIntake!, data.days![i].lastWeekIntake!)
                                                                              : i == dayIndex
                                                                                  ? snapshot.data.percent
                                                                                  : percentConverter(getDrinkWaterModel[getDrinkWaterModel.length - 1].waterIntake!, data.days![i].intake!),
                                                                          data.days![i].day!.substring(
                                                                              0,
                                                                              3),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            }),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox12(),
                                                RotatedBox(
                                                  quarterTurns: 2,
                                                  child: SmoothPageIndicator(
                                                    controller: controller,
                                                    count: 2,
                                                    effect: ExpandingDotsEffect(
                                                        dotWidth: 6,
                                                        dotHeight: 6,
                                                        activeDotColor: myColor
                                                            .primaryColorDark,
                                                        spacing: 8,
                                                        dotColor: kWhite
                                                            .withOpacity(0.4)),
                                                  ),
                                                ),
                                                const SizedBox12(),
                                              ],
                                            ),
                                          );
                                        }
                                      case Status.ERROR:
                                        return Container(
                                          width: maxWidth(context),
                                          margin: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: Text('Server Error'),
                                          ),
                                        );
                                    }
                                  }
                                  return Container();
                                });
                          })),
                ),
              ],
            ),
          ),
          bottomNavigationBar: StreamBuilder<dynamic>(
              initialData: false,
              stream: showBottomNavBloc!.stateStream,
              builder: (context, snapshot) {
                if (snapshot.data == false) {
                  return Container(
                    color: myColor.dialogBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    width: maxWidth(context),
                    height: 1.0,
                  );
                } else {
                  return Container(
                    color: myColor.dialogBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    width: maxWidth(context),
                    height: 85.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox8(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 60.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Confirm that you ',
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'have drank ',
                                      style: kStyleNormal.copyWith(
                                        fontSize: 14.0,
                                      ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: myWaterConfirmation.toString(),
                                          style: kStyleNormal.copyWith(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ml',
                                          style: kStyleNormal.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder<dynamic>(
                                initialData: StaticDataModelForAnimation(
                                  waterIntake: formatNumber(double.parse(
                                      getDrinkWaterModel[
                                              getDrinkWaterModel.length - 1]
                                          .days![dayIndex]
                                          .intake!
                                          .toString())),
                                ),
                                stream: staticAnimationBloc!.stateStream,
                                builder: (context, snapshot) {
                                  return GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor:
                                              myColor.dialogBackgroundColor,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(20))),
                                          builder: ((builder) =>
                                              switchCupBottomSheet(double.parse(
                                                      snapshot.data.waterIntake
                                                          .toString()) +
                                                  double.parse(formatNumber(
                                                          double.parse(
                                                              myWaterConfirmation.toString()))
                                                      .toString()))));
                                    },
                                    child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor:
                                            myColor.primaryColorDark,
                                        child: StreamBuilder<dynamic>(
                                            initialData: 0,
                                            stream: loadingBloc!.stateStream,
                                            builder: (context, snapshot) {
                                              return snapshot.data == 1
                                                  ? const AnimatedWaterLoading()
                                                  : Icon(
                                                      Icons
                                                          .local_drink_outlined,
                                                      color: kWhite,
                                                    );
                                            })),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget settingsDrawer() {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
        color: myColor.dialogBackgroundColor,
        width: maxWidth(context) / 1.3,
        height: maxHeight(context),
        child: StatefulBuilder(builder: (context, s) {
          return Column(
            children: [
              Container(
                color: myColor.dialogBackgroundColor,
                width: maxWidth(context),
                height: 130.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Edit\n',
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Notifications',
                            style: kStyleNormal.copyWith(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      child: StreamBuilder<dynamic>(
                          initialData:
                              getDrinkWaterModel[getDrinkWaterModel.length - 1]
                                  .notificationStatus,
                          stream: notificationSwitchBloc!.stateStream,
                          builder: (context, snapshot) {
                            return Switch(
                              value: snapshot.data == 0 ? false : true,
                              onChanged: (value) async {
                                notificationSwitchBloc!
                                    .storeData(value == false ? 0 : 1);
                                int statusCode;
                                statusCode = await API().postData(
                                    context,
                                    PostDrinkWaterTimingsModel(
                                      notificationStatus:
                                          value == false ? 0 : 1,
                                    ),
                                    endpoints.postWaterNotifcationEndpoint);

                                if (statusCode == 200) {
                                  // _scaffoldKey.currentState!.closeEndDrawer();
                                  if (value == false) {
                                    sharedPrefs.storeToDevice(
                                        "waterNotification", "waterStatusOff");

                                    mySnackbar.mySnackBar(
                                        context,
                                        'Water reminder notification off',
                                        kRed);
                                  } else {
                                    sharedPrefs.storeToDevice(
                                        "waterNotification", "waterStatusOn");
                                    mySnackbar.mySnackBar(
                                        context,
                                        'Water reminder notification on',
                                        kGreen);
                                  }
                                } else {
                                  notificationSwitchBloc!
                                      .storeData(value == false ? 1 : 0);
                                }
                              },
                              activeTrackColor:
                                  myColor.primaryColorDark.withOpacity(0.3),
                              activeColor: myColor.primaryColorDark,
                              inactiveTrackColor: kWhite.withOpacity(0.4),
                              inactiveThumbColor: kWhite.withOpacity(0.4),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              settingsCard(
                  showCircle: false,
                  data: getDrinkWaterModel[getDrinkWaterModel.length - 1])
            ],
          );
        }),
      ),
    );
  }

  Widget waterCircularPercentIndicator(intake, maxIntake) {
    return StreamBuilder<dynamic>(
        initialData: StaticDataModelForAnimation(
          percent: percentConverter(double.parse(maxIntake.toString()),
              double.parse(intake.toString())),
          waterIntake: formatNumber(double.parse(intake.toString())),
        ),
        stream: staticAnimationBloc!.stateStream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 13.0,
                animation: true,
                animationDuration: 2000,
                progressColor: myColor.primaryColorDark,
                percent: intake == null ? 0 : snapshot.data.percent,
                animateFromLastPercent: true,
                backgroundColor: kWhite.withOpacity(0.2),
                center: Text(
                  snapshot.data.waterIntake ?? 'null',
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.square,
              ),
              const SizedBox12(),
            ],
          );
        });
  }

  Widget myLinearProgressIndicator(value, percent, week) {
    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      trailing: RotatedBox(
        quarterTurns: -1,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            week.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: myColor.primaryColorDark,
            ),
          ),
        ),
      ),
      lineHeight: 12.0,
      isRTL: true,
      backgroundColor: myColor.dialogBackgroundColor,
      center: Text(
        value.toString(),
        style: kStyleNormal.copyWith(fontSize: 11.0),
      ),
      animation: true,
      animationDuration: 1000,
      percent: percent,
      progressColor: myColor.primaryColorDark,
    );
  }

  void _onFormChanged() {
    if (!_formChanged) {
      formBloc!.storeData(true);
    }
  }

  Widget settingsCard({showCircle, required data}) {
    if (showCircle == false) {
      unit = data!.intervalUnit.toString();
      interval = data.interval.toString();
    } else {
      unit ??= listOfTimeUnit[0].name.toString();
      interval ??= listOfHourInterval[0].name.toString();
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox16(),
            showCircle == false
                ? Container()
                : Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 50.0,
                        lineWidth: 13.0,
                        animation: true,
                        animationDuration: 2000,
                        progressColor: myColor.primaryColorDark,
                        percent: 1,
                        animateFromLastPercent: true,
                        backgroundColor: kWhite.withOpacity(0.2),
                        center: Text(
                          double.parse(waterToDrinkDaily.toString()) % 1 == 0
                              ? double.parse(waterToDrinkDaily.toString())
                                  .toStringAsFixed(0)
                                  .toString()
                              : waterToDrinkDaily!,
                          style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.square,
                      ),
                      const SizedBox16(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            size: 15.0,
                            color: kBlue,
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            'You should drink ${double.parse(waterToDrinkDaily.toString()) % 1 == 0 ? double.parse(waterToDrinkDaily.toString()).toStringAsFixed(0).toString() : waterToDrinkDaily} ml water everyday',
                            style: kStyleNormal.copyWith(
                              color: kBlack,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox16(),
                      Text(
                        'Set up reminder',
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox12(),
                    ],
                  ),
            Form(
              key: _form,
              onChanged: _onFormChanged,
              child: SizedBox(
                width: maxWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox12(),
                    Text(
                      'Start Time',
                      style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    const SizedBox16(),
                    myTimePicker(
                      context,
                      startTime,
                      data != null && data.startTime != null
                          ? data.startTime
                          : 'Start Time',
                      kWhite.withOpacity(0.2),
                      'Start Time',
                      onValueChanged: (v) {
                        startTime = v;
                        formBloc!.storeData(true);
                        setState(() {});
                      },
                    ),
                    const SizedBox16(),
                    Text(
                      'End Time',
                      style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    const SizedBox16(),
                    myTimePicker(
                        context,
                        endTime,
                        data != null && data.endTime != null
                            ? data.endTime
                            : 'End Time',
                        kWhite.withOpacity(0.4),
                        'Please select end time', onValueChanged: (v) {
                      endTime = v;
                      formBloc!.storeData(true);
                    }),
                    const SizedBox16(),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interval',
                                style: kStyleNormal.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              const SizedBox16(),
                              myDropDown2(
                                  context,
                                  Icons.timer,
                                  kBlack,
                                  kBlack,
                                  maxWidth(context),
                                  data != null && data.interval != null
                                      ? interval
                                      : interval,
                                  unit == 'hours'
                                      ? listOfHourInterval
                                      : listOfMinuteInterval,
                                  kWhite.withOpacity(0.4), onValueChanged: (v) {
                                setState(() {
                                  interval = v.name;
                                });
                                formBloc!.storeData(true);
                              }),
                              const SizedBox16(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Unit',
                                style: kStyleNormal.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              const SizedBox16(),
                              myDropDown2(
                                  context,
                                  Icons.timer,
                                  kBlack,
                                  kBlack,
                                  maxWidth(context),
                                  data != null && data.intervalUnit != null
                                      ? data.intervalUnit
                                      : unit,
                                  listOfTimeUnit,
                                  kWhite.withOpacity(0.4), onValueChanged: (v) {
                                setState(() {
                                  unit = v.name;
                                  if (unit == 'hours') {
                                    interval =
                                        listOfHourInterval[0].name.toString();
                                  } else {
                                    interval =
                                        listOfMinuteInterval[0].name.toString();
                                  }
                                });
                                formBloc!.storeData(true);
                              }),
                              const SizedBox16(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox16(),
            StreamBuilder<dynamic>(
                initialData: false,
                stream: postTimingLoadingBloc!.stateStream,
                builder: (context, snapshot) {
                  return snapshot.data == true
                      ? myBtnLoading(context, 50.0)
                      : StreamBuilder<dynamic>(
                          initialData: getDrinkWaterModel.isEmpty
                              ? 1
                              : getDrinkWaterModel[
                                      getDrinkWaterModel.length - 1]
                                  .notificationStatus,
                          stream: notificationSwitchBloc!.stateStream,
                          builder: (context, data) {
                            return StreamBuilder<dynamic>(
                                initialData: false,
                                stream: formBloc!.stateStream,
                                builder: (context, formData) {
                                  return SizedBox(
                                    width: maxWidth(context),
                                    height: 50.0,
                                    child: myCustomButton(
                                      context,
                                      showCircle == false &&
                                              formData.data == false
                                          ? myColor.primaryColorDark
                                              .withOpacity(0.12)
                                          : myColor.primaryColorDark,
                                      showCircle == false
                                          ? 'Update'
                                          : 'Proceed',
                                      kStyleNormal.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: kWhite),
                                      () {
                                        if (showCircle == false &&
                                            formData.data == false) {
                                        } else {
                                          postTiming(
                                            showCircle == false
                                                ? 'admin/water-intake/update/${getDrinkWaterModel[getDrinkWaterModel.length - 1].id}'
                                                : endpoints
                                                    .postDrinkWaterTimingsEndpoint,
                                            data.data,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                });
                          });
                })
          ],
        ),
      ),
    );
  }

  postTiming(endpoint, notificationStatus) async {
    myfocusRemover(context);
    bool? isValid;
    if (endpoint == endpoints.postDrinkWaterTimingsEndpoint) {
      isValid = _form.currentState?.validate();
    } else {
      isValid = true;
    }
    if (!isValid!) {
      return;
    } else {
      postTimingLoadingBloc!.storeData(true);
      int statusCode;
      statusCode = await API().postData(
          context,
          PostDrinkWaterTimingsModel(
            endTime: endTime ??
                getDrinkWaterModel[getDrinkWaterModel.length - 1].endTime,
            notificationStatus: notificationStatus,
            interval: int.parse(interval.toString()),
            intervalUnit: unit,
            startTime: startTime ??
                getDrinkWaterModel[getDrinkWaterModel.length - 1].startTime,
            waterIntake: double.parse(waterToDrinkDaily.toString()) % 1 == 0
                ? double.parse(
                    double.parse(waterToDrinkDaily!).toStringAsFixed(0))
                : double.parse(waterToDrinkDaily!),
          ),
          endpoint);

      if (statusCode == 200) {
        if (endpoint == endpoints.postDrinkWaterTimingsEndpoint) {
          refreshDrinkWaterBloc!.storeData('refresh');
          sharedPrefs.storeToDevice("waterNotification", "waterStatusOn");
        } else {
          Navigator.pop(context);
        }
        sharedPrefs.storeBooleanToDevice("waterNotification", true);
        postTimingLoadingBloc!.storeData(false);
      } else {
        postTimingLoadingBloc!.storeData(false);
      }
    }
  }

  Widget switchCupBottomSheet(water) {
    return StatefulBuilder(builder: (context, s) {
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox16(),
                  SizedBox(
                    width: maxWidth(context),
                    height: 230.0,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: myWaterDatabaseModel.length == 6
                          ? myWaterDatabaseModel.length
                          : myWaterDatabaseModel.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (myWaterDatabaseModel.length == 6) {
                          return gridCard(
                              index, myWaterDatabaseModel[index], s);
                        } else {
                          if (index == myWaterDatabaseModel.length) {
                            return GestureDetector(
                              onTap: () {
                                addWaterCupDialog();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox2(),
                                    const SizedBox2(),
                                    Expanded(
                                      flex: 2,
                                      child: Icon(FontAwesomeIcons.plus,
                                          size: 30.0,
                                          color: myColor.primaryColorDark),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Add Cup',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 13.0,
                                          color: myColor.primaryColorDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox2(),
                                    const SizedBox2(),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return gridCard(
                                index, myWaterDatabaseModel[index], s);
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox16(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Confirm that you ',
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'have drank ',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: myWaterConfirmation.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ml',
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          postWaterIntakeBtn(water +
                              double.parse(myWaterConfirmation.toString()));
                        },
                        child: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: myColor.primaryColorDark,
                            child: Icon(
                              Icons.check,
                              color: kWhite,
                            )),
                      ),
                    ],
                  ),
                ])),
      );
    });
  }

  Widget gridCard(index, MyWaterDatabaseModel data, state) {
    return GestureDetector(
      onTap: () {
        updateWaterCup(data.id, state);
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox2(),
            const SizedBox2(),
            Expanded(
              flex: 2,
              child: Icon(
                  index == 0
                      ? FontAwesomeIcons.mugHot
                      : index == 1
                          ? FontAwesomeIcons.mugSaucer
                          : index == 2
                              ? FontAwesomeIcons.glassWaterDroplet
                              : index == 3
                                  ? FontAwesomeIcons.glassWater
                                  : index == 4
                                      ? FontAwesomeIcons.whiskeyGlass
                                      : index == 5
                                          ? FontAwesomeIcons.bottleWater
                                          : index == 5
                                              ? FontAwesomeIcons.beerMugEmpty
                                              : FontAwesomeIcons.beerMugEmpty,
                  size: 30.0,
                  color: myWaterConfirmation == data.water
                      ? myColor.primaryColorDark
                      : myColor.primaryColorDark.withOpacity(0.2)),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${data.water} ml',
                style: kStyleNormal.copyWith(
                  fontSize: 13.0,
                  color: myWaterConfirmation == data.water
                      ? myColor.primaryColorDark
                      : myColor.primaryColorDark.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox2(),
            const SizedBox2(),
          ],
        ),
      ),
    );
  }

  addWaterCupDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            backgroundColor: myColor.dialogBackgroundColor,
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      backgroundColor: myColor.primaryColorDark,
                      child: Icon(Icons.close, color: kWhite),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox16(),
                    Text(
                      'Customize Cup',
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox16(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.beerMugEmpty,
                          color: myColor.primaryColorDark,
                          size: 40.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: myNumberTextFormFieldWithoutIcon(
                            '',
                            '',
                            _waterCupText,
                            kWhite.withOpacity(0.4),
                            onValueChanged: (v) {
                              _waterCupText = v;
                            },
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          'ml',
                          style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox16(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      width: maxWidth(context),
                      child: SizedBox(
                        width: maxWidth(context),
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Add Cup',
                          kStyleNormal.copyWith(fontSize: 16.0, color: kWhite),
                          () async {
                            List<String> testList = [];
                            testList.clear();
                            for (var element in myWaterDatabaseModel) {
                              if (_waterCupText == element.water) {
                                testList.add('a');
                              }
                            }
                            if (testList.isEmpty) {
                              MyWaterDatabaseModel addWaterCup;
                              addWaterCup = MyWaterDatabaseModel(
                                  userID: userID, water: _waterCupText);
                              await MyDatabase.instance
                                  .addWaterToLocalDB(addWaterCup);
                              myWaterDatabaseModel = await MyDatabase.instance
                                  .fetchWaterCupData(userID);
                              setState(() {});
                              Navigator.of(context).pop();
                              showCupErrorBloc!.storeData(false);
                            } else {
                              showCupErrorBloc!.storeData(true);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox12(),
                    StreamBuilder<dynamic>(
                        initialData: false,
                        stream: showCupErrorBloc!.stateStream,
                        builder: (context, snapshot) {
                          return snapshot.data == false
                              ? Container()
                              : Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '$_waterCupText ml cup already exist',
                                    style: kStyleNormal.copyWith(
                                      color: kRed,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                );
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class AnimatedWaterLoading extends StatefulWidget {
  const AnimatedWaterLoading({Key? key}) : super(key: key);

  @override
  State<AnimatedWaterLoading> createState() => _AnimatedWaterLoadingState();
}

class _AnimatedWaterLoadingState extends State<AnimatedWaterLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _currentIndex++;
          if (_currentIndex == 3) {
            _currentIndex = 0;
          }
          _animationController!.reset();
          _animationController!.forward();
        }
      });
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Container(
          alignment: Alignment.topCenter,
          height: 12.0,
          child: ListView.builder(
              itemCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return FittedBox(
                  child: Icon(
                    Icons.water_drop_outlined,
                    color:
                        kWhite.withOpacity(index == _currentIndex ? 1.0 : 0.2),
                  ),
                );
              }),
        );
      },
    );
  }
}

class StaticDataModelForAnimation {
  String? waterIntake;
  double? percent;
  String? remainingWaterIntake;

  StaticDataModelForAnimation(
      {this.waterIntake, this.percent, this.remainingWaterIntake});
}
