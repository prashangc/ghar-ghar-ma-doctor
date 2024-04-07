import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'OnBoardingScreen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    sharedPrefs.removeFromDevice('checkInternet');
    return Scaffold(
      backgroundColor: myColor.primaryColorDark,
      body: SafeArea(
        child: SizedBox(
          width: maxWidth(context),
          height: maxHeight(context),
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                      top: -250,
                      left: -250,
                      child: CircleAvatar(
                        backgroundColor:
                            const Color(0xFFC6DFF6).withOpacity(0.4),
                        radius: 270.0,
                        child: CircleAvatar(
                          backgroundColor: myColor.primaryColorDark,
                          radius: 180.0,
                        ),
                      )),
                  SizedBox(
                    width: maxWidth(context),
                    height: 350,
                    child: Container(
                      margin: const EdgeInsets.all(100.0),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                              spreadRadius: 7.0,
                              color: Colors.grey.withOpacity(0.07))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 20.0,
                  ),
                  width: maxWidth(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: maxWidth(context),
                        child: Text(
                          'Nepal\'s First Preventive\n Health Care App',
                          style: kStyleTitle2.copyWith(
                            color: myColor.scaffoldBackgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox12(),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          width: maxWidth(context),
                          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              buildRowDetails(
                                  context,
                                  FontAwesomeIcons.userDoctor,
                                  'Doctor\'s at your Door Steps.'),
                              buildRowDetails(
                                  context,
                                  FontAwesomeIcons.chartLine,
                                  'Graphical Medical History'),
                              buildRowDetails(
                                  context,
                                  FontAwesomeIcons.handHoldingHeart,
                                  'Medical emergencies payback by Insurance'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox24(),
                      SizedBox(
                        width: maxWidth(context),
                        height: 55,
                        child: myCustomButton(
                            context,
                            myColor.scaffoldBackgroundColor,
                            'Get Started',
                            kStyleNormal.copyWith(
                                color: myColor.primaryColorDark,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold), () {
                          goThere(context, const OnBoardingScreen());
                        }),
                      ),
                      Container(
                        height: 72.0,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRowDetails(BuildContext context, icon, text) {
  return Column(
    children: [
      const SizedBox8(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 25.0,
              child: Icon(
                icon,
                size: 12.0,
                color: myColor.primaryColor,
              )),
          const SizedBox(width: 6.0),
          Expanded(
            child: SizedBox(
              width: maxWidth(context),
              child: Text(
                text,
                overflow: TextOverflow.clip,
                style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    color: myColor.scaffoldBackgroundColor),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
