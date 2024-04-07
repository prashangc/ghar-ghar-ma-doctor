import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox12(),
              const Icon(Icons.signal_wifi_off_outlined, size: 50),
              const SizedBox24(),
              Text(
                'No Internet Connection',
                style: kStyleNormal.copyWith(
                  fontSize: 18.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox2(),
              Text(
                'Connect to the internet and try again.',
                style: kStyleNormal.copyWith(
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            height: 50.0,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: myWhiteButton(
                context,
                backgroundColor,
                'Retry',
                kStyleNormal.copyWith(
                  fontSize: 14.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ), () {
              Navigator.pop(context);
            })),
      ),
    );
  }
}
