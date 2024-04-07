import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/Nurse/appointment/NurseListofAppointments.dart';
import 'package:ghargharmadoctor/screens/Nurse/home/NurseHomeScreen.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/NurseProfileScreen.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/notificationScreen/UserNotificationScreen.dart';
import 'package:ghargharmadoctor/screens/User/register/SelectUser.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class MainHomePageNurse extends StatefulWidget {
  final int index;
  final bool? isSwitched;
  final String? image;
  final String? name;
  final String? switchType;
  const MainHomePageNurse(
      {Key? key,
      required this.index,
      this.isSwitched,
      this.switchType,
      this.name,
      this.image})
      : super(key: key);

  @override
  State<MainHomePageNurse> createState() => _MainHomePageNurseState();
}

class _MainHomePageNurseState extends State<MainHomePageNurse>
    with TickerProviderStateMixin {
  String? getToken;
  final int _initialIndex = 1;
  StateHandlerBloc switchingLoadingBloc = StateHandlerBloc();
  int? _currentIndex;
  TabController? _tabController;
  bool menuIndex = false;
  List<Widget> screens = [];
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _tabController = TabController(
      initialIndex: _initialIndex,
      length: 4,
      vsync: this,
    );
    getToken = sharedPrefs.getFromDevice('token') ?? 'nullValue';
    screens = [
      const NurseHomeScreen(),
      const NurseListofAppointments(),
      const UserNotificationScreen(userType: 'Nurse'),
      const NurseProfileScreen(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _currentIndex == 1
            ? myForceBack.exitApp(context)
            : setState(() {
                _currentIndex = 1;
              });
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
                      name: widget.name,
                      image: widget.image,
                      switchType: widget.switchType,
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                extendBody: true,
                body: screens[_currentIndex!],
                bottomNavigationBar: SizedBox(
                  width: maxWidth(context),
                  height: 60,
                  child: Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          color: Colors.white,
                          width: maxWidth(context),
                          height: 60,
                        ),
                        Positioned(
                          top: -30,
                          child: SizedBox(
                            width: maxWidth(context),
                            height: maxHeight(context),
                            child: ListView.builder(
                                itemCount: 4,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, i) {
                                  return GestureDetector(
                                    onDoubleTap: () {
                                      if (i == 3) {
                                        String image =
                                            sharedPrefs.getFromDevice(
                                                'userProfilePicture');
                                        String name = sharedPrefs
                                            .getFromDevice('userName');
                                        goThere(
                                          context,
                                          MainHomePage(
                                            index: 4,
                                            tabIndex: 0,
                                            isSwitched: true,
                                            image: image,
                                            name: name,
                                          ),
                                        );
                                      }
                                    },
                                    onTap: () {
                                      setState(() {
                                        _currentIndex = i;
                                        menuIndex = false;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        _buildBottomBar(
                                            i == 0
                                                ? Icons.home
                                                : i == 1
                                                    ? Icons.date_range
                                                    : i == 2
                                                        ? Icons
                                                            .notifications_rounded
                                                        : i == 3
                                                            ? Icons.person
                                                            : Icons.abc,
                                            i == 0
                                                ? 'Home'
                                                : i == 1
                                                    ? 'Appointments'
                                                    : i == 2
                                                        ? 'Notification'
                                                        : i == 3
                                                            ? 'Profile'
                                                            : Icons.abc,
                                            i),
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
              );
            }
          }),
    );
  }

  Widget _buildBottomBar(icon, text, i) {
    return Container(
      color: Colors.transparent,
      width: maxWidth(context) / 4,
      height: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          menuIndex == false && _currentIndex == i
              ? CircleAvatar(
                  backgroundColor: kWhite,
                  radius: 33,
                  child: CircleAvatar(
                    backgroundColor: _currentIndex == i
                        ? myColor.primaryColorDark
                        : Colors.transparent,
                    radius: 28,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: _currentIndex == i ? 30.0 : 25.0,
                    ),
                  ))
              : Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Icon(
                    icon,
                    color: const Color(0xFFB3B3B3),
                    size: 25.0,
                  ),
                ),
          Text(
            text,
            style: kStyleNormal.copyWith(
              color: menuIndex == false && _currentIndex == i
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

  Widget _menuBottomBar() {
    return Container(
      color: Colors.transparent,
      width: (maxWidth(context) - (maxWidth(context) / 5)) / 4,
      height: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          menuIndex == true
              ? CircleAvatar(
                  backgroundColor: kWhite,
                  radius: 33,
                  child: CircleAvatar(
                    backgroundColor: myColor.primaryColorDark,
                    radius: 28,
                    child: Icon(
                      Icons.menu,
                      color: kWhite,
                      size: 30.0,
                    ),
                  ),
                )
              : const Icon(
                  Icons.menu,
                  color: Color(0xFFB3B3B3),
                  size: 25.0,
                ),
          const SizedBox2(),
          Text(
            'Menu',
            style: kStyleNormal.copyWith(
              color: menuIndex == true
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

class GuestProfileWidget extends StatefulWidget {
  const GuestProfileWidget({Key? key}) : super(key: key);

  @override
  State<GuestProfileWidget> createState() => _GuestProfileWidgetState();
}

class _GuestProfileWidgetState extends State<GuestProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: maxWidth(context)),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            width: maxWidth(context),
            height: 50,
            child: myCustomButton(
                context,
                myColor.primaryColorDark,
                'Register an account',
                kStyleNormal.copyWith(
                  color: Colors.white,
                  fontSize: 15.0,
                ), () {
              goThere(context, const SelectUser());
            }),
          ),
          const SizedBox12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: kStyleNormal,
              ),
              const SizedBox(width: 4.0),
              GestureDetector(
                onTap: () {
                  goThere(context, const LoginScreen());
                },
                child: Text(
                  'Login',
                  style: kStyleNormal.copyWith(
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
