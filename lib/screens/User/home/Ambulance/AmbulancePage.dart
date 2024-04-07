import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/AllAmbulanceLatLng.dart';
import 'package:ghargharmadoctor/models/AmbulanceModel/GetAllAmbulanceListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:location/location.dart' as loc;

class AmbulancePage extends StatefulWidget {
  const AmbulancePage({Key? key}) : super(key: key);

  @override
  State<AmbulancePage> createState() => _AmbulancePageState();
}

class _AmbulancePageState extends State<AmbulancePage> {
  double value = 50;
  String? selectedLocation, selectedAmbulanceType;
  int selectedLocationIndex = 0;
  int selectedAmbulanceIndex = 0;
  ApiHandlerBloc? ambulanceBloc;
  StateHandlerBloc? bottomSheetBloc, btnBloc, bottomNavigationBtnBloc;
  final TextEditingController _myController = TextEditingController();
  int selectedHospitalIndex = 0;
  List<GetAllAmbulanceListModel> getAllAmbulanceListModel = [];
  double? latitude, longitude;
  double? userCurrentLatitude, userCurrentLongitude;
  GoogleMapModel? testPopModal;
  bool isLoading = false;

  List<AllAmbulanceListModel> myAllAmbulanceList = [];
  @override
  void initState() {
    super.initState();
    ambulanceBloc = ApiHandlerBloc();
    bottomSheetBloc = StateHandlerBloc();
    bottomNavigationBtnBloc = StateHandlerBloc();
    btnBloc = StateHandlerBloc();
    requestLocationPermission(getLatAndLng, onLocationDeclined);
    ambulanceBloc!.fetchAPIList(endpoints.getAllAmbulanceEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Ambulances',
        color: backgroundColor,
        borderRadius: 20.0,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox12(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: StreamBuilder<ApiResponse<dynamic>>(
                    stream: ambulanceBloc!.apiListStream,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return Container(
                              width: maxWidth(context),
                              height: maxHeight(context) / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const AnimatedLoading(),
                            );
                          case Status.COMPLETED:
                            if (snapshot.data!.data.isEmpty) {
                              return Container(
                                  height: 140,
                                  padding: const EdgeInsets.all(22.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                      child: Text('No ambulance added')));
                            } else {
                              bottomNavigationBtnBloc!.storeData(true);
                              getAllAmbulanceListModel =
                                  List<GetAllAmbulanceListModel>.from(
                                      snapshot.data!.data.map((i) =>
                                          GetAllAmbulanceListModel.fromJson(
                                              i)));
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: getAllAmbulanceListModel.length,
                              itemBuilder: (ctx, i) {
                                return GestureDetector(
                                  onTap: () {
                                    myAllAmbulanceList.clear();
                                    myAllAmbulanceList.add(
                                        AllAmbulanceListModel(
                                            lat: double.parse(
                                                getAllAmbulanceListModel[i]
                                                    .latitude
                                                    .toString()),
                                            lng: double.parse(
                                                getAllAmbulanceListModel[i]
                                                    .longitude
                                                    .toString())));
                                    showModalBottomSheet(
                                        backgroundColor: backgroundColor,
                                        isScrollControlled: true,
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        builder: (context) =>
                                            ambulanceBottomSheet(context,
                                                getAllAmbulanceListModel[i]));

                                    // goThere(
                                    //     context,
                                    //     GoogleMapAmbulanceUserSide(
                                    //       getAllAmbulanceListModel:
                                    //           myAllAmbulanceList,
                                    //       driverID: getAllAmbulanceListModel[i]
                                    //           .driverId,
                                    //     ));
                                  },
                                  child: ambulanceCard(
                                      getAllAmbulanceListModel[i]),
                                  // Stack(
                                  //   children: [
                                  //     Container(
                                  //       margin:
                                  //           const EdgeInsets.only(bottom: 12.0),
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         borderRadius:
                                  //             BorderRadius.circular(12.0),
                                  //       ),
                                  //       width: maxWidth(context),
                                  //       padding: const EdgeInsets.symmetric(
                                  //           vertical: 12.0),
                                  //       child: Column(
                                  //         children: [
                                  //           Container(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     horizontal: 8.0),
                                  //             width: maxWidth(context),
                                  //             height: 90,
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.start,
                                  //               children: [
                                  //                 ClipRRect(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(
                                  //                             25.0),
                                  //                     child:
                                  //                         myCachedNetworkImage(
                                  //                       110.0,
                                  //                       maxHeight(context),
                                  //                       getAllAmbulanceListModel[
                                  //                               i]
                                  //                           .user!
                                  //                           .phone
                                  //                           .toString(),
                                  //                       BorderRadius.circular(
                                  //                           25.0),
                                  //                       BoxFit.contain,
                                  //                     )),
                                  //                 Expanded(
                                  //                   child: Container(
                                  //                     padding: const EdgeInsets
                                  //                             .symmetric(
                                  //                         horizontal: 10.0),
                                  //                     child: Column(
                                  //                       crossAxisAlignment:
                                  //                           CrossAxisAlignment
                                  //                               .start,
                                  //                       children: [
                                  //                         Text(
                                  //                           getAllAmbulanceListModel[
                                  //                                   i]
                                  //                               .driverId
                                  //                               .toString(),
                                  //                           style: kStyleNormal
                                  //                               .copyWith(
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .bold,
                                  //                             fontSize: 15.0,
                                  //                           ),
                                  //                         ),
                                  //                         const SizedBox(
                                  //                             height: 8.0),
                                  //                         SizedBox(
                                  //                           height: 30.0,
                                  //                           child:
                                  //                               ElevatedButton(
                                  //                             style:
                                  //                                 ElevatedButton
                                  //                                     .styleFrom(
                                  //                               primary: Colors
                                  //                                   .white,
                                  //                               elevation: 0.0,
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                           .all(
                                  //                                       8.0),
                                  //                               shape:
                                  //                                   RoundedRectangleBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius
                                  //                                         .circular(
                                  //                                             4.0),
                                  //                                 side: BorderSide(
                                  //                                     color: myColor
                                  //                                         .primaryColorDark),
                                  //                               ),
                                  //                             ),
                                  //                             onPressed: () {},
                                  //                             child: Text(
                                  //                               '3km away',
                                  //                               style:
                                  //                                   kStyleNormal
                                  //                                       .copyWith(
                                  //                                 color: myColor
                                  //                                     .primaryColorDark,
                                  //                                 fontSize:
                                  //                                     10.0,
                                  //                                 fontWeight:
                                  //                                     FontWeight
                                  //                                         .bold,
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //                         ),
                                  //                         const SizedBox(
                                  //                             height: 8.0),
                                  //                         Row(
                                  //                           mainAxisAlignment:
                                  //                               MainAxisAlignment
                                  //                                   .start,
                                  //                           children: [
                                  //                             Container(
                                  //                               width: 20.0,
                                  //                               height: 20.0,
                                  //                               padding:
                                  //                                   const EdgeInsets
                                  //                                           .all(
                                  //                                       4.0),
                                  //                               decoration: BoxDecoration(
                                  //                                   color: myColor
                                  //                                       .dialogBackgroundColor
                                  //                                       .withOpacity(
                                  //                                           0.3),
                                  //                                   shape: BoxShape
                                  //                                       .circle),
                                  //                               child: Icon(
                                  //                                 FontAwesomeIcons
                                  //                                     .phone,
                                  //                                 size: 11.0,
                                  //                                 color: myColor
                                  //                                     .primaryColorDark,
                                  //                               ),
                                  //                             ),
                                  //                             const SizedBox(
                                  //                                 width: 8.0),
                                  //                             GestureDetector(
                                  //                               onTap: () {
                                  //                                 Clipboard.setData(
                                  //                                     ClipboardData(
                                  //                                   text: getAllAmbulanceListModel[
                                  //                                           i]
                                  //                                       .user!
                                  //                                       .phone
                                  //                                       .toString(),
                                  //                                 ));
                                  //                                 mySnackbar.mySnackBar(
                                  //                                     context,
                                  //                                     'Phone number. copied',
                                  //                                     Colors
                                  //                                         .black
                                  //                                         .withOpacity(
                                  //                                             0.8));
                                  //                               },
                                  //                               onLongPress:
                                  //                                   () {
                                  //                                 Clipboard.setData(
                                  //                                     ClipboardData(
                                  //                                   text: getAllAmbulanceListModel[
                                  //                                           i]
                                  //                                       .user!
                                  //                                       .phone
                                  //                                       .toString(),
                                  //                                 ));
                                  //                                 mySnackbar.mySnackBar(
                                  //                                     context,
                                  //                                     'Phone number copied',
                                  //                                     Colors
                                  //                                         .black
                                  //                                         .withOpacity(
                                  //                                             0.8));
                                  //                               },
                                  //                               child: Text(
                                  //                                 getAllAmbulanceListModel[
                                  //                                         i]
                                  //                                     .user!
                                  //                                     .phone
                                  //                                     .toString(),
                                  //                                 overflow:
                                  //                                     TextOverflow
                                  //                                         .ellipsis,
                                  //                                 style: kStyleNormal
                                  //                                     .copyWith(
                                  //                                   fontSize:
                                  //                                       12.0,
                                  //                                   fontWeight:
                                  //                                       FontWeight
                                  //                                           .bold,
                                  //                                 ),
                                  //                               ),
                                  //                             ),
                                  //                           ],
                                  //                         )
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           const Padding(
                                  //             padding: EdgeInsets.symmetric(
                                  //                 horizontal: 10.0),
                                  //             child: Divider(),
                                  //           ),
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     horizontal: 10.0),
                                  //             child: Row(
                                  //               children: [
                                  //                 Expanded(
                                  //                   flex: 1,
                                  //                   child: SizedBox(
                                  //                     // width: maxWidth(context) / 2 - 28,
                                  //                     height: 45.0,
                                  //                     child: myWhiteButton(
                                  //                       context,
                                  //                       Colors.white,
                                  //                       'Send Request',
                                  //                       kStyleNormal.copyWith(
                                  //                           color: myColor
                                  //                               .primaryColorDark,
                                  //                           fontSize: 14.0),
                                  //                       () {
                                  //                         showModalBottomSheet(
                                  //                             backgroundColor:
                                  //                                 myColor
                                  //                                     .backgroundColor,
                                  //                             isScrollControlled:
                                  //                                 true,
                                  //                             context: context,
                                  //                             shape: const RoundedRectangleBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius.vertical(
                                  //                                         top: Radius.circular(
                                  //                                             20))),
                                  //                             builder: (context) =>
                                  //                                 ambulanceBottomSheet(
                                  //                                     context,
                                  //                                     getAllAmbulanceListModel[
                                  //                                         i]));
                                  //                       },
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //                 const SizedBox(width: 12.0),
                                  //                 Expanded(
                                  //                   flex: 1,
                                  //                   child: SizedBox(
                                  //                     height: 45.0,
                                  //                     child: myCustomButton(
                                  //                         context,
                                  //                         myColor
                                  //                             .primaryColorDark,
                                  //                         'Make a Call',
                                  //                         kStyleNormal.copyWith(
                                  //                             color:
                                  //                                 Colors.white,
                                  //                             fontSize: 14.0),
                                  //                         () {
                                  //                       launch(
                                  //                           "tel://${getAllAmbulanceListModel[i].user!.phone.toString()}");
                                  //                       // callBtn();
                                  //                     }),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                );
                              },
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
                        height: 200,
                      );
                    }),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
      floatingActionButton: StreamBuilder<dynamic>(
          initialData: false,
          stream: bottomNavigationBtnBloc!.stateStream,
          builder: (context, snapshot) {
            if (snapshot.data == false) {
              return Container();
            } else {
              return FloatingActionButton.extended(
                elevation: 0.0,
                backgroundColor: myColor.primaryColorDark,
                foregroundColor: kWhite,
                onPressed: () {
                  // Respond to button press
                },
                icon: const Icon(
                  FontAwesomeIcons.truckMedical,
                  size: 16.0,
                ),
                label: const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text('Quickly Find Ambulance'),
                ),
              );
            }
          }),
      bottomNavigationBar: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: StreamBuilder<dynamic>(
            initialData: false,
            stream: bottomNavigationBtnBloc!.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return Container();
              } else {
                return myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Near by Ambulance',
                    kStyleNormal.copyWith(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ), () async {
                  myAllAmbulanceList.clear();
                  for (var element in getAllAmbulanceListModel) {
                    myAllAmbulanceList.add(
                      AllAmbulanceListModel(
                        lat: double.parse(
                          element.latitude.toString(),
                        ),
                        lng: double.parse(
                          element.longitude.toString(),
                        ),
                      ),
                    );
                  }
                  if (getAllAmbulanceListModel.length ==
                      myAllAmbulanceList.length) {
                    goThere(
                        context,
                        GoogleMapAmbulanceUserSide(
                          driverID: getAllAmbulanceListModel[0].driverId,
                          getAllAmbulanceListModel: myAllAmbulanceList,
                        ));
                  }
                });
              }
            }),
      ),
    );
  }

  getLatAndLng() async {
    loc.LocationData? currentPosition;
    final loc.Location location = loc.Location();

    currentPosition = await location.getLocation();
    location.onLocationChanged.listen((loc.LocationData currentLocation) {
      currentPosition = currentLocation;
    });
    userCurrentLatitude = currentPosition!.latitude;
    userCurrentLongitude = currentPosition!.longitude;
    List<Placemark> placemark = await placemarkFromCoordinates(
        userCurrentLatitude!, userCurrentLongitude!);
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
    } else if (subArea == district) {
      address = '$street, $mainAddress, $area, $district, $country';
    } else {
      address = '$street, $mainAddress, $district, $country';
    }

    testPopModal = GoogleMapModel(
      lat: userCurrentLatitude,
      address: address,
      lng: userCurrentLongitude,
    );
    bottomSheetBloc!.storeData(testPopModal);
  }

  onLocationDeclined() {
    Navigator.pop(context);
  }

  Widget ambulanceBottomSheet(context, GetAllAmbulanceListModel ambulance) {
    sendRequestToDriver() async {
      btnBloc!.storeData(!isLoading);
      int statusCode;
      FocusManager.instance.primaryFocus?.unfocus();
      statusCode = await API().postData(
          context,
          SendRequestToDriver(
            driverId: ambulance.id,
            pickUpLatitude: testPopModal!.lat.toString(),
            pickUpLongitude: testPopModal!.lng.toString(),
          ),
          endpoints.postRequestToDriver);

      if (statusCode == 200) {
        myAllAmbulanceList.clear();
        for (var element in getAllAmbulanceListModel) {
          myAllAmbulanceList.add(
            AllAmbulanceListModel(
              lat: double.parse(
                element.latitude.toString(),
              ),
              lng: double.parse(
                element.longitude.toString(),
              ),
            ),
          );
        }
        btnBloc!.storeData(isLoading);
        if (getAllAmbulanceListModel.length == myAllAmbulanceList.length) {
          goThere(
              context,
              GoogleMapAmbulanceUserSide(
                getAllAmbulanceListModel: myAllAmbulanceList,
              ));
        }
        Navigator.pop(context);
      } else {
        btnBloc!.storeData(isLoading);
        Navigator.pop(context);
        mySnackbar.mySnackBar(
            context, 'Can\'t refer! Error: $statusCode', Colors.red);
      }
    }

    return StreamBuilder<dynamic>(
        initialData: testPopModal,
        stream: bottomSheetBloc!.stateStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: AnimatedLoading(),
            );
          } else {
            return GestureDetector(
              onTap: () {
                myfocusRemover(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
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
                    GestureDetector(
                      onTap: () async {
                        var myPoppedData =
                            await goThere(context, const MyGoogleMap());
                        if (myPoppedData != null) {
                          testPopModal = myPoppedData;
                          bottomSheetBloc!.storeData(testPopModal);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            stream: btnBloc!.stateStream,
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
              ),
            );
          }
        });
  }

  Widget ambulanceCard(GetAllAmbulanceListModel ambulance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
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
                  ambulance.driver!.name.toString().capitalize(),
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
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: myColor.primaryColorDark,
            size: 25.0,
          ),
        ],
      ),
    );
  }
}
