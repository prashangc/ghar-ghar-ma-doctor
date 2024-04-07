import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/AlNurseModel.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseTypeModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/screens/User/home/ViewAllNurses/IndividualNursePage.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:location/location.dart';

class Nurse extends StatefulWidget {
  const Nurse({Key? key}) : super(key: key);

  @override
  State<Nurse> createState() => _NurseState();
}

class _NurseState extends State<Nurse> {
  double value = 50;
  String? selectedLocation, selectedHospitalType;
  int selectedLocationIndex = 0;
  int selectedNurseType = 0;
  ApiHandlerBloc? nurseBloc;
  String _search = '';
  String nurseTypeValue = '';
  final TextEditingController _myController = TextEditingController();
  int selectedHospitalIndex = 0;
  bool _isLoading = false;
  bool _isSelected = false;
  double distance = 30;
  GoogleMapModel? testPopModal;
  NurseModel? nurseList;
  ProfileModel? profileModel;

  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    getDataFromAPI();
  }

  void _filterBtn(myState) {
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => filterNurseBottomSheet(myState));
  }

  getDataFromAPI() async {
    nurseBloc = ApiHandlerBloc();
    nurseBloc!.fetchAPIList(
        'nurse?keyword=$_search&nurse_type&member_id=${profileModel!.memberId}');
  }

  _getLatLng(Function mySetState) async {
    LocationData? currentPosition;
    final Location location = Location();

    currentPosition = await location.getLocation();
    double? latitude, longitude;
    location.onLocationChanged.listen((LocationData currentLocation) {
      currentPosition = currentLocation;
    });
    mySetState(() {
      latitude = currentPosition!.latitude;
      longitude = currentPosition!.longitude;
      _isLoading = !_isLoading;
    });
    var myPoppedData = await goThere(context, const MyGoogleMap());
    mySetState(() {
      testPopModal = myPoppedData;
    });
  }

  Widget filterNurseBottomSheet(myState) {
    return StatefulBuilder(builder: (builder, setState) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5.0),
                Center(
                  child: Text(
                    "Filters",
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox12(),
                Text(
                  "Location",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox12(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLoading = !_isLoading;
                    });
                    requestLocationPermission(_getLatLng(setState), () {});
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
                                  _isLoading
                                      ? 'Locating your address...'
                                      : testPopModal == null
                                          ? 'Select an address'
                                          : testPopModal!.address.toString(),
                                  style: kStyleNormal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _isLoading
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: SizedBox(
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 1.0,
                                            color: myColor.primaryColor,
                                            backgroundColor:
                                                myColor.primaryColorDark),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
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
                const SizedBox12(),
                Text(
                  "Distance",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                SliderTheme(
                  data: SliderThemeData(
                    trackShape: CustomTrackShape(),
                    valueIndicatorColor: myColor.primaryColorDark,
                    thumbColor: Colors.white,
                    activeTrackColor: myColor.primaryColorDark,
                    inactiveTrackColor: myColor.dialogBackgroundColor,
                  ),
                  child: SizedBox(
                    width: maxWidth(context),
                    child: Slider(
                        value: distance,
                        max: 100,
                        divisions: 100,
                        label: distance.round().toString(),
                        min: 0,
                        onChanged: (value) {
                          setState(() {
                            distance = value;
                          });
                        }),
                  ),
                ),
                Text(
                  "Nurse Type",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox12(),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 53.0,
                  width: maxWidth(context),
                  child: ListView.builder(
                      itemCount: nurseTypeList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          onTap: () {
                            if (selectedNurseType == 0) {
                              setState(() {
                                nurseTypeValue =
                                    nurseTypeList[i].name.toString();
                                selectedNurseType =
                                    int.parse(nurseTypeList[i].id.toString());
                                _isSelected = !_isSelected;
                              });
                            } else if (_isSelected == true &&
                                selectedNurseType ==
                                    int.parse(nurseTypeList[i].id.toString())) {
                              setState(() {
                                selectedNurseType = 0;
                                nurseTypeValue = '';
                                _isSelected = false;
                              });
                            } else if (_isSelected == true &&
                                selectedNurseType != 0) {
                              setState(() {
                                nurseTypeValue =
                                    nurseTypeList[i].name.toString();
                                selectedNurseType =
                                    int.parse(nurseTypeList[i].id.toString());
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: selectedNurseType ==
                                              int.parse(nurseTypeList[i]
                                                  .id
                                                  .toString())
                                          ? myColor.primaryColorDark
                                          : const Color.fromARGB(
                                              255, 211, 210, 210),
                                      width: 1.7,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Icon(
                                      Icons.circle,
                                      color: selectedNurseType ==
                                              int.parse(nurseTypeList[i]
                                                  .id
                                                  .toString())
                                          ? myColor.primaryColorDark
                                          : Colors.white,
                                      size: 13.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  nurseTypeList[i].name.toString(),
                                  style: kStyleNormal.copyWith(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox16(),
                const SizedBox16(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        myState(() {
                          selectedNurseType = 0;
                          nurseTypeValue = '';
                          _isSelected = false;
                          distance = 30.0;
                          testPopModal = null;
                          getDataFromAPI();
                        });
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
                              'Clear',
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
                      child: SizedBox(
                        height: 50,
                        child: myCustomButton(
                            context,
                            myColor.primaryColorDark,
                            'Apply',
                            kStyleNormal.copyWith(
                              color: Colors.white,
                              fontSize: 18.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                            ), () {
                          if (testPopModal != null) {
                            Navigator.pop(context);
                            print(testPopModal!.lng);
                            print(testPopModal!.lat);
                            myState(() {
                              nurseBloc!.fetchAPIList(
                                  'nurse?longitude=${testPopModal!.lng}&latitude=${testPopModal!.lat}&distance=$distance&nurse_type=$nurseTypeValue&member_id=${profileModel!.memberId}');
                            });
                          } else {
                            Navigator.pop(context);
                            myState(() {
                              nurseBloc!.fetchAPIList(
                                  'nurse?nurse_type=$nurseTypeValue&member_id=${profileModel!.memberId}');
                            });
                          }
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox12(),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Nurse',
        color: myColor.dialogBackgroundColor,
        borderRadius: 0.0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 4.0),
            width: maxWidth(context),
            decoration: BoxDecoration(
              color: myColor.dialogBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: myFilterSearchTextField(
                context,
                _myController,
                'Search all nurses',
                _search,
                Icons.search,
                Icons.sort,
                () {
                  _filterBtn(setState);
                },
                () {
                  _myController.clear();
                  setState(() {
                    _search = '';
                    getDataFromAPI();
                  });
                },
                onValueChanged: (value) {
                  setState(() {
                    _search = value;
                    print(_search);
                    getDataFromAPI();
                  });
                },
              ),
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      const SizedBox12(),
                      StreamBuilder<ApiResponse<dynamic>>(
                        stream: nurseBloc!.apiListStream,
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
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                          child: Text('No nurse added')));
                                }

                                nurseList =
                                    NurseModel.fromJson(snapshot.data!.data);
                                List<AllNurseModel>? data = [];
                                data = nurseList!.allNurseModel!
                                    .where((element) => element.fee != null)
                                    .toList();
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (ctx, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        goThere(
                                            context,
                                            IndividualNursePage(
                                                nurseModel: data![i]));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.fromLTRB(
                                            5.0, 15.0, 15.0, 15.0),
                                        width: maxWidth(context),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10.0),
                                              width: 100.0,
                                              height: 100.0,
                                              child: myCachedNetworkImage(
                                                100.0,
                                                100.0,
                                                data![i].imagePath.toString(),
                                                BorderRadius.circular(12),
                                                BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[i]
                                                        .user!
                                                        .name
                                                        .toString(),
                                                    overflow: TextOverflow.clip,
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  SizedBox(
                                                    // width: 90,
                                                    child: Text(
                                                      data[i]
                                                          .address
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        color: myColor
                                                            .primaryColorDark,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    data[i]
                                                        .user!
                                                        .phone
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                      testPopModal == null
                          ? Container()
                          : const SizedBox(
                              height: 130.0,
                            ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: testPopModal == null
                    ? Container()
                    : Container(
                        height: 120.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox12(),
                            Text(
                              "Results",
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox8(),
                            Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text.rich(TextSpan(
                                        text: 'Total Nurses within ',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 12.0,
                                        ),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: ' $distance km',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' radius from ',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${testPopModal!.address.toString()}',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                  ),
                                  const SizedBox(width: 22.0),
                                  Text(
                                    "${nurseList!.allNurseModel!.length}",
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox12(),
                          ],
                        ),
                      ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
