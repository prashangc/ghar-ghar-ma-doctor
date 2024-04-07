import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  String _stepCount = '3000';
  String? humanStatus;
  PageController controller = PageController();
  StateHandlerBloc pageViewBloc = StateHandlerBloc();
  StateHandlerBloc isWalkingBloc = StateHandlerBloc();
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  ApiHandlerBloc? stepCountApiBloc;

  @override
  void initState() {
    super.initState();
    stepCountApiBloc = ApiHandlerBloc();
    stepCountApiBloc!.fetchAPIList(endpoints.getStepCountHistoryEndpoint);
  }

  void startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

    // _stepCountStream!.listen((StepCount stepCount) {
    //   setState(() {
    //     _stepCount = stepCount.steps.toString();
    //   });
    //   print('hello steps -  $_stepCount ');
    // });
    _stepCountStream!.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream!
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _pedestrianStatusStream!.listen((PedestrianStatus status) {
      setState(() {
        humanStatus = status.toString();
      });
    });
  }

  void onStepCount(StepCount event) {
    int steps = event.steps;
    DateTime timeStamp = event.timeStamp;
    setState(() {
      _stepCount = event.steps.toString();
    });
    if (_stepCount == '4000' || _stepCount == '8000' || _stepCount == '10000') {
      updateStepCountMth();
    }
  }

  updateStepCountMth() async {
    int statusCode = await API().postData(
        context,
        PostStepCountModel(
          credit: 1,
          stepsCount: int.parse(_stepCount.toString()),
        ),
        endpoints.postStepCountEndpoint);
    if (statusCode == 200) {
      myToast.toast("success");
    } else {
      myToast.toast("error");
    }
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    /// Handle status changed
    String status = event.status;
    DateTime timeStamp = event.timeStamp;
  }

  void onPedestrianStatusError(error) {
    print('hello steps onPedestrianStatusError $error');

    /// Handle the error
  }

  void onStepCountError(error) {
    /// Handle the error
    print('hello steps onStepCountError $error');
  }

  @override
  void dispose() {
    super.dispose();
    stopListening();
  }

  void startAccelerometer() {
    MotionSensors().accelerometer.listen((AccelerometerEvent event) {
      double accelerationMagnitude =
          event.x.abs() + event.y.abs() + event.z.abs();
      double speed = accelerationMagnitude;
      print('Speed: $speed m/s');
    });
  }

  void stopListening() {
    // _stepCountStream!.cancel();
    // _pedestrianStatusStream!.cancel();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Row(
              children: [
                const SizedBox(width: 12.0),
                SizedBox(
                  width: 65,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: myColor.scaffoldBackgroundColor,
                      ),
                      margin: const EdgeInsets.only(right: 15.0, top: 12),
                      child: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black,
                        size: 35.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Steps Count',
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
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 12.0),
                    height: 50.0,
                    child: Icon(
                      FontAwesomeIcons.award,
                      color: myColor.primaryColorDark,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
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
                  child: Column(
                    children: [
                      const SizedBox12(),
                      GestureDetector(
                        onTap: () {
                          updateStepCountMth();
                          // startAccelerometer();
                        },
                        child: Text(
                          '$_stepCount Steps',
                          style: kStyleTitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                      ),
                      const SizedBox8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 15.0,
                            color: Color(0xFFEB5757),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '300 more steps then yesterday',
                            style: kStyleNormal.copyWith(
                              color: kBlack,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            humanStatus == 'walking'
                                ? Icons.directions_walk
                                : humanStatus == 'stopped'
                                    ? Icons.accessibility_new
                                    : Icons.error,
                            size: 15.0,
                            color: humanStatus == null
                                ? const Color(0xFFEB5757)
                                : myColor.primaryColorDark,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            humanStatus ?? 'Not active',
                            style: kStyleNormal.copyWith(
                              color: kRed,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox24(),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              myHistoryCard(),
                              const SizedBox16(),
                              myTimelineCard(),
                              const SizedBox12(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: maxWidth(context),
        color: myColor.dialogBackgroundColor,
        height: 60.0,
        child: StreamBuilder<dynamic>(
            initialData: false,
            stream: isWalkingBloc.stateStream,
            builder: (c, s) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                width: maxWidth(context),
                height: 50.0,
                child: myCustomButton(
                  context,
                  myColor.primaryColorDark,
                  s.data == false ? 'Start Walking' : 'Stop Walking',
                  kStyleNormal.copyWith(
                      color: kWhite,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  () {
                    isWalkingBloc.storeData(!s.data);
                    if (s.data == false) {
                      startListening();
                    } else {
                      stopListening();
                    }
                  },
                ),
              );
            }),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 20.0,
        ),
        height: maxHeight(context),
        child: StatefulBuilder(builder: (context, s) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: myColor.dialogBackgroundColor,
                width: maxWidth(context),
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'View\n',
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Rewards',
                            style: kStyleNormal.copyWith(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox16(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: kWhite.withOpacity(0.4),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                width: maxWidth(context),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.award,
                      color: myColor.primaryColorDark,
                      size: 28.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'GD Points',
                                    style: kStyleNormal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    size: 12.0,
                                  ),
                                ],
                              ),
                              Text(
                                '30 GD-P',
                                style: kStyleNormal.copyWith(
                                  fontSize: 16.0,
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox2(),
                          Text(
                            'You can redeem GD points for payments.',
                            style: kStyleNormal.copyWith(
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget myLinearProgressIndicator(value, percent, week) {
    return LinearPercentIndicator(
      trailing: RotatedBox(
        quarterTurns: -1,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            week,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: myColor.primaryColorDark,
            ),
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      lineHeight: 12.0,
      barRadius: const Radius.circular(10.0),
      backgroundColor: myColor.dialogBackgroundColor,
      center: Text(
        value,
        style: kStyleNormal.copyWith(fontSize: 11.0),
      ),
      animation: true,
      animationDuration: 1000,
      percent: percent,
      progressColor: myColor.primaryColorDark,
    );
  }

  Widget myTimelineCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stepCountTimlineList.length,
          itemBuilder: (c, i) {
            return SizedBox(
              width: maxWidth(context),
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: myColor.primaryColorDark,
                        radius: 10.0,
                        child: CircleAvatar(
                          backgroundColor: int.parse(_stepCount.toString()) <
                                  int.parse(
                                      stepCountTimlineList[i].steps.toString())
                              ? myColor.dialogBackgroundColor
                              : myColor.primaryColorDark,
                          radius: 8.0,
                        ),
                      ),
                      int.parse(_stepCount.toString()) <
                              int.parse(
                                  stepCountTimlineList[i].steps.toString())
                          ? SizedBox(
                              height: 80.0,
                              child: Column(
                                children: List.generate(8, (i) {
                                  return Container(
                                    color: i.isEven
                                        ? myColor.primaryColorDark
                                        : kTransparent,
                                    width: 2,
                                    height: 10,
                                  );
                                }),
                              ),
                            )
                          : Container(
                              color: myColor.primaryColorDark,
                              width: 2.0,
                              height: 80.0,
                            ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      height: 100.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${stepCountTimlineList[i].steps} steps',
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                width: maxWidth(context),
                                decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        stepCountTimlineList[i].text.toString(),
                                        style: kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_up_sharp,
                                          color: kGreen,
                                          size: 18.0,
                                        ),
                                        Text(
                                          '1',
                                          style: kStyleNormal.copyWith(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: kGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
    // SizedBox(
    //   height: 200.0,
    //   child: Timeline.tileBuilder(
    //     scrollDirection: Axis.vertical,
    //     builder: TimelineTileBuilder.fromStyle(
    //       contentsAlign: ContentsAlign.alternating,
    //       contentsBuilder: (context, index) => Padding(
    //         padding: const EdgeInsets.all(24.0),
    //         child: Text('Timeline Event $index'),
    //       ),
    //       itemCount: 10,
    //     ),
    //   ),
    // );
  }

  double percentConverter(step) {
    double percentage = (step / 10000) * 100;
    double percentValue = percentage / 100;
    return percentValue > 1 ? 1 : percentValue;
  }

  Widget myHistoryCard() {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: stepCountApiBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                width: maxWidth(context),
                height: maxHeight(context) / 4,
                decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const AnimatedLoading(),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: maxHeight(context) / 4,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('No History')));
              }
              List<GetStepCountHistory> getStepCountHistory =
                  List<GetStepCountHistory>.from(snapshot.data!.data
                      .map((i) => GetStepCountHistory.fromJson(i)));
              return Column(
                children: [
                  getStepCountHistory.length == 1
                      ? Text(
                          'This Week',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: StreamBuilder<dynamic>(
                              initialData: 0,
                              stream: pageViewBloc.stateStream,
                              builder: (context, snapshot) {
                                if (snapshot.data == 0) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut);
                                          pageViewBloc.storeData(0);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                                Icons
                                                    .keyboard_arrow_left_outlined,
                                                size: 18.0,
                                                color:
                                                    myColor.primaryColorDark),
                                            const SizedBox(width: 5.0),
                                            Text(
                                              'Last Week',
                                              style: kStyleNormal.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                                color: myColor.primaryColorDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'This Week',
                                        style: kStyleNormal.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Last Week',
                                        style: kStyleNormal.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut);

                                          pageViewBloc.storeData(1);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'This Week',
                                              style: kStyleNormal.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                                color: myColor.primaryColorDark,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            Icon(
                                                Icons
                                                    .keyboard_arrow_right_outlined,
                                                size: 18.0,
                                                color:
                                                    myColor.primaryColorDark),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                        ),
                  const SizedBox12(),
                  getStepCountHistory.length == 1
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          height: 200.0,
                          margin: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.4),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: ListView.builder(
                              itemCount: getStepCountHistory[0].step!.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, i) {
                                return SizedBox(
                                  width: (maxWidth(context) - 24) /
                                      getStepCountHistory[0].step!.length,
                                  // margin: const EdgeInsets.only(right: 16),
                                  child: Center(
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: myLinearProgressIndicator(
                                        getStepCountHistory[0]
                                            .step![i]
                                            .stepCount
                                            .toString(),
                                        percentConverter(getStepCountHistory[0]
                                            .step![i]
                                            .stepCount),
                                        getStepCountHistory[0]
                                            .step![i]
                                            .day!
                                            .substring(0, 3),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : SizedBox(
                          height: 200.0,
                          width: maxWidth(context),
                          child: PageView.builder(
                            reverse: true,
                            controller: controller,
                            itemCount: 2,
                            onPageChanged: (i) {
                              pageViewBloc.storeData(i);
                            },
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                height: 200.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: ListView.builder(
                                    itemCount:
                                        getStepCountHistory[0].step!.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, i) {
                                      return SizedBox(
                                        width: (maxWidth(context) - 24) /
                                            getStepCountHistory[0].step!.length,
                                        // margin: const EdgeInsets.only(right: 16),
                                        child: Center(
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: myLinearProgressIndicator(
                                              index == 0
                                                  ? getStepCountHistory[0]
                                                      .step![
                                                          getStepCountHistory[0]
                                                                  .step!
                                                                  .length -
                                                              1]
                                                      .stepCount
                                                      .toString()
                                                  : getStepCountHistory[0]
                                                      .step![
                                                          getStepCountHistory[0]
                                                                  .step!
                                                                  .length -
                                                              2]
                                                      .stepCount
                                                      .toString(),
                                              percentConverter(
                                                index == 0
                                                    ? getStepCountHistory[0]
                                                        .step![
                                                            getStepCountHistory[
                                                                        0]
                                                                    .step!
                                                                    .length -
                                                                1]
                                                        .stepCount
                                                        .toString()
                                                    : getStepCountHistory[0]
                                                        .step![
                                                            getStepCountHistory[
                                                                        0]
                                                                    .step!
                                                                    .length -
                                                                2]
                                                        .stepCount
                                                        .toString(),
                                              ),
                                              getStepCountHistory[0]
                                                  .step![0]
                                                  .day!
                                                  .substring(0, 3),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            },
                          ),
                        ),
                  getStepCountHistory.length == 1
                      ? Container()
                      : const SizedBox12(),
                  getStepCountHistory.length == 1
                      ? Container()
                      : RotatedBox(
                          quarterTurns: 2,
                          child: SmoothPageIndicator(
                            controller: controller,
                            count: 2,
                            effect: ExpandingDotsEffect(
                                dotWidth: 6,
                                dotHeight: 6,
                                activeDotColor: myColor.primaryColorDark,
                                spacing: 8,
                                dotColor: kWhite.withOpacity(0.4)),
                          ),
                        ),
                ],
              );
            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 135.0,
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Server Error'),
                ),
              );
          }
        }
        return const SizedBox();
      }),
    );
  }
}
