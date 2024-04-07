import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        // onSelectNotification
        // app should redirect to new screen on forground
        // Navigator.push
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => DemoScreen(
        //       id: id,
        //     ),
        //   ),
        // );
      },
    );
  }

  static void initializeNotificationIos() {
// Configure the notification settings for iOS
    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

// initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: iosInitializationSettings,
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {},
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "ghargharmadoctor",
          "appchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      );
      if (message.notification!.title != 'Reminder') {
        myNotificationCount();
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

myNotificationCount() {
  var notificationCount =
      sharedPrefs.getIntFromDevice("notificationCount") ?? 0;
  int value = notificationCount + 1;
  sharedPrefs.storeIntToDevice("notificationCount", value);
  notificationCountBloc.storeData(value);
}
