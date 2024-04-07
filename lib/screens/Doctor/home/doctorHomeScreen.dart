import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAppointmentsInDoctorSide.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetIndividualDoctorTimings.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/appointmentTabBarView/DoctorSideAppointmentListTabView.dart';
import 'package:ghargharmadoctor/screens/Doctor/side%20navigation/Schedule/DoctorTimings.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

StateHandlerBloc refreshDoctorTimingBloc = StateHandlerBloc();

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  DoctorProfileModel? profileModel;
  ApiHandlerBloc? timeBloc, appointmentBloc;
  PageController _pageController = PageController();
  int activeIndex = 0;
  var locationEnabled;
  LocationData? _currentPosition;
  final Location location = Location();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("doctorProfile");
    profileModel = DoctorProfileModel.fromJson(json.decode(test));
    _refresh();
  }

  _refresh() {
    timeBloc = ApiHandlerBloc();
    timeBloc!.fetchAPIList(endpoints.getIndividualDoctorTimingsEndpoint);
    appointmentBloc = ApiHandlerBloc();
    appointmentBloc!.fetchAPIList(endpoints.getAppointmentsInDoctorSide);
  }

  postDoctorCurrentAddress() async {
    _currentPosition = await location.getLocation();
    double? latitude, longitude;
    location.onLocationChanged.listen((LocationData currentLocation) {
      _currentPosition = currentLocation;
    });

    latitude = _currentPosition!.latitude;
    longitude = _currentPosition!.longitude;
    int statusCode;
    String? doctorID = profileModel!.user!.id.toString();
    statusCode = await API().postData(
        context,
        PostDoctorLocationModel(
          latitude: latitude,
          longitude: longitude,
        ),
        'admin/doctor-profile/location/$doctorID');

    if (statusCode == 200) {}
  }

  @override
  Widget build(BuildContext context) {
    // requestLocationPermission(postDoctorCurrentAddress, () {});
    return Scaffold(
      key: _scaffoldKey,
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
                'NMC No. : ${profileModel!.user!.name}',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: myColor.primaryColorDark,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Rating : ${profileModel!.averageRating}',
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
            stream: refreshDoctorTimingBloc.stateStream,
            builder: (c, s) {
              if (s.data == 'refresh') {
                timeBloc = ApiHandlerBloc();
                timeBloc!
                    .fetchAPIList(endpoints.getIndividualDoctorTimingsEndpoint);
              }
              return StreamBuilder<ApiResponse<dynamic>>(
                stream: timeBloc!.apiListStream,
                builder: ((c, snapshot) {
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
                        GetIndividualDoctorTimings getIndividualDoctorTimings =
                            GetIndividualDoctorTimings.fromJson(
                                snapshot.data!.data);
                        if (getIndividualDoctorTimings.bookings!.isEmpty) {
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
                                  'You haven\'t set your schedule',
                                  style: kStyleNormal.copyWith(
                                    letterSpacing: 0.5,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox8(),
                                Text(
                                  'Add appointment timings to receive appointments.',
                                  style: kStyleNormal.copyWith(
                                    color: kBlack,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox16(),
                                GestureDetector(
                                  onTap: () {
                                    goThere(context,
                                        const DoctorTimings(isHomepage: true));
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
                                        'Set Time',
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
                              itemCount:
                                  getIndividualDoctorTimings.bookings!.length,
                              itemBuilder: (context, index, realIndex) {
                                return doctorScheduleCard(
                                    getIndividualDoctorTimings
                                        .bookings![index]);
                              },
                            ),
                            const SizedBox12(),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count:
                                  getIndividualDoctorTimings.bookings!.length,
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
                          margin: const EdgeInsets.symmetric(horizontal: 12.0),
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
            }),
      ],
    );
  }

  Widget doctorScheduleCard(BookingsDetails bookings) {
    String getWeekNameFromDate(DateTime date) {
      final df = DateFormat('EEEE', 'en');
      return df.format(date);
    }

    DateTime myDate = DateTime.parse(bookings.date.toString());
    String weekName = getWeekNameFromDate(myDate);
    DateTime startTime = DateTime.parse(bookings.startTime.toString());
    DateTime endTime = DateTime.parse(bookings.endTime.toString());

    Duration duration = endTime.difference(startTime);
    int hours = duration.inHours;
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
                      text: '${bookings.date.toString().substring(8, 10)} ',
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${getMonth(bookings.date.toString())}, ${bookings.date.toString().substring(0, 4)}\n',
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
              bookings.times!.isEmpty
                  ? Container()
                  : Column(
                      children: [
                        Text(
                          'Service Type',
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                            color: myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox2(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: myColor.primaryColorDark,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          child: Text(
                            bookings.times![0].serviceType.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 10.0,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          const SizedBox16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${getHour(bookings.startTime.toString().substring(11, 16))} : ',
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                bookings.startTime.toString().substring(14, 16),
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8,
                ),
              ),
              Text(
                ' ${getAmPm(bookings.startTime.toString().substring(11, 16))}',
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4.0),
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
                  '$hours\n hours',
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    fontSize: 10.0,
                  ),
                ),
              ),
              Expanded(
                child: Container(color: myColor.primaryColorDark, height: 2.0),
              ),
              const SizedBox(width: 4.0),
              Text(
                '${getHour(bookings.endTime.toString().substring(11, 16))} : ',
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                bookings.endTime.toString().substring(14, 16),
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8,
                ),
              ),
              Text(
                ' ${getAmPm(bookings.endTime.toString().substring(11, 16))}',
                style: kStyleNormal.copyWith(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
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
                    return Column(
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
                    );
                  }
                  List<GetAppointmentsInDoctorSide>
                      getAppointmentsInDoctorSide =
                      List<GetAppointmentsInDoctorSide>.from(snapshot.data!.data
                          .map((i) => GetAppointmentsInDoctorSide.fromJson(i)));
                  List<GetAppointmentsInDoctorSide> pendingModel =
                      getAppointmentsInDoctorSide
                          .where(
                              (element) => element.bookingStatus == 'Scheduled')
                          .toList();

                  return DoctorSideAppoinmentTabBarView(
                    doctorAppointmentListModel: pendingModel,
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
