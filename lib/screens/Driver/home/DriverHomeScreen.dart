import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DriverSideModel/GetListOfUserRequestModel.dart';
import 'package:ghargharmadoctor/models/PostFcmTokenModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Driver/main/mainHomePageDriver.dart';
import 'package:location/location.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSwitched = false;
  bool isLoading = false;
  ApiHandlerBloc? userRequestListBloc;
  StateHandlerBloc? acceptBtnBloc, googleMapBloc;
  String? fcmToken;
  String? userID;
  List<GetListOfUserRequestModel> getListOfUserRequestModel = [];
  GoogleMapModel? googleMapModel;
  double? lat, lng;
  LocationData? _currentPosition;
  final Location location = Location();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myColor.dialogBackgroundColor,
        toolbarHeight: 80.0,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi',
                // 'Hi, ${profileModel!.member!.name.toString().capitalize()}',
                style: kStyleNormal.copyWith(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'How are you feeling today?',
                style: kStyleNormal.copyWith(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 20.0, right: 20.0, bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: myColor.primaryColorDark,
            ),
            child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  size: 30.0,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox12(),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14.0, 2.0, 2.0, 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Status',
                    style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: myColor.primaryColorDark),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeTrackColor: myColor.primaryColorDark.withOpacity(0.3),
                    activeColor: myColor.primaryColorDark,
                    inactiveTrackColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
            const SizedBox16(),
            GestureDetector(
              onTap: () {
                pop_upHelper.popUpLogout(context);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: myColor.primaryColorDark,
                      size: 18.0,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'Logout',
                      style: kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox16(),
            Row(
              children: [
                const Text('fcm token'),
                Switch(
                  value: isSwitched,
                  onChanged: (value) async {
                    setState(() {
                      isSwitched = value;
                    });

                    if (isSwitched == true) {
                      _postFCMTokenToAllowNotification();
                      print('a');
                    }
                  },
                  activeTrackColor: myColor.primaryColorDark.withOpacity(0.3),
                  activeColor: myColor.primaryColorDark,
                  inactiveTrackColor: Colors.grey[200],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  acceptBtn() async {
    acceptBtnBloc!.storeData(!isLoading);
    int statusCode;
    statusCode = await API().postData(
        context,
        AcceptRequestModel(
          driverSourceLatitude: googleMapModel!.lat.toString(),
          driverSourceLongitude: googleMapModel!.lng.toString(),
        ),
        endpoints.postAcceptAmbulanceReq);

    if (statusCode == 200) {
      acceptBtnBloc!.storeData(isLoading);
      goThere(context, const MainHomePageDriver(index: 1));
    } else {
      mySnackbar.mySnackBar(context, 'Error $statusCode', kRed);
      acceptBtnBloc!.storeData(isLoading);
    }
  }

  Widget acceptRejectCard(GetListOfUserRequestModel myData) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myCachedNetworkImageCircle(
                40.0,
                40.0,
                'ambulance.address.toString()',
                BoxFit.cover,
              ),
              const SizedBox(width: 18.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'a',
                      // myData.userProfile!.user!.name.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox2(),
                    Text(
                      '2 km away',
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        color: myColor.primaryColorDark,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'NPR 500',
                style: kStyleNormal.copyWith(
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          const SizedBox16(),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50.0,
                  child: myWhiteButton(
                    context,
                    kWhite,
                    'Decline',
                    kStyleNormal.copyWith(
                      color: myColor.primaryColorDark,
                      fontSize: 16.0,
                    ),
                    () {},
                  ),
                ),
              ),
              const SizedBox(width: 6.0),
              Expanded(
                flex: 1,
                child: StreamBuilder<dynamic>(
                    initialData: isLoading,
                    stream: acceptBtnBloc!.stateStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return myBtnLoading(context, 50.0);
                      } else {
                        return SizedBox(
                            height: 50.0,
                            child: myCustomButton(
                              context,
                              myColor.primaryColorDark,
                              'Accept',
                              kStyleNormal.copyWith(
                                color: kWhite,
                                fontSize: 16.0,
                              ),
                              () {
                                acceptBtn();
                              },
                            ));
                      }
                    }),
              ),
            ],
          ),
        ]));
  }

  Future _postFCMTokenToAllowNotification() async {
    fcmToken = sharedPrefs.getFromDevice("fcm");
    print('fcmToken $fcmToken');
    var statusCode;
    statusCode = await API().postData(context,
        PostFcmTokenModel(deviceKey: fcmToken), endpoints.postFCMTokenEndpoint);
    if (statusCode == 200) {
      myToast.toast('fcmToken posted');
    } else {
      myToast.toast('Server Error');
    }
  }
}
