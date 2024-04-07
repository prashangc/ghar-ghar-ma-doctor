import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/constants/refreshTokenMethod.dart';
import 'package:ghargharmadoctor/screens/User/notification/local_notification_service.dart';
import 'package:ghargharmadoctor/screens/User/splash/SplashScreen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:torch_controller/torch_controller.dart';
import 'constants/sharePreferencesHelper.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await PreferenceHelper().init();
  myNotificationCount();
}

void main() async {
  TorchController().initialize();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await PreferenceHelper().init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  if (Platform.isAndroid) {
    LocalNotificationService.initialize();
  } else {
    LocalNotificationService.initializeNotificationIos();
  }
  initializeDateFormatting('en', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer refreshTokenTimer;
    void startRefreshTokenTimer() {
      refreshTokenTimer =
          Timer.periodic(const Duration(minutes: 55), (Timer t) {
        refreshToken(context);
      });
    }

    startRefreshTokenTimer();
    // refreshToken(context);
    return KhaltiScope(
      publicKey: "live_public_key_6311e5fa7019448cb1d03d1c7d4adbd4",
      builder: (c, navigatorKey) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          theme: ThemeData(
              primaryColor: const Color(0xFF56328c),
              appBarTheme: const AppBarTheme(
                color: Color(0xFF56328c),
              )),
          title: 'Ghar Ghar Ma Doctor',
          home: Builder(builder: (context) {
            return const SplashScreen();
          }),
        );
      },
    );
  }
}
