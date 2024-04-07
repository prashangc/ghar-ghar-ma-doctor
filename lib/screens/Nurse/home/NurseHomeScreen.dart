import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/GetAppointmentsInNurseSideModel.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Nurse/appointment/nurseAppointmentTabBarView.dart';
import 'package:ghargharmadoctor/screens/Nurse/sideNavigation/myShifts/MyShifts.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

StateHandlerBloc refreshNurseTimingBloc = StateHandlerBloc();

class NurseHomeScreen extends StatefulWidget {
  const NurseHomeScreen({Key? key}) : super(key: key);

  @override
  State<NurseHomeScreen> createState() => _NurseHomeScreenState();
}

class _NurseHomeScreenState extends State<NurseHomeScreen> {
  NurseProfileModel? profileModel;
  PageController _pageController = PageController();
  int activeIndex = 0;
  ApiHandlerBloc? shiftBloc, appointmentBloc;
  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("nurseProfile");
    profileModel = NurseProfileModel.fromJson(json.decode(test));
    _refresh();
  }

  _refresh() {
    shiftBloc = ApiHandlerBloc();
    shiftBloc!.fetchAPIList(endpoints.getIndividualNurseShiftsEndpoints);
    appointmentBloc = ApiHandlerBloc();
    appointmentBloc!.fetchAPIList(endpoints.getAppointmentsInNurseSide);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myColor.dialogBackgroundColor,
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: maxWidth(context),
          height: maxHeight(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: maxWidth(context),
                color: myColor.dialogBackgroundColor,
                height: 6.0,
              ),
              logoCard(),
              appointmentCard(),
              const SizedBox32(),
              const SizedBox12(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      timingCard(),
                      const SizedBox16(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: pendingAppointmentList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      width: maxWidth(context),
      color: myColor.dialogBackgroundColor,
      child: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/gd_logo_banner.png',
                  width: maxWidth(context) / 2,
                  height: 70.0,
                  fit: BoxFit.cover,
                ),
                CircleAvatar(
                  backgroundColor: kWhite.withOpacity(0.4),
                  radius: 25.0,
                  child: myCachedNetworkImageCircle(
                    50.0,
                    50.0,
                    profileModel!.imagePath,
                    BoxFit.cover,
                  ),
                )
              ]),
          const SizedBox8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NNC No. : ${profileModel!.nncNo}',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: myColor.primaryColorDark,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Rating : 5',
                    // 'Rating : ${profileModel!.averageRating}',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: myColor.primaryColorDark,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(
                    Icons.star,
                    color: kAmber,
                    size: 14.0,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget appointmentCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: maxWidth(context),
          height: 70.0,
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          child: Row(
            children: [
              appointmentCountCard(kAmber, 'Pending', Icons.timer, '40'),
              const SizedBox(width: 12.0),
              appointmentCountCard(
                  kGreen, 'Completed', Icons.check_circle_outline, '40'),
              const SizedBox(width: 12.0),
              appointmentCountCard(
                  kRed, 'Cancelled', Icons.remove_circle_outline, '40'),
              const SizedBox(width: 12.0),
              appointmentCountCard(
                  myColor.primaryColorDark, 'Total', Icons.date_range, '40'),
            ],
          ),
        ),
      ],
    );
  }

  Widget appointmentCountCard(cardColor, text, icon, value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          border: Border.all(color: cardColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              Text(
                text,
                overflow: TextOverflow.clip,
                style: kStyleNormal.copyWith(
                  fontSize: 10.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox8(),
              Icon(
                icon,
                size: 24.0,
                color: cardColor,
              ),
              const SizedBox8(),
              Text(
                value,
                style: kStyleNormal.copyWith(
                  fontSize: 16.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget timingCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Timing Availability',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
        const SizedBox16(),
        StreamBuilder<dynamic>(
            initialData: '',
            stream: refreshNurseTimingBloc.stateStream,
            builder: (cc, ss) {
              if (ss.data == 'refresh') {
                shiftBloc = ApiHandlerBloc();
                shiftBloc!
                    .fetchAPIList(endpoints.getIndividualNurseShiftsEndpoints);
              }
              return StreamBuilder<ApiResponse<dynamic>>(
                stream: shiftBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return Container(
                          width: maxWidth(context),
                          margin:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          height: 160.0,
                          decoration: BoxDecoration(
                            color: myColor.dialogBackgroundColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: const AnimatedLoading(),
                        );
                      case Status.COMPLETED:
                        List<GetIndividualNurseShifts>
                            getIndividualNurseShifts =
                            List<GetIndividualNurseShifts>.from(
                                snapshot.data!.data.map((i) =>
                                    GetIndividualNurseShifts.fromJson(i)));
                        if (getIndividualNurseShifts.isEmpty) {
                          return Container(
                            width: maxWidth(context),
                            margin:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            decoration: BoxDecoration(
                              color: myColor.dialogBackgroundColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox16(),
                                Icon(
                                  Icons.timer,
                                  size: 24.0,
                                  color: myColor.primaryColorDark,
                                ),
                                const SizedBox16(),
                                Text(
                                  'You haven\'t set your shift schedule',
                                  style: kStyleNormal.copyWith(
                                    letterSpacing: 0.5,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox8(),
                                Text(
                                  'Add appointment shifts to receive appointments.',
                                  style: kStyleNormal.copyWith(
                                    color: kBlack,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox16(),
                                GestureDetector(
                                  onTap: () {
                                    goThere(context,
                                        const MyShifts(isHomepage: true));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: myColor.primaryColorDark,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 18.0),
                                    width: maxWidth(context) / 3,
                                    height: 45,
                                    child: Center(
                                      child: Text(
                                        'Set Shift',
                                        style: kStyleNormal.copyWith(
                                          color: myColor.primaryColorDark,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  height: 160.0,
                                  autoPlay: false,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: false,
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 400),
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                    _pageController =
                                        PageController(initialPage: index);
                                  }),
                              itemCount: getIndividualNurseShifts.length,
                              itemBuilder: (context, index, realIndex) {
                                return nurseScheduleCard(
                                    getIndividualNurseShifts[index]);
                              },
                            ),
                            const SizedBox12(),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: getIndividualNurseShifts.length,
                              effect: ExpandingDotsEffect(
                                  dotWidth: 6,
                                  dotHeight: 6,
                                  activeDotColor: myColor.primaryColorDark,
                                  spacing: 8,
                                  dotColor: myColor.dialogBackgroundColor),
                            ),
                          ],
                        );

                      case Status.ERROR:
                        return Container(
                          width: maxWidth(context),
                          height: 135.0,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  return const SizedBox();
                }),
              );
            }),
      ],
    );
  }

  Widget nurseScheduleCard(GetIndividualNurseShifts data) {
    String getWeekNameFromDate(DateTime date) {
      final df = DateFormat('EEEE', 'en');
      return df.format(date);
    }

    DateTime myDate = DateTime.parse(data.date.toString());
    String weekName = getWeekNameFromDate(myDate);

    return Container(
      width: maxWidth(context),
      margin: const EdgeInsets.only(left: 12.0, right: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      height: 160.0,
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: kStyleNormal,
                  children: [
                    TextSpan(
                      text: '${data.date.toString().substring(8, 10)} ',
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${getMonth(data.date.toString())}, ${data.date.toString().substring(0, 4)}\n',
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: weekName,
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  FontAwesomeIcons.userNurse,
                  size: 16.0,
                  color: myColor.primaryColorDark,
                ),
              ),
            ],
          ),
          const SizedBox16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${data.shift.toString().substring(0, 1)} ',
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data.shift.toString().substring(2, 4),
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Container(color: myColor.primaryColorDark, height: 2.0),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: myColor.primaryColorDark, width: 2.0),
                ),
                child: Text(
                  '7\n hours',
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    fontSize: 10.0,
                  ),
                ),
              ),
              Expanded(
                child: Container(color: myColor.primaryColorDark, height: 2.0),
              ),
              const SizedBox(width: 10.0),
              Text(
                '${data.shift.toString().substring(7, 8)} ',
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data.shift.toString().substring(9, 11),
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8,
                ),
              ),
            ],
          ),
          const SizedBox16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 15.0,
                color: myColor.primaryColorDark,
              ),
              Text(
                'Norvic Hospital',
                style: kStyleNormal.copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox2(),
          Text(
            'Kalanki, KTM',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget pendingAppointmentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Appointments',
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const SizedBox16(),
        StreamBuilder<ApiResponse<dynamic>>(
          stream: appointmentBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Container(
                    width: maxWidth(context),
                    height: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      color: myColor.dialogBackgroundColor,
                    ),
                    child: const Center(
                      child: AnimatedLoading(),
                    ),
                  );
                case Status.COMPLETED:
                  if (snapshot.data!.data.isEmpty) {
                    return Container(
                      width: maxWidth(context),
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        color: myColor.dialogBackgroundColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox16(),
                          Icon(
                            Icons.date_range,
                            size: 24.0,
                            color: myColor.primaryColorDark,
                          ),
                          const SizedBox16(),
                          Text(
                            'No any pending appointments',
                            style: kStyleNormal.copyWith(
                              letterSpacing: 0.5,
                              color: myColor.primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  List<GetAppointmentsInNurseSideModel>
                      getAppointmentsInNurseSide =
                      List<GetAppointmentsInNurseSideModel>.from(
                          snapshot.data!.data.map((i) =>
                              GetAppointmentsInNurseSideModel.fromJson(i)));
                  List<GetAppointmentsInNurseSideModel> pendingModel =
                      getAppointmentsInNurseSide
                          .where((element) =>
                              element.bookingStatus == 'Scheduled' ||
                              element.bookingStatus == 'Not Scheduled')
                          .toList();

                  return NurseSideAppoinmentTabBarView(
                    nurseAppointmentListModel: pendingModel,
                    isHomepage: true,
                  );

                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
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
        ),
      ],
    );
  }
}
