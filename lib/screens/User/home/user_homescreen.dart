import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/AllAmbulanceLatLng.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/GetAllAmbulanceListModel.dart';
import 'package:ghargharmadoctor/models/DoctorAppointmentListModel.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAllDoctorsModel.dart';
import 'package:ghargharmadoctor/models/NurseModel/AlNurseModel.dart';
import 'package:ghargharmadoctor/models/PostFcmTokenModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/HomeScreenAmubulances.dart';
import 'package:ghargharmadoctor/screens/User/home/FindBySpeciality/AllDepartment.dart';
import 'package:ghargharmadoctor/screens/User/home/FindBySpeciality/FindBySpeciality.dart';
import 'package:ghargharmadoctor/screens/User/home/ImageSlider.dart';
import 'package:ghargharmadoctor/screens/User/home/OurServices/ourServices.dart';
import 'package:ghargharmadoctor/screens/User/home/RelatedNews/HomeScreenNews.dart';
import 'package:ghargharmadoctor/screens/User/home/Symptoms/AllSymptoms.dart';
import 'package:ghargharmadoctor/screens/User/home/Symptoms/FindBySymptoms.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/FilterAllDoctor.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/HomeScreenDoctors.dart';
import 'package:ghargharmadoctor/screens/User/home/ViewAllNurses/AllNurse.dart';
import 'package:ghargharmadoctor/screens/User/home/ViewAllNurses/HomeScreenNurses.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/appointmentCard.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Hospital/Hospital.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/AllNews.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/setupFingerprintWhileLogin.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:torch_controller/torch_controller.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with AutomaticKeepAliveClientMixin<UserHomeScreen> {
  @override
  bool get wantKeepAlive => true;
  final _bottomNavIndex = 0;
  ApiHandlerBloc? profileBloc,
      kycBloc,
      imageSliderBloc,
      departmentBloc,
      appointmentListBloc,
      servicesBloc,
      symptomsBloc,
      newsHomePageBloc,
      ambulanceBloc,
      nursesBloc,
      doctorsBloc;
  AllDoctorsModel? allDoctorsModel;
  String? getToken;
  List<DoctorAppointmentListModel> doctorAppointmentListModel = [],
      urgentAppointmentModel = [];
  NurseModel? nurseList;
  List<GetAllAmbulanceListModel> getAllAmbulanceListModel = [];
  List<GetSymptomsModel> getSymptomsModel = [];
  List<OurServicesModel> ourServicesModel = [];
  List<NewsData> newsModel = [];
  List<DepartmentModel> departmentModel = [];
  DateTime? currentDate, subtractedDate;
  List<AllAmbulanceListModel> myAllAmbulanceList = [];
  KycResponseModel? kycResponseModel;
  ProfileModel? profileModel;
  bool? canCheckBiometrics;
  final form = GlobalKey<FormState>();
  TorchController torchController = TorchController();
  String? userName,
      biometricType,
      biometricEmail,
      biometricPassword,
      biometricUserID,
      biometricStatus;
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    requestNotificationPermission(context, ifGranted: topicBasedNotification);
    checkTokenAuth();
    _scrollController = ScrollController();
    biometricEmail = sharedPrefs.getFromDevice('biometricEmail');
    biometricPassword = sharedPrefs.getFromDevice('biometricPassword');
    biometricUserID = sharedPrefs.getFromDevice('biometricUserID');
    biometricStatus = sharedPrefs.getFromDevice('biometricStatus');
    imageSliderBloc = ApiHandlerBloc();
    kycBloc = ApiHandlerBloc();
    departmentBloc = ApiHandlerBloc();
    servicesBloc = ApiHandlerBloc();
    symptomsBloc = ApiHandlerBloc();
    doctorsBloc = ApiHandlerBloc();
    ambulanceBloc = ApiHandlerBloc();
    nursesBloc = ApiHandlerBloc();
    appointmentListBloc = ApiHandlerBloc();
    torchController.initialize();
    refreshAPI();
    checkBiometric();
  }

  topicBasedNotification() async {
    String fcmToken = sharedPrefs.getFromDevice('fcm') ?? 'empty';
    if (fcmToken != 'empty') {
      int statusCode = await API().postData(
          context,
          TopicBasedNotiModel(deviceKey: fcmToken),
          endpoints.postGeneralNotiEndpoint);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final internetRestored =
        ModalRoute.of(context)?.settings.arguments as bool?;
    if (internetRestored == true) {
      refreshAPI();
      setState(() {});
    }
  }

  checkTokenAuth() async {
    getToken = sharedPrefs.getFromDevice('token');
    if (getToken != null) {
      String tokenId = sharedPrefs.getFromDevice("tokenId") ?? 'dontPost';
      if (tokenId != 'dontPost') {
        var resp = await API().getPostResponseData(context,
            CheckTokenModel(tokenId: tokenId), endpoints.checkTokenEndpoint);
        if (resp != null) {
          KycResponseModel kycResponseModel = KycResponseModel.fromJson(resp);
          if (kycResponseModel.message != 'Token is still valid') {
            Future.delayed(const Duration(seconds: 0)).then((_) {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: backgroundColor,
                  isDismissible: false,
                  isScrollControlled: true,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (builder) {
                    return WillPopScope(
                        onWillPop: () async {
                          return false;
                        },
                        child: sessionExpired(context));
                  });
            });
          }
        }
      }
    }
  }

  refreshAPI() {
    getToken = sharedPrefs.getFromDevice('token') ?? 'nullValue';
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));

    if (profileModel!.member!.roles != null &&
        profileModel!.member!.roles!.length == 1) {
      getProfileAPI();
    } else {
      sharedPrefs.storeToDevice("becomeMember", "memberVerified");
    }
    getDate();
    symptomsBloc!.fetchAPIList(endpoints.getSymptomsEndpoint, context: context);
    ambulanceBloc!
        .fetchAPIList(endpoints.getAllAmbulanceEndpoint, context: context);
    doctorsBloc!.fetchAPIList(
        'booking/date?member_id=${profileModel!.memberId}',
        context: context);
    nursesBloc!.fetchAPIList('nurse?member_id=${profileModel!.memberId}',
        context: context);
    newsHomePageBloc = ApiHandlerBloc();
    newsHomePageBloc!.fetchAPIList('homepage?take=10', context: context);
    imageSliderBloc!
        .fetchAPIList(endpoints.getImageSliderEndpoint, context: context);
    kycBloc!.fetchAPIList(endpoints.getkycStatusEndpoint, context: context);
    departmentBloc!
        .fetchAPIList(endpoints.getDepartmentEndpoint, context: context);
    servicesBloc!
        .fetchAPIList(endpoints.getOurServicesEndpoint, context: context);
    appointmentListBloc!
        .fetchAPIList(endpoints.getAppointmentBookingDetails, context: context);
  }

  checkBiometric() async {
    getToken = sharedPrefs.getFromDevice('token');
    if (getToken != null) {
      if (biometricEmail == null && biometricStatus != 'dontShow') {
        biometricType = await getBiometricType();
        if (biometricType != 'not added in device' ||
            biometricType != 'device doesnt support') {
          Future.delayed(const Duration(seconds: 0)).then((_) {
            showModalBottomSheet(
                context: context,
                backgroundColor: backgroundColor,
                isDismissible: false,
                isScrollControlled: true,
                enableDrag: false,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                builder: (builder) {
                  return WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: setupFingerprintWhileLogin(
                          context, profileModel!, biometricType));
                });
          });
        }
      }
    }
  }

  getProfileAPI() async {
    await API().getData(context, endpoints.getUserProfileEndpoint);
  }

  Future _postFCMTokenToAllowNotification() async {
    String fcmToken = sharedPrefs.getFromDevice('fcm') ?? 'dontPost';
    if (fcmToken != 'dontPost') {
      var statusCode;
      statusCode = await API().postData(
          context,
          PostFcmTokenModel(
            deviceKey: fcmToken,
            platform: Platform.isAndroid ? 'Android' : 'iOS',
          ),
          endpoints.postFCMTokenEndpoint);
      if (statusCode == 200) {
      } else {
        myToast.toast('Server Error');
      }
    }
  }

  void getDate() {
    currentDate = DateTime.now();
    subtractedDate =
        currentDate!.subtract(const Duration(days: 1, hours: 0, minutes: 0));
  }

  seeAllAmbulance() {
    myAllAmbulanceList.clear();
    for (var element in getAllAmbulanceListModel) {
      myAllAmbulanceList.add(
        AllAmbulanceListModel(
          lat: double.parse(
            element.latitude.toString(),
          ),
          lng: double.parse(
            element.longitude.toString(),
          ),
        ),
      );
    }
    goThere(
        context,
        GoogleMapAmbulanceUserSide(
          seeAll: 'See All',
          getAllAmbulanceListModel: myAllAmbulanceList,
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (getToken != null) {
      _postFCMTokenToAllowNotification();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myColor.dialogBackgroundColor,
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: myColor.dialogBackgroundColor,
      //   toolbarHeight: 80.0,
      //   elevation: 0.0,

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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/gd_logo_banner.png',
                        width: maxWidth(context) / 2,
                        height: 70.0,
                        fit: BoxFit.cover,
                      ),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        goThere(
                          context,
                          FilterAllDoctors(
                            context: context,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        width: maxWidth(context),
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: myColor.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 8.0),
                                Text(
                                  "Search Doctors",
                                  style: kStyleNormal.copyWith(
                                      color: Colors.grey[400]),
                                ),
                              ],
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                // color: myColor.primaryColorDark,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox8(),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  edgeOffset: 0,
                  strokeWidth: 2.0,
                  color: kWhite,
                  backgroundColor: myColor.primaryColorDark,
                  onRefresh: () async {
                    await refreshAPI();
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: StreamBuilder<dynamic>(
                        initialData: null,
                        stream: scrollingBloc.stateStream,
                        builder: (c, s) {
                          if (s.data == 0) {
                            _scrollController!.animateTo(0,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 500));
                          }
                          return Column(
                            children: [
                              StreamBuilder<ApiResponse<dynamic>>(
                                stream: kycBloc!.apiListStream,
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        return Container();
                                      case Status.COMPLETED:
                                        kycResponseModel =
                                            KycResponseModel.fromJson(
                                                snapshot.data!.data);
                                        sharedPrefs.storeToDevice("kycStatus",
                                            kycResponseModel!.message);
                                        return Container();
                                      case Status.ERROR:
                                        return Container();
                                    }
                                  }
                                  return SizedBox(
                                    width: maxWidth(context),
                                  );
                                }),
                              ),
                              const SizedBox12(),
                              StreamBuilder<ApiResponse<dynamic>>(
                                stream: imageSliderBloc!.apiListStream,
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          width: maxWidth(context),
                                          height: maxHeight(context) / 4,
                                          decoration: BoxDecoration(
                                            color:
                                                myColor.dialogBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const AnimatedLoading(),
                                        );
                                      case Status.COMPLETED:
                                        if (snapshot.data!.data.isEmpty) {
                                          return Container(
                                              height: maxHeight(context) / 4,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              decoration: BoxDecoration(
                                                color: kWhite,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Center(
                                                  child:
                                                      Text('No image added')));
                                        }
                                        List<ImageSliderModel>
                                            imageSliderModel =
                                            List<ImageSliderModel>.from(
                                                snapshot.data!.data.map((i) =>
                                                    ImageSliderModel.fromJson(
                                                        i)));
                                        return ImageSlider(
                                          imageSliderModel: imageSliderModel,
                                        );
                                      case Status.ERROR:
                                        return Container(
                                          width: maxWidth(context),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          height: 135.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                              // const SizedBox12(),
                              StreamBuilder<ApiResponse<dynamic>>(
                                stream: appointmentListBloc!.apiListStream,
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        return Container(
                                          height: 200,
                                          margin: const EdgeInsets.fromLTRB(
                                            20.0,
                                            20.0,
                                            20.0,
                                            20.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                myColor.dialogBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Center(
                                            child: AnimatedLoading(),
                                          ),
                                        );
                                      case Status.COMPLETED:
                                        if (snapshot.data!.data.isEmpty) {
                                          return Container();
                                        }

                                        doctorAppointmentListModel = List<
                                                DoctorAppointmentListModel>.from(
                                            snapshot.data!.data.map((i) =>
                                                DoctorAppointmentListModel
                                                    .fromJson(i)));
                                        urgentAppointmentModel =
                                            doctorAppointmentListModel
                                                .where((element) =>
                                                    currentDate!.isAfter(
                                                        DateTime.parse(element
                                                                .slot!
                                                                .expiryDate
                                                                .toString())
                                                            .subtract(
                                                                const Duration(
                                                                    days: 1,
                                                                    hours: 0,
                                                                    minutes:
                                                                        0))) &&
                                                    currentDate!.isBefore(
                                                        DateTime.parse(element
                                                            .slot!.expiryDate
                                                            .toString())))
                                                .toList();

                                        return urgentAppointmentModel.isNotEmpty
                                            ? Container(
                                                color: myColor
                                                    .dialogBackgroundColor,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        17.0, 14.0, 17.0, 0.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Urgent Appointments',
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    const SizedBox16(),
                                                    ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          urgentAppointmentModel
                                                              .length,
                                                      itemBuilder:
                                                          (scontext, i) =>
                                                              Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 12.0),
                                                        child: appointmentCard(
                                                          context,
                                                          setState,
                                                          urgentAppointmentModel[
                                                              i],
                                                          true,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container();
                                      case Status.ERROR:
                                        return Container();
                                    }
                                  }
                                  return SizedBox(
                                    width: maxWidth(context),
                                  );
                                }),
                              ),
                              const SizedBox16(),
                              const SizedBox2(),
                              const SizedBox2(),

                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: Row(
                                  children: [
                                    infoCard(
                                      context,
                                      FontAwesomeIcons.box,
                                      'Packages',
                                      () {
                                        goThere(context,
                                            const Packages(isBtnNav: false));
                                      },
                                    ),
                                    infoCard(
                                      context,
                                      FontAwesomeIcons.userNurse,
                                      'Nurses',
                                      () {
                                        goThere(context, const Nurse());
                                      },
                                    ),
                                    infoCard(
                                      context,
                                      FontAwesomeIcons.hospital,
                                      'Hospitals',
                                      () {
                                        goThere(context, const Hospital());
                                      },
                                    ),
                                    infoCard(
                                      context,
                                      FontAwesomeIcons.truckMedical,
                                      'Ambulance',
                                      () {
                                        seeAllAmbulance();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox24(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    17.0, 12.0, 17.0, 5.0),
                                color: myColor.dialogBackgroundColor,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Find by Speciality',
                                          style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            swipeTo(
                                              context,
                                              AllDepartment(
                                                departmentModel:
                                                    departmentModel,
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 28.0,
                                            color: myColor.primaryColorDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox12(),
                                    StreamBuilder<ApiResponse<dynamic>>(
                                      stream: departmentBloc!.apiListStream,
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          switch (snapshot.data!.status) {
                                            case Status.LOADING:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 100.0,
                                                margin: const EdgeInsets.only(
                                                    top: 12.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const AnimatedLoading(),
                                              );
                                            case Status.COMPLETED:
                                              if (snapshot.data!.data.isEmpty) {
                                                return Container(
                                                    height: 140,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: const Center(
                                                        child: Text(
                                                            'No departments added')));
                                              }
                                              departmentModel =
                                                  List<DepartmentModel>.from(
                                                      snapshot.data!.data.map(
                                                          (i) => DepartmentModel
                                                              .fromJson(i)));

                                              return FindBySpeciality(
                                                departmentModel:
                                                    departmentModel,
                                              );
                                            case Status.ERROR:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text('Server Error'),
                                                ),
                                              );
                                          }
                                        }
                                        return SizedBox(
                                          width: maxWidth(context),
                                          height: 200,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox24(),
                              seeAll(
                                'Find All Doctors',
                                'See all',
                                () {
                                  goThere(
                                    context,
                                    FilterAllDoctors(
                                      context: context,
                                    ),
                                  );
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17.0),
                                child: StreamBuilder<ApiResponse<dynamic>>(
                                  stream: doctorsBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  myColor.dialogBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const AnimatedLoading(),
                                          );
                                        case Status.COMPLETED:
                                          allDoctorsModel =
                                              AllDoctorsModel.fromJson(
                                                  snapshot.data!.data);
                                          List<Doctors>? data = [];
                                          data = allDoctorsModel!.data!
                                              .where((element) =>
                                                  element.fee != null)
                                              .toList();
                                          if (allDoctorsModel!.data!.isEmpty) {
                                            return Container(
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: const Center(
                                                    child: Text(
                                                        'No doctor\'s added')));
                                          }
                                          if (allDoctorsModel!.data!.isEmpty) {
                                            return Container(
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: const Center(
                                                    child: Text(
                                                        'No doctor\'s added')));
                                          }
                                          return HomeScreenDoctors(
                                            doctors: allDoctorsModel!.data!,
                                          );
                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
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
                                    return SizedBox(
                                      width: maxWidth(context),
                                      height: 200,
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox12(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    17.0, 12.0, 17.0, 5.0),
                                color: myColor.dialogBackgroundColor,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Identify your symptoms',
                                          style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            goThere(
                                              context,
                                              AllSymptomsScreen(
                                                getSymptomsModel:
                                                    getSymptomsModel,
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 28.0,
                                            color: myColor.primaryColorDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox12(),
                                    StreamBuilder<ApiResponse<dynamic>>(
                                      stream: symptomsBloc!.apiListStream,
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          switch (snapshot.data!.status) {
                                            case Status.LOADING:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const AnimatedLoading(),
                                              );
                                            case Status.COMPLETED:
                                              if (snapshot.data!.data.isEmpty) {
                                                return Container(
                                                    height: 140,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Center(
                                                        child: Text(
                                                            'No symptoms added')));
                                              }
                                              getSymptomsModel =
                                                  List<GetSymptomsModel>.from(
                                                      snapshot.data!.data.map(
                                                          (i) =>
                                                              GetSymptomsModel
                                                                  .fromJson(
                                                                      i)));

                                              return FindBySymptoms(
                                                getSymptomsModel:
                                                    getSymptomsModel,
                                              );
                                            case Status.ERROR:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text('Server Error'),
                                                ),
                                              );
                                          }
                                        }
                                        return SizedBox(
                                          width: maxWidth(context),
                                          height: 200,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox24(),
                              seeAll(
                                'Find All Nurses',
                                'See all',
                                () {
                                  goThere(
                                    context,
                                    const Nurse(),
                                  );
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17.0),
                                child: StreamBuilder<ApiResponse<dynamic>>(
                                  stream: nursesBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  myColor.dialogBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const AnimatedLoading(),
                                          );
                                        case Status.COMPLETED:
                                          nurseList = NurseModel.fromJson(
                                              snapshot.data!.data);

                                          List<AllNurseModel>? data = [];
                                          data = nurseList!.allNurseModel!
                                              .where((element) =>
                                                  element.fee != null)
                                              .toList();
                                          if (nurseList!
                                              .allNurseModel!.isEmpty) {
                                            return Container(
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: const Center(
                                                    child: Text(
                                                        'No nurse\'s added')));
                                          }

                                          if (data.isEmpty) {
                                            return Container(
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: const Center(
                                                    child: Text(
                                                        'No nurse\'s added')));
                                          }
                                          return HomeScreenNurses(
                                            allNurseModel: data,
                                          );
                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text('Server Error'),
                                            ),
                                          );
                                      }
                                    }
                                    return SizedBox(
                                      width: maxWidth(context),
                                      height: 200,
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox24(),
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    17.0, 12.0, 17.0, 5.0),
                                color: myColor.dialogBackgroundColor,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Our Services',
                                          style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 28.0,
                                            color: myColor.primaryColorDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox8(),
                                    StreamBuilder<ApiResponse<dynamic>>(
                                      stream: servicesBloc!.apiListStream,
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          switch (snapshot.data!.status) {
                                            case Status.LOADING:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const AnimatedLoading(),
                                              );
                                            case Status.COMPLETED:
                                              if (snapshot.data!.data.isEmpty) {
                                                return Container(
                                                    height: 140,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Center(
                                                        child: Text(
                                                            'No services')));
                                              }
                                              ourServicesModel =
                                                  List<OurServicesModel>.from(
                                                      snapshot.data!.data.map(
                                                          (i) =>
                                                              OurServicesModel
                                                                  .fromJson(
                                                                      i)));

                                              return OurServices(
                                                ourServicesModel:
                                                    ourServicesModel,
                                              );
                                            case Status.ERROR:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text('Server Error'),
                                                ),
                                              );
                                          }
                                        }
                                        return SizedBox(
                                          width: maxWidth(context),
                                          height: 200,
                                        );
                                      }),
                                    ),
                                    const SizedBox16(),
                                  ],
                                ),
                              ),
                              const SizedBox24(),
                              seeAll(
                                'Find All Ambulances',
                                'See all',
                                () {
                                  seeAllAmbulance();
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17.0),
                                child: StreamBuilder<ApiResponse<dynamic>>(
                                  stream: ambulanceBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color:
                                                  myColor.dialogBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const AnimatedLoading(),
                                          );
                                        case Status.COMPLETED:
                                          if (snapshot.data!.data!.isEmpty) {
                                            return Container(
                                                height: 140,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14.0),
                                                child: const Center(
                                                    child: Text(
                                                        'No any ambulances')));
                                          }
                                          getAllAmbulanceListModel = List<
                                                  GetAllAmbulanceListModel>.from(
                                              snapshot.data!.data.map((i) =>
                                                  GetAllAmbulanceListModel
                                                      .fromJson(i)));
                                          return HomeScreenAmbulances(
                                            getAllAmbulanceListModel:
                                                getAllAmbulanceListModel,
                                          );
                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                              ),
                              const SizedBox24(),
                              Container(
                                color: myColor.dialogBackgroundColor,
                                padding: const EdgeInsets.fromLTRB(
                                    17.0, 12.0, 17.0, 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Related News',
                                          style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            goThere(
                                              context,
                                              const AllNews(),
                                            );
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 28.0,
                                            color: myColor.primaryColorDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox16(),
                                    StreamBuilder<ApiResponse<dynamic>>(
                                      stream: newsHomePageBloc!.apiListStream,
                                      builder: ((context, snapshot) {
                                        if (snapshot.hasData) {
                                          switch (snapshot.data!.status) {
                                            case Status.LOADING:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: myColor
                                                      .dialogBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const AnimatedLoading(),
                                              );
                                            case Status.COMPLETED:
                                              if (snapshot
                                                  .data!.data!.isEmpty) {
                                                return Container(
                                                    height: 140,
                                                    decoration: BoxDecoration(
                                                      color: kWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: const Center(
                                                        child: Text(
                                                            'No any news')));
                                              }
                                              newsModel = List<NewsData>.from(
                                                  snapshot.data!.data.map((i) =>
                                                      NewsData.fromJson(i)));
                                              return HomeScreenNews(
                                                newsModel: newsModel,
                                              );
                                            case Status.ERROR:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
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
                                        return const SizedBox();
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard(context, icon, text, Function myTap) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Column(
        children: [
          Container(
            width: maxWidth(context) / 4 - 13,
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              color: myColor.dialogBackgroundColor,
            ),
            // margin: const EdgeInsets.only(right: 5.0),
            child: Center(
              child: Icon(
                icon,
                size: 16,
                color: myColor.primaryColorDark,
              ),
            ),
          ),
          const SizedBox8(),
          Text(
            text,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: myColor.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget seeAll(title, seeAll, Function myTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              myTap();
            },
            child: Text(
              seeAll,
              style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: myColor.primaryColorDark),
            ),
          ),
        ],
      ),
    );
  }
}
