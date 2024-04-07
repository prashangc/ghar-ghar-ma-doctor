import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class Hospital extends StatefulWidget {
  const Hospital({Key? key}) : super(key: key);

  @override
  State<Hospital> createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  double value = 50;
  String? selectedLocation, selectedHospitalType;
  int selectedLocationIndex = 0;
  ApiHandlerBloc? hospitalBloc;
  int selectedHospitalIndex = 0;
  String _search = '';
  final TextEditingController _myController = TextEditingController();
  List<AllHospitalModel> hospitalList = [];

  @override
  void initState() {
    super.initState();
    hospitalBloc = ApiHandlerBloc();
    hospitalBloc!.fetchAPIList(endpoints.getAllHospitalsEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Hospitals',
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
                'Search all hospitals',
                _search,
                Icons.search,
                Icons.sort,
                () {
                  // _filterBtn(setState);
                },
                () {
                  _myController.clear();
                  setState(() {
                    _search = '';
                    // getDataFromAPI();
                  });
                },
                onValueChanged: (value) {
                  setState(() {
                    _search = value;
                    print(_search);
                    // getDataFromAPI();
                  });
                },
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox12(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: StreamBuilder<ApiResponse<dynamic>>(
                    stream: hospitalBloc!.apiListStream,
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
                                  margin: const EdgeInsets.only(bottom: 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                      child: Text('No hospitals added')));
                            }

                            hospitalList = List<AllHospitalModel>.from(snapshot
                                .data!.data
                                .map((i) => AllHospitalModel.fromJson(i)));
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: hospitalList.length,
                              itemBuilder: (ctx, i) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 15.0, 15.0, 15.0),
                                    width: maxWidth(context),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          width: 100.0,
                                          height: 100.0,
                                          // decoration: BoxDecoration(
                                          //     borderRadius:
                                          //         BorderRadius.circular(12),
                                          //     color: const Color.fromARGB(
                                          //         255, 238, 238, 238),
                                          //     image: const DecorationImage(
                                          //       image: AssetImage(
                                          //           'assets/logo.png'),
                                          //       fit: BoxFit.fitHeight,
                                          //     )),
                                          child: myCachedNetworkImage(
                                            100.0,
                                            100.0,
                                            hospitalList[i]
                                                .imagePath
                                                .toString(),
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
                                                hospitalList[i].name.toString(),
                                                overflow: TextOverflow.clip,
                                                // textAlign: TextAlign.center,
                                                // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                                                style: kStyleNormal.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                // width: 90,
                                                child: Text(
                                                  hospitalList[i]
                                                      .address
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                                                  style: kStyleNormal.copyWith(
                                                    color: myColor
                                                        .primaryColorDark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                hospitalList[i]
                                                    .phone
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                // "${snapshot.data![index]['hospital_name'].substring(0, 6)}...",
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
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
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget filterHospitalBottomSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
            SizedBox(
              width: maxWidth(context),
              height: 60.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: locationList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLocationIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: selectedLocationIndex == index
                            ? myColor.primaryColorDark
                            : Colors.transparent,
                        border: Border.all(
                            color: myColor.primaryColorDark, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 100,
                      child: Center(
                        child: Text(locationList[index].textValue.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: kStyleNormal.copyWith(
                                color: selectedLocationIndex == index
                                    ? Colors.white
                                    : myColor.primaryColorDark)),
                      ),
                    ),
                  );
                },
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
              child: StatefulBuilder(
                builder: (context, setState) => SizedBox(
                  width: maxWidth(context),
                  child: Slider(
                      value: value,
                      max: 100,
                      divisions: 100,
                      label: value.round().toString(),
                      min: 0,
                      onChanged: (value) {
                        setState(() {
                          this.value = value;
                        });
                      }),
                ),
              ),
            ),
            Text(
              "Type",
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const SizedBox16(),
            SizedBox(
              width: maxWidth(context),
              height: 60.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: hospitalTypeList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedHospitalIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: selectedHospitalIndex == index
                            ? myColor.primaryColorDark
                            : Colors.transparent,
                        border: Border.all(
                            color: myColor.primaryColorDark, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: 100,
                      child: Center(
                        child: Text(
                            hospitalTypeList[index].typeValue.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: kStyleNormal.copyWith(
                                color: selectedHospitalIndex == index
                                    ? Colors.white
                                    : myColor.primaryColorDark)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox16(),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border:
                        Border.all(color: myColor.primaryColorDark, width: 1.0),
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
                        ),
                        () {}),
                  ),
                ),
              ],
            ),
            const SizedBox12(),
          ],
        ),
      );
    });
  }
}
