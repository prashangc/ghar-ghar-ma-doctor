import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/GoogleMapModel/NotificationStatusModel.dart';
import 'package:ghargharmadoctor/screens/Driver/driverMap/DriverMap.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/notification/local_notification_service.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void GetFCMToken(context) async {
  // 1. This method call when app in terminated state and you get a notification
  // when you click on notification, even if the  app is in terminated state , the app will open when u click the notification and you can get notification data in this method

  FirebaseMessaging.instance.getInitialMessage().then(
    (message) {
      notificationCountIncrement(message, context);
    },
  );
  // 2. This method only call when App in running: it mean app must be opened
  FirebaseMessaging.onMessage.listen(
    (message) {
      notificationCountIncrement(message, context);
    },
  );
  // 3. This method only call when App is in background and not terminated(not closed)
  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) {
      notificationCountIncrement(message, context);
    },
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  sharedPrefs.storeToDevice('fcm', fcmToken);
  print('fcmToken $fcmToken');
  FirebaseMessaging.onBackgroundMessage((message) {
    return notificationCountIncrement(message, context);
  });
}

Future<String> returnAddressFromCoordinates(lat, lng) async {
  List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);

  Placemark place = placemark[0];
  String mainAddress = place.thoroughfare.toString();
  String area = place.subLocality.toString();
  String subArea = place.locality.toString();
  String district = place.subAdministrativeArea.toString();
  String country = place.country.toString();
  String street = place.street.toString();
  String address;
  if (mainAddress == '') {
    address = '$street, $subArea, $district, $country';
  } else {
    address = '$street, $mainAddress, $district, $country';
  }

  if (subArea == district) {
    address = '$street, $mainAddress, $area, $district, $country';
  }
  return address;
}

notificationCountIncrement(message, context) async {
  if (message != null) {
    NotificationStatusModel notificationStatusModel =
        NotificationStatusModel.fromJson(message.data);
    if (message.notification != null) {
      LocalNotificationService.createanddisplaynotification(message);
      // else if (notificationStatusModel.status == 'qr') {
      if (notificationStatusModel.status == 'Drink Water') {
        _displayNotificationDialog(context);
      }
      if (notificationStatusModel.status == 'DriverArrived') {
        completeTripBtnBloc!.storeData('show');
      }
      if (notificationStatusModel.status ==
          'complete journey request by driver') {
        completeTripBtnBloc!.storeData('hide');
      }
      if (notificationStatusModel.status == 'driverAcceptedRequest') {
        completeTripBtnBloc!.storeData('show');
        refreshDialogBloc!.storeData('data');
      } else if (notificationStatusModel.status == 'Order') {
        storeNotificationCountInLocal(
            "orderNotificationCount", orderNotificationCountBloc);
      } else if (notificationStatusModel.status == 'Doctor Booked') {
        storeNotificationCountInLocal(
            "appointmentNotificationCount", appointmentNotificationCountBloc);
      } else if (notificationStatusModel.status == 'User-Doctor-Booking') {
        storeNotificationCountInLocal("userSideAppointmentNotificationCount",
            userSideAppointmentNotificationCountBloc);
      } else if (notificationStatusModel.status == 'Nurse Booked') {
        storeNotificationCountInLocal("nurseAppointmentNotificationCount",
            nurseAppointmentNotificationCountBloc);
      } else if (notificationStatusModel.status == 'News') {
        storeNotificationCountInLocal(
            "newsNotificationCount", newsNotificationCountBloc);
      }
    } else {
      if (notificationStatusModel.status == 'qrLogin') {}
      if (notificationStatusModel.status == 'Request Received') {
        refreshFamilyStateQr.storeData(true);
        // Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
        // goThere(context, const FamilyPage(tabIndex: 1));
        // radioBtnBloc.storeData(1);
        // Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
      }

      if (notificationStatusModel.status == 'Request Sent') {
        refreshFamilyStateQr.storeData(true);
        // print('is this the line 2');
        // Navigator.pop(context);
        // goThere(context, const FamilyPage(tabIndex: 1));
      }
      // }

      // LatestTrackLatLng latestTrackLatLng =
      //     LatestTrackLatLng.fromJson(message.data);
      // var address = returnAddressFromCoordinates(
      //     double.parse(latestTrackLatLng.lat.toString()),
      //     double.parse(latestTrackLatLng.lon.toString()));
      // GoogleMapModel googleMapModel = GoogleMapModel(
      //   lat: double.parse(latestTrackLatLng.lat.toString()),
      //   lng: double.parse(latestTrackLatLng.lon.toString()),
      //   time: latestTrackLatLng.time.toString().substring(5, 10),
      //   address: address.toString(),
      // );

      // googleMapBloc!.storeData(googleMapModel);
    }
  }
}

storeNotificationCountInLocal(key, bloc) {
  var count = sharedPrefs.getIntFromDevice(key);
  count ??= 0;
  int value = count + 1;
  sharedPrefs.storeIntToDevice(key, value);
  bloc.storeData(value);
}

void _displayNotificationDialog(context) {
  String dailyWaterToDrink = sharedPrefs.getFromDevice("waterToDrinkDaily");
  showDialog(
    context: context,
    builder: (BuildContext c) {
      return AlertDialog(
          title: Center(
            child: Text(
              'Water Reminder',
              style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          backgroundColor: myColor.dialogBackgroundColor,
          content: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox16(),
                  CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 13.0,
                    animation: true,
                    animationDuration: 2000,
                    percent: 0,
                    animateFromLastPercent: true,
                    backgroundColor: kWhite.withOpacity(0.4),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox2(),
                        FittedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '0',
                              style: kStyleNormal.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ),
                        ),
                        const SizedBox2(),
                        Text(
                          'ml',
                          style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 10.0),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.square,
                    progressColor: myColor.primaryColorDark,
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text.rich(
                        TextSpan(
                          text: 'Out of ',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: double.parse(dailyWaterToDrink.toString()) %
                                          1 ==
                                      0
                                  ? '${double.parse(dailyWaterToDrink.toString()).toStringAsFixed(0)} ml'
                                  : '$dailyWaterToDrink ml',
                              style: kStyleNormal.copyWith(
                                fontSize: 16.0,
                                color: myColor.primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ' / day',
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox32(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Remember to\n',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Drink Water',
                              style: kStyleNormal.copyWith(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(c);
                        },
                        child: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: myColor.primaryColorDark,
                            child: Icon(
                              FontAwesomeIcons.glassWater,
                              color: kWhite,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox12(),
                ],
              ),
            ],
          ));
    },
  );
}
