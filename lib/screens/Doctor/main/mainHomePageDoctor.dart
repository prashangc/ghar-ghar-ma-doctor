import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/DotorListOfAppointmentScreen.dart';
import 'package:ghargharmadoctor/screens/Doctor/home/doctorHomeScreen.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/doctorProfile.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/notificationScreen/UserNotificationScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class MainHomePageDoctor extends StatefulWidget {
  final int index;
  final bool? isSwitched;
  final String? image;
  final String? name;
  final String? switchType;
  const MainHomePageDoctor(
      {Key? key,
      required this.index,
      this.isSwitched,
      this.switchType,
      this.name,
      this.image})
      : super(key: key);

  @override
  State<MainHomePageDoctor> createState() => _MainHomePageDoctorState();
}

class _MainHomePageDoctorState extends State<MainHomePageDoctor>
    with TickerProviderStateMixin {
  String? getToken;
  final int _initialIndex = 1;
  int? _currentIndex;
  TabController? _tabController;
  StateHandlerBloc switchingLoadingBloc = StateHandlerBloc();
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
      const DoctorHomeScreen(),
      const DotorListOfAppointmentScreen(),
      const UserNotificationScreen(userType: 'Doctor'),
      const DoctorProfileScreen(),
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
        _currentIndex == 0
            ? myForceBack.exitApp(context)
            : setState(() {
                _currentIndex = 0;
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
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        color: kWhite,
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
                                      String image = sharedPrefs
                                          .getFromDevice('userProfilePicture');
                                      String name =
                                          sharedPrefs.getFromDevice('userName');
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

                //   bottomNavigationBar: SizedBox(
                //     width: maxWidth(context),
                //     height: 60,
                //     child: Row(
                //       children: [
                //         Stack(
                //           clipBehavior: Clip.none,
                //           children: [
                //             Container(
                //               color: kWhite,
                //               width: maxWidth(context) / 5,
                //               height: 60,
                //             ),
                //             Positioned(
                //               top: -30,
                //               child: SizedBox(
                //                 height: maxHeight(context),
                //                 child: GestureDetector(
                //                   onTap: () {
                //                     setState(() {
                //                       menuIndex = true;
                //                     });
                //                     _scaffoldKey.currentState!.openDrawer();
                //                   },
                //                   child: Column(
                //                     children: [
                //                       _menuBottomBar(),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         Expanded(
                //           child: Stack(
                //             clipBehavior: Clip.none,
                //             children: [
                //               Container(
                //                 color: Colors.white,
                //                 width: maxWidth(context),
                //                 height: 60,
                //               ),
                //               Positioned(
                //                 top: -30,
                //                 child: SizedBox(
                //                   width: maxWidth(context),
                //                   height: maxHeight(context),
                //                   child: ListView.builder(
                //                       itemCount: 4,
                //                       physics: const NeverScrollableScrollPhysics(),
                //                       shrinkWrap: true,
                //                       scrollDirection: Axis.horizontal,
                //                       itemBuilder: (ctx, i) {
                //                         return GestureDetector(
                //                           onTap: () {
                //                             setState(() {
                //                               _currentIndex = i;
                //                               menuIndex = false;
                //                             });
                //                           },
                //                           child: Column(
                //                             children: [
                //                               _buildBottomBar(
                //                                   i == 0
                //                                       ? Icons.date_range
                //                                       : i == 1
                //                                           ? Icons.home
                //                                           : i == 2
                //                                               ? Icons
                //                                                   .notifications_rounded
                //                                               : i == 3
                //                                                   ? Icons.person
                //                                                   : Icons.abc,
                //                                   i == 0
                //                                       ? 'Appointments'
                //                                       : i == 1
                //                                           ? 'Home'
                //                                           : i == 2
                //                                               ? 'Notification'
                //                                               : i == 3
                //                                                   ? 'Profile'
                //                                                   : Icons.abc,
                //                                   i),
                //                             ],
                //                           ),
                //                         );
                //                       }),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              );
            }
          }),
    );
  }

  Widget _buildBottomBar(icon, text, i) {
    return GestureDetector(
      onDoubleTap: () {
        if (i == 2) {
          String image = sharedPrefs.getFromDevice('userProfilePicture');
          String name = sharedPrefs.getFromDevice('userName');
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
      child: Container(
        color: kTransparent,
        width: (maxWidth(context) / 4),
        height: 85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            menuIndex == false && _currentIndex == i
                ? CircleAvatar(
                    backgroundColor: _currentIndex == i ? kWhite : kGreen,
                    radius: 33,
                    child: CircleAvatar(
                      backgroundColor: _currentIndex == i
                          ? myColor.primaryColorDark
                          : kTransparent,
                      radius: 28,
                      child: Icon(
                        icon,
                        color: kWhite,
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
      ),
    );
  }
}
