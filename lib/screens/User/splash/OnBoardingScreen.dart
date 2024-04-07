import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/screens/User/register/RegisterScreen.dart';
import 'package:ghargharmadoctor/screens/User/register/SelectUser.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  PageController controller2 = PageController();

  bool isLastPage = false;
  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        initialIndex = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorPrimaryDark = myColor.primaryColorDark;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (initialIndex != 0) {
              controller.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
              controller2.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            } else {
              Navigator.pop(context);
            }
            return false;
          },
          child: Container(
            width: maxWidth(context),
            height: maxHeight(context),
            color: backgroundColor,
            child: Stack(
              children: [
                Positioned(
                    top: -250,
                    left: -250,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFFC6DFF6).withOpacity(0.4),
                      radius: 270.0,
                      child: CircleAvatar(
                        backgroundColor: backgroundColor,
                        radius: 180.0,
                      ),
                    )),
                Column(
                  children: [
                    Container(
                      width: maxWidth(context),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                    spreadRadius: 7.0,
                                    color: Colors.grey.withOpacity(0.07))
                              ],
                              color: kWhite,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 80.0,
                              height: 80.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: controller,
                          itemCount: onboardingContents.length,
                          itemBuilder: (ctx, i) {
                            return Image.asset(
                              onboardingContents[i].image,
                            );
                          }),
                    ),
                    const SizedBox8(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      width: maxWidth(context),
                      height: 350.0,
                      decoration: BoxDecoration(
                        color: myColor.primaryColorDark,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 138.0,
                                width: maxWidth(context),
                                child: PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller2,
                                    itemCount: onboardingContents.length,
                                    itemBuilder: (ctx, i) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 70.0,
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: Text(
                                              onboardingContents[i]
                                                  .title
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: kStyleTitle2.copyWith(
                                                color: kWhite,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                          const SizedBox8(),
                                          SizedBox(
                                            height: 30.0,
                                            child: Text(
                                              onboardingContents[i]
                                                  .engDesc
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: kStyleNormal.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                            child: Text(
                                              onboardingContents[i]
                                                  .nepDesc
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: kStyleNormal.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              const SizedBox32(),
                              const SizedBox8(),
                              Center(
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  count: onboardingContents.length,
                                  effect: ExpandingDotsEffect(
                                    dotWidth: 6,
                                    dotHeight: 6,
                                    activeDotColor: Colors.white,
                                    spacing: 8,
                                    dotColor:
                                        myColor.primaryColor.withOpacity(0.2),
                                  ),
                                  onDotClicked: (index) {
                                    controller.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                    controller2.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox24(),
                              btnWidget(),
                              Expanded(
                                child: Container(),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnWidget() {
    return initialIndex != 3
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: maxWidth(context),
                height: 55,
                child: myCustomButton(
                    context,
                    kWhite,
                    'Next',
                    kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold), () {
                  controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                  controller2.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                }),
              ),
              const SizedBox12(),
              GestureDetector(
                onTap: () {
                  goToLoginScreen();
                },
                child: Text(
                  'Skip',
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: maxWidth(context),
                height: 55,
                child: myCustomButton(
                    context,
                    Colors.white,
                    'Login',
                    kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold), () {
                  goToLoginScreen();
                }),
              ),
              const SizedBox12(),
              GestureDetector(
                onTap: () {
                  goThere(context, const RegisterScreen());
                },
                child: Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
  }

  void goToRegisterScreen() {
    sharedPrefs.storeBooleanToDevice('INTRO', true);
    goThere(context, const SelectUser());
  }

  void goToLoginScreen() {
    sharedPrefs.storeBooleanToDevice('INTRO', true);
    goThere(context, const LoginScreen());
  }
}

class SlantedLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    // path.quadraticBezierTo(20, 20, 20, 20);
    path.lineTo(size.width / 2, size.height + size.height / 1.5);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
