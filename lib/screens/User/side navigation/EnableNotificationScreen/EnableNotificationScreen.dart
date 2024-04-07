import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class EnableNotificationScreen extends StatefulWidget {
  final Function myMethod;
  const EnableNotificationScreen({super.key, required this.myMethod});

  @override
  State<EnableNotificationScreen> createState() =>
      _EnableNotificationScreenState();
}

class _EnableNotificationScreenState extends State<EnableNotificationScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        String myStatus = await checkNotificationPermission();
        if (myStatus == 'System notifications are enabled.') {
          widget.myMethod;
        } else {
          mySnackbar.mySnackBar(context,
              'You can later enable notification from profile settings', kRed);
        }
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
        elevation: 0.0,
        backgroundColor: backgroundColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox16(),
                  Image.asset(
                    'assets/empty_basket.png',
                  ),
                  const SizedBox32(),
                  Text(
                    'Please enable notification for better experience',
                    textAlign: TextAlign.center,
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      color: myColor.primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: maxWidth(context),
              height: 50.0,
              child: myCustomButton(
                context,
                myColor.primaryColorDark,
                'Allow',
                kStyleNormal.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: kWhite,
                ),
                () async {
                  Navigator.pop(context);
                  await AppSettings.openAppSettings();
                },
              ),
            ),
            const SizedBox8(),
            SizedBox(
              width: maxWidth(context),
              height: 50.0,
              child: myWhiteButton(
                context,
                backgroundColor,
                'Deny',
                kStyleNormal.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: myColor.primaryColorDark,
                ),
                () {
                  Navigator.pop(context);
                  mySnackbar.mySnackBar(
                      context,
                      'You can later enable notification from profile settings',
                      kRed);
                },
              ),
            ),
            const SizedBox16(),
          ],
        ),
      ),
    );
  }
}
