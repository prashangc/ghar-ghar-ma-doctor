import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetIndividualDoctorTimings.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Nurse/home/NurseHomeScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class MyShifts extends StatefulWidget {
  final bool? isHomepage;
  const MyShifts({Key? key, this.isHomepage}) : super(key: key);

  @override
  State<MyShifts> createState() => _MyShiftsState();
}

class _MyShiftsState extends State<MyShifts> {
  TextEditingController dateinput = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? _shift;
  ApiHandlerBloc? shiftBloc;
  List<GetIndividualNurseShifts> getIndividualNurseShifts = [];
  final _form = GlobalKey<FormState>();
  StateHandlerBloc setTimingBloc = StateHandlerBloc();

  @override
  void initState() {
    super.initState();
    dateinput.text = "";
    if (widget.isHomepage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addShift(setState);
      });
    }
    _refresh();
  }

  _refresh() {
    shiftBloc = ApiHandlerBloc();
    shiftBloc!.fetchAPIList(endpoints.getIndividualNurseShiftsEndpoints);
  }

  setShiftBtn(context) async {
    myfocusRemover(context);
    int statusCode;
    setTimingBloc.storeData(true);

    statusCode = await API().postData(
        context,
        PostNurseShiftsModel(date: dateinput.text, shift: _shift),
        endpoints.postNurseShifts);

    if (statusCode == 200) {
      setTimingBloc.storeData(false);
      Navigator.pop(context);
      _refresh();
      setState(() {});
      refreshNurseTimingBloc.storeData('refresh');
    } else {
      setTimingBloc.storeData(false);
    }
  }

  void addShift(myState) {
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => addShiftBottomSheet(myState));
  }

  Widget addShiftBottomSheet(myState) {
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
                      "Set Shifts",
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox16(),
                  TextFormField(
                    controller: dateinput,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: myColor
                                      .primaryColorDark, // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: Colors.black, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: myColor
                                        .primaryColorDark, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101));
                      if (picked != null && picked != selectedDate) {
                        myState(() {
                          selectedDate = picked;
                          dateinput.text =
                              selectedDate.toLocal().toString().split(' ')[0];
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.4),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.4), width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                            color: myColor.primaryColorDark, width: 1.5),
                      ),
                      errorStyle: kStyleNormal.copyWith(
                          color: const Color.fromRGBO(244, 67, 54, 1),
                          fontSize: 12.0),
                      suffixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        size: 14,
                        color: myColor.primaryColorDark,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Set Date',
                      hintStyle: kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                    ),
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'Set Date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox16(),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text(
                          'Choose Shift',
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                          ),
                        ),
                        items: nurseShiftTimingList
                            .map((item) => DropdownMenuItem(
                                  value: item.shift,
                                  child: Text(
                                    item.shift.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: _shift,
                        onChanged: (dynamic value) {
                          setState(() {
                            _shift = value;
                          });
                        },
                        icon: Icon(Icons.keyboard_arrow_down_outlined,
                            color: myColor.primaryColorDark),
                        dropdownOverButton: true,
                        iconSize: 20,
                        iconEnabledColor: myColor.primaryColorDark,
                        iconDisabledColor: Colors.black,
                        buttonHeight: 50,
                        buttonWidth: maxWidth(context),
                        buttonPadding:
                            const EdgeInsets.only(left: 12, right: 14.0),
                        buttonElevation: 0,
                        dropdownElevation: 0,
                        // buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                        buttonDecoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        itemHeight: 40,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 12),
                        dropdownMaxHeight: 180,
                        dropdownPadding:
                            const EdgeInsets.symmetric(horizontal: 3),
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
                              setShiftBtn(context);
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
          title: 'My Shifts',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: StreamBuilder<ApiResponse<dynamic>>(
          stream: shiftBloc!.apiListStream,
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
                  getIndividualNurseShifts =
                      List<GetIndividualNurseShifts>.from(snapshot.data!.data
                          .map((i) => GetIndividualNurseShifts.fromJson(i)));
                  if (getIndividualNurseShifts.isEmpty) {
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
                              'You haven\'t set your shifts',
                              style: kStyleNormal.copyWith(
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox8(),
                            Text(
                              'Add shifts timings to receive appointments.',
                              style: kStyleNormal.copyWith(
                                color: Colors.grey[400],
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox16(),
                            GestureDetector(
                              onTap: () {
                                addShift(setState);
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
                                    'Set Shift',
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

                  return streamCard();
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

  Widget streamCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          const SizedBox12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: getIndividualNurseShifts.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return dateCard(getIndividualNurseShifts[i]);
                }),
          ),
          const SizedBox8(),
          const Divider(),
          const SizedBox16(),
          GestureDetector(
            onTap: () {
              addShift(setState);
            },
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: myColor.primaryColorDark, width: 1.0),
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
                    'Set Shifts',
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
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget shiftCard(Times time) {
    return Text(time.slot.toString());
  }

  Widget dateCard(GetIndividualNurseShifts getIndividualNurseShifts) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                    getIndividualNurseShifts.date.toString().substring(8, 10),
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    getMonth(getIndividualNurseShifts.date.toString()),
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                    ),
                  )
                ],
              )),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            margin: const EdgeInsets.only(right: 8.0, top: 12.0),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            child: Text(
              getIndividualNurseShifts.shift.toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                color: myColor.primaryColorDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
