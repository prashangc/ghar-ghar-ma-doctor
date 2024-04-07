import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/AllAmbulanceLatLng.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewAmbulanceOnMap extends StatefulWidget {
  final List<AllAmbulanceListModel> getAllAmbulanceListModel;
  final double? currentLat;
  final double? currentLng;

  const ViewAmbulanceOnMap(
      {Key? key,
      required this.getAllAmbulanceListModel,
      this.currentLat,
      this.currentLng})
      : super(key: key);

  @override
  State<ViewAmbulanceOnMap> createState() => _ViewAmbulanceOnMapState();
}

class _ViewAmbulanceOnMapState extends State<ViewAmbulanceOnMap> {
  final Set<Marker> _markers = <Marker>{};
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? customIcon;
  @override
  void initState() {
    super.initState();
    customMarkerIcon();
    myMarker();
  }

  customMarkerIcon() async {
    print('object');
    // ImageConfiguration configuration = createLocalImageConfiguration(context);
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(20, 20)),
            'assets/ambulance.jpg')
        .then((v) {
      setState(() {
        customIcon = v;
      });
    });
  }

  void myMarker() {
    for (var element in widget.getAllAmbulanceListModel) {
      _markers.add(Marker(
          icon: customIcon ?? BitmapDescriptor.defaultMarker,
          // markerId: const MarkerId('currentLocation'),
          markerId: const MarkerId('1'),
          position: LatLng(double.parse(element.lat.toString()),
              double.parse(element.lng.toString())),
          infoWindow: const InfoWindow(
            title: 'name',
            // title: widget.getAllAmbulanceListModel.user!.name.toString(),
            snippet: 'my snippet',
          ),
          onTap: () {
            print('tapped');
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Ambulances',
        color: myColor.dialogBackgroundColor,
        borderRadius: 0.0,
      ),
      body: GoogleMap(
        // onTap: (position) {
        //   _mapOnTap(position);
        // },
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: widget.currentLat == null
                ? LatLng(
                    double.parse(
                        widget.getAllAmbulanceListModel[0].lat.toString()),
                    double.parse(
                        widget.getAllAmbulanceListModel[0].lng.toString()))
                : LatLng(widget.currentLat!, widget.currentLng!),
            zoom: widget.currentLat == null ? 17 : 128),
        markers: _markers,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
