import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/AllAmbulanceLatLng.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/GetAllAmbulanceListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/AmbulanceCompletedList/HospitalizationForm.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:pip_view/pip_view.dart';
import 'package:url_launcher/url_launcher.dart';

double? ambulanceCurrentLat,
    ambulanceCurrentLng,
    afterScrollLatValue,
    afterScrollLngValue;

StateHandlerBloc? googleMapBloc = StateHandlerBloc();
StateHandlerBloc? refreshDialogBloc = StateHandlerBloc();
GoogleMapModel googleMapModel = GoogleMapModel();
ApiHandlerBloc? tripStatusBloc = ApiHandlerBloc();

class GoogleMapAmbulanceUserSide extends StatefulWidget {
  final int? driverID;
  final List<AllAmbulanceListModel>? getAllAmbulanceListModel;
  final String? seeAll;

  const GoogleMapAmbulanceUserSide({
    Key? key,
    this.driverID,
    this.getAllAmbulanceListModel,
    this.seeAll,
  }) : super(key: key);

  @override
  State<GoogleMapAmbulanceUserSide> createState() =>
      _GoogleMapAmbulanceUserSideState();
}

class _GoogleMapAmbulanceUserSideState extends State<GoogleMapAmbulanceUserSide>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        const AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          "ghargharmadoctor",
          "appchannel",
          importance: Importance.max,
          priority: Priority.high,
          // autoCancel: false,
          ongoing: true, colorized: true,
        );
        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);
        final FlutterLocalNotificationsPlugin notificationsPlugin =
            FlutterLocalNotificationsPlugin();

        notificationsPlugin.show(0, 'Ambulance Tracking Ongoing',
            'Tap here to view live ambulance tracking', notificationDetails,
            payload: 'item x');
        print('paused');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.resumed:
        print('resumed');
        break;
      case AppLifecycleState.detached:
        print('detached');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  PointerSizeModel? pointerSizeModel;
  GoogleMapModel? testPopModal, testPopModal2;
  bool isDriverTapped = false;
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Completer<GoogleMapController> _controller = Completer();
  ProfileModel? profileModel;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool areYouPatientValue = false;
  double? userLat,
      userLng,
      pickUpLng,
      pickUpLat,
      destinationLat,
      destinationLng;
  List<Predictions> placeSuggestion = [];
  final Set<Marker> _markers = <Marker>{};
  StateHandlerBloc? checkBoxBloc,
      areYouPatientBloc,
      btnBloc,
      showDriverHasArrivedBloc,
      priceBloc,
      markerBloc,
      stepperBloc,
      priceForExtendedBloc,
      ambulanceCardBloc,
      showBloc,
      completeBtnBloc,
      distanceBloc;
  final TextEditingController _myController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _formPatientname = GlobalKey<FormState>();
  ApiHandlerBloc? mapBloc,
      mapBloc2,
      medicalAssistantBloc,
      ambulanceTripBloc,
      ambulanceBloc;
  bool isTracking = false;
  String initialValue = '';
  List<LatLng> polylineCoordinates = [];
  List<AmbulanceTripModel> ambulanceTripModel = [];
  List<MedicalAssitanceModel> medicalAssitanceModel = [];
  int currentStep = 0;
  int currentStepExtend = 0;
  double _distance = 0;
  double totalPrice = 0;
  double totalPriceForExtended = 0;
  double extendedDistance = 0.0;
  int? isLastStep, myDriverId, isLastStepExtend;
  int? _medicalAssitantCheckBoxValue;
  String? _searchValue,
      currentAddress,
      patientName,
      timeNow,
      visitorName,
      visitorPhone,
      _paymentType,
      _paymentTypeForExtend,
      patientNumber,
      isAmbulanceTrackingStatus;
  double? newUpdatedLat, newUpdatedLng;
  TripStatusModel? tripStatusModel;
  List<GetAllAmbulanceListModel> getAllAmbulanceListModel = [];
  double rating = 5;
  @override
  void initState() {
    super.initState();
    pointerSizeModel = PointerSizeModel(
      outterCircleSize: 15.0,
      innerCircleSize: 12.0,
      imageSize: 24.0,
      verticalHeight: 15.0,
      gap: 0.0,
      dot: 6.0,
    );
    WidgetsBinding.instance.addObserver(this);
    myDriverId = widget.driverID;

    isAmbulanceTrackingStatus =
        sharedPrefs.getFromDevice('isAmbulanceTracking') ??
            'noAmbulanceTrackingStatus';
    if (isAmbulanceTrackingStatus == 'showAmbulanceForm') {
      isTracking = true;
      Future.delayed(const Duration(seconds: 0)).then((_) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return StreamBuilder<dynamic>(
                  stream: refreshDialogBloc!.stateStream,
                  builder: (context, snapshot) {
                    return bookingStatusDialog(tripStatusBloc);
                  });
            });
      });
    } else if (isAmbulanceTrackingStatus == 'showTrackingScreen') {
      isTracking = true;
      // pickUpLat =
      //     double.parse(sharedPrefs.getFromDevice('pickUpLat').toString());
      // pickUpLng =
      //     double.parse(sharedPrefs.getFromDevice('pickUpLng').toString());
    }
    // // PIPView.of(context)?.dispose();
    // PIPView.of(context)?.deac;
    currentTime();
    // googleMapBloc =
    checkBoxBloc = StateHandlerBloc();
    markerBloc = StateHandlerBloc();
    showBloc = StateHandlerBloc();
    stepperBloc = StateHandlerBloc();
    mapBloc = ApiHandlerBloc();
    ambulanceBloc = ApiHandlerBloc();
    ambulanceBloc!.fetchAPIList(endpoints.getAllAmbulanceEndpoint);
    ambulanceTripBloc = ApiHandlerBloc();
    mapBloc!.fetchGoogleMapAPIAutoComplete(initialValue);
    btnBloc = StateHandlerBloc();
    ambulanceCardBloc = StateHandlerBloc();
    priceBloc = StateHandlerBloc();
    completeBtnBloc = StateHandlerBloc();
    showDriverHasArrivedBloc = StateHandlerBloc();
    priceForExtendedBloc = StateHandlerBloc();
    distanceBloc = StateHandlerBloc();
    mapBloc2 = ApiHandlerBloc();
    medicalAssistantBloc = ApiHandlerBloc();
    areYouPatientBloc = StateHandlerBloc();
    requestLocationPermission(getLatAndLng, onLocationDeclined);
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  currentTime() {
    DateTime now = DateTime.now();
    timeNow = DateFormat('kk:mm').format(now);
  }

  getLatAndLng() async {
    loc.LocationData? currentPosition;
    final loc.Location location = loc.Location();

    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((loc.LocationData currentLocation) async {
      currentPosition = currentLocation;
      if (isTracking == true) {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newUpdatedLat!,
                newUpdatedLng!,
              ),
            ),
          ),
        );
      }
    });
    userLat = currentPosition!.latitude;
    userLng = currentPosition!.longitude;

    _getCurrentPostion();
  }

  onLocationDeclined() {
    Navigator.pop(context);
  }

  _getCurrentPostion() async {
    if (widget.getAllAmbulanceListModel != null &&
        widget.getAllAmbulanceListModel!.length == 1) {
      getPolyPoints(
          userLat!,
          userLng!,
          widget.getAllAmbulanceListModel![0].lat!,
          widget.getAllAmbulanceListModel![0].lng);
    }

    if (widget.getAllAmbulanceListModel != null) {
      // ImageConfiguration configuration =
      //     createLocalImageConfiguration(context, size: const Size(4.0, 4.0));
      // bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
      // if (isIOS) {
      //   BitmapDescriptor.fromAssetImage(
      //           configuration, 'assets/ambulanceIcon.png')
      //       .then((icon) {
      //     setState(() {
      //       ambulanceIcon = icon;
      //     });
      //   });
      // } else {
      //   BitmapDescriptor.fromAssetImage(
      //           configuration, 'assets/ambulanceIcon.png')
      //       .then((icon) {
      //     setState(() {
      //       ambulanceIcon = icon;
      //     });
      //   });
      // }
      for (var element in widget.getAllAmbulanceListModel!) {
        ambulanceCurrentLat = element.lat;
        ambulanceCurrentLng = element.lng;
        if (widget.getAllAmbulanceListModel!.length == 1) {
          googleMapModel = GoogleMapModel(
            lat: element.lat,
            lng: element.lng,
            isCameraMove: false,
          );
        } else {
          print(
              '${widget.getAllAmbulanceListModel!.length} in else widget.getAllAmbulanceListModel!.length');
          googleMapModel = GoogleMapModel(
            lat: userLat,
            lng: userLng,
            isCameraMove: false,
          );
        }
        _setAmbulanceMarker(LatLng(element.lat!, element.lng!));
      }
      print('individual ambulance clicked');
    } else {
      if (isAmbulanceTrackingStatus == 'showAmbulanceForm' ||
          isAmbulanceTrackingStatus == 'showTrackingScreen') {
        ambulanceCurrentLat =
            double.parse(sharedPrefs.getFromDevice('ambulanceLat').toString());
        ambulanceCurrentLng =
            double.parse(sharedPrefs.getFromDevice('ambulanceLng').toString());

        print('ambulanceCurrentLat $ambulanceCurrentLat');
        googleMapModel = GoogleMapModel(
          lat: ambulanceCurrentLat,
          lng: ambulanceCurrentLng,
          isCameraMove: false,
        );
        // if (pickUpLat != null) {
        // }
        _setAmbulanceMarker(
          LatLng(
            ambulanceCurrentLat!,
            ambulanceCurrentLng!,
          ),
        );
      } else {
        googleMapModel = GoogleMapModel(
          lat: userLat,
          lng: userLng,
          isCameraMove: false,
        );
        print('else current location');
      }
    }

    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: LatLng(ambulanceCurrentLat!, ambulanceCurrentLng!), zoom: 17)));

    // _markers.add(Marker(
    //     icon: ambulanceIcon!,
    //     markerId: const MarkerId('1'),
    //     position: LatLng(googleMapModel!.lat!, googleMapModel!.lng!),
    //     infoWindow: const InfoWindow(
    //       title: 'my title',
    //       snippet: 'my snippet',
    //     ),
    //     onTap: () {}));
    _getAddressFromCoordinates(userLat!, userLng!);

    googleMapBloc!.storeData(googleMapModel);
  }

  Future<String> returnAddressFromCoordinates(lat, lng) async {
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
    return address;
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
  }

  double calculateDistance(Dlat1, Dlon1, Ulat2, Ulon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((Ulat2 - Dlat1) * p) / 2 +
        cos(Dlat1 * p) * cos(Ulat2 * p) * (1 - cos((Ulon2 - Dlon1) * p)) / 2;
    // distanceBloc!.storeData(12742 * asin(sqrt(a)));
    return 12742 * asin(sqrt(a));
  }

  double calculatePickupToDestinationDistance(
      pickupLat, pickupLng, destinationLat, destinationLng) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((destinationLat - pickupLat) * p) / 2 +
        cos(pickupLat * p) *
            cos(destinationLat * p) *
            (1 - cos((destinationLng - pickupLng) * p)) /
            2;
    // distanceBloc!.storeData(12742 * asin(sqrt(a)));
    return 12742 * asin(sqrt(a));
  }

  void getPolyPoints(lat, lng, sourceLat, sourceLng) async {
    if (widget.seeAll != 'See All' || isDriverTapped == true) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        endpoints.apiKey,
        PointLatLng(sourceLat, sourceLng),
        PointLatLng(lat, lng),
      );
      if (result.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        // setState(() {});
      }
      _distance = 0.0;
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        _distance += calculateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude);
      }
      // _distance =
      //     calculateDistance(ambulanceCurrentLat, ambulanceCurrentLng, lat, lng);

      distanceBloc!.storeData(_distance);

      print('_distance _distance $_distance');
    } else {
      distanceBloc!.storeData(0);
    }
  }

  Future<void> _goToOffice() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
            target: LatLng(27.6966014, 85.3517784), zoom: 17)));
    _markers.clear();
    _setMarker(const LatLng(27.6966014, 85.3517784));
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(userLat!, userLng!), zoom: 17)));
    _markers.clear();
    _setMarker(LatLng(userLat!, userLng!));
  }

  void _setMarker(LatLng point) {
    if (isTracking == false) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('marker'),
            position: point,
          ),
        );
      });
    }
  }

  void _setAmbulanceMarker(LatLng point) async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/ambulanceIcon.png",
    );
    print('hello');
    _markers.add(Marker(
        icon: markerbitmap,
        markerId: const MarkerId('1'),
        position: point,
        infoWindow: const InfoWindow(
          title: 'my title',
          snippet: 'my snippet',
        ),
        onTap: () {}));

    // setState(() {});
  }

  void _searchBtn() async {
    _form.currentState?.validate();
    FocusManager.instance.primaryFocus?.unfocus();
    mapBloc!.fetchGoogleMapAPIAutoComplete(initialValue);
    var place = await LocationService().getPlace(_myController.text);
    _goToPlace(place);
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => similarPlaceBottomSheet());
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

  Widget similarPlaceBottomSheet() {
    mapBloc2!.fetchGoogleMapAPIAutoComplete(_myController.text);
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: mapBloc2!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Container(
                width: maxWidth(context),
                height: 135.0,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const AnimatedLoading(),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: 140,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('No Nearby landmarks')));
              }

              placeSuggestion = List<Predictions>.from(
                  snapshot.data!.data.map((i) => Predictions.fromJson(i)));
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Similar Place',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const Icon(
                          Icons.close,
                          size: 22.0,
                        )
                      ],
                    ),
                    const SizedBox32(),
                    const SizedBox32(),
                    ListView.builder(
                        itemCount: placeSuggestion.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              var place = await LocationService().getPlace(
                                  placeSuggestion[i].description.toString());
                              _goToPlace(place);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                placeSuggestion[i].description.toString(),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              );
            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 135.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Server Error'),
                ),
              );
          }
        }
        return const SizedBox();
      }),
    );
  }

  void myAutoCompleteLocationTap(myIndex) async {
    setState(() {
      _searchValue = placeSuggestion[myIndex].description.toString();
    });

    FocusManager.instance.primaryFocus?.unfocus();
    _myController.text = placeSuggestion[myIndex].description.toString();
    mapBloc!.fetchGoogleMapAPIAutoComplete('');

    List<Location> locations = await locationFromAddress(
        placeSuggestion[myIndex].description.toString());
    setState(() {
      userLat = locations.last.latitude;
      userLng = locations.last.longitude;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLat!, userLng!),
          zoom: 16,
        ),
      ),
    );
    _markers.clear();
    _setMarker(LatLng(userLat!, userLng!));
  }

  Widget allAmbulanceStreamBuilderCard() {
    return StreamBuilder<ApiResponse<dynamic>>(
      // initialData: ApiResponse.loading('LOADING')
      stream: ambulanceBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return SizedBox(
                width: maxWidth(context),
                height: 180,
                child: const Center(child: AnimatedLoading()),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: 20.0,
                    padding: const EdgeInsets.all(22.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('No ambulance added')));
              }
              print('completed');
              getAllAmbulanceListModel = List<GetAllAmbulanceListModel>.from(
                  snapshot.data!.data
                      .map((i) => GetAllAmbulanceListModel.fromJson(i)));
              return Column(
                children: [
                  widget.seeAll == 'See All'
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          color: myColor.primaryColorDark,
                          width: maxWidth(context),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 18.0,
                                color: kWhite,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  _myController.text,
                                  style: kStyleNormal.copyWith(color: kWhite),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  const SizedBox16(),
                  Text(
                    'Near By Ambulances',
                    style: kStyleNormal.copyWith(
                      color: myColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox16(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: getAllAmbulanceListModel.length,
                      itemBuilder: (ctx, i) {
                        return allAmbulanceCard(getAllAmbulanceListModel[i], i);
                      },
                    ),
                  ),
                ],
              );

            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 135.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Server Error'),
                ),
              );
          }
        }
        return const SizedBox();
      }),
    );
  }

  Widget ambulanceBottomSheet(context, GetAllAmbulanceListModel ambulance) {
    bool isLoading = false;
    StateHandlerBloc btnBloc = StateHandlerBloc();
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Text(
                "Pickup Location",
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox12(),
              Container(
                width: maxWidth(context),
                height: 45.0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8.0),
                    Icon(
                      Icons.location_on,
                      size: 18.0,
                      color: myColor.primaryColorDark,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _myController.text,
                              style: kStyleNormal,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SizedBox(
                              width: 20.0,
                              height: 40.0,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 30.0,
                                color: myColor.primaryColorDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox16(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: myColor.primaryColorDark, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 120,
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(width: 18.0),
                          Container(
                            margin: const EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.close,
                              color: myColor.primaryColorDark,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Close',
                            style: kStyleNormal.copyWith(
                              color: myColor.primaryColorDark,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: StreamBuilder<dynamic>(
                      initialData: isLoading,
                      stream: btnBloc.stateStream,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data) {
                            case true:
                              return myCircularIndicator();
                            case false:
                              return SizedBox(
                                width: maxWidth(context),
                                height: 50.0,
                                child: myCustomButton(
                                  context,
                                  myColor.primaryColorDark,
                                  'Book',
                                  kStyleNormal.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                  () {
                                    sendRequestToDriver();
                                  },
                                ),
                              );
                          }
                        }
                        return const SizedBox();
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox12(),
              const SizedBox8(),
            ],
          ),
        );
      }),
    );
  }

  Widget allAmbulanceCard(GetAllAmbulanceListModel ambulance, i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isDriverTapped = true;
        });
        _scaffoldKey.currentState!.closeEndDrawer();
        getPolyPoints(
            userLat!, userLng!, ambulanceCurrentLat!, ambulanceCurrentLng!);
        ambulanceCardBloc!.storeData(i);
        ambulanceCurrentLat = double.parse(ambulance.latitude.toString());
        ambulanceCurrentLng = double.parse(ambulance.longitude.toString());
        googleMapModel = GoogleMapModel(
            lat: ambulanceCurrentLat,
            lng: ambulanceCurrentLng,
            isCameraMove: true);
        googleMapBloc!.storeData(googleMapModel);
      },
      child: StreamBuilder<dynamic>(
          stream: ambulanceCardBloc!.stateStream,
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(12.0),
              width: maxWidth(context),
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  border: Border.all(
                      color: snapshot.data == null
                          ? kTransparent
                          : i == snapshot.data
                              ? myColor.primaryColorDark
                              : kTransparent)),
              margin: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  myCachedNetworkImageCircle(
                    40.0,
                    40.0,
                    ambulance.address.toString(),
                    BoxFit.cover,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ambulance.driver!.name.toString(),
                          style: kStyleNormal.copyWith(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox2(),
                        // StreamBuilder<dynamic>(
                        //     initialData: _distance,
                        //     stream: distanceBloc!.stateStream,
                        //     builder: (context, snapshot) {
                        //       String finalDist = '';
                        //       var dist = calculateDistance(
                        //           double.parse(ambulance.latitude.toString()),
                        //           double.parse(ambulance.longitude.toString()),
                        //           afterScrollLatValue,
                        //           afterScrollLngValue);
                        //       if (dist > 1.0) {
                        //         finalDist = dist.round().toString();
                        //       } else {
                        //         finalDist = dist.toString().substring(0, 3);
                        //       }

                        //       return Row(
                        //         children: [
                        //           RatingBar.builder(
                        //             minRating: 5,
                        //             itemBuilder: (context, _) {
                        //               return const Icon(
                        //                 Icons.star,
                        //                 color: Color.fromRGBO(255, 193, 7, 1),
                        //                 size: 1.0,
                        //               );
                        //             },
                        //             itemCount: 5,
                        //             initialRating: rating,
                        //             updateOnDrag: true,
                        //             itemSize: 12.0,
                        //             itemPadding:
                        //                 const EdgeInsets.only(right: 2.0),
                        //             onRatingUpdate: (rating) => setState(() {
                        //               this.rating = rating;
                        //             }),
                        //           ),
                        //           const SizedBox(width: 10.0),
                        //           Text('$finalDist km away',
                        //               style: kStyleNormal.copyWith(
                        //                 fontSize: 12.0,
                        //                 fontWeight: FontWeight.bold,
                        //               )),
                        //         ],
                        //       );
                        //     }),
                        // const SizedBox2(),
                        Text(ambulance.address.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  GestureDetector(
                    onTap: () {
                      // myDriverId = ambulance.id;
                      showModalBottomSheet(
                          backgroundColor: backgroundColor,
                          isScrollControlled: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) =>
                              ambulanceBottomSheet(context, ambulance));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: myColor.primaryColorDark,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: kWhite,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget pickUpLocationCard() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox16(),
          Text(
            'Pickup Location',
            style: kStyleNormal.copyWith(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          textFormUnEditable(_myController.text),
          const SizedBox16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Distance',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
              ),
              StreamBuilder<dynamic>(
                  initialData: _distance,
                  stream: distanceBloc!.stateStream,
                  builder: (context, snapshot) {
                    return Text(
                      '${snapshot.data} km',
                      style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: myColor.primaryColorDark),
                    );
                  }),
            ],
          ),
          const SizedBox16(),
          isTracking == true
              ? Container()
              : StreamBuilder<dynamic>(
                  initialData: isLoading,
                  stream: btnBloc!.stateStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data) {
                        case true:
                          return myBtnLoading(context, 55.0);
                        case false:
                          return SizedBox(
                              width: maxWidth(context),
                              height: 55.0,
                              child: myCustomButton(
                                context,
                                myColor.primaryColorDark,
                                'Book Ambulance',
                                kStyleNormal.copyWith(
                                    color: kWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                                () {
                                  sendRequestToDriver();
                                },
                              ));
                      }
                    }
                    return const SizedBox();
                  }),
                ),
        ],
      ),
    );
  }

  Widget textFormUnEditable(textValue) {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 17.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12.0),
          const Icon(
            Icons.location_on_outlined,
            size: 16.0,
            color: Colors.black,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              textValue,
              overflow: TextOverflow.ellipsis,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  chooseDestinationStep() {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () async {
          var myPoppedData = await goThere(context, const MyGoogleMap());
          if (myPoppedData != null) {
            setState(() {
              testPopModal = myPoppedData;
            });
            print('afterScrollLatValue $afterScrollLatValue');
            print('afterScrollLngValue $afterScrollLngValue');
            print('testPopModal!.lat ${testPopModal!.lat}');
            print('testPopModal!.lng ${testPopModal!.lng}');
            double secondDistance = 0.0;
            for (var i = 0; i < polylineCoordinates.length - 1; i++) {
              secondDistance += calculateDistance(
                  polylineCoordinates[i].latitude,
                  polylineCoordinates[i].longitude,
                  polylineCoordinates[i + 1].latitude,
                  polylineCoordinates[i + 1].longitude);
            }
            // var secondDistance = calculateDistance(
            //     afterScrollLatValue ?? userLat,
            //     afterScrollLngValue ?? userLng,
            //     testPopModal!.lat,
            //     testPopModal!.lng);
            print('_distance $_distance');
            print('secondDistance $secondDistance');
            var totalDistance = _distance + secondDistance;
            print('totalDistance $totalDistance');
            totalPrice = double.parse(ambulanceTripModel[0]
                    .ambulanceFare!
                    .amountPerKmPerHr
                    .toString()) *
                totalDistance;
            print('totalPrice $totalPrice');

            priceBloc!.storeData(totalPrice);
          }
        },
        child: Container(
          width: maxWidth(context),
          height: 45.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              Icon(
                Icons.location_on,
                size: 18.0,
                color: myColor.primaryColorDark,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        testPopModal == null
                            ? 'Select from Map'
                            : testPopModal!.address.toString(),
                        style: kStyleNormal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 20.0,
                        height: 40.0,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  chooseDestinationForExtendStep() {
    return StatefulBuilder(builder: (context, setState2) {
      return GestureDetector(
        onTap: () async {
          var myPoppedData = await goThere(context, const MyGoogleMap());
          if (myPoppedData != null) {
            setState2(() {
              testPopModal2 = myPoppedData;
              showBloc!.storeData(1);
            });
            print('distance is down');
            print(
              double.parse(
                  ambulanceTripModel[0].destinationLatitude.toString()),
            );
            extendedDistance = 0.0;
            for (var i = 0; i < polylineCoordinates.length - 1; i++) {
              extendedDistance += calculateDistance(
                  polylineCoordinates[i].latitude,
                  polylineCoordinates[i].longitude,
                  polylineCoordinates[i + 1].latitude,
                  polylineCoordinates[i + 1].longitude);
            }
            //  = calculateDistance(
            //   double.parse(
            //       ambulanceTripModel[0].destinationLatitude.toString()),
            //   double.parse(
            //       ambulanceTripModel[0].destinationLongitude.toString()),
            //   testPopModal2!.lat,
            //   testPopModal2!.lng,
            // );
            totalPriceForExtended = 70.0 * extendedDistance;
            priceForExtendedBloc!.storeData(totalPriceForExtended);
          }
        },
        child: Container(
          width: maxWidth(context),
          height: 45.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8.0),
              Icon(
                Icons.location_on,
                size: 18.0,
                color: myColor.primaryColorDark,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        testPopModal2 == null
                            ? 'Select from Map'
                            : testPopModal2!.address.toString(),
                        style: kStyleNormal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 20.0,
                        height: 40.0,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  paymentMethodForExtendStep() {
    return StatefulBuilder(builder: (context, setState) {
      return paymentMethod(context, false, false, onValueChanged: (v) {
        _paymentTypeForExtend = v;
      });
    });
  }

  List<Step> getStepsForExtend() => [
        Step(
          state: currentStepExtend > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStepExtend >= 0,
          title: Text(
            'Choose Destination',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: chooseDestinationForExtendStep(),
        ),
        Step(
          state: currentStepExtend > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStepExtend >= 1,
          title: Text(
            'Payment Method',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: paymentMethodForExtendStep(),
        ),
      ];

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            'Choose Destination',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: chooseDestinationStep(),
        ),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text(
              'Patient\'s Information',
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            content: patientInformationStep()),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text(
            'Visitor\'s Information',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: visitorInformationStep(),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: Text(
            'Medical Assurance',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          content: medicalStep(),
        ),
      ];

  Widget visitorInformationStep() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          myTextForm(
              context,
              visitorName ?? 'Enter Visitor Name',
              'Enter Visitor Name',
              visitorName,
              kWhite.withOpacity(0.4), onValueChanged: (v) {
            visitorName = v;
          }),
          const SizedBox12(),
          myTextForm(
              context,
              visitorPhone ?? 'Enter Visitor Phone',
              'Enter Visitor Phone',
              visitorPhone,
              kWhite.withOpacity(0.4), onValueChanged: (v) {
            visitorPhone = v;
          }),
        ],
      );
    });
  }

  Widget patientInformationStep() {
    return StatefulBuilder(builder: (context, setState) {
      return Form(
        key: _formPatientname,
        child: Column(
          children: [
            myCheckBox(
              'Are you the Patient?',
              areYouPatientBloc,
              onValueChanged: (v) {
                areYouPatientValue = v;
                if (areYouPatientValue == true) {
                  setState(() {
                    patientName = profileModel!.member!.name;
                    patientNumber = profileModel!.member!.phone;
                  });
                } else {
                  setState(() {
                    patientName = null;
                    patientNumber = null;
                  });
                }
              },
            ),
            const SizedBox8(),
            myTextForm(
                context,
                patientName ?? 'Enter Patient Name',
                'Enter Patient Name',
                patientName,
                kWhite.withOpacity(0.4), onValueChanged: (v) {
              patientName = v;
            }),
            const SizedBox12(),
            myTextForm(
                context,
                patientNumber ?? 'Enter Patient Phone',
                'Enter Patient Phone',
                patientNumber,
                kWhite.withOpacity(0.4), onValueChanged: (v) {
              patientNumber = v;
            }),
          ],
        ),
      );
    });
  }

  Widget medicalStep() {
    medicalAssistantBloc!
        .fetchAPIList(endpoints.getMedicalAssistanceInAmbulanceBooking);
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<ApiResponse<dynamic>>(
            stream: medicalAssistantBloc!.apiListStream,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return LoadingShimmer(
                      height: 20.0,
                      width: maxWidth(context),
                    );
                  case Status.COMPLETED:
                    if (snapshot.data!.data.isEmpty) {
                      return Container();
                    }
                    medicalAssitanceModel = List<MedicalAssitanceModel>.from(
                        snapshot.data!.data
                            .map((i) => MedicalAssitanceModel.fromJson(i)));

                    return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: medicalAssitanceModel.length,
                        itemBuilder: (ctx, i) {
                          return myCheckBoxList(
                            '${medicalAssitanceModel[i].title.toString()}  (Rs ${medicalAssitanceModel[i].price.toString()})',
                            checkBoxBloc,
                            onValueChanged: (v) {
                              setState(() {
                                _medicalAssitantCheckBoxValue = v;
                                if (_medicalAssitantCheckBoxValue == 0) {
                                  totalPrice = double.parse(
                                          ambulanceTripModel[0]
                                              .ambulanceFare!
                                              .amountPerKmPerHr
                                              .toString()) *
                                      _distance;
                                  priceBloc!.storeData(totalPrice);
                                } else {
                                  totalPrice = double.parse(
                                          ambulanceTripModel[0]
                                              .ambulanceFare!
                                              .amountPerKmPerHr
                                              .toString()) *
                                      _distance;
                                  totalPrice = totalPrice +
                                      double.parse(medicalAssitanceModel[i]
                                          .price!
                                          .toString());
                                  priceBloc!.storeData(totalPrice);
                                }
                              });
                            },
                          );
                        });
                  case Status.ERROR:
                    return const Center(
                      child: Text('Server Error'),
                    );
                }
              }
              return const SizedBox();
            }),
          ),
          const SizedBox16(),
          Text(
            'Payment Method',
            style: kStyleNormal.copyWith(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          paymentMethod(context, false, false, onValueChanged: (v) {
            _paymentType = v;
          }),
        ],
      );
    });
  }

  Widget myCheckBoxList(name, StateHandlerBloc? dynamicBloc,
      {ValueChanged<int>? onValueChanged}) {
    return Row(children: [
      Expanded(
        child: Text(
          name,
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        width: 30.0,
        height: 30.0,
        child: StreamBuilder<dynamic>(
            initialData: false,
            stream: dynamicBloc!.stateStream,
            builder: (context, snapshot) {
              return Checkbox(
                  activeColor: myColor.primaryColorDark,
                  side: BorderSide(width: 1.0, color: myColor.primaryColorDark),
                  visualDensity: const VisualDensity(horizontal: -4),
                  value: snapshot.data,
                  onChanged: (bool? newValue) {
                    dynamicBloc.storeData(newValue!);
                    onValueChanged!(newValue == false ? 0 : 1);
                  });
            }),
      ),
    ]);
  }

  Widget ambulanceVerificationForm(status) {
    ambulanceTripBloc!.fetchAPIList(endpoints.getUserTripEndpoint);
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
          width: maxWidth(context),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: myColor.dialogBackgroundColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox12(),
                infoCard(
                    context,
                    status == 'approved'
                        ? kRed.withOpacity(0.4)
                        : myColor.dialogBackgroundColor,
                    status == 'approved'
                        ? kRed.withOpacity(0.4)
                        : myColor.primaryColorDark,
                    status == 'pending'
                        ? 'Please wait until driver accepts the request.'
                        : status == 'approved'
                            ? 'Please fill the form to view live ambulance tracking.'
                            : status == 2
                                ? 'The trip has ended.'
                                : ''),
                status == 'approved'
                    ? StreamBuilder<ApiResponse<dynamic>>(
                        stream: ambulanceTripBloc!.apiListStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return const AnimatedLoading();
                              case Status.COMPLETED:
                                ambulanceTripModel =
                                    List<AmbulanceTripModel>.from(
                                        snapshot.data!.data.map((i) =>
                                            AmbulanceTripModel.fromJson(i)));
                                // totalPrice = ambulanceTripModel[0].price;
                                totalPrice = double.parse(ambulanceTripModel[0]
                                    .ambulanceFare!
                                    .amountPerKmPerHr
                                    .toString());
                                totalPrice = totalPrice * _distance;
                                priceBloc!.storeData(totalPrice);
                                return StreamBuilder<dynamic>(
                                    initialData: 0,
                                    stream: stepperBloc!.stateStream,
                                    builder: (context, snapshot) {
                                      return Theme(
                                        data: ThemeData(
                                          colorScheme: Theme.of(context)
                                              .colorScheme
                                              .copyWith(
                                                primary:
                                                    myColor.primaryColorDark,
                                              ),
                                        ),
                                        child: Stepper(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            elevation: 0,
                                            type: StepperType.vertical,
                                            onStepTapped: (int index) {
                                              // if (currentStep != index) {
                                              //   currentStep = currentStep;
                                              // }
                                            },
                                            steps: getSteps(),
                                            currentStep: snapshot.data,
                                            controlsBuilder:
                                                (context, details) {
                                              isLastStep =
                                                  getSteps().length - 1;
                                              return Container();
                                            }),
                                      );
                                    });

                              case Status.ERROR:
                                return Container(
                                  width: maxWidth(context),
                                  height: 135.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('Server Error'),
                                  ),
                                );
                            }
                          }
                          return const SizedBox();
                        }),
                      )
                    : Container(),
                status == 'approved'
                    ? Container(
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            currentStep > 0
                                ? Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (currentStep != 0) {
                                          // var isValid = _form2.currentState?.validate();
                                          // if (isValid!) {
                                          // setState(() {
                                          currentStep -= 1;
                                          stepperBloc!.storeData(currentStep);
                                          // });
                                          // }
                                        } else {
                                          submitAmbulanceForm(false);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: myColor.primaryColorDark,
                                        ),
                                        child: const Icon(
                                          FontAwesomeIcons.arrowLeft,
                                          size: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kGrey.withOpacity(0.4)),
                                    child: const Icon(
                                      FontAwesomeIcons.arrowLeft,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: StreamBuilder<dynamic>(
                                    initialData: 0,
                                    stream: showBloc!.stateStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == 0) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Price',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            StreamBuilder<dynamic>(
                                                initialData: totalPrice,
                                                stream: priceBloc!.stateStream,
                                                builder: (context, snapshot) {
                                                  return Text.rich(
                                                    TextSpan(
                                                      text: 'Rs  ',
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontSize: 22.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: snapshot.data
                                                              .round()
                                                              .toString(),
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontSize: 22.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Price',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            StreamBuilder<dynamic>(
                                                initialData: totalPrice,
                                                stream: priceBloc!.stateStream,
                                                builder: (context, snapshot) {
                                                  return Text.rich(
                                                    TextSpan(
                                                      text: 'Rs  ',
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontSize: 22.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: snapshot.data
                                                              .round()
                                                              .toString(),
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontSize: 22.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ],
                                        );
                                      }
                                    }),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  if (currentStep != isLastStep) {
                                    // var isValid = _form2.currentState?.validate();
                                    // if (isValid!) {
                                    // setState(() {
                                    currentStep += 1;
                                    stepperBloc!.storeData(currentStep);

                                    // });
                                    // }
                                  } else {
                                    submitAmbulanceForm(false);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: myColor.primaryColorDark,
                                  ),
                                  child: Icon(
                                    isLastStep == currentStep
                                        ? FontAwesomeIcons.check
                                        : FontAwesomeIcons.arrowRight,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [

                //     StreamBuilder<dynamic>(
                //         initialData: false,
                //         stream: tickBtnBloc!.stateStream,
                //         builder: (context, snapshot) {
                //           if (snapshot.data == true) {
                //             return Container(
                //               margin: const EdgeInsets.only(right: 20.0),
                //               decoration: BoxDecoration(
                //                 shape: BoxShape.circle,
                //                 color: myColor.primaryColorDark,
                //               ),
                //               child: CircularProgressIndicator(
                //                 backgroundColor: myColor.dialogBackgroundColor,
                //                 color: kWhite.withOpacity(0.4),
                //                 strokeWidth: 1.3,
                //               ),
                //             );
                //           } else {
                //             return GestureDetector(
                //               onTap: () {
                //                 if (currentStep == 0) {
                //                   // var isValid = _form2.currentState?.validate();
                //                   // if (isValid!) {
                //                   setState(() {
                //                     currentStep += 1;
                //                   });
                //                   // }
                //                 } else {
                //                   submitAmbulanceForm();
                //                 }
                //               },
                //               child: Container(
                //                 margin: const EdgeInsets.only(right: 20.0),
                //                 padding: const EdgeInsets.all(10.0),
                //                 decoration: BoxDecoration(
                //                   shape: BoxShape.circle,
                //                   color: myColor.primaryColorDark,
                //                 ),
                //                 child: Icon(
                //                   isLastStep == currentStep
                //                       ? FontAwesomeIcons.check
                //                       : FontAwesomeIcons.arrowRight,
                //                   size: 18.0,
                //                   color: Colors.white,
                //                 ),
                //               ),
                //             );
                //           }
                //         }),
                //   ],
                // ),
                const SizedBox12(),
                ambulanceLog(status),
                // SizedBox(
                //   width: maxWidth(context),
                //   height: 55.0,
                //   child: myCustomButton(
                //     context,
                //     myColor.primaryColorDark,
                //     'Submit',
                //     kStyleNormal.copyWith(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 16.0),
                //     () {},
                //   ),
                // ),
                // const SizedBox16(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget myTextForm(context, hintText, errorMessage, textValue, bgColor,
      {required ValueChanged<String>? onValueChanged}) {
    // TextEditingController myText = TextEditingController();
    // myText.text = hintText ?? '';
    // myText.selection = TextSelection.collapsed(offset: myText.text.length);
    return TextFormField(
      // controller: myText,
      textCapitalization: TextCapitalization.words,
      style: kStyleNormal.copyWith(
        fontSize: 12.0,
      ),
      onChanged: (String value) {
        onValueChanged!(value);
      },
      onTap: () {},
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        filled: true,
        fillColor: bgColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: bgColor, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: hintText,
        hintStyle: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      onSaved: (v) {
        textValue = v;
      },
    );
  }

  Widget ambulanceLog(status) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              const SizedBox12(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    status == 'approved'
                        ? Icons.check_circle
                        : Icons.error_outline_outlined,
                    color: status == 1 ? kGreen : myColor.primaryColorDark,
                    size: 35.0,
                  ),
                  const SizedBox(width: 15.0),
                  Text(
                    status == 'approved'
                        ? 'Booked Successfully'
                        : 'Booking Pending',
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: status == 1 ? kGreen : myColor.primaryColorDark,
                    ),
                  ),
                ],
              ),
              const SizedBox16(),
              status == 'approved'
                  ? StreamBuilder<dynamic>(
                      initialData: googleMapModel,
                      stream: googleMapBloc!.stateStream,
                      builder: (context, snapshot) {
                        if (snapshot.data.address == null) {
                          return Row(
                            children: [
                              Text(
                                timeNow.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              SizedBox(
                                width: 40.0,
                                child: Divider(
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                  child: Text(
                                'Locating the Ambulance...',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              )),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Text(
                                snapshot.data.time.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              SizedBox(
                                width: 40.0,
                                child: Divider(
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                  child: Text(
                                snapshot.data.address.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              )),
                            ],
                          );
                        }
                      })
                  : Container(),
              const SizedBox16(),
            ],
          ),
        ),
        const SizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myBtn('Cancel', FontAwesomeIcons.xmark, kRed, 18.0, () {
              sharedPrefs.removeFromDevice('isAmbulanceTracking');
              sharedPrefs.removeFromDevice('ambulanceLat');
              sharedPrefs.removeFromDevice('ambulanceLng');
            }),
            const SizedBox(width: 10.0),
            myBtn('Call', FontAwesomeIcons.phone, kGreen, 16.0, () {}),
          ],
        ),
        const SizedBox16(),
      ],
    );
  }

  Widget myBtn(txt, icon, clr, size, tap) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          tap();
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: clr,
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                txt,
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  color: kWhite,
                ),
              ),
              const SizedBox(width: 8.0),
              Icon(
                icon,
                size: size,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  completeJourney(AmbulanceTripModel data) async {
    completeBtnBloc!.storeData(true);
    int statusCode;
    statusCode = await API().postData(
      context,
      AcceptRequestModel(status: 'complete journey clicked by user'),
      'trips/user-finished-trip/${data.id}',
    );

    if (statusCode == 200) {
      sharedPrefs.removeFromDevice('isAmbulanceTracking');
      completeBtnBloc!.storeData(false);
      sharedPrefs.removeFromDevice('ambulanceLat');
      sharedPrefs.removeFromDevice('ambulanceLng');
      goThere(context, const HospitalizationFormPage());
    } else {
      completeBtnBloc!.storeData(false);
    }
  }

  Widget driverDetailsCard() {
    ambulanceTripBloc!.fetchAPIList(endpoints.getUserTripEndpoint);
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: ambulanceTripBloc!.apiListStream,
      builder: ((context, snapshot) {
        print('reload done');
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const AnimatedLoading();
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return infoCard(
                  context,
                  myColor.dialogBackgroundColor,
                  myColor.primaryColorDark,
                  'data empty',
                );
              }
              ambulanceTripModel = List<AmbulanceTripModel>.from(snapshot
                  .data!.data
                  .map((i) => AmbulanceTripModel.fromJson(i)));
              //  _setAmbulanceMarker(LatLng(
              //                    double.parse(
              //                     ambulanceTripModel[0].driverSourceLatitude.toString()),
              //                 double.parse(
              //                     ambulanceTripModel[0].driverSourceLongitude.toString()),
              //                 ));
              if (ambulanceTripModel[0].status == 1) {
                pickUpLat = double.parse(ambulanceTripModel[0]
                    .userAddress!
                    .pickUpLatitude
                    .toString());
                pickUpLng = double.parse(ambulanceTripModel[0]
                    .userAddress!
                    .pickUpLongitude
                    .toString());
                ambulanceCurrentLat = double.parse(
                    ambulanceTripModel[0].driverSourceLatitude.toString());
                ambulanceCurrentLng = double.parse(
                    ambulanceTripModel[0].driverSourceLongitude.toString());
                GoogleMapModel googleMapModel = GoogleMapModel(
                  lat: double.parse(
                      ambulanceTripModel[0].driverSourceLatitude.toString()),
                  lng: double.parse(
                      ambulanceTripModel[0].driverSourceLongitude.toString()),
                  time: ambulanceTripModel[0].startTime.toString(),
                  address: 'Driver has left',
                );
                getPolyPoints(pickUpLat, pickUpLng, ambulanceCurrentLat!,
                    ambulanceCurrentLng!);
                googleMapBloc!.storeData(googleMapModel);
              }
              if (ambulanceTripModel[0].status == 2) {
                pickUpLat = double.parse(ambulanceTripModel[0]
                    .userAddress!
                    .pickUpLatitude
                    .toString());
                pickUpLng = double.parse(ambulanceTripModel[0]
                    .userAddress!
                    .pickUpLongitude
                    .toString());
                destinationLat = 27.700514;
                destinationLng = 85.2733308;

                // double destinationLat = double.parse(
                //     ambulanceTripModel[0].destinationLatitude.toString());
                // double destinationLng = double.parse(
                //     ambulanceTripModel[0].destinationLongitude.toString());
                GoogleMapModel googleMapModel = GoogleMapModel(
                  lat: pickUpLat,
                  lng: pickUpLng,
                  time: ambulanceTripModel[0].startTime.toString(),
                  address: 'Driver has reached to user',
                );
                getPolyPoints(
                    pickUpLat, pickUpLng, destinationLat, destinationLng);

                googleMapBloc!.storeData(googleMapModel);
              }

              return Column(
                children: [
                  const SizedBox8(),
                  ambulanceTripModel[0].status == 4
                      ? StreamBuilder<dynamic>(
                          stream: googleMapBloc!.stateStream,
                          initialData: googleMapModel,
                          builder: (context, snapshot) {
                            // var distFromPickUpToDestination =
                            //     calculatePickupToDestinationDistance(pickUpLat,
                            //         pickUpLng, destinationLat, destinationLng);
                            var distFromPickUpToDestination = 0.6;
                            print(
                                'distFromPickUpToDestination $distFromPickUpToDestination');
                            if (distFromPickUpToDestination < 1.1) {
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: myContainerCard(
                                      myColor.primaryColorDark,
                                      'Extend',
                                      () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return extendDialogBox();
                                            });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    flex: 1,
                                    child: StreamBuilder<dynamic>(
                                        initialData: false,
                                        stream: completeBtnBloc!.stateStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.data == true) {
                                            return const Text('loading');
                                          } else {
                                            return myContainerCard(
                                              kGreen,
                                              'Complete Journey',
                                              () {
                                                completeJourney(
                                                    ambulanceTripModel[0]);
                                              },
                                            );
                                          }
                                        }),
                                  ),
                                ],
                              );
                            } else {
                              return infoCard(
                                  context,
                                  myColor.dialogBackgroundColor,
                                  myColor.primaryColorDark,
                                  'The trip has started towards hospital');
                            }
                          })
                      : ClipPath(
                          clipper: MyCustomClipper(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: myColor.primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                            ),
                            width: maxWidth(context),
                            child: ambulanceTripModel[0].status == 2
                                ? infoCard(
                                    context,
                                    myColor.dialogBackgroundColor,
                                    myColor.primaryColorDark,
                                    'The trip has started towards hospital')
                                : StreamBuilder<dynamic>(
                                    stream: googleMapBloc!.stateStream,
                                    initialData: googleMapModel,
                                    builder: (context, snapshot) {
                                      var dist = calculateDistance(
                                          snapshot.data.lat,
                                          snapshot.data.lng,
                                          pickUpLat,
                                          pickUpLng);
                                      // double dist = 0.0;
                                      //                                     for(var i = 0; i < polylineCoordinates.length-1; i++){
                                      //      dist += calculateDistance(
                                      //           polylineCoordinates[i].latitude,
                                      //           polylineCoordinates[i].longitude,
                                      //           polylineCoordinates[i+1].latitude,
                                      //           polylineCoordinates[i+1].longitude);
                                      // }
                                      return StreamBuilder<dynamic>(
                                          initialData: 'init',
                                          stream: showDriverHasArrivedBloc!
                                              .stateStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.data == 'init') {
                                              if (dist < 0.5) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'We have arrived',
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: kWhite,
                                                                ),
                                                              ),
                                                              const SizedBox2(),
                                                              Text(
                                                                'Please click this button for further process',
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: kWhite,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            driverHasArrivedBtn(
                                                                ambulanceTripModel[
                                                                    0]);
                                                          },
                                                          child: Container(
                                                            width: 45.0,
                                                            height: 45.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: kWhite,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    8.0),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .keyboard_arrow_right_outlined,
                                                              size: 25.0,
                                                              color: myColor
                                                                  .primaryColorDark,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'We\'re $dist km away from you.',
                                                      // 'We\'re on the way to the hospital',
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: kWhite,
                                                      ),
                                                    ),
                                                    const SizedBox2(),
                                                    Text(
                                                      'Please call if you have any assistance',
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontSize: 10.0,
                                                        color: kWhite,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            } else if (snapshot.data ==
                                                'loading') {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Notifying Driver',
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: kWhite,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 45.0,
                                                        height: 45.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kWhite,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(
                                                                8.0),
                                                          ),
                                                        ),
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 1.0,
                                                          backgroundColor: myColor
                                                              .primaryColorDark,
                                                          color: myColor
                                                              .dialogBackgroundColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            } else {
                                              getPolyPoints(
                                                double.parse(
                                                    ambulanceTripModel[0]
                                                        .userAddress!
                                                        .pickUpLatitude
                                                        .toString()),
                                                double.parse(
                                                    ambulanceTripModel[0]
                                                        .userAddress!
                                                        .pickUpLongitude
                                                        .toString()),
                                                double.parse(
                                                    ambulanceTripModel[0]
                                                        .destinationLatitude
                                                        .toString()),
                                                double.parse(
                                                    ambulanceTripModel[0]
                                                        .destinationLongitude
                                                        .toString()),
                                              );

                                              return infoCard(
                                                  context,
                                                  myColor.dialogBackgroundColor,
                                                  myColor.primaryColorDark,
                                                  'The trip has started towards hospital');
                                            }
                                          });
                                    }),
                          ),
                        ),
                  const SizedBox24(),
                  Row(
                    children: [
                      myCachedNetworkImageCircle(
                        40.0,
                        40.0,
                        'ambulance.address.toString()',
                        BoxFit.cover,
                      ),
                      const SizedBox(width: 18.0),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'driver',
                              style: kStyleNormal.copyWith(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox2(),
                            RatingBar.builder(
                              minRating: 5,
                              itemBuilder: (context, _) {
                                return const Icon(
                                  Icons.star,
                                  color: Color.fromRGBO(255, 193, 7, 1),
                                  size: 1.0,
                                );
                              },
                              itemCount: 5,
                              initialRating: 0.0,
                              updateOnDrag: true,
                              itemSize: 20.0,
                              itemPadding: const EdgeInsets.only(right: 2.0),
                              onRatingUpdate: (rating) => setState(() {
                                // this.rating = rating;
                              }),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Ambulance Number',
                              style: kStyleNormal.copyWith(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox2(),
                            Text(
                              'KA 05 Z 2893',
                              style: kStyleNormal.copyWith(
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox32(),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: myIconButton(() {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return extendDialogBox();
                              });
                        }, Icons.location_on_outlined, kAmber, 'Extend Trip'),
                      ),
                      Expanded(
                        flex: 1,
                        child: myIconButton(() {
                          launchUrl(Uri.parse("tel://9840308344"));
                        }, Icons.call_outlined, kGreen, 'Call'),
                      ),
                      Expanded(
                        flex: 1,
                        child: myIconButton(() {
                          sharedPrefs.removeFromDevice('isAmbulanceTracking');
                          sharedPrefs.removeFromDevice('ambulanceLat');
                          sharedPrefs.removeFromDevice('ambulanceLng');
                        }, Icons.remove_outlined, kRed, 'Cancel'),
                      ),
                    ],
                  ),
                  const SizedBox8(),
                ],
              );

            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 135.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Server Error 3'),
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
  }

  driverHasArrivedBtn(AmbulanceTripModel data) async {
    showDriverHasArrivedBloc!.storeData('loading');
    print(data.id);
    int statusCode;

    statusCode = await API().postData(
        context,
        DriverHasArrivedModel(
          driverId: data.driverId,
          status: 'DriverArrived',
        ),
        'trips/driver-arrived/${data.id}');

    if (statusCode == 200) {
      ambulanceTripBloc!.fetchAPIList(endpoints.getUserTripEndpoint);
      showDriverHasArrivedBloc!.storeData('final');
    } else {
      ambulanceTripBloc!.fetchAPIList(endpoints.getUserTripEndpoint);
      showDriverHasArrivedBloc!.storeData('init');
    }
  }

  Widget myIconButton(myTap, icon, color, text) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Column(children: [
        Icon(
          icon,
          color: color,
          size: 25.0,
        ),
        const SizedBox2(),
        Text(
          text,
          style: kStyleNormal.copyWith(
            fontSize: 10.0,
            color: color,
          ),
        ),
      ]),
    );
  }

  Widget extendDialogBox() {
    ambulanceTripBloc!.fetchAPIList(endpoints.postAcceptAmbulanceReq);
    return Dialog(
        insetPadding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        backgroundColor: kTransparent,
        elevation: 0.0,
        child: extendTripForm());
  }

  Widget extendTripForm() {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
            width: maxWidth(context),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              color: myColor.dialogBackgroundColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox12(),
                    infoCard(
                      context,
                      kRed.withOpacity(0.4),
                      myColor.primaryColorDark,
                      'Please fill the form to change hospital.',
                    ),
                    Theme(
                      data: ThemeData(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: myColor.primaryColorDark,
                            ),
                      ),
                      child: Stepper(
                          physics: const BouncingScrollPhysics(),
                          elevation: 0,
                          type: StepperType.vertical,
                          onStepTapped: (int index) {
                            if (currentStepExtend != index) {
                              currentStepExtend = currentStepExtend;
                            }
                          },
                          steps: getStepsForExtend(),
                          currentStep: currentStepExtend,
                          controlsBuilder: (context, details) {
                            isLastStepExtend = getStepsForExtend().length - 1;
                            return Container();
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              StreamBuilder<dynamic>(
                                  initialData: totalPriceForExtended,
                                  stream: priceForExtendedBloc!.stateStream,
                                  builder: (context, snapshot) {
                                    return Text.rich(
                                      TextSpan(
                                        text: 'Rs  ',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: snapshot.data
                                                .round()
                                                .toString(),
                                            style: kStyleNormal.copyWith(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          const SizedBox(width: 100.0),
                          GestureDetector(
                            onTap: () {
                              if (currentStepExtend != isLastStepExtend) {
                                // var isValid = _form2.currentState?.validate();
                                // if (isValid!) {
                                setState(() {
                                  currentStepExtend += 1;
                                });
                                // }
                              } else {
                                submitAmbulanceForm(true);
                                // submitAmbulanceFormForExtened();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: myColor.primaryColorDark,
                              ),
                              child: Icon(
                                isLastStepExtend == currentStepExtend
                                    ? FontAwesomeIcons.check
                                    : FontAwesomeIcons.arrowRight,
                                size: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
      );
    });
  }

  Widget bookingStatusDialog(tripStatusBloc) {
    tripStatusBloc!.fetchAPIList(endpoints.getUserNotificationEndpoint);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        insetPadding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
        backgroundColor: kTransparent,
        elevation: 0.0,
        child: StreamBuilder<ApiResponse<dynamic>>(
          stream: tripStatusBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return const AnimatedLoading();
                case Status.COMPLETED:
                  if (snapshot.data!.data.isEmpty) {
                    return GestureDetector(
                      onTap: () {
                        sharedPrefs.removeFromDevice('isAmbulanceTracking');
                        sharedPrefs.removeFromDevice('ambulanceLat');
                        sharedPrefs.removeFromDevice('ambulanceLng');
                      },
                      child: infoCard(
                        context,
                        myColor.dialogBackgroundColor,
                        myColor.primaryColorDark,
                        'data empty',
                      ),
                    );
                  }
                  tripStatusModel =
                      TripStatusModel.fromJson(snapshot.data!.data);
                  return ambulanceVerificationForm(
                      tripStatusModel!.userDetails!.status);
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    height: 135.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
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

  submitAmbulanceForm(isExtend) async {
    if (isExtend == false) {
      PostAmbulanceBookingForm postAmbulanceBookingForm =
          PostAmbulanceBookingForm(
        id: ambulanceTripModel[0].id,
        medicalSupport: _medicalAssitantCheckBoxValue,
        patientName: patientName.toString(),
        patientNumber: patientNumber.toString(),
        paymentMethod: _paymentType.toString(),
        paymentAmount: totalPrice.round(),
        // destinationLatitude: testPopModal2!.lat.toString(),
        destinationLatitude: '27.715248',
        destinationLongitude: '85.283456',
        // destinationLongitude: testPopModal2!.lng.toString(),
      );
      switch (_paymentType) {
        case 'esewa':
          // myEsewa(context, widget.totalAmount.toString());
          break;

        case 'khalti':
          // mySnackbar.mySnackBarCustomized(
          //     context, '', 'You will now receive patient request', () {}, kGreen);
          // setState(() {
          //   isTracking = true;
          //   isAmbulanceTrackingStatus = 'showTrackingScreen';
          // });
          // sharedPrefs.storeToDevice('isAmbulanceTracking', 'showTrackingScreen');
          // Navigator.pop(context);
          myKhalti(context, totalPrice, 'isAmbulanceBooking',
              postAmbulanceBookingForm);
          break;

        case '2':
          // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
          break;

        case '3':
          // myKhalti(context, widget.totalAmount, 'isProductOrder');
          break;

        case '4':
          // goThere(context, const EsewaTestScreen());
          break;

        case '5':
          // myKhalti(context, widget.totalAmount, 'isProductOrder');
          break;

        default:
      }
    } else {
      PostAmbulanceExtendForm postAmbulanceBookingForm =
          PostAmbulanceExtendForm(
        id: ambulanceTripModel[0].id,
        extendedLatitude: testPopModal2!.lat.toString(),
        extendedLongitude: testPopModal2!.lng.toString(),
        extendedPaymentAmount: totalPriceForExtended.toString(),
        extendedTotalKmCovered: extendedDistance.toString(),
        extendedTotalTimeConsumed: '1',
        extendedPaymentMethod: _paymentTypeForExtend,
      );
      switch (_paymentTypeForExtend) {
        case 'esewa':
          // myEsewa(context, widget.totalAmount.toString());
          break;

        case 'khalti':
          // mySnackbar.mySnackBarCustomized(
          //     context, '', 'You will now receive patient request', () {}, kGreen);
          // setState(() {
          //   isTracking = true;
          //   isAmbulanceTrackingStatus = 'showTrackingScreen';
          // });
          // sharedPrefs.storeToDevice('isAmbulanceTracking', 'showTrackingScreen');
          // Navigator.pop(context);
          myKhalti(context, 100, 'isAmbulanceExtend', postAmbulanceBookingForm);
          break;

        case '2':
          // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
          break;

        case '3':
          // myKhalti(context, widget.totalAmount, 'isProductOrder');
          break;

        case '4':
          // goThere(context, const EsewaTestScreen());
          break;

        case '5':
          // myKhalti(context, widget.totalAmount, 'isProductOrder');
          break;

        default:
      }
    }
  }

  sendRequestToDriver() async {
    btnBloc!.storeData(!isLoading);
    int statusCode;
    FocusManager.instance.primaryFocus?.unfocus();
    statusCode = await API().postData(
        context,
        SendRequestToDriver(
          driverId: widget.driverID,
          pickUpLatitude: afterScrollLatValue == null
              ? userLat.toString()
              : afterScrollLatValue.toString(),
          pickUpLongitude: afterScrollLngValue == null
              ? userLng.toString()
              : afterScrollLngValue.toString(),
          // distance:
        ),
        endpoints.postRequestToDriver);

    if (statusCode == 200) {
      btnBloc!.storeData(isLoading);
      sharedPrefs.storeToDevice('isAmbulanceTracking', 'showAmbulanceForm');
      sharedPrefs.storeToDevice('ambulanceLat', ambulanceCurrentLat.toString());
      sharedPrefs.storeToDevice('ambulanceLng', ambulanceCurrentLng.toString());
      sharedPrefs.storeToDevice(
          'pickUpLat',
          afterScrollLatValue == null
              ? userLat.toString()
              : afterScrollLatValue.toString());
      sharedPrefs.storeToDevice(
          'pickUpLng',
          afterScrollLngValue == null
              ? userLng.toString()
              : afterScrollLngValue.toString());
      googleMapBloc!.storeData(GoogleMapModel(
        lat: ambulanceCurrentLat,
        lng: ambulanceCurrentLng,
        address: 'The ambulance is informed and will move immediately.',
        time: timeNow.toString(),
      ));
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StreamBuilder<dynamic>(
                stream: refreshDialogBloc!.stateStream,
                builder: (context, snapshot) {
                  print('hello 22');

                  return bookingStatusDialog(tripStatusBloc);
                });
          });
    } else {
      btnBloc!.storeData(isLoading);
      mySnackbar.mySnackBar(
          context, 'Something went wrong: $statusCode', Colors.red);
    }
  }

  driverAnimationMethod() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 13.5,
          target: LatLng(
            newUpdatedLat!,
            newUpdatedLng!,
          ),
        ),
      ),
    );
    googleMapModel = GoogleMapModel(
        lat: newUpdatedLat, lng: newUpdatedLng, isCameraMove: false);
    googleMapBloc!.storeData(googleMapModel);
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return WillPopScope(
        onWillPop: isTracking == true
            ? () => Future.value(false)
            : () => Future.value(true),
        child: GestureDetector(
          onTap: () {
            sharedPrefs.removeFromDevice('isAmbulanceTracking');
            sharedPrefs.removeFromDevice('ambulanceLat');
            sharedPrefs.removeFromDevice('ambulanceLng');
          },
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: !isFloating,
            backgroundColor: backgroundColor,
            body: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: StreamBuilder<dynamic>(
                      initialData: googleMapModel,
                      stream: googleMapBloc!.stateStream,
                      builder: (context, snapshot) {
                        newUpdatedLat = snapshot.data.lat;
                        newUpdatedLng = snapshot.data.lng;
                        if (snapshot.data.isCameraMove == true) {
                          driverAnimationMethod();
                        }
                        if (snapshot.data.lat == null) {
                          return const Center(child: AnimatedLoading());
                        } else {
                          if (isTracking == true) {
                            _setAmbulanceMarker(LatLng(
                              snapshot.data.lat,
                              snapshot.data.lng,
                            ));
                          }
                          // if (widget.getAllAmbulanceListModel != null) {
                          //   for (var element in widget.getAllAmbulanceListModel!) {
                          //     _markers.add(Marker(
                          //         icon: ambulanceIcon ?? BitmapDescriptor.defaultMarker,
                          //         markerId: const MarkerId('1'),
                          //         position: LatLng(
                          //           snapshot.data.lat,
                          //           snapshot.data.lng,
                          //         ),
                          //         infoWindow: const InfoWindow(
                          //           title: 'my title',
                          //           snippet: 'my snippet',
                          //         ),
                          //         onTap: () {}));
                          //   }
                          // } else {
                          //   // _markers.add(Marker(
                          //   //     icon: ambulanceIcon ?? BitmapDescriptor.defaultMarker,
                          //   //     markerId: const MarkerId('1'),
                          //   //     position: LatLng(
                          //   //       snapshot.data.lat,
                          //   //       snapshot.data.lng,
                          //   //     ),
                          //   //     infoWindow: const InfoWindow(
                          //   //       title: 'my title',
                          //   //       snippet: 'my snippet',
                          //   //     ),
                          //   //     onTap: () {}));
                          // }

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GoogleMap(
                                polylines: {
                                  Polyline(
                                    polylineId: const PolylineId("route"),
                                    points: polylineCoordinates,
                                    color: myColor.primaryColorDark,
                                    width: 6,
                                  ),
                                },
                                onCameraMove: (position) async {
                                  pointerSizeModel = PointerSizeModel(
                                    outterCircleSize: 18.0,
                                    innerCircleSize: 17.0,
                                    imageSize: 30.0,
                                    verticalHeight: 12.0,
                                    gap: 3.0,
                                    dot: 4.0,
                                  );
                                  markerBloc!.storeData(pointerSizeModel);
                                  final GoogleMapController controller =
                                      await _controller.future;
                                  LatLngBounds bounds =
                                      await controller.getVisibleRegion();
                                  LatLng center = LatLng(
                                    (bounds.northeast.latitude +
                                            bounds.southwest.latitude) /
                                        2,
                                    (bounds.northeast.longitude +
                                            bounds.southwest.longitude) /
                                        2,
                                  );
                                  afterScrollLatValue = center.latitude;
                                  afterScrollLngValue = center.longitude;
                                },
                                onCameraIdle: () {
                                  if (isTracking == false &&
                                      afterScrollLatValue != null) {
                                    pointerSizeModel = PointerSizeModel(
                                      outterCircleSize: 15.0,
                                      innerCircleSize: 12.0,
                                      imageSize: 24.0,
                                      verticalHeight: 15.0,
                                      gap: 0.0,
                                      dot: 6.0,
                                    );

                                    markerBloc!.storeData(pointerSizeModel);
                                    _getAddressFromCoordinates(
                                        afterScrollLatValue,
                                        afterScrollLngValue);
                                    getPolyPoints(
                                      afterScrollLatValue,
                                      afterScrollLngValue,
                                      ambulanceCurrentLat!,
                                      ambulanceCurrentLng!,
                                    );
                                  }
                                },
                                onTap: (position) {
                                  if (isTracking == false) {
                                    _mapOnTap(position);
                                    getPolyPoints(
                                      position.latitude,
                                      position.longitude,
                                      ambulanceCurrentLat!,
                                      ambulanceCurrentLng!,
                                    );
                                  }
                                },
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      snapshot.data.lat,
                                      snapshot.data.lng,
                                    ),
                                    zoom: 17),
                                markers: _markers,
                                //     {
                                //   Marker(
                                //       icon: ambulanceIcon ??
                                //           BitmapDescriptor.defaultMarker,
                                //       markerId: const MarkerId('1'),
                                //       position: LatLng(
                                //         snapshot.data.lat,
                                //         snapshot.data.lng,
                                //       ),
                                //       infoWindow: const InfoWindow(
                                //         title: 'my title',
                                //         snippet: 'my snippet',
                                //       ),
                                //       onTap: () {})
                                // },
                                zoomControlsEnabled: false,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                  print('isTracking  --- $isTracking');
                                  if (isTracking == false) {
                                    print('newUpdatedLat $newUpdatedLat');
                                    snapshot.data.onLocationChanged.listen(
                                        (loc.LocationData
                                            currentLocation) async {
                                      GoogleMapController controller =
                                          await _controller.future;
                                      controller.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            zoom: 13.5,
                                            target: LatLng(
                                              newUpdatedLat!,
                                              newUpdatedLng!,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                  }

                                  // controller.animateCamera(
                                  //     CameraUpdate.newCameraPosition(
                                  //         CameraPosition(
                                  //             target: LatLng(
                                  //               snapshot.data.lat,
                                  //               snapshot.data.lng,
                                  //             ),
                                  //             zoom: 17)));
                                },
                              ),
                              Positioned(
                                top: 50.0,
                                left: 12.0,
                                child: isTracking == true
                                    ? GestureDetector(
                                        onTap: () {
                                          if (isAmbulanceTrackingStatus ==
                                              'showTrackingScreen') {
                                            PIPView.of(context)?.presentBelow(
                                                const MainHomePage(
                                                    index: 0, tabIndex: 0));
                                          } else {
                                            Navigator.pop(context);
                                          } // showDialog(
                                          //     barrierDismissible: false,
                                          //     context: context,
                                          //     builder: (BuildContext context) {
                                          //       return bookingStatusDialog();
                                          //     });
                                        },
                                        child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: myColor
                                                  .scaffoldBackgroundColor,
                                            ),
                                            child: const Icon(
                                              Icons.keyboard_arrow_left,
                                              color: Colors.black,
                                              size: 35.0,
                                            )),
                                      )
                                    : Container(),
                              ),
                              Positioned(
                                top: 50.0,
                                left: 12.0,
                                right: 65.5,
                                child: isTracking == true
                                    ? Container()
                                    : Form(
                                        key: _form,
                                        child: TextFormField(
                                          style: kStyleNormal.copyWith(
                                              fontSize: 12.0),
                                          controller: _myController,
                                          onChanged: (String value) {
                                            setState(() {
                                              mapBloc!
                                                  .fetchGoogleMapAPIAutoComplete(
                                                      value);
                                            });
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 0.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              borderSide: BorderSide(
                                                  color:
                                                      myColor.primaryColorDark,
                                                  width: 1.5),
                                            ),
                                            errorStyle: kStyleNormal.copyWith(
                                                color: Colors.red,
                                                fontSize: 12.0),
                                            prefixIcon: Icon(
                                              Icons.location_on,
                                              size: 20,
                                              color: Colors.grey[400],
                                            ),
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  _myController.clear();
                                                  setState(() {
                                                    mapBloc!
                                                        .fetchGoogleMapAPIAutoComplete(
                                                            initialValue);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Colors.grey[400],
                                                )),
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            hintText:
                                                _searchValue ?? 'Search here',
                                            hintStyle: kStyleNormal.copyWith(
                                                color: Colors.grey[400]),
                                          ),
                                          validator: (v) {
                                            if (v!.isEmpty) {
                                              return '';
                                            }
                                            return null;
                                          },
                                          onSaved: (v) {
                                            _searchValue = v;
                                          },
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: 105.0,
                                left: 12.0,
                                right: 12.0,
                                child: isTracking == true
                                    ? Container()
                                    : StreamBuilder<ApiResponse<dynamic>>(
                                        stream: mapBloc!.apiListStream,
                                        builder: ((context, snapshot) {
                                          if (snapshot.hasData) {
                                            switch (snapshot.data!.status) {
                                              case Status.LOADING:
                                                return _myController
                                                        .text.isEmpty
                                                    ? Container()
                                                    : const AnimatedLoading();
                                              case Status.COMPLETED:
                                                placeSuggestion =
                                                    List<Predictions>.from(
                                                        snapshot.data!.data.map(
                                                            (i) => Predictions
                                                                .fromJson(i)));
                                                return Container(
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      12.0),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      12.0))),
                                                  child: ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      itemCount: placeSuggestion
                                                          .length,
                                                      itemBuilder: (ctx, i) {
                                                        return ListTile(
                                                          onTap: () {
                                                            myAutoCompleteLocationTap(
                                                                i);
                                                          },
                                                          title: SizedBox(
                                                            width: maxWidth(
                                                                context),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  size: 20,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        10.0),
                                                                Expanded(
                                                                  child: Text(
                                                                    placeSuggestion[
                                                                            i]
                                                                        .description
                                                                        .toString(),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        kStyleNormal,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                );

                                              case Status.ERROR:
                                                return Container(
                                                  width: maxWidth(context),
                                                  height: 135.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: const Center(
                                                    child: Text('Server Error'),
                                                  ),
                                                );
                                            }
                                          }
                                          return const SizedBox();
                                        }),
                                      ),
                              ),
                              Positioned(
                                  top: 50.0,
                                  right: 11.0,
                                  child: isTracking == true
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              placeSuggestion = [];
                                            });
                                            _searchBtn();
                                          },
                                          child: Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color: myColor.primaryColorDark,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.search,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                              Positioned(
                                top: 1,
                                bottom: 50,
                                right: 1,
                                left: 1,
                                // right: (maxWidth(context) / 2) - 13,
                                // left: (maxWidth(context) / 2) - 13,
                                child: isTracking == true
                                    ? Container()
                                    : StreamBuilder<dynamic>(
                                        initialData: pointerSizeModel,
                                        stream: markerBloc!.stateStream,
                                        builder: (context, snapshot) {
                                          return AnimatedSize(
                                            curve: Curves.easeIn,
                                            duration:
                                                const Duration(seconds: 1),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: snapshot
                                                      .data.outterCircleSize,
                                                  backgroundColor: kRed,
                                                  child: CircleAvatar(
                                                    radius: snapshot
                                                        .data.innerCircleSize,
                                                    backgroundColor: kRed,
                                                    child:
                                                        myCachedNetworkImageCircle(
                                                      snapshot.data.imageSize,
                                                      snapshot.data.imageSize,
                                                      profileModel!.imagePath
                                                          .toString(),
                                                      BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  color: kRed,
                                                  width: 2.0,
                                                  height: snapshot
                                                      .data.verticalHeight,
                                                ),
                                                snapshot.data.gap == 0.0
                                                    ? Container()
                                                    : const SizedBox(
                                                        height: 3.0),
                                                Container(
                                                  width: snapshot.data.dot,
                                                  height: snapshot.data.dot,
                                                  decoration: BoxDecoration(
                                                      color: kRed,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: kRed,
                                                          blurRadius: 5.0,
                                                        ),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                              ),
                              // Positioned(
                              //   bottom: maxHeight(context) / 2,
                              //   right: (maxWidth(context) / 2) - 1,
                              //   left: (maxWidth(context) / 2) - 1,
                              //   child: Container(
                              //     color: kAmber,
                              //   ),
                              // ),
                              // Positioned(
                              //   top: 1,
                              //   bottom: 1,
                              //   right: (maxWidth(context) / 2) - 10,
                              //   left: (maxWidth(context) / 2) - 10,
                              //   child:
                              // ),
                              Positioned(
                                left: 15.0,
                                bottom: 25.0,
                                child: isTracking == true
                                    ? Container()
                                    : myCircularIconCard(
                                        () {
                                          _goToMyLocation();
                                        },
                                        Icons.my_location_outlined,
                                      ),
                              ),
                              Positioned(
                                left: 15.0,
                                bottom: 75.0,
                                child: isTracking == true
                                    ? Container()
                                    : myCircularIconCard(
                                        () {
                                          _goToOffice();
                                        },
                                        Icons.work,
                                      ),
                              ),
                              Positioned(
                                right: 15.0,
                                bottom: 75.0,
                                child: widget.seeAll == 'See All'
                                    ? Container()
                                    : isTracking == true
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              _scaffoldKey.currentState!
                                                  .openEndDrawer();
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 12.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      myColor.primaryColorDark,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                ),
                                                child: Row(children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .truckMedical,
                                                    size: 15.0,
                                                    color: kWhite,
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text('Find Nearby Ambulance',
                                                      style:
                                                          kStyleNormal.copyWith(
                                                              color: kWhite,
                                                              fontSize: 12.0)),
                                                ])),
                                          ),
                              ),
                              Positioned(
                                right: 15.0,
                                bottom: 25.0,
                                child: isTracking == true
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          launchUrl(
                                              Uri.parse("tel://9840308344"));
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 12.0),
                                            decoration: BoxDecoration(
                                              color: myColor.primaryColorDark,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            child: Row(children: [
                                              Icon(
                                                Icons.call,
                                                size: 15.0,
                                                color: kWhite,
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text('Quickly Find Ambulance',
                                                  style: kStyleNormal.copyWith(
                                                      color: kWhite,
                                                      fontSize: 12.0)),
                                            ])),
                                      ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: myColor.dialogBackgroundColor,
                    child: Column(
                      children: [
                        widget.seeAll == 'See All'
                            ? allAmbulanceStreamBuilderCard()
                            : isTracking == true
                                ? Container(
                                    padding: const EdgeInsets.all(12.0),
                                    color: myColor.dialogBackgroundColor,
                                    child: driverDetailsCard())
                                : Container(
                                    color: myColor.dialogBackgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: pickUpLocationCard(),
                                  ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            endDrawer: myEndDrawer(),
            //  StreamBuilder<ApiResponse<dynamic>>(
            //     stream: ambulanceBloc!.apiListStream,
            //     builder: (context, snapshot) {

            //       print('testss ${snapshot.data}');
            //       return const Text('s');
            //     }),
          ),
        ),
      );
    });
  }

  Widget myContainerCard(color, title, myTap) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Text(
          title,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            color: kWhite,
          ),
        ),
      ),
    );
  }

  Widget myEndDrawer() {
    return Container(
      color: myColor.dialogBackgroundColor,
      width: maxWidth(context) / 1.3,
      height: maxHeight(context),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            width: maxWidth(context) / 1.3,
            height: 120.0,
            color: myColor.primaryColorDark,
            child: Center(
              child: Text(
                'Find Routes',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: kWhite,
                ),
              ),
            ),
          ),
          allAmbulanceStreamBuilderCard(),
        ],
      ),
    );
  }

  Widget myCircularIconCard(myTap, icon) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: CircleAvatar(
        backgroundColor: myColor.primaryColorDark,
        child: Icon(
          icon,
          size: 18.0,
          color: kWhite,
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height + 10)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PointerSizeModel {
  double outterCircleSize;
  double innerCircleSize;
  double imageSize;
  double verticalHeight;
  double gap;
  double dot;

  PointerSizeModel({
    required this.outterCircleSize,
    required this.innerCircleSize,
    required this.imageSize,
    required this.verticalHeight,
    required this.gap,
    required this.dot,
  });
}
