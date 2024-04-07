import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/appointment/DotorListOfAppointmentScreen.dart';
import 'package:ghargharmadoctor/screens/Nurse/appointment/NurseListofAppointments.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/notificationScreen/noAnyNotification.dart';
import 'package:ghargharmadoctor/screens/User/register/RegisterScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/AppointmentList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/MyOrders.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class UserNotificationScreen extends StatefulWidget {
  final String userType;
  const UserNotificationScreen({Key? key, required this.userType})
      : super(key: key);

  @override
  State<UserNotificationScreen> createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen>
    with AutomaticKeepAliveClientMixin<UserNotificationScreen> {
  @override
  bool get wantKeepAlive => true;
  ApiHandlerBloc? notificationBloc;
  List<UserNotificationModel> userNotificationModel = [];
  String? getToken;
  String params = '';
  StateHandlerBloc seenUnseenBloc = StateHandlerBloc();
  ScrollController? _scrollController;

  fetchAPI() {
    notificationBloc = ApiHandlerBloc();
    notificationBloc!.fetchAPIList('admin/booking-notification?type=$params');
  }

  @override
  void initState() {
    super.initState();
    getToken = sharedPrefs.getFromDevice('token');
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0.0,
        toolbarHeight: getToken == null ? 0.0 : 70.0,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Notifications',
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
                overflow: TextOverflow.ellipsis,
                color: kBlack,
              ),
            ),
          ),
        ),
      ),
      body: getToken == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    goThere(context, const RegisterScreen());
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
            )
          : StreamBuilder<dynamic>(
              initialData: 0,
              stream: refreshMainSreenBloc.stateStream,
              builder: (context, snapshot) {
                fetchAPI();
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                      ),
                      child: widget.userType == 'User'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                infoCard(
                                  context,
                                  FontAwesomeIcons.bell,
                                  'All',
                                  () {
                                    setState(() {
                                      params = '';
                                      fetchAPI();
                                    });
                                  },
                                  notificationCountBloc,
                                  'allUser',
                                ),
                                infoCard(
                                  context,
                                  FontAwesomeIcons.hospital,
                                  'Appointments',
                                  () {
                                    setState(() {
                                      params = 'User Booking';
                                      fetchAPI();
                                    });
                                  },
                                  userSideAppointmentNotificationCountBloc,
                                  'userAppointment',
                                ),
                                infoCard(
                                    context, FontAwesomeIcons.box, 'Orders',
                                    () {
                                  setState(() {
                                    params = 'Order';
                                    fetchAPI();
                                  });
                                }, orderNotificationCountBloc, 'Orders'),
                                infoCard(
                                  context,
                                  FontAwesomeIcons.newspaper,
                                  'News',
                                  () {
                                    setState(() {
                                      params = 'Order';
                                      fetchAPI();
                                    });
                                  },
                                  newsNotificationCountBloc,
                                  'News',
                                ),
                              ],
                            )
                          : widget.userType == 'Nurse'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                      infoCard(
                                        context,
                                        FontAwesomeIcons.bell,
                                        'All',
                                        () {
                                          setState(() {
                                            params = '';
                                            fetchAPI();
                                          });
                                        },
                                        allNurseNotificationCountBloc,
                                        'allNurse',
                                      ),
                                      infoCard(
                                        context,
                                        FontAwesomeIcons.hospital,
                                        'Appointments',
                                        () {
                                          setState(() {
                                            params = 'Nurse Booking';
                                            fetchAPI();
                                          });
                                        },
                                        nurseAppointmentNotificationCountBloc,
                                        'nurseAppointment',
                                      )
                                    ])
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    infoCard(
                                      context,
                                      FontAwesomeIcons.bell,
                                      'All',
                                      () {
                                        setState(() {
                                          params = '';
                                          fetchAPI();
                                        });
                                      },
                                      notificationCountBloc,
                                      'allDoctor',
                                    ),
                                    infoCard(
                                      context,
                                      FontAwesomeIcons.hospital,
                                      'Appointments',
                                      () {
                                        setState(() {
                                          params = 'Doctor Booking';
                                          fetchAPI();
                                        });
                                      },
                                      appointmentNotificationCountBloc,
                                      'doctorAppointment',
                                    ),
                                  ],
                                ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          color: myColor.dialogBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: StreamBuilder<dynamic>(
                              initialData: null,
                              stream: scrollingBloc.stateStream,
                              builder: (c, s) {
                                if (s.data == 3) {
                                  _scrollController!.animateTo(0,
                                      curve: Curves.easeInOut,
                                      duration:
                                          const Duration(milliseconds: 500));
                                }
                                return Column(children: [
                                  const SizedBox12(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text('Mark all as read',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 12.0,
                                                color: myColor.primaryColorDark,
                                              )),
                                          const SizedBox(width: 12.0),
                                          Icon(FontAwesomeIcons.broom,
                                              size: 12.0,
                                              color: myColor.primaryColorDark),
                                          const SizedBox(width: 16.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox16(),
                                  StreamBuilder<ApiResponse<dynamic>>(
                                    stream: notificationBloc!.apiListStream,
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData) {
                                        switch (snapshot.data!.status) {
                                          case Status.LOADING:
                                            return Container(
                                              width: maxWidth(context),
                                              height: maxHeight(context) / 2,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const AnimatedLoading(),
                                            );
                                          case Status.COMPLETED:
                                            if (snapshot.data!.data.isEmpty) {
                                              return noAnyNotificationCard();
                                            }
                                            userNotificationModel = List<
                                                    UserNotificationModel>.from(
                                                snapshot.data!.data.map((i) =>
                                                    UserNotificationModel
                                                        .fromJson(i)));
                                            return ListView.builder(
                                              itemCount:
                                                  userNotificationModel.length,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (ctx, i) {
                                                return notificationCard(
                                                    userNotificationModel[i],
                                                    i);
                                              },
                                            );

                                          case Status.ERROR:
                                            return Container(
                                              width: maxWidth(context),
                                              height: 160.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Center(
                                                child: Text('Server Error'),
                                              ),
                                            );
                                        }
                                      }
                                      return SizedBox(
                                        width: maxWidth(context),
                                      );
                                    }),
                                  ),
                                ]);
                              }),
                        ),
                      ),
                    ),
                  ],
                );
              }),
    );
  }

  Widget notificationCard(UserNotificationModel notification, int i) {
    return StreamBuilder<dynamic>(
        initialData: '${notification.watched}$i',
        stream: seenUnseenBloc.stateStream,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              if (snapshot.data == 'unseen$i') {
                seenBtn(notification, i);
              } else {
                print('already watched');
              }
              if (notification.type == 'allUser') {
              } else if (notification.type == 'allDoctor') {
              } else if (notification.type == 'allNurse') {
              } else if (notification.type == 'Order') {
                goThere(context, const MyOrders());
              } else if (notification.type == 'Appointments') {
                goThere(context, const AppointmentList(tabIndex: 0));
                // goThere(context, NurseAppointmentList());
              } else if (notification.type == 'doctorAppointment') {
                goThere(context, const DotorListOfAppointmentScreen());
              } else if (notification.type == 'nurseAppointment') {
                goThere(context, const NurseListofAppointments());
              } else if (notification.type == 'News') {}
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 2.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: snapshot.data == 'unseen$i'
                    ? kWhite.withOpacity(0.6)
                    : kWhite.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              width: maxWidth(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myCachedNetworkImageCircle(
                    50.0,
                    50.0,
                    notification.image,
                    BoxFit.cover,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.body.toString(),
                                // snapshot.data,
                                overflow: TextOverflow.clip,
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: snapshot.data == 'unseen$i'
                                      ? FontWeight.bold
                                      : FontWeight.w200,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            snapshot.data == 'unseen$i'
                                ? Icon(
                                    Icons.lightbulb_circle,
                                    color: kRed,
                                    size: 10.0,
                                  )
                                : Container(
                                    width: 10.0,
                                  ),
                          ],
                        ),
                        const SizedBox8(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: myColor.dialogBackgroundColor
                                      .withOpacity(0.4),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 4.0),
                              child: Text(
                                notification.createdAt!
                                    .substring(0, 10)
                                    .toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  seenBtn(UserNotificationModel data, i) async {
    var resp = await API()
        .getData(context, 'admin/notification/${data.type}/${data.id}');
    if (resp != null) {
      print('i - $i');
      seenUnseenBloc.storeData('seen$i');
      print('success');
    } else {
      print('error');
    }
  }

  Widget deleteBgCard() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget infoCard(context, icon, text, Function myTap, bloc, type) {
    int? count;
    if (type == 'allUser') {
      count = sharedPrefs.getIntFromDevice("notificationCount") ?? 0;
    } else if (type == 'allDoctor') {
      count = sharedPrefs.getIntFromDevice("allDoctorNotificationCount") ?? 0;
    } else if (type == 'allNurse') {
      count = sharedPrefs.getIntFromDevice("allNurseNotificationCount") ?? 0;
    } else if (type == 'Orders') {
      count = sharedPrefs.getIntFromDevice("orderNotificationCount") ?? 0;
    } else if (type == 'userAppointment') {
      count = sharedPrefs
              .getIntFromDevice("userSideAppointmentNotificationCount") ??
          0;
    } else if (type == 'doctorAppointment') {
      count = sharedPrefs.getIntFromDevice("appointmentNotificationCount") ?? 0;
    } else if (type == 'nurseAppointment') {
      count =
          sharedPrefs.getIntFromDevice("nurseAppointmentNotificationCount") ??
              0;
    } else if (type == 'News') {
      count = sharedPrefs.getIntFromDevice("newsNotificationCount") ?? 0;
    }

    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            // margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 50.0,
            decoration: BoxDecoration(
                color: kWhite.withOpacity(0.4), shape: BoxShape.circle),
            child: Stack(
              children: [
                Positioned(
                    right: 0.0,
                    child: StreamBuilder<dynamic>(
                        initialData: count,
                        stream: bloc.stateStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == 0) {
                            return Container();
                          } else {
                            return Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kRed,
                                  border: Border.all(
                                      color: backgroundColor, width: 1.5),
                                ),
                                child: Text(snapshot.data.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 8.0,
                                      color: kWhite,
                                    )));
                          }
                        })),
                Center(
                  child: Icon(
                    icon,
                    size: 16,
                    color: myColor.primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox8(),
          Text(
            text,
            style: kStyleNormal.copyWith(
              fontSize: 10.0,
              color: myColor.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}
