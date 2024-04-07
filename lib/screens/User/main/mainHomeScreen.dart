import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/ChatBot/Chatbot.dart';
import 'package:ghargharmadoctor/screens/User/home/user_homescreen.dart';
import 'package:ghargharmadoctor/screens/User/notificationScreen/UserNotificationScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/profileScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/GdStore.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:showcaseview/showcaseview.dart';

StateHandlerBloc refreshMainSreenBloc = StateHandlerBloc();
StateHandlerBloc currentIndexBloc = StateHandlerBloc();
StateHandlerBloc scrollingBloc = StateHandlerBloc();
// StateHandlerBloc mainStateBloc = StateHandlerBloc();

class MainHomePage extends StatefulWidget {
  final int index;
  final int tabIndex;
  final bool? isSwitched;
  final String? image;
  final String? name;
  final bool? showPaymentUI;
  const MainHomePage(
      {Key? key,
      required this.index,
      required this.tabIndex,
      this.isSwitched,
      this.name,
      this.showPaymentUI,
      this.image})
      : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  String? getToken;
  int? notificationCount;
  bool isVisible = true;
  List<Widget> screens = [];
  ProfileModel? profileModel;
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();
  final keyFive = GlobalKey();
  ScrollController? _scrollController;
  PageController? _pageController;
  String? showCase;
  StateHandlerBloc switchingLoadingBloc = StateHandlerBloc();
  @override
  void initState() {
    super.initState();
    sharedPrefs.removeFromDevice('checkInternet');
    showCase = sharedPrefs.getFromDevice("showCase1") ?? 'empty';
    // if (showCase == 'empty') {
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => ShowCaseWidget.of(context)
    //       .startShowCase([keyOne, keyTwo, keyThree, keyFour, keyFive]),
    // );
    // }
    notificationCount = sharedPrefs.getIntFromDevice("notificationCount");

    _pageController = PageController(initialPage: widget.index);
    _scrollController = ScrollController();
    _scrollController!.addListener(listen);
    showCase = sharedPrefs.getFromDevice("showCase1") ?? 'empty';
    var test = sharedPrefs.getFromDevice("userProfile");
    if (test == null) {
      profileModel = ProfileModel();
    } else {
      profileModel = ProfileModel.fromJson(json.decode(test));
    }
    screens = [
      const UserHomeScreen(),
      // const OpeningSoon(),
      const GdStore(),
      Packages(isBtnNav: true, showPaymentUI: widget.showPaymentUI),
      const UserNotificationScreen(userType: 'User'),
      ProfileScreen(tabIndex: widget.tabIndex),
      // ShowCaseWidget(builder: Builder(builder: (context) {
      //   return ProfileScreen(tabIndex: widget.tabIndex);
      // })),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
    _scrollController!.dispose();
    _scrollController!.removeListener(listen);
  }

  void show() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void hide() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    }
  }

  void listen() {
    final direction = _scrollController!.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        initialData: widget.index,
        stream: currentIndexBloc.stateStream,
        builder: (c, mySnapshot) {
          // if (mySnapshot.data != 0) {
          //   _pageController!.jumpToPage(mySnapshot.data);
          // }
          return WillPopScope(
            onWillPop: () async {
              if (mySnapshot.data == 0) {
                myForceBack.exitApp(context);
              } else {
                currentIndexBloc.storeData(0);
                _pageController!.jumpToPage(0);
              }
              return false;
            },
            child: StreamBuilder<dynamic>(
                initialData: widget.isSwitched ?? false,
                stream: switchingLoadingBloc.stateStream,
                builder: (context, switchSnapshot) {
                  if (switchSnapshot.data == true) {
                    Future.delayed(const Duration(seconds: 2)).then((_) {
                      switchingLoadingBloc.storeData(false);
                    });
                    return Scaffold(
                      backgroundColor: backgroundColor,
                      body: SizedBox(
                        width: maxWidth(context),
                        height: maxHeight(context),
                        child: Center(
                          child: AnimatedLoading(
                              name: widget.name, image: widget.image),
                        ),
                      ),
                    );
                  } else {
                    return Scaffold(
                      extendBody: true,
                      body: SizedBox(
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: screens,
                        ),
                      ),
                      floatingActionButton: GestureDetector(
                        onTap: () {
                          goThere(context, const Chatbot());
                        },
                        child: Hero(
                          tag: 'chatbot',
                          child: Image.asset(
                            'assets/chatbot.gif',
                            height: 140.0,
                            width: 140.0,
                          ),
                        ),
                      ),
                      bottomNavigationBar: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onDoubleTap: () {
                            scrollingBloc.storeData(mySnapshot.data);
                          },
                          child: SizedBox(
                            width: maxWidth(context),
                            height: 60,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  color: kWhite,
                                  height: 60,
                                ),
                                Positioned(
                                  top: -30,
                                  child: SizedBox(
                                    width: maxWidth(context),
                                    height: maxHeight(context),
                                    child: ListView.builder(
                                        itemCount: 5,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, i) {
                                          return GestureDetector(
                                            onTap: () {
                                              currentIndexBloc.storeData(i);
                                              _pageController!.jumpToPage(i);
                                            },
                                            onDoubleTap: () {
                                              if (i == 4 &&
                                                  profileModel!.member!.roles!
                                                          .length ==
                                                      2) {
                                                switchUserFunc(
                                                    context,
                                                    profileModel!
                                                        .member!.roles![0].id!);
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                _buildBottomBar(
                                                    i == 0
                                                        ? Icons.home
                                                        : i == 1
                                                            ? Icons.store
                                                            : i == 2
                                                                ? Icons
                                                                    .home_repair_service_rounded
                                                                : i == 3
                                                                    ? Icons
                                                                        .notifications
                                                                    : i == 4
                                                                        ? Icons
                                                                            .person
                                                                        : Icons
                                                                            .abc,
                                                    i == 0
                                                        ? 'Home'
                                                        : i == 1
                                                            ? 'GD Store'
                                                            : i == 2
                                                                ? 'Package'
                                                                : i == 3
                                                                    ? 'Notification'
                                                                    : i == 4
                                                                        ? 'Profile'
                                                                        : Icons
                                                                            .abc,
                                                    i,
                                                    mySnapshot.data),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //     });
                      //   },
                      // ),
                    );
                  }
                }),
          );
        });
  }

  Widget _buildBottomBar(icon, text, i, currentIndex) {
    return Container(
      color: Colors.transparent,
      width: maxWidth(context) / 5,
      height: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          currentIndex == i
              ? CircleAvatar(
                  backgroundColor:
                      currentIndex == i && isVisible ? kWhite : kTransparent,
                  radius: 33,
                  child:
                      //  showCase == 'empty'
                      //     ?
                      ShowCaseWidget(
                    builder: Builder(builder: (context) {
                      return MyShowCase(
                        globalKey: i == 0
                            ? keyOne
                            : i == 1
                                ? keyTwo
                                : i == 2
                                    ? keyThree
                                    : i == 3
                                        ? keyFour
                                        : keyFive,
                        title: i == 0
                            ? 'Explore GD'
                            : i == 1
                                ? 'View GD Store'
                                : i == 2
                                    ? 'View our packages'
                                    : i == 3
                                        ? 'Get Notified'
                                        : 'View your details',
                        desc: i == 0
                            ? 'Scroll to view our services.'
                            : i == 1
                                ? 'Scroll to view our products.'
                                : i == 2
                                    ? 'Tap here to view our packages'
                                    : i == 3
                                        ? 'Tap here to view your notification'
                                        : 'Tap here to view your details',
                        child: CircleAvatar(
                          backgroundColor: currentIndex == i && isVisible
                              ? currentIndex == 4
                                  ? myColor.dialogBackgroundColor
                                      .withOpacity(0.4)
                                  : myColor.primaryColorDark
                              : Colors.transparent,
                          radius: 28,
                          child: currentIndex == 3
                              ? myIconStack(Icons.notifications, 30.0, kWhite,
                                  notificationCountBloc)
                              : currentIndex == 4 && getToken != null
                                  ? myCachedNetworkImageCircle(
                                      56.0,
                                      56.0,
                                      profileModel!.imagePath.toString(),
                                      BoxFit.cover,
                                    )
                                  : Icon(
                                      icon,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                        ),
                      );
                    }),
                  )
                  // : CircleAvatar(
                  //     backgroundColor: currentIndex == i && isVisible
                  //         ? currentIndex == 4
                  //             ? myColor.dialogBackgroundColor
                  //                 .withOpacity(0.4)
                  //             : myColor.primaryColorDark
                  //         : Colors.transparent,
                  //     radius: 28,
                  //     child: currentIndex == 3
                  //         ? myIconStack(Icons.notifications, 30.0, kWhite,
                  //             notificationCountBloc)
                  //         : currentIndex == 4 && getToken != null
                  //             ? myCachedNetworkImageCircle(
                  //                 56.0,
                  //                 56.0,
                  //                 profileModel!.imagePath.toString(),
                  //                 BoxFit.cover,
                  //               )
                  //             : Icon(
                  //                 Icons.abc,
                  //                 color: kWhite,
                  //                 size: 30.0,
                  //               ),
                  //   ),
                  )
              : i == 3
                  //  && notificationCount != null
                  ? myIconStack(Icons.notifications, 25.0,
                      const Color(0xFFB3B3B3), notificationCountBloc)
                  : Icon(
                      icon,
                      color: const Color(0xFFB3B3B3),
                      size: 25.0,
                    ),
          const SizedBox2(),
          Text(
            text,
            style: kStyleNormal.copyWith(
              color: currentIndex == i
                  ? myColor.primaryColorDark
                  : const Color(0xFFB3B3B3),
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3.0),
        ],
      ),
    );
  }
}
