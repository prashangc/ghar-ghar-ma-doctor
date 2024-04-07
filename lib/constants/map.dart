import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class myMap extends StatefulWidget {
  final ValueChanged<String>? onValueChangedDistrict,
      onValueChangedArea,
      onValueChangedSubArea,
      onValueChangedStreet;
  const myMap(
      {Key? key,
      required this.onValueChangedDistrict,
      required this.onValueChangedArea,
      required this.onValueChangedSubArea,
      required this.onValueChangedStreet})
      : super(key: key);

  @override
  State<myMap> createState() => _myMapState();
}

class _myMapState extends State<myMap> {
  late GoogleMapController googleMapController;
  String? _district, _area, _subArea, _street;
  double? latitude, longitude;
  late StreamSubscription<Position> streamSubscription;

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(27.705423, 85.322988), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    _getCurrentPostion();
  }

  _getCurrentPostion() async {
    print('my map');
    Position position = await _determinePosition();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14)));

    markers.clear();

    markers.add(Marker(
        // markerId: const MarkerId('currentLocation'),
        markerId: const MarkerId('1'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: 'my title',
          snippet: 'my snippet',
        ),
        onTap: () {
          print('tapped');
        }));

    setState(() {});
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        latitude = position.latitude;

        longitude = position.longitude;
      });

      String address = 'place';

      getAddressFromLatLang(position);
    });

    return position;
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    // address = '${place.street}, ${place.locality}, ${place.country}';
    _district = place.subAdministrativeArea;
    _area = place.subLocality;
    _subArea = place.locality;
    _street = place.street;
    widget.onValueChangedDistrict!(_district!);
    widget.onValueChangedArea!(_area!);
    widget.onValueChangedSubArea!(_subArea!);
    widget.onValueChangedStreet!(_street!);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(latitude!, longitude!), zoom: 14),
      markers: markers,
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        googleMapController = controller;
      },
      // onCameraMove: _onCameraMove,
    );
  }
}
