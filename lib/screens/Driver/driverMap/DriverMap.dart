import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DriverSideModel/GetListOfUserRequestModel.dart';
import 'package:ghargharmadoctor/models/PostFcmTokenModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

StateHandlerBloc? completeTripBtnBloc = StateHandlerBloc();

class DriverMap extends StatefulWidget {
  const DriverMap({
    Key? key,
  }) : super(key: key);

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? ambulanceIcon;
  ProfileModel? profileModel;
  bool isLoading = false;
  bool areYouPatientValue = false;
  double? myLat, myLng, afterScrollLatValue, afterScrollLngValue;
  List<Predictions> placeSuggestion = [];
  ApiHandlerBloc? userRequestListBloc, ambulanceTripBloc;
  StateHandlerBloc? acceptBtnBloc, isDriverOnRideBloc;
  bool isDriverOnRide = false;
  List<GetUserLatLngToTrackInDriverSide> getUserLatLngToTrackInDriverSide = [];
  final Set<Marker> _markers = <Marker>{};
  StateHandlerBloc? checkBoxBloc, areYouPatientBloc, btnBloc;
  final TextEditingController _myController = TextEditingController();
  final _form = GlobalKey<FormState>();
  List<AmbulanceTripModel> ambulanceTripModel = [];
  ApiHandlerBloc? mapBloc, mapBloc2, userLatLngBloc;
  String initialValue = '';
  int currentStep = 0; 
  int? isLastStep;
  GetListOfUserRequestModel? getListOfUserRequestModel;
  String? _searchValue,
      currentAddress,
      bookerName,
      patientName,
      bookerNumber,
      patientNumber;
  StateHandlerBloc? googleMapBloc;
  List<LatLng> polylineCoordinates = [];
  GoogleMapModel? googleMapModel;
  TabController? _tabController;
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();
    userRequestListBloc = ApiHandlerBloc();
    ambulanceTripBloc = ApiHandlerBloc();
    userRequestListBloc!.fetchAPIList(endpoints.postRequestToDriver);
    googleMapBloc = StateHandlerBloc();
    acceptBtnBloc = StateHandlerBloc();
    // startJourneyBtnBloc = StateHandlerBloc();
    // completeTripBtnBloc = StateHandlerBloc();
    isDriverOnRideBloc = StateHandlerBloc();
    userLatLngBloc = ApiHandlerBloc();
    requestLocationPermission(getLatAndLng, onLocationDeclined);
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    ambulanceTripBloc!.fetchAPIList(endpoints.postAcceptAmbulanceReq);
  }

  void getPolyPoints(sourceLat, sourceLng, desLat, desLng) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      endpoints.apiKey,
      PointLatLng(sourceLat, sourceLng),
      PointLatLng(desLat, desLng),
      // PointLatLng(myLat!, myLng!),
      // const PointLatLng(
      //     27.693778,
      //    85.321623),
      // PointLatLng(
      //   double.parse(
      //       ambulanceTripModel[0].userAddress!.pickUpLatitude.toString()),
      //   double.parse(
      //       ambulanceTripModel[0].userAddress!.pickUpLongitude.toString()),
      // ),
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  getLatAndLng() async {
    loc.LocationData? currentPosition;
    final loc.Location location = loc.Location();

    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((loc.LocationData currentLocation) async {
      currentPosition = currentLocation;
    });
    myLat = currentPosition!.latitude;
    myLng = currentPosition!.longitude;
    googleMapModel = GoogleMapModel(
      lat: myLat,
      lng: myLng,
    );

    _getCurrentPostion();
  }

  double calculateDistance(sLat, sLng, dlat, dLng) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((dlat - sLat) * p) / 2 +
        cos(sLat * p) * cos(dlat * p) * (1 - cos((dLng - sLng) * p)) / 2;
    // distanceBloc!.storeData(12742 * asin(sqrt(a)));
    return 12742 * asin(sqrt(a));
  }

  trackLocationContinuous(context, AmbulanceTripModel data) async {
    loc.LocationData? currentPosition;
    final loc.Location location = loc.Location();

    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((loc.LocationData currentLocation) async {
      currentPosition = currentLocation;
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            ),
          ),
        ),
      );
      String tripStatus = sharedPrefs.getFromDevice("tripStatus");
      if (tripStatus == 'tripStarted') {
        var dist = calculateDistance(
            currentLocation.latitude!,
            currentLocation.longitude!,
            double.parse(
              data.userAddress!.pickUpLatitude.toString(),
            ),
            double.parse(
              data.userAddress!.pickUpLongitude.toString(),
            ));

        if (dist < 0.8) {
          isDriverOnRideBloc!.storeData('reachedDestination');
          completeTripBtnBloc!.storeData('endTrip');
        }
      }

      _markers.clear();
      _markers.add(Marker(
          icon: ambulanceIcon!,
          markerId: const MarkerId('1'),
          position: LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          ),
          infoWindow: const InfoWindow(
            title: 'my title',
            snippet: 'my snippet',
          ),
          onTap: () {}));
      String userID = sharedPrefs.getUserID('userID');
      // int statusCode;
      // statusCode = await API().postData(
      //     context,
      //     PostDriverCurrentLocationModel(
      //       latitude: currentLocation.latitude!,
      //       longitude: currentLocation.longitude!,
      //       // deviceKey:
      //       //     'dNDWCcl0QD2UG1bPAGl-81:APA91bF5ey3phhX7jbb79IcA52ShskWclabObn0rgKyFNtjHvTEWyDKX_Zndyws-3jILEttmc6gBZG5WMR4TR7wwHuqlN6WxJFtZRel7U1Kak9agjisFBPUEikK_wU_TodKHR0vnstIb',
      //       deviceKey: getListOfUserRequestModel!.fcm!.deviceKey,
      //     ),
      //     'trips/location/$userID');
      // if (statusCode == 200) {
      //   mySnackbar.mySnackBar(
      //       context, 'new lat updated: $statusCode', myColor.primaryColorDark);
      // } else {
      //   mySnackbar.mySnackBar(
      //       context, 'location not posted: $statusCode', Colors.red);
      // }
      // setState(() {});
    });
    myLat = currentPosition!.latitude;
    myLng = currentPosition!.longitude;
    googleMapModel = GoogleMapModel(
      lat: myLat,
      lng: myLng,
    );
  }

  onLocationDeclined() {
    Navigator.pop(context);
  }

  _getCurrentPostion() async {
    userLatLngBloc!.fetchAPIList(endpoints.postAcceptAmbulanceReq);
    googleMapBloc!.storeData(googleMapModel);
    postLatLngToServer();
    _postFCMTokenToAllowNotification();
    if (ambulanceIcon == null) {
      ImageConfiguration configuration =
          createLocalImageConfiguration(context, size: const Size(4.0, 4.0));
      bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      if (isIOS) {
        BitmapDescriptor.fromAssetImage(
                configuration, 'assets/ambulanceIcon.png')
            .then((icon) {
          setState(() {
            ambulanceIcon = icon;
          });
        });
      } else {
        BitmapDescriptor.fromAssetImage(
                configuration, 'assets/ambulanceIcon.png')
            .then((icon) {
          setState(() {
            ambulanceIcon = icon;
          });
        });
      }
    }
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myLat!, myLng!), zoom: 17)));

    _markers.add(Marker(
        icon: ambulanceIcon!,
        markerId: const MarkerId('1'),
        position: LatLng(myLat!, myLng!),
        infoWindow: const InfoWindow(
          title: 'my title',
          snippet: 'my snippet',
        ),
        onTap: () {}));
    // _getAddressFromCoordinates(myLat!, myLng!);
  }

  void _getAddressFromCoordinates(lat, lng) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lng);

    Placemark place = placemark[0];
    String mainAddress = place.thoroughfare.toString();
    String area = place.subLocality.toString();
    String subArea = place.locality.toString();
    String district = place.subAdministrativeArea.toString();
    String country = place.country.toString();
    String street = place.street.toString();
    String address;
    if (mainAddress == '') {
      address = '$street, $subArea, $district, $country';
    } else {
      address = '$street, $mainAddress, $district, $country';
    }

    if (subArea == district) {
      address = '$street, $mainAddress, $area, $district, $country';
    }
    setState(() {
      _myController.text = address;
      _searchValue = address;
    });
    print('_searchValue $_searchValue');
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    double myLat = place['geometry']['location']['lat'];
    double myLng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(myLat, myLng),
          zoom: 17,
        ),
      ),
    );
    _markers.clear();
    _setMarker(LatLng(myLat, myLng));
  }

  void _mapOnTap(position) async {
    mapBloc!.fetchGoogleMapAPIAutoComplete('');
    FocusManager.instance.primaryFocus?.unfocus();
    double myLat = position.latitude;
    double myLng = position.longitude;
    _getAddressFromCoordinates(myLat, myLng);
    _markers.clear();
    _setMarker(position);
  }

  Future _postFCMTokenToAllowNotification() async {
    String fcmToken = sharedPrefs.getFromDevice("fcm");
    API().postData(context, PostFcmTokenModel(deviceKey: fcmToken),
        endpoints.postFCMTokenEndpoint);
  }

  postLatLngToServer() async {
    String userID = sharedPrefs.getUserID('userID');
    API().postData(
        context,
        PostDriverCurrentLocationModel(
          latitude: myLat,
          longitude: myLng,
        ),
        'trips/location/$userID');
  }

  void postDriverActiveStatus() async {
    String userID = sharedPrefs.getUserID('userID');
    int statusCode;
    statusCode = await API().postData(
        context, PostDriverCurrentLocationModel(), 'trips/status/$userID');
    if (statusCode == 200) {
      if (_tabController!.index == 0) {
        mySnackbar.mySnackBarCustomized(
            context, '', 'You wont\'t receive patient request', () {}, kRed);
      } else {
        mySnackbar.mySnackBarCustomized(
            context, '', 'You will now receive patient request', () {}, kGreen);
      }
    }
  }

  acceptBtn(GetListOfUserRequestModel myData) async {
    acceptBtnBloc!.storeData(!isLoading);
    int statusCode;
    statusCode = await API().postData(
        context,
        AcceptRequestModel(
          driverSourceLatitude: googleMapModel!.lat.toString(),
          driverSourceLongitude: googleMapModel!.lng.toString(),
          status: 'driverAcceptedRequest',
          // notificationID:
          //     'fqNRUhvJT52cXAJ8weAxn6:APA91bGt1xEd-cJySYAmNELyMRy5kxL5RpGxqieWOKjjrJXOK5b1t4mdjDKXIpPLbyEqxo5D1GlaTdAcGfmIU5UKnQGpnuSPXMbtkvCOKMAPG6qwSufWL7CRsgvy-jkNoA07mYjwWwaq',
          notificationID: myData.fcm!.deviceKey,
        ),
        endpoints.postAcceptAmbulanceReq);

    if (statusCode == 200) {
      acceptBtnBloc!.storeData(isLoading);
      isDriverOnRideBloc!.storeData('onTheWay');
      // ambulanceTripBloc!.fetchAPIList(endpoints.postAcceptAmbulanceReq);
      // userRequestListBloc!.fetchAPIList(endpoints.postRequestToDriver);
    } else {
      mySnackbar.mySnackBar(context, 'Error $statusCode', kRed);
      acceptBtnBloc!.storeData(isLoading);
    }
  }

  endTrip(context) async {
    completeTripBtnBloc!.storeData('loading');
    print('ambulanceTripModel[0].id ${ambulanceTripModel[0].id}');
    int statusCode;
    statusCode = await API().postData(
      context,
      AcceptRequestModel(status: 'complete journey request by driver'),
      'trips/driver-finished-trip/${ambulanceTripModel[0].id}',
    );

    if (statusCode == 200) {
      completeTripBtnBloc!.storeData('hide');
      isDriverOnRideBloc!.storeData('waitForUserVerification');
    } else {
      completeTripBtnBloc!.storeData('endTrip');
    }
  }

  startTrip(context) async {
    sharedPrefs.storeToDevice("tripStatus", 'tripStarted');
    getPolyPoints(
      double.parse(
        ambulanceTripModel[0].userAddress!.pickUpLatitude.toString(),
      ),
      double.parse(
        ambulanceTripModel[0].userAddress!.pickUpLongitude.toString(),
      ),
      double.parse(
        ambulanceTripModel[0].destinationLatitude.toString(),
      ),
      double.parse(
        ambulanceTripModel[0].destinationLongitude.toString(),
      ),
    );
    var dist = calculateDistance(
      double.parse(
        ambulanceTripModel[0].userAddress!.pickUpLatitude.toString(),
      ),
      double.parse(
        ambulanceTripModel[0].userAddress!.pickUpLongitude.toString(),
      ),
      double.parse(
        ambulanceTripModel[0].destinationLatitude.toString(),
      ),
      double.parse(
        ambulanceTripModel[0].destinationLongitude.toString(),
      ),
    );

    if (dist < 0.8) {
      completeTripBtnBloc!.storeData('endTrip');

      // startJourneyBtnBloc!.storeData('showCompleteJourneyBtn');
    } else {
      completeTripBtnBloc!.storeData('hide');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: StreamBuilder<dynamic>(
            initialData: googleMapModel,
            stream: googleMapBloc!.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: AnimatedLoading());
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GoogleMap(
                            polylines: getListOfUserRequestModel != null
                                ? {
                                    Polyline(
                                      polylineId: const PolylineId("route"),
                                      points: polylineCoordinates,
                                      color: myColor.primaryColorDark,
                                      width: 6,
                                    )
                                  }
                                : {},
                            onCameraMove: (position) async {
                              // final GoogleMapController controller =
                              //     await _controller.future;
                              // LatLngBounds bounds =
                              //     await controller.getVisibleRegion();
                              // LatLng center = LatLng(
                              //   (bounds.northeast.latitude +
                              //           bounds.southwest.latitude) /
                              //       2,
                              //   (bounds.northeast.longitude +
                              //           bounds.southwest.longitude) /
                              //       2,
                              // );
                              // afterScrollLatValue = center.latitude;
                              // afterScrollLngValue = center.longitude;
                            },
                            onCameraIdle: () {
                              // _getAddressFromCoordinates(
                              //     afterScrollLatValue, afterScrollLngValue);
                            },
                            onTap: (position) {
                              _mapOnTap(position);
                            },
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(myLat!, myLng!), zoom: 17),
                            markers: _markers,
                            zoomControlsEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                          Positioned(
                            top: 50.0,
                            right: 12.0,
                            left: 12.0,
                            child: StreamBuilder<dynamic>(
                                initialData: 'waitingForTrip',
                                stream: isDriverOnRideBloc!.stateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data == 'onTheWay') {
                                    return infoCard(
                                      context,
                                      myColor.dialogBackgroundColor,
                                      myColor.primaryColorDark,
                                      'Please follow the route and reach the patient as soon as possible',
                                    );
                                  } else if (snapshot.data ==
                                      'waitForUserVerification') {
                                    return infoCard(
                                      context,
                                      myColor.dialogBackgroundColor,
                                      myColor.primaryColorDark,
                                      'Please wait until user verfies journey completion',
                                    );
                                  } else if (snapshot.data ==
                                      'waitingForTrip') {
                                    return Container(
                                      width: maxWidth(context),
                                      decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                              color: _tabController!.index == 0
                                                  ? kRed
                                                  : myColor.primaryColorDark)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: TabBar(
                                          onTap: (i) {
                                            if (_tabController!
                                                .indexIsChanging) {
                                              postLatLngToServer();
                                              postDriverActiveStatus();
                                            }
                                            setState(() {});
                                          },
                                          labelColor: kWhite,
                                          unselectedLabelColor: kBlack,
                                          controller: _tabController,
                                          indicator: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: _tabController!.index == 0
                                                ? kRed
                                                : myColor.primaryColorDark,
                                          ),
                                          tabs: [
                                            Tab(
                                              child: Text(
                                                'Offline',
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: Text(
                                                'Online',
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.data ==
                                      'reachedDestination') {
                                    return infoCard(
                                      context,
                                      myColor.dialogBackgroundColor,
                                      myColor.primaryColorDark,
                                      'You have reached the hospital',
                                    );
                                  }
                                  return Container();
                                }),
                          ),
                          Positioned(
                            top: 1,
                            bottom: 1,
                            right: (maxWidth(context) / 2) - 12,
                            left: (maxWidth(context) / 2) - 12,
                            child: CircleAvatar(
                              backgroundColor: kRed,
                            ),
                          ),
                          Positioned(
                            top: 1,
                            bottom: 1,
                            right: (maxWidth(context) / 2) - 10,
                            left: (maxWidth(context) / 2) - 10,
                            child: CircleAvatar(
                              backgroundColor: kRed,
                              child: myCachedNetworkImageCircle(
                                20.0,
                                20.0,
                                profileModel!.imagePath.toString(),
                                BoxFit.cover,
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: 15.0,
                          //   left: 15.0,
                          //   bottom: 155.0,
                          //   child: StreamBuilder<dynamic>(
                          //       initialData: 'hide',
                          //       stream: startJourneyBtnBloc!.stateStream,
                          //       builder: (context, snapshot) {
                          //         if (snapshot.data == 'hide') {
                          //           return Container();
                          //         } else if (snapshot.data ==
                          //             'showCompleteJourneyBtn') {
                          //           return SizedBox(
                          //             width: maxWidth(context),
                          //             height: 50.0,
                          //             child: myCustomButton(
                          //               context,
                          //               myColor.primaryColorDark,
                          //               'End Trip',
                          //               kStyleNormal.copyWith(
                          //                 fontSize: 14.0,
                          //                 color: kWhite,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //               () {
                          //                 endTrip(context);
                          //               },
                          //             ),
                          //           );
                          //         } else {
                          //           return SizedBox(
                          //             width: maxWidth(context),
                          //             height: 50.0,
                          //             child: myCustomButton(
                          //               context,
                          //               myColor.primaryColorDark,
                          //               'Start Trip',
                          //               kStyleNormal.copyWith(
                          //                 fontSize: 14.0,
                          //                 color: kWhite,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //               () {
                          //                 startTrip(context);
                          //               },
                          //             ),
                          //           );
                          //         }
                          //       }),
                          // ),

                          Positioned(
                            right: 15.0,
                            left: 15.0,
                            bottom: 155.0,
                            child: StreamBuilder<dynamic>(
                                initialData: 'hide',
                                stream: completeTripBtnBloc!.stateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data == 'loading') {
                                    return myBtnLoading(context, 50.0);
                                  } else if (snapshot.data == 'hide') {
                                    return Container();
                                  } else if (snapshot.data == 'endTrip') {
                                    return SizedBox(
                                      width: maxWidth(context),
                                      height: 50.0,
                                      child: myCustomButton(
                                        context,
                                        myColor.primaryColorDark,
                                        'Complete Trip',
                                        kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          color: kWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        () {
                                          endTrip(context);
                                        },
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      width: maxWidth(context),
                                      height: 50.0,
                                      child: myCustomButton(
                                        context,
                                        myColor.primaryColorDark,
                                        'Start Trip',
                                        kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          color: kWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        () {
                                          startTrip(context);
                                        },
                                      ),
                                    );
                                  }
                                }),
                          ),
                          Positioned(
                            right: 15.0,
                            left: 15.0,
                            bottom: 200.0,
                            child: StreamBuilder<ApiResponse<dynamic>>(
                              stream: userLatLngBloc!.apiListStream,
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.LOADING:
                                      return const Center(
                                        child: AnimatedLoading(),
                                      );
                                    case Status.COMPLETED:
                                      if (snapshot.data!.data.isEmpty) {
                                        return Container(
                                          width: maxWidth(context),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 12.0),
                                          decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: const [
                                              Text('No any ride'),
                                            ],
                                          ),
                                        );
                                      }

                                      getUserLatLngToTrackInDriverSide = List<
                                              GetUserLatLngToTrackInDriverSide>.from(
                                          snapshot.data!.data.map((i) =>
                                              GetUserLatLngToTrackInDriverSide
                                                  .fromJson(i)));

                                      return Container();
                                    case Status.ERROR:
                                      return Container(
                                        width: maxWidth(context),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text('Server Error 3'),
                                        ),
                                      );
                                  }
                                }
                                return const SizedBox();
                              }),
                            ),
                          ),
                          Positioned(
                            left: 12.0,
                            right: 12.0,
                            bottom: 100.0,
                            child: StreamBuilder<dynamic>(
                                initialData: 'onTheWay',
                                stream: isDriverOnRideBloc!.stateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data == 'onTheWay') {
                                    return StreamBuilder<ApiResponse<dynamic>>(
                                      stream:
                                          userRequestListBloc!.apiListStream,
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
                                                return infoCard(
                                                  context,
                                                  myColor.dialogBackgroundColor,
                                                  myColor.primaryColorDark,
                                                  'No any active trip',
                                                );
                                              }
                                              getListOfUserRequestModel =
                                                  GetListOfUserRequestModel
                                                      .fromJson(
                                                          snapshot.data!.data);
                                              // if (getListOfUserRequestModel!
                                              //         .driverDetails!.status ==
                                              //     'approved') {}
                                              if (getListOfUserRequestModel!
                                                      .driverDetails!.status ==
                                                  'pending') {
                                                return acceptRejectCard(
                                                    getListOfUserRequestModel!);
                                              } else {
                                                // isDriverOnRideBloc!
                                                //     .storeData('onTheWay');
                                                return StreamBuilder<
                                                    ApiResponse<dynamic>>(
                                                  stream: ambulanceTripBloc!
                                                      .apiListStream,
                                                  builder:
                                                      ((context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      switch (snapshot
                                                          .data!.status) {
                                                        case Status.LOADING:
                                                          return const AnimatedLoading();
                                                        case Status.COMPLETED:
                                                          ambulanceTripModel = List<
                                                                  AmbulanceTripModel>.from(
                                                              snapshot
                                                                  .data!.data
                                                                  .map((i) =>
                                                                      AmbulanceTripModel
                                                                          .fromJson(
                                                                              i)));

                                                          if (ambulanceTripModel[
                                                                      0]
                                                                  .status ==
                                                              1) {
                                                            getPolyPoints(
                                                              myLat!,
                                                              myLng!,
                                                              double.parse(
                                                                ambulanceTripModel[
                                                                        0]
                                                                    .userAddress!
                                                                    .pickUpLatitude
                                                                    .toString(),
                                                              ),
                                                              double.parse(
                                                                ambulanceTripModel[
                                                                        0]
                                                                    .userAddress!
                                                                    .pickUpLongitude
                                                                    .toString(),
                                                              ),
                                                            );
                                                          }
                                                          if (ambulanceTripModel[
                                                                      0]
                                                                  .status ==
                                                              2) {
                                                            getPolyPoints(
                                                              double.parse(
                                                                ambulanceTripModel[
                                                                        0]
                                                                    .userAddress!
                                                                    .pickUpLatitude
                                                                    .toString(),
                                                              ),
                                                              double.parse(
                                                                ambulanceTripModel[
                                                                        0]
                                                                    .userAddress!
                                                                    .pickUpLongitude
                                                                    .toString(),
                                                              ),
                                                              double.parse(
                                                                ambulanceTripModel[
                                                                        0]
                                                                    .destinationLatitude
                                                                    .toString(),
                                                              ),
                                                              double.parse(
                                                                ambulanceTripModel[
                                                                        0]
                                                                    .destinationLongitude
                                                                    .toString(),
                                                              ),
                                                            );
                                                          }
                                                          trackLocationContinuous(
                                                              context,
                                                              ambulanceTripModel[
                                                                  0]);
                                                          // if (getListOfUserRequestModel!
                                                          //         .driverDetails!
                                                          //         .status ==
                                                          //     'pending') {
                                                          //   return acceptRejectCard(
                                                          //       getListOfUserRequestModel!);
                                                          // } else if (getListOfUserRequestModel!
                                                          //         .driverDetails!
                                                          //         .status ==
                                                          //     'approved') {
                                                          //   return patientDetailsCard(
                                                          //       getListOfUserRequestModel!);
                                                          // } else {
                                                          //   return Container();
                                                          // }
                                                          return patientDetailsCard(
                                                              getListOfUserRequestModel!);
                                                        case Status.ERROR:
                                                          return Container(
                                                            width: maxWidth(
                                                                context),
                                                            height: 135.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                  'Server Error'),
                                                            ),
                                                          );
                                                      }
                                                    }
                                                    return const SizedBox();
                                                  }),
                                                );
                                              }

                                            case Status.ERROR:
                                              return Container(
                                                width: maxWidth(context),
                                                height: 135.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                  child: Text('Server Error 2'),
                                                ),
                                              );
                                          }
                                        }
                                        return SizedBox(
                                          width: maxWidth(context),
                                          height: 200,
                                        );
                                      }),
                                    );
                                  } else {
                                    return const Text(
                                        'inside else of Driver Is On the way bloc');
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget patientDetailsCard(GetListOfUserRequestModel data) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        width: maxWidth(context),
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(children: [
          Text('Patient name: ',
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              )),
          Text(data.driverDetails!.userProfile!.user!.name.toString(),
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ))
        ]));
  }

  Widget acceptRejectCard(GetListOfUserRequestModel myData) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        width: maxWidth(context),
        margin: const EdgeInsets.only(bottom: 8.0),
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
              myData.driverDetails!.userProfile!.imagePath,
                BoxFit.cover,
              ),
              const SizedBox(width: 18.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myData.driverDetails!.userProfile!.user!.name.toString(),
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
                                acceptBtn(myData);
                              },
                            ));
                      }
                    }),
              ),
            ],
          ),
        ]));
  }
}
