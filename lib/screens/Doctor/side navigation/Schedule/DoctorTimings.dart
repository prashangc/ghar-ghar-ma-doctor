import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/ConsultationTypeModel.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetIndividualDoctorTimings.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/home/doctorHomeScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class DoctorTimings extends StatefulWidget {
  final bool? isHomepage;
  const DoctorTimings({Key? key, this.isHomepage}) : super(key: key);

  @override
  State<DoctorTimings> createState() => _DoctorTimingsState();
}

class _DoctorTimingsState extends State<DoctorTimings> {
  DateTime selectedDate = DateTime.now();
  String? nepDate,
      engDate,
      _startTime,
      _endTime,
      _serviceType,
      hospitalID,
      hospitalName;
  ApiHandlerBloc? timeBloc, hospitalBloc;
  GetIndividualDoctorTimings? getIndividualDoctorTimings;
  List<AllHospitalModel> hospitalList = [];
  List<GetIDNameModel> hospitals = [];
  List<GetIDNameModel> serviceTypeList = [];
  StateHandlerBloc setTimingBloc = StateHandlerBloc();
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.isHomepage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addTimings(setState);
      });
    }
    _refresh();
    for (int i = 0; i < consultationTypeList.length; i++) {
      serviceTypeList.add(GetIDNameModel(
        id: consultationTypeList[i].type,
        name: consultationTypeList[i].type,
      ));
    }
  }

  _refresh() {
    timeBloc = ApiHandlerBloc();
    timeBloc!.fetchAPIList(endpoints.getIndividualDoctorTimingsEndpoint);
  }

  setTimeBtn(context) async {
    myfocusRemover(context);
    var isValid = _form.currentState?.validate();
    int statusCode;
    if (!isValid!) {
      return;
    } else {
      setTimingBloc.storeData(true);
      statusCode = await API().postData(
          context,
          PostDoctorTimingsModel(
            date: engDate,
            endTime: _endTime,
            startTime: _startTime,
            hospital: _serviceType == 'In Video' ? hospitalID : '0',
            serviceType: _serviceType,
          ),
          endpoints.postDoctorTimings);

      if (statusCode == 200) {
        setTimingBloc.storeData(false);
        Navigator.pop(context);
        _refresh();
        refreshDoctorTimingBloc.storeData('refresh');
        setState(() {});
      } else {
        setTimingBloc.storeData(false);
      }
    }
  }

  void addTimings(myState) {
    hospitalBloc = ApiHandlerBloc();
    hospitalBloc!.fetchAPIList(endpoints.getAllHospitalsEndpoint);

    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => addTimingsBottomSheet(myState));
  }

  Widget addTimingsBottomSheet(myState) {
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
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5.0),
                  Center(
                    child: Text(
                      "Set Schedule",
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox16(),
                  widgetDatePickerWithoutPrefixIcon(
                      context,
                      kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                      nepDate,
                      Colors.white.withOpacity(0.4),
                      18.0, onValueChanged: (v) {
                    setState(() {
                      nepDate = v.nepaliDate;
                      engDate = v.englishDate;
                    });
                  }),
                  const SizedBox16(),
                  myTimePicker(context, _startTime, 'Start Time', Colors.white,
                      'Select Start Time', onValueChanged: (v) {
                    _startTime = v;
                  }),
                  const SizedBox16(),
                  myTimePicker(context, _endTime, 'End Time', Colors.white,
                      'Select End Time', onValueChanged: (v) {
                    _endTime = v;
                  }),
                  const SizedBox16(),
                  myDropDown2WithoutIcon(
                      context,
                      _serviceType ?? 'Service Type',
                      serviceTypeList,
                      Colors.white.withOpacity(0.4), onValueChanged: (v) {
                    setState(() {
                      _serviceType = v.name;
                    });
                  }),
                  const SizedBox16(),
                  // _serviceType == null || _serviceType == 'In Video'
                  //     ? Container()
                  //     :
                  StreamBuilder<ApiResponse<dynamic>>(
                    stream: hospitalBloc!.apiListStream,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return myDropDown2Loading(
                                context,
                                Icons.perm_identity,
                                Colors.black,
                                Colors.black,
                                maxWidth(context),
                                'Select Hospital',
                                hospitals,
                                onValueChanged: (value) {});
                          case Status.COMPLETED:
                            hospitalList = List<AllHospitalModel>.from(snapshot
                                .data!.data
                                .map((i) => AllHospitalModel.fromJson(i)));
                            hospitals.clear();
                            for (int i = 0; i < hospitalList.length; i++) {
                              hospitals.add(GetIDNameModel(
                                id: hospitalList[i].id.toString(),
                                name: hospitalList[i].name,
                              ));
                            }

                            return myDropDown2WithoutIcon(
                                context,
                                hospitalName ??
                                    (_serviceType == null ||
                                            _serviceType == 'In Video'
                                        ? 'Not required'
                                        : 'Select Hospital'),
                                _serviceType == null ||
                                        _serviceType == 'In Video'
                                    ? []
                                    : hospitals,
                                myColor.scaffoldBackgroundColor
                                    .withOpacity(0.4), onValueChanged: (v) {
                              setState(() {
                                hospitalName = v.name;
                                hospitalID = v.id;
                              });
                            });
                          case Status.ERROR:
                            return Container(
                              width: maxWidth(context),
                              height: 135.0,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child:
                                    Text('Server Error', style: kStyleNormal),
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
                  StreamBuilder<dynamic>(
                      initialData: false,
                      stream: setTimingBloc.stateStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == false) {
                          return SizedBox(
                            width: maxWidth(context),
                            height: 50,
                            child: myCustomButton(
                                context,
                                myColor.primaryColorDark,
                                'Set Timings',
                                kStyleNormal.copyWith(
                                  color: kWhite,
                                  fontSize: 16.0,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w300,
                                ), () {
                              setTimeBtn(context);
                            }),
                          );
                        } else {
                          return myBtnLoading(context, 50.0);
                        }
                      }),
                  const SizedBox12(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'My Schedule',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: StreamBuilder<ApiResponse<dynamic>>(
          stream: timeBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Container(
                    width: maxWidth(context),
                    height: maxHeight(context),
                    margin: const EdgeInsets.all(22.0),
                    child: const AnimatedLoading(),
                  );
                case Status.COMPLETED:
                  getIndividualDoctorTimings =
                      GetIndividualDoctorTimings.fromJson(snapshot.data!.data);
                  if (getIndividualDoctorTimings!.bookings!.isEmpty) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        width: maxWidth(context),
                        height: maxHeight(context) / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 100.0,
                              color: myColor.primaryColorDark,
                            ),
                            const SizedBox32(),
                            Text(
                              'You haven\'t set your schedule',
                              style: kStyleNormal.copyWith(
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox8(),
                            Text(
                              'Add appointment timings to receive appointments.',
                              style: kStyleNormal.copyWith(
                                color: Colors.grey[400],
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox16(),
                            GestureDetector(
                              onTap: () {
                                addTimings(setState);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                      color: myColor.primaryColorDark,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: const EdgeInsets.fromLTRB(
                                    12.0, 0.0, 12.0, 18.0),
                                width: maxWidth(context) / 3,
                                height: 45,
                                child: Center(
                                  child: Text(
                                    'Set Time',
                                    style: kStyleNormal.copyWith(
                                      color: myColor.primaryColorDark,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox12(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date',
                                    style: kStyleNormal.copyWith(
                                      color: myColor.primaryColorDark,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.timer,
                                    size: 22.0,
                                    color: myColor.primaryColorDark,
                                  ),
                                ],
                              ),
                              const SizedBox12(),
                              const Divider(),
                              const SizedBox12(),
                              ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: getIndividualDoctorTimings!
                                      .bookings!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, i) {
                                    return dateCard(getIndividualDoctorTimings!
                                        .bookings![i]);
                                  }),
                            ],
                          ),
                        )),
                        const SizedBox8(),
                        GestureDetector(
                          onTap: () {
                            addTimings(setState);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              border: Border.all(
                                  color: myColor.primaryColorDark, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 22.0,
                                  color: myColor.primaryColorDark,
                                ),
                                const SizedBox(width: 3.0),
                                Text(
                                  'Set Time',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 3.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox8(),
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
            return SizedBox(
              width: maxWidth(context),
              height: 200,
            );
          }),
        ),
      ),
    );
  }

  Widget timeCard(Times time) {
    return Text(time.slot.toString());
  }

  Widget dateCard(BookingsDetails bookings) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(6.0),
          )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 70.0,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6.0),
                    topLeft: Radius.circular(6.0),
                  )),
              child: Column(
                children: [
                  Text(
                    bookings.date.toString().substring(8, 10),
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getMonth(bookings.date.toString()),
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                    ),
                  )
                ],
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: myColor.dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(6.0),
                  topRight: Radius.circular(6.0),
                )),
            child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  height: 35,
                  mainAxisSpacing: 10,
                ),
                itemCount: bookings.times!.length,
                itemBuilder: (BuildContext ctx, idx) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        bookings.times![idx].slot.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                    ),
                  );
                }),
          )),
        ],
      ),
    );
  }

  Widget myDropDown2Loading(BuildContext context, icon, Color iconColor,
      Color titleTextColor, width, hintText, List<GetIDNameModel> listItemData,
      {required ValueChanged<GetIDNameModel>? onValueChanged}) {
    String? selectedValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Text(
                hintText,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
              items: listItemData
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(
                          item.name.toString(),
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (dynamic value) {
                onValueChanged!(value);
              },

              icon: Container(
                width: 15.0,
                height: 15.0,
                margin: const EdgeInsets.only(right: 10.0),
                child: CircularProgressIndicator(
                  backgroundColor: myColor.primaryColorDark,
                  color: myColor.dialogBackgroundColor,
                  strokeWidth: 1.5,
                ),
              ),
              dropdownOverButton: true,
              iconSize: 20,
              iconEnabledColor: myColor.primaryColorDark,
              iconDisabledColor: Colors.grey,
              buttonHeight: 50,
              buttonWidth: width,
              buttonPadding: const EdgeInsets.only(left: 12, right: 14.0),
              buttonElevation: 0,
              dropdownElevation: 0,
              // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8.0),
              ),
              itemHeight: 40,
              itemPadding: const EdgeInsets.symmetric(horizontal: 14),
              dropdownMaxHeight: 180,
              dropdownPadding: const EdgeInsets.symmetric(horizontal: 3),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 3,
              scrollbarAlwaysShow: false,
              offset: const Offset(0, 0),
            ),
          ),
        ),
      ],
    );
  }
}
