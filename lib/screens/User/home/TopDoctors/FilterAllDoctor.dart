import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAllDoctorsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Loading/loading_imports.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/IndividualDoctorPage.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:location/location.dart';

class FilterAllDoctors extends StatefulWidget {
  final BuildContext context;
  final int? symptomID;
  final bool? symptomValidation;

  const FilterAllDoctors({
    Key? key,
    required this.context,
    this.symptomID,
    this.symptomValidation,
  }) : super(key: key);

  @override
  State<FilterAllDoctors> createState() => _FilterAllDoctorsState();
}

class _FilterAllDoctorsState extends State<FilterAllDoctors> {
  double distance = 30;
  ApiHandlerBloc? departmentBloc, doctorsBloc;
  String? selectedLocation,
      selectedEarliestTime,
      _dateNep1,
      _dateNep2,
      _dateEng1,
      _dateEng2;
  int selectedLocationIndex = 0;
  GoogleMapModel? testPopModal;
  AllDoctorsModel? allDoctorsModel;
  List<Doctors> allDoctorsByDepartModel = [];
  List<Doctors> testList = [];
  final TextEditingController _myController = TextEditingController();
  String _search = '';
  int deparmentSelectedIndex = 0;
  StateHandlerBloc validationTextBloc = StateHandlerBloc();
  int selectedEarliestIndex = 0;
  double? lat, lng;
  bool _isLoading = false;
  ProfileModel? profileModel;
  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));

    getDataFromAPI();
  }

  Future getDataFromAPI() async {
    doctorsBloc = ApiHandlerBloc();
    doctorsBloc!.fetchAPIList(
        'booking/date?keyword=$_search&department=$deparmentSelectedIndex&member_id=${profileModel!.memberId}&mintime=$_dateEng1&mintime=$_dateEng2');
  }

  void _filterBtn(myState) {
    myfocusRemover(context);
    departmentBloc = ApiHandlerBloc();
    departmentBloc!.fetchAPIList(endpoints.getDepartmentEndpoint);
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => filterDoctorBottomSheet(myState));
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => myfocusRemover(context),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Search Doctor',
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
                  'Search all doctors',
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
                      getDataFromAPI();
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: StreamBuilder<ApiResponse<dynamic>>(
                    stream: doctorsBloc!.apiListStream,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return const Padding(
                              padding: EdgeInsets.only(top: 18.0),
                              child: AnimatedLoading(),
                            );
                          case Status.COMPLETED:
                            allDoctorsModel =
                                AllDoctorsModel.fromJson(snapshot.data!.data);

                            testList.clear();
                            for (var element in allDoctorsModel!.data!) {
                              testList.add(element);
                            }
                            if (widget.symptomID != null) {
                              testList = testList
                                  .where((element) =>
                                      element.departments!.id ==
                                      widget.symptomID)
                                  .toList();
                            }
                            return testList.isEmpty
                                ? Container(
                                    height: 140,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: StreamBuilder<dynamic>(
                                        initialData:
                                            widget.symptomValidation != null
                                                ? 1
                                                : 0,
                                        stream: validationTextBloc.stateStream,
                                        builder: (c, s) {
                                          return Text(
                                            s.data == 0
                                                ? 'No doctors available.'
                                                : s.data == 1
                                                    ? 'No doctors available for selected symptoms.'
                                                    : 'No any doctors found.',
                                            style: kStyleNormal,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: testList.length,
                                    itemBuilder: (ctx, i) {
                                      return doctorCard(testList[i]);
                                    });
                          case Status.ERROR:
                            return Container(
                              width: maxWidth(context),
                              height: 135.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget doctorCard(Doctors doctors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: () {
          goThere(context, IndividualDoctorPage(doctors: doctors));
        },
        child: Container(
          // margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.fromLTRB(5.0, 15.0, 15.0, 15.0),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                width: 100.0,
                height: 100.0,
                child: myCachedNetworkImage(
                  100.0,
                  100.0,
                  doctors.imagePath.toString(),
                  const BorderRadius.all(Radius.circular(12)),
                  BoxFit.contain,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Icon(
                        Icons.circle,
                        size: 12.0,
                        color: doctors.fee == null
                            ? kGrey.withOpacity(0.9)
                            : kGreen,
                      ),
                    ]),
                    Text(
                      '${doctors.salutation.toString()}  ${doctors.user!.name.toString()}',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                      style: kStyleNormal.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                          width: 80.0,
                          child: Text(
                            doctors.specialization.toString(),
                            overflow: TextOverflow.ellipsis,
                            // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                            style: kStyleNormal.copyWith(
                              color: myColor.primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        SizedBox(
                          width: 80.0,
                          child: Text(
                            doctors.address.toString(),
                            overflow: TextOverflow.ellipsis,
                            // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                            style: kStyleNormal.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: myColor.dialogBackgroundColor,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.medical_information,
                            size: 15.0,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        SizedBox(
                          width: 45,
                          child: Text(
                            '${doctors.yearPracticed.toString()} years',
                            overflow: TextOverflow.ellipsis,
                            // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                            style: kStyleNormal.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: myColor.dialogBackgroundColor,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.timer,
                            size: 15.0,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        SizedBox(
                          width: 70,
                          child: Text(
                            '${doctors.createdAt.toString()} years',
                            overflow: TextOverflow.ellipsis,
                            // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                            style: kStyleNormal.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget filterDoctorBottomSheet(myState) {
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
                  "Appointment Date",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox12(),
                Row(
                  children: [
                    Expanded(
                      child: widgetDatePicker(
                          context,
                          disableDateType: 'past',
                          mergeTimePicker: true,
                          kStyleNormal.copyWith(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          _dateNep1 ?? 'From',
                          _dateNep1,
                          null,
                          kWhite, onValueChanged: (value) {
                        setState(() {
                          _dateNep1 = value.nepaliDate;
                          _dateEng1 = value.englishDate;
                        });
                      }),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: widgetDatePicker(
                          context,
                          disableDateType: 'past',
                          mergeTimePicker: true,
                          kStyleNormal.copyWith(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          _dateNep2 ?? 'To',
                          _dateNep2,
                          null,
                          kWhite, onValueChanged: (value) {
                        setState(() {
                          _dateNep2 = value.nepaliDate;
                          _dateEng2 = value.englishDate;
                        });
                      }),
                    ),
                  ],
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
                  "Departments",
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox16(),
                StreamBuilder<ApiResponse<dynamic>>(
                  stream: departmentBloc!.apiListStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return const FilterDoctorDepartmentsLoadingShimmer();
                        case Status.COMPLETED:
                          if (snapshot.data!.data.isEmpty) {
                            return Container(
                                width: maxWidth(context),
                                height: 85.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child: Text('No departments found')));
                          }
                          List<DepartmentModel> departmentModel =
                              List<DepartmentModel>.from(snapshot.data!.data
                                  .map((i) => DepartmentModel.fromJson(i)));

                          return SizedBox(
                            width: maxWidth(context),
                            height: 85.0,
                            child: ListView.builder(
                                itemCount: departmentModel.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (deparmentSelectedIndex ==
                                            int.parse(departmentModel[index]
                                                .id
                                                .toString())) {
                                          deparmentSelectedIndex = 0;
                                        } else {
                                          deparmentSelectedIndex = int.parse(
                                              departmentModel[index]
                                                  .id
                                                  .toString());
                                        }
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                right: 10.0),
                                            width: 65,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor: myColor
                                                        .dialogBackgroundColor,
                                                    radius: 30.0,
                                                    child:
                                                        myCachedNetworkImageCircle(
                                                            25.0,
                                                            25.0,
                                                            departmentModel[
                                                                    index]
                                                                .imagePath
                                                                .toString(),
                                                            BoxFit.contain)),
                                                const SizedBox(height: 4.0),
                                                SizedBox(
                                                  width: maxWidth(context),
                                                  height: 18,
                                                  child: Center(
                                                    child: Text(
                                                      departmentModel[index]
                                                          .department
                                                          .toString(),
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontSize: 12.0,
                                                        // fontWeight:
                                                        // FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                // const Text("data"),
                                              ],
                                            )),
                                        Positioned(
                                          right: 19.0,
                                          child: Icon(
                                            deparmentSelectedIndex ==
                                                    int.parse(
                                                        departmentModel[index]
                                                            .id
                                                            .toString())
                                                ? Icons.check_circle
                                                : null,
                                            color: myColor.primaryColorDark,
                                            size: 12.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                })),
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
                const SizedBox16(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        myState(() {
                          deparmentSelectedIndex = 0;
                          _dateEng1 = null;
                          _dateEng2 = null;
                          testPopModal = null;
                          distance = 30;
                          doctorsBloc!.fetchAPIList(
                              'booking/date?keyword=$_search&department=$deparmentSelectedIndex&member_id=${profileModel!.memberId}&mintime=$_dateEng1&mintime=$_dateEng2');
                        });
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
                          validationTextBloc.storeData(2);
                          if (testPopModal != null) {
                            Navigator.pop(context);
                            myState(() {
                              doctorsBloc!.fetchAPIList(
                                  'booking/date?longitude=${testPopModal!.lng}&latitude=${testPopModal!.lat}&distance=$distance&department=$deparmentSelectedIndex&mintime=$_dateEng1&maxtime=$_dateEng2');
                            });
                          } else {
                            Navigator.pop(context);
                            myState(() {
                              doctorsBloc!.fetchAPIList(
                                  'booking/date?distance&department=$deparmentSelectedIndex&mintime=$_dateEng1&maxtime=$_dateEng2');
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
}
