import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/constants/refreshTokenMethod.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/splash/GetStartedScreen.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';

StateHandlerBloc requestTimeOutBloc = StateHandlerBloc();

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? dontShowIntro;
  bool? dontShowLogin;
  String? isAmbulanceTracking, token, checkInternet;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  ConnectivityResult? _connectivityResult;

  @override
  void initState() {
    // GetFCMToken();
    String showCase = sharedPrefs.getFromDevice('showCase1') ?? 'empty';
    sharedPrefs.storeToDevice('checkInternet', 'yes');
    sharedPrefs.removeFromDevice("isSchool");
    token = sharedPrefs.getFromDevice('token');
    dontShowIntro = sharedPrefs.getBooleanFromDevice('INTRO');
    dontShowLogin = sharedPrefs.getBooleanFromDevice('isChecked');
    isAmbulanceTracking = sharedPrefs.getFromDevice('isAmbulanceTracking');
    String getRoleID = sharedPrefs.getFromDevice("roleID") ?? "emptyRole";

    Timer(const Duration(seconds: 1), () {
      checkForceUpdate();
      goThere(
          context,
          dontShowIntro == false
              ? const GetStartedScreen()
              : dontShowLogin == false
                  ? const LoginScreen()
                  : isAmbulanceTracking == 'showAmbulanceForm' ||
                          isAmbulanceTracking == 'showTrackingScreen'
                      ? const GoogleMapAmbulanceUserSide()
                      :
                      // showCase == 'empty'
                      //     ?
                      ShowCaseWidget(
                          // onStart: (i, n) {
                          //   if (i != 5) {
                          //     currentIndexBloc.storeData(i);
                          //   }
                          // },
                          // onFinish: () {
                          //   sharedPrefs.storeToDevice(
                          //       'showCase1', 'over');
                          //   currentIndexBloc.storeData(4);
                          // },
                          builder: Builder(builder: (context) {
                            return const MainHomePage(
                              tabIndex: 0,
                              index: 0,
                            );
                          }),
                        ));
    });
    super.initState();
  }

  checkForceUpdate() async {
    String year = '${DateTime.now().year}';
    String month = '${DateTime.now().month}';
    if (month.length == 1) {
      month = "0$month";
    }
    String day = '${DateTime.now().day}';
    var resp = await API()
        .getData(context, 'check-updated?updated_date=$year-$month-$day');
    ForceUpdateModel forceUpdateModel = ForceUpdateModel.fromJson(resp);
    if (resp != null) {
      // PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // String version = packageInfo.version;

      // print('packageInfo: $packageInfo  ${packageInfo.version}');
      if ('version' != 'version') {
        // if (version != forceUpdateModel.version) {
        Future.delayed(const Duration(seconds: 0)).then((_) {
          showModalBottomSheet(
              context: context,
              backgroundColor: backgroundColor,
              isDismissible: forceUpdateModel.status == 0 ? true : false,
              isScrollControlled: true,
              enableDrag: forceUpdateModel.status == 0 ? true : false,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (builder) {
                return WillPopScope(
                    onWillPop: () async {
                      return forceUpdateModel.status == 0 ? true : false;
                    },
                    child: updateApp(
                        context, forceUpdateModel.status == 0 ? true : false));
              });
        });
      }
    }
  }

  postAppAnalytics() async {
    String myFcm = sharedPrefs.getFromDevice('fcm') ?? 'empty';
    if (myFcm != 'empty') {
      var resp;
      resp = await API().getData(context, endpoints.getAppAnalyticsEndpoint);
      if (resp.isNotEmpty) {
        List<AppAnalyticsGetFcmModel> appAnalyticsGetFcmModel =
            List<AppAnalyticsGetFcmModel>.from(
          resp.map(
            (i) => AppAnalyticsGetFcmModel.fromJson(i),
          ),
        );

        List<AppAnalyticsGetFcmModel> listOfFcmNotNull = appAnalyticsGetFcmModel
            .where((element) => element.fcmToken != null)
            .toList();

        bool hasMatchingFcmToken =
            listOfFcmNotNull.any((element) => element.fcmToken == myFcm);

        if (hasMatchingFcmToken == false) {
          postFcm(myFcm);
        }
      } else {
        postFcm(myFcm);
      }
    }
  }

  postFcm(myFcm) async {
    int statusCode;
    statusCode = await API().postData(
        context,
        AppAnalyticsPostModel(
          fcmToken: myFcm,
          platform: Platform.isAndroid ? 'android' : 'ios',
        ),
        endpoints.postAppAnalyticsFcmEndpoint);

    if (statusCode == 200) {
      if (kDebugMode) {
        print('fcm posted for analytics. [ STATUS CODE : $statusCode ]');
      }
    } else {
      if (kDebugMode) {
        print(
            'fcm post method for analytics FAILED. [ STATUS CODE : $statusCode ]');
      }
      Navigator.pop(context);
    }
  }

  requestTimeout(context) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: backgroundColor,
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<dynamic>(
                  initialData: false,
                  stream: requestTimeOutBloc.stateStream,
                  builder: (context, snapshot) {
                    return WillPopScope(
                        onWillPop: () async {
                          return false;
                        },
                        child: const Text(
                            '(context, profileModel!, biometricType)'));
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    GetFCMToken(context);
    refreshToken(context);
    postAppAnalytics();
    internetRestored(context, setState);
    return Scaffold(
      backgroundColor: myColor.primaryColorDark,
      body: Center(
        child: Image.asset(
          'assets/logo_white.png',
          width: maxWidth(context),
          height: 230.0,
        ),
      ),
    );
  }

  Widget updateApp(context, showSkip) {
    return StatefulBuilder(builder: (c, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox12(),
            CircleAvatar(
              radius: 40.0,
              backgroundColor: backgroundColor,
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox8(),
            Text(
              'New Update Available',
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: myColor.primaryColorDark,
              ),
            ),
            const SizedBox16(),
            Text(
              'Please update to get new features.',
              textAlign: TextAlign.justify,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
            ),
            const SizedBox24(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor.primaryColorDark,
                elevation: 0.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              onPressed: () async {
                bool connection = await checkInternetConnection();
                if (connection == true) {
                  redirectToPlayStore();
                } else {
                  mySnackbar.mySnackBar(
                      context, 'No internet connection', kRed);
                }
              },
              child: Text(
                'Update',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  color: kWhite,
                ),
              ),
            ),
            showSkip == true ? const SizedBox8() : Container(),
            showSkip == true
                ? GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Skip',
                      style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          color: myColor.primaryColorDark),
                    ),
                  )
                : Container(),
            const SizedBox16(),
          ],
        ),
      );
    });
  }

  void redirectToPlayStore() async {
    String url = 'market://details?id=com.example.ghargharmadoctor';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      myToast.toast('Couldn\'t open playstore. Please try again');
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }
}
