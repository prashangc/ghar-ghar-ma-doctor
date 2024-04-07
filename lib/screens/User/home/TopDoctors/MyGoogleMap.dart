import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/GoogleMapModel/NearbyPlaceModal.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/animatedLoading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({
    Key? key,
  }) : super(key: key);

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  StateHandlerBloc? btnBloc;
  bool isLoading = false;

  final Completer<GoogleMapController> _controller = Completer();
  late StreamSubscription<Position> streamSubscription;
  final TextEditingController _myController = TextEditingController();
  final Set<Marker> _markers = <Marker>{};
  ProfileModel? profileModel;
  ApiHandlerBloc? mapBloc, mapBloc2, nearByPlacesBloc;
  String initialValue = '';
  String currentAddress = '';
  final String _mapType = 'source';
  String? _searchValue, _destination;
  double? currentLat,
      currentLng,
      myLat,
      myLng,
      afterScrollLatValue,
      afterScrollLngValue,
      _destinationLat,
      _destinationLng;
  List<Predictions> placeSuggestion = [];
  List<Results> results = [];
  final _form = GlobalKey<FormState>();
  int isBtnVisible = 0;
  StateHandlerBloc? checkBoxBloc, areYouPatientBloc;
  StateHandlerBloc? googleMapBloc;
  GoogleMapModel googleMapModel = GoogleMapModel();
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    googleMapBloc = StateHandlerBloc();
    checkBoxBloc = StateHandlerBloc();
    areYouPatientBloc = StateHandlerBloc();
    btnBloc = StateHandlerBloc();
    requestLocationPermission(getLatAndLng, onLocationDeclined);
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
  }

  getLatAndLng() async {
    loc.LocationData? currentPosition;
    final loc.Location location = loc.Location();

    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((loc.LocationData currentLocation) {
      currentPosition = currentLocation;
    });
    currentLat = currentPosition!.latitude;
    currentLng = currentPosition!.longitude;

    googleMapModel = GoogleMapModel(
      lat: currentLat,
      lng: currentLng,
    );

    _getCurrentPostion();
    getPolyPoints();
    fetchAPI();
  }

  onLocationDeclined() {
    Navigator.pop(context);
  }

  void fetchAPI() {
    mapBloc = ApiHandlerBloc();
    mapBloc2 = ApiHandlerBloc();
    nearByPlacesBloc = ApiHandlerBloc();
    mapBloc!.fetchGoogleMapAPIAutoComplete(initialValue);
    nearByPlacesBloc!.fetchGoogleMapAPINearByPlaced(currentLat!, currentLng!);
    // if (widget.type == 'showAllAmbulance') {
    //   ambulanceBloc = ApiHandlerBloc();
    //   ambulanceBloc!.fetchAPIList(endpoints.getAllAmbulanceEndpoint);
    // }
  }

  void _mapOnTap(position) async {
    mapBloc!.fetchGoogleMapAPIAutoComplete('');
    FocusManager.instance.primaryFocus?.unfocus();
    if (_mapType == 'destination') {
      _destinationLat = position.latitude;
      _destinationLng = position.longitude;
      _getAddressFromCoordinates(_destinationLat, _destinationLng);
    } else {
      myLat = position.latitude;
      myLng = position.longitude;
      _getAddressFromCoordinates(myLat, myLng);
    }
    _markers.clear();
    _setMarker(position);
    nearByPlacesBloc!.fetchGoogleMapAPINearByPlaced(myLat!, myLng!);
    isBtnVisible = 0;
  }

  void _setLocationBtn() async {
    print('_myController.text ${_myController.text}');
    print('currentAddress $currentAddress');
    print('myLat! ${myLat!}');

    Navigator.pop(
      context,
      GoogleMapModel(
        address: _myController.text == '' ? currentAddress : _myController.text,
        lat: myLat!,
        lng: myLng!,
      ),
    );
  }

  void _searchBtn() async {
    _form.currentState?.validate();
    FocusManager.instance.primaryFocus?.unfocus();
    mapBloc!.fetchGoogleMapAPIAutoComplete(initialValue);
    nearByPlacesBloc!.fetchGoogleMapAPINearByPlaced(myLat!, myLng!);
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
      currentLat = locations.last.latitude;
      currentLng = locations.last.longitude;
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLat!, currentLng!),
          zoom: 16,
        ),
      ),
    );
    _markers.clear();
    _setMarker(LatLng(currentLat!, currentLng!));
    isBtnVisible = 0;
  }

  _getCurrentPostion() async {
    googleMapBloc!.storeData(googleMapModel);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(currentLat!, currentLng!), zoom: 17)));

    _markers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId('1'),
        position: LatLng(currentLat!, currentLng!),
        infoWindow: const InfoWindow(
          title: 'my title',
          snippet: 'my snippet',
        ),
        onTap: () {}));

    _getAddressFromCoordinates(currentLat!, currentLng!);
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
      if (_mapType == 'destination') {
        _destination = address;
        _destinationLat = lat;
        _destinationLng = lng;
      } else {
        _myController.text = address;
        myLat = lat;
        myLng = lng;
        _searchValue = address;
      }
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      endpoints.apiKey,
      PointLatLng(currentLat!, currentLng!),
      const PointLatLng(27.693310, 85.281638),
      // const PointLatLng(27, 88),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<dynamic>(
          initialData: googleMapModel,
          stream: googleMapBloc!.stateStream,
          builder: (context, snapshot) {
            if (googleMapModel.lat == null) {
              return const Center(child: AnimatedLoading());
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: maxWidth(context),
                    height: maxHeight(context) / 1.5,
                    child: Stack(
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
                          myLocationEnabled: true,
                          onCameraMove: (position) async {
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
                            print('center.latitude ${center.latitude}');
                            afterScrollLatValue = center.latitude;
                            afterScrollLngValue = center.longitude;
                            mapBloc!.fetchGoogleMapAPIAutoComplete('');
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onCameraIdle: () {
                            if (afterScrollLatValue != null) {
                              _getAddressFromCoordinates(
                                  afterScrollLatValue, afterScrollLngValue);
                              _markers.clear();
                              _setMarker(LatLng(
                                afterScrollLatValue!,
                                afterScrollLngValue!,
                              ));

                              nearByPlacesBloc!.fetchGoogleMapAPINearByPlaced(
                                  afterScrollLatValue!, afterScrollLngValue!);
                              isBtnVisible = 0;
                            }
                          },
                          onTap: (position) {
                            _mapOnTap(position);
                          },
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLat!, currentLng!),
                              zoom: 17),
                          markers: _markers,
                          zoomControlsEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
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
                        Positioned(
                          top: 50.0,
                          left: 12.0,
                          right: 65.5,
                          child: Form(
                            key: _form,
                            child: TextFormField(
                              controller: _myController,
                              onChanged: (String value) {
                                setState(() {
                                  mapBloc!.fetchGoogleMapAPIAutoComplete(value);
                                  isBtnVisible = 1;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide(
                                      color: myColor.primaryColorDark,
                                      width: 1.5),
                                ),
                                errorStyle: kStyleNormal.copyWith(
                                    color: Colors.red, fontSize: 12.0),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.grey[400],
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      _myController.clear();
                                      setState(() {
                                        mapBloc!.fetchGoogleMapAPIAutoComplete(
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
                                hintText: _searchValue ?? 'Search here',
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
                          child: StreamBuilder<ApiResponse<dynamic>>(
                            stream: mapBloc!.apiListStream,
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                switch (snapshot.data!.status) {
                                  case Status.LOADING:
                                    return _myController.text.isEmpty
                                        ? Container()
                                        : const AnimatedLoading();
                                  case Status.COMPLETED:
                                    placeSuggestion = List<Predictions>.from(
                                        snapshot.data!.data.map(
                                            (i) => Predictions.fromJson(i)));
                                    return Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12.0),
                                              bottomRight:
                                                  Radius.circular(12.0))),
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: placeSuggestion.length,
                                          itemBuilder: (ctx, i) {
                                            return ListTile(
                                              onTap: () {
                                                myAutoCompleteLocationTap(i);
                                              },
                                              title: SizedBox(
                                                width: maxWidth(context),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 20,
                                                      color: Colors.grey[400],
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Expanded(
                                                      child: Text(
                                                        placeSuggestion[i]
                                                            .description
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: kStyleNormal,
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
                                        borderRadius: BorderRadius.circular(12),
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
                        ),
                        Positioned(
                            top: 50.0,
                            right: 11.0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  placeSuggestion = [];
                                  print('my length ${placeSuggestion.length}');
                                });
                                _searchBtn();
                              },
                              child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: myColor.primaryColorDark,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        _myController.text != '' && isBtnVisible == 0
                            ? Positioned(
                                right: 15.0,
                                left: 15.0,
                                bottom: 30.0,
                                child: StreamBuilder<dynamic>(
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
                                              'Set Location',
                                              kStyleNormal.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                              () {
                                                _setLocationBtn();
                                              },
                                            ),
                                          );
                                      }
                                    }
                                    return const SizedBox();
                                  }),
                                ),
                              )
                            : Positioned(
                                right: 15.0,
                                left: 15.0,
                                bottom: 30.0,
                                child: SizedBox(
                                  width: maxWidth(context),
                                  height: 55.0,
                                  child: myCustomButton(
                                    context,
                                    myColor.dialogBackgroundColor,
                                    'Set Location',
                                    kStyleNormal.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                    () {},
                                  ),
                                ),
                              ),
                        Positioned(
                          right: 15.0,
                          bottom: 100.0,
                          child: GestureDetector(
                            onTap: () {
                              _goToOffice();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Text('Our Office', style: kStyleNormal),
                                  Icon(
                                    Icons.local_post_office,
                                    color: myColor.primaryColorDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        color: myColor.dialogBackgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox12(),
                            Text(
                              'Near By Places',
                              style: kStyleNormal.copyWith(
                                color: myColor.primaryColorDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox12(),
                            Expanded(
                              child: StreamBuilder<ApiResponse<dynamic>>(
                                stream: nearByPlacesBloc!.apiListStream,
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        return Container(
                                          width: maxWidth(context),
                                          height: maxHeight(context),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const AnimatedLoading(),
                                        );
                                      case Status.COMPLETED:
                                        if (snapshot.data!.data.isEmpty) {
                                          return Container(
                                              height: 140,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Center(
                                                  child: Text(
                                                      'No nearby places')));
                                        }

                                        results = List<Results>.from(snapshot
                                            .data!.data
                                            .map((i) => Results.fromJson(i)));
                                        return SizedBox(
                                          width: maxWidth(context),
                                          child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: results.length,
                                              shrinkWrap: true,
                                              itemBuilder: (ctx, i) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      myLat = double.parse(
                                                          results[i]
                                                              .geometry!
                                                              .location!
                                                              .lat
                                                              .toString());
                                                      myLng = double.parse(
                                                          results[i]
                                                              .geometry!
                                                              .location!
                                                              .lng
                                                              .toString());
                                                      _myController.text =
                                                          results[i]
                                                              .name
                                                              .toString();
                                                      isBtnVisible = 0;
                                                    });

                                                    _markers.clear();
                                                    _setMarker(
                                                        LatLng(myLat!, myLng!));

                                                    final GoogleMapController
                                                        controller =
                                                        await _controller
                                                            .future;
                                                    controller.animateCamera(
                                                        CameraUpdate
                                                            .newCameraPosition(
                                                                CameraPosition(
                                                                    target: LatLng(
                                                                        myLat!,
                                                                        myLng!),
                                                                    zoom: 17)));
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 20.0,
                                                          color: Colors
                                                              .transparent,
                                                          height: 20.0,
                                                          child:
                                                              myCachedNetworkImage(
                                                            10.0,
                                                            10.0,
                                                            results[i].icon,
                                                            const BorderRadius
                                                                .all(
                                                              Radius.circular(
                                                                  0.0),
                                                            ),
                                                            BoxFit.contain,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 12.0),
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Text(
                                                                results[i]
                                                                    .name
                                                                    .toString(),
                                                                style:
                                                                    kStyleNormal),
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
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0),
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
                                    height: 200,
                                  );
                                }),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              );
            }
          }),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    myLat = place['geometry']['location']['lat'];
    myLng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(myLat!, myLng!),
          zoom: 17,
        ),
      ),
    );
    _markers.clear();
    _setMarker(LatLng(myLat!, myLng!));
  }

  Future<void> _goToOffice() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(27.6966014, 85.3517784),
            tilt: 59.440717697143555,
            zoom: 17)));
    _markers.clear();
    _setMarker(const LatLng(27.6966014, 85.3517784));
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
                    child: const Center(child: Text('No doctors added')));
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
                              isBtnVisible = 0;
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
}
