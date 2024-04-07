import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/LabServices/labProfileCard.dart';
import 'package:ghargharmadoctor/screens/User/home/LabServices/labTestCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class LabServices extends StatefulWidget {
  const LabServices({Key? key}) : super(key: key);

  @override
  State<LabServices> createState() => _LabServicesState();
}

class _LabServicesState extends State<LabServices>
    with SingleTickerProviderStateMixin {
  ApiHandlerBloc? labBloc, testBloc;
  List<LabServicesDepartmentsModel> labServicesDepartmentsModel = [];
  String _search = '';
  StateHandlerBloc? searchBarRadiusBloc;
  AnimationController? _controller;
  GetAllLabServicesModel? getAllLabServicesModel;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
    );
    searchBarRadiusBloc = StateHandlerBloc();
    getDataFromAPI();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  getDataFromAPI() {
    labBloc = ApiHandlerBloc();
    testBloc = ApiHandlerBloc();
    labBloc!.fetchAPIList(endpoints.getLabServiceDepartmentsEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Lab Services',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: StreamBuilder<ApiResponse<dynamic>>(
        stream: labBloc!.apiListStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return SizedBox(
                  width: maxWidth(context),
                  height: maxHeight(context) / 2,
                  child: const AnimatedLoading(),
                );
              case Status.COMPLETED:
                if (snapshot.data!.data.isEmpty) {
                  return Container(
                      width: maxWidth(context),
                      height: 110.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('No services added')));
                }
                labServicesDepartmentsModel =
                    List<LabServicesDepartmentsModel>.from(snapshot.data!.data
                        .map((i) => LabServicesDepartmentsModel.fromJson(i)));
                testBloc!.fetchAPIList(
                    'lab-test/tests/${labServicesDepartmentsModel[0].id}');
                return SizedBox(
                  width: maxWidth(context),
                  height: maxHeight(context),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            const SizedBox12(),
                            searchField(context, 'Search Test', _search,
                                onValueChanged: (v) {
                              _search = v;
                            }),
                            StreamBuilder<dynamic>(
                                initialData: true,
                                stream: searchBarRadiusBloc!.stateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data == false) {
                                    return AnimatedSize(
                                        curve: Curves.easeIn,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: Container());
                                  } else {
                                    return AnimatedSize(
                                      curve: Curves.easeIn,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: Container(
                                        width: maxWidth(context),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 14.0),
                                        decoration: BoxDecoration(
                                          color: myColor.dialogBackgroundColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(0.0),
                                            topRight: Radius.circular(0.0),
                                            bottomLeft: Radius.circular(8.0),
                                            bottomRight: Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Container(
                                          width: maxWidth(context),
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.start,
                                            spacing: 10.0,
                                            runSpacing: 10.0,
                                            children: List.generate(
                                                labServicesDepartmentsModel
                                                    .length,
                                                (index) => GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                          color: kWhite
                                                              .withOpacity(0.4),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 8.0),
                                                        child: Text(
                                                          labServicesDepartmentsModel[
                                                                  index]
                                                              .department
                                                              .toString(),
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontSize: 12.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                            const SizedBox12(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: maxWidth(context),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          decoration: BoxDecoration(
                            color: myColor.dialogBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(22.0),
                              topRight: Radius.circular(22.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: StreamBuilder<ApiResponse<dynamic>>(
                              stream: testBloc!.apiListStream,
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.LOADING:
                                      return SizedBox(
                                        width: maxWidth(context),
                                        height: maxHeight(context) / 2,
                                        child: const AnimatedLoading(),
                                      );
                                    case Status.COMPLETED:
                                      if (snapshot.data!.data.isEmpty) {
                                        return Container(
                                            width: maxWidth(context),
                                            height: 110.0,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                                child:
                                                    Text('No services added')));
                                      }
                                      getAllLabServicesModel =
                                          GetAllLabServicesModel.fromJson(
                                              snapshot.data!.data);
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox12(),
                                          myTitle(
                                              '${labServicesDepartmentsModel[0].department} Lab Profile',
                                              '${getAllLabServicesModel!.labprofiles!.length} lab profiles found in ${labServicesDepartmentsModel[0].department}'),
                                          const SizedBox16(),
                                          SizedBox(
                                            width: maxWidth(context),
                                            height: 151.0,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    getAllLabServicesModel!
                                                        .labprofiles!.length,
                                                itemBuilder: (ctx, i) {
                                                  return labProfileCard(
                                                      context,
                                                      getAllLabServicesModel!
                                                          .labprofiles![i]);
                                                }),
                                          ),
                                          const SizedBox16(),
                                          myTitle(
                                              '${labServicesDepartmentsModel[0].department} Lab Tests',
                                              '${getAllLabServicesModel!.labtests!.length} lab tests found in ${labServicesDepartmentsModel[0].department}'),
                                          const SizedBox16(),
                                          GridView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      childAspectRatio:
                                                          2 / 1.75,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10),
                                              itemCount: getAllLabServicesModel!
                                                  .labtests!.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return labTestCard(
                                                  context,
                                                  getAllLabServicesModel!
                                                      .labtests![index],
                                                );
                                              }),
                                        ],
                                      );
                                    case Status.ERROR:
                                      return Container(
                                        width: maxWidth(context),
                                        height: 110.0,
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
                                return const SizedBox();
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              case Status.ERROR:
                return Container(
                  width: maxWidth(context),
                  height: 110.0,
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
      ),
    );
  }

  myTitle(title, subTitle) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: kStyleNormal.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox2(),
      Text(
        subTitle,
        style: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
    ]);
  }

  // Widget allLabServiceList(GetAllLabServicesModel getAllLabServicesModel) {
  //   return GestureDetector(
  //     onTap: () {
  //       goThere(
  //         context,
  //         IndividualLabDetails(getAllLabServicesModel: getAllLabServicesModel),
  //       );
  //     },
  //     child: Container(
  //       width: 70.0,
  //       margin: const EdgeInsets.only(right: 10.0),
  //       decoration: const BoxDecoration(
  //         color: Colors.red,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(8.0),
  //         ),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Expanded(
  //             flex: 2,
  //             child: myCachedNetworkImageCircle(
  //               70.0,
  //               70.0,
  //               getAllLabServicesModel.testResultType,
  //               BoxFit.cover,
  //             ),
  //           ),
  //           const SizedBox8(),
  //           Expanded(
  //             flex: 1,
  //             child: Text(
  //               getAllLabServicesModel.serviceName.toString(),
  //               textAlign: TextAlign.center,
  //               maxLines: 2,
  //               overflow: TextOverflow.ellipsis,
  //               style: kStyleNormal.copyWith(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 13.0,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget searchField(context, hintText, textValue,
      {required ValueChanged<String>? onValueChanged}) {
    final TextEditingController myController = TextEditingController();
    return StreamBuilder<dynamic>(
        initialData: true,
        stream: searchBarRadiusBloc!.stateStream,
        builder: (context, snapshot) {
          double radius = 0.0;
          if (snapshot.data == true) {
            radius = 0.0;
          } else {
            radius = 8.0;
          }
          return SizedBox(
            height: 45,
            child: TextFormField(
              controller: myController,
              cursorColor: myColor.primaryColorDark,
              textCapitalization: TextCapitalization.words,
              style: kStyleNormal.copyWith(fontSize: 12.0, color: kBlack),
              onChanged: (String value) {
                onValueChanged!(value);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                filled: true,
                fillColor: myColor.dialogBackgroundColor,
                prefixIcon: Icon(
                  Icons.search,
                  size: 17,
                  color: kBlack,
                ),
                suffixIcon: StreamBuilder<dynamic>(
                    initialData: true,
                    stream: searchBarRadiusBloc!.stateStream,
                    builder: (context, snapshot) {
                      return RotationTransition(
                        turns:
                            Tween(begin: 0.0, end: 1.0).animate(_controller!),
                        child: IconButton(
                          onPressed: () {
                            searchBarRadiusBloc!.storeData(!snapshot.data);
                            if (snapshot.data == true) {
                              _controller!.reverse(from: 0.5);
                            } else {
                              _controller!.forward(from: 0.0);
                            }
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 18,
                          ),
                          color: kBlack,
                        ),
                      );
                    }),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                    topRight: const Radius.circular(8.0),
                    topLeft: const Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(color: kWhite, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                    topRight: const Radius.circular(8.0),
                    topLeft: const Radius.circular(8.0),
                  ),
                  borderSide:
                      BorderSide(color: myColor.primaryColorDark, width: 1.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                    topRight: const Radius.circular(8.0),
                    topLeft: const Radius.circular(8.0),
                  ),
                ),
                hintText: hintText,
                hintStyle: kStyleNormal.copyWith(fontSize: 12.0, color: kBlack),
              ),
              onSaved: (v) {
                textValue = v;
              },
            ),
          );
        });
  }
}
