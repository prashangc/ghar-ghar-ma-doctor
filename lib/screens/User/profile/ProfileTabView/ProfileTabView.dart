import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/constants/graph.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/editProfile.dart';
import 'package:ghargharmadoctor/screens/User/profile/refreshMethod.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Ideal%20Health%20Indicator/BMI.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Ideal%20Health%20Indicator/BloodPressure.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Ideal%20Health%20Indicator/DrinkWater.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Ideal%20Health%20Indicator/Pedometer.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileTabView extends StatefulWidget {
  final ProfileModel profileModel;
  final StateHandlerBloc companyOrNormalProfileBloc;
  const ProfileTabView(
      {Key? key,
      required this.profileModel,
      required this.companyOrNormalProfileBloc})
      : super(key: key);

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ApiHandlerBloc? packagesListBloc;
  String? _weight,
      _height,
      _heightToPost,
      _upperBP,
      _lowerBP,
      _myBP,
      _bmiValue,
      _urlID,
      waterDrankToday,
      waterNotification,
      showWaterNotification,
      dailyWaterToDrinkPercent,
      _gender;
  final _form = GlobalKey<FormState>();
  final bool _isBloodPressureLoading = false;
  List<String> activityPermissionRestrictedList = [
    "Your device doesn't supports step count sensor",
  ];
  List<String> activityPermissionDeniedList = [
    "Physical activity permission should be enabled.",
  ];
  StateHandlerBloc? waterNotificationBloc;
  StateHandlerBloc physicalActivityBloc = StateHandlerBloc();
  String? showCase3;
  // final keyOne = GlobalKey();

  @override
  void initState() {
    super.initState();
    showCase3 = sharedPrefs.getFromDevice("showCase3");
    checkPhysicalActivityPermission();
    packagesListBloc = ApiHandlerBloc();

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => ShowCaseWidget.of(context).startShowCase([
    //     keyOne,
    //   ]),
    // );
    _urlID = widget.profileModel.id.toString();
    _weight = widget.profileModel.weight;
    _height = widget.profileModel.height;
    _myBP = widget.profileModel.bp;
    _gender = widget.profileModel.gender ?? 'Male';
    waterNotificationBloc = StateHandlerBloc();
  }

  checkPhysicalActivityPermission() async {
    String status = await checkPermissionStatus();
    if (status == 'isRestricted') {
      physicalActivityBloc.storeData(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
      width: maxWidth(context),
      child: RefreshIndicator(
        edgeOffset: 0,
        strokeWidth: 2.0,
        color: kWhite,
        backgroundColor: myColor.primaryColorDark,
        onRefresh: () async {
          await refresh(context);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          myContainer(
                            StreamBuilder<dynamic>(
                                initialData: widget.profileModel,
                                stream: refreshMainSreenBloc.stateStream,
                                builder: (c, s) {
                                  return profileCard(s.data);
                                }),
                            companyProfileCard(),
                          ),
                          const SizedBox12(),
                          Expanded(
                              flex: 1,
                              child: myContainer(
                                  familyCard(), const Text('empty'))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<dynamic>(
                                initialData: 0,
                                stream: physicalActivityBloc.stateStream,
                                builder: (x, z) {
                                  return z.data == 0
                                      ? myContainer(stepsCountCard(context),
                                          companyVerificationCard())
                                      : Stack(
                                          children: [
                                            myContainer(stepsCountCard(context),
                                                companyVerificationCard()),
                                            Positioned(
                                              top: 1,
                                              left: 1,
                                              right: 1,
                                              bottom: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor: myColor
                                                          .dialogBackgroundColor,
                                                      isScrollControlled: true,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20))),
                                                      builder: ((builder) =>
                                                          physicalActivityPermissionBottomSheet(
                                                            "Activity Permission Restricted",
                                                            activityPermissionRestrictedList,
                                                            'Back',
                                                          )));
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6.0,
                                                          vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color: kBlack,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  8.0),
                                                        ),
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Icon(
                                                              Icons.lock,
                                                              color: kWhite,
                                                              size: 12.0,
                                                            ),
                                                            Text(
                                                              'Not Supported',
                                                              style:
                                                                  kStyleNormal
                                                                      .copyWith(
                                                                color: kWhite,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 12.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kBlack
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    8.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                }),
                          ),
                          const SizedBox12(),
                          Expanded(
                            child: myContainer(waterCard(), const Text('a')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox16(),
              StreamBuilder<dynamic>(
                  initialData: 'user',
                  stream: widget.companyOrNormalProfileBloc.stateStream,
                  builder: (ct, s) {
                    return Center(
                      child: s.data != 'user'
                          ? Container()
                          : StreamBuilder<dynamic>(
                              initialData: 0,
                              stream: refreshPackageBloc.stateStream,
                              builder: (context, s) {
                                packagesListBloc!.fetchAPIList(
                                    endpoints.getIndividualPackageEndpoint);
                                return StreamBuilder<ApiResponse<dynamic>>(
                                  stream: packagesListBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: kWhite.withOpacity(0.4),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                            width: maxWidth(context),
                                            height: 250.0,
                                            child: const Center(
                                              child: AnimatedLoading(),
                                            ),
                                          );
                                        case Status.COMPLETED:
                                          IndividualPackagesListModel
                                              individualPackagesListModel =
                                              IndividualPackagesListModel
                                                  .fromJson(
                                                      snapshot.data!.data);

                                          return Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      individualPackagesListModel
                                                                  .myPackage !=
                                                              null
                                                          ? Text(
                                                              "Blood Pressure",
                                                              style: kStyleNormal
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                            )
                                                          : Row(
                                                              children: [
                                                                Text(
                                                                  "Blood Pressure",
                                                                  style: kStyleNormal.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        12.0),
                                                                Text(
                                                                  "( ",
                                                                  style: kStyleNormal.copyWith(
                                                                      color: myColor
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                                Icon(
                                                                  Icons.lock,
                                                                  color: myColor
                                                                      .primaryColorDark,
                                                                  size: 16.0,
                                                                ),
                                                                Text(
                                                                  " )",
                                                                  style: kStyleNormal.copyWith(
                                                                      color: myColor
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                              ],
                                                            ),
                                                      individualPackagesListModel
                                                                  .myPackage ==
                                                              null
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                goThere(context,
                                                                    const BloodPressure());
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "View",
                                                                    style: kStyleNormal.copyWith(
                                                                        color: myColor
                                                                            .primaryColorDark,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12.0),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          4.0),
                                                                  Icon(
                                                                    Icons
                                                                        .keyboard_arrow_right_outlined,
                                                                    color: myColor
                                                                        .primaryColorDark,
                                                                    size: 16.0,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                  const SizedBox8(),
                                                  Stack(
                                                    children: [
                                                      myGraph(context),
                                                      individualPackagesListModel
                                                                  .myPackage !=
                                                              null
                                                          ? Container()
                                                          : lockedCard(
                                                              () {
                                                                showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    backgroundColor:
                                                                        myColor
                                                                            .dialogBackgroundColor,
                                                                    isScrollControlled:
                                                                        true,
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                                20))),
                                                                    builder:
                                                                        ((builder) =>
                                                                            lockedBottomModalSheet()));
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox16(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      individualPackagesListModel
                                                                  .myPackage !=
                                                              null
                                                          ? Text(
                                                              "Current BMI",
                                                              style: kStyleNormal
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                            )
                                                          : Row(
                                                              children: [
                                                                Text(
                                                                  "Current BMI",
                                                                  style: kStyleNormal.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        12.0),
                                                                Text(
                                                                  "( ",
                                                                  style: kStyleNormal.copyWith(
                                                                      color: myColor
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                                Icon(
                                                                  Icons.lock,
                                                                  color: myColor
                                                                      .primaryColorDark,
                                                                  size: 16.0,
                                                                ),
                                                                Text(
                                                                  " )",
                                                                  style: kStyleNormal.copyWith(
                                                                      color: myColor
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                              ],
                                                            ),
                                                      individualPackagesListModel
                                                                  .myPackage ==
                                                              null
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                goThere(context,
                                                                    const BMI());
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "View",
                                                                    style: kStyleNormal.copyWith(
                                                                        color: myColor
                                                                            .primaryColorDark,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12.0),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          4.0),
                                                                  Icon(
                                                                    Icons
                                                                        .keyboard_arrow_right_outlined,
                                                                    color: myColor
                                                                        .primaryColorDark,
                                                                    size: 16.0,
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                  const SizedBox8(),
                                                  Stack(
                                                    children: [
                                                      myGraph(context),
                                                      individualPackagesListModel
                                                                  .myPackage !=
                                                              null
                                                          ? Container()
                                                          : lockedCard(
                                                              () {
                                                                showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    backgroundColor:
                                                                        myColor
                                                                            .dialogBackgroundColor,
                                                                    isScrollControlled:
                                                                        true,
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                                20))),
                                                                    builder:
                                                                        ((builder) =>
                                                                            lockedBottomModalSheet()));
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox16(),
                                            ],
                                          );
                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
                                            decoration: BoxDecoration(
                                              color: kWhite,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                              child: Text('Server yhis error'),
                                            ),
                                          );
                                      }
                                    }
                                    return const SizedBox();
                                  }),
                                );
                              }),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget companyVerificationCard() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Status',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: myColor.primaryColorDark,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: myColor.primaryColorDark,
            size: 16.0,
          ),
        ],
      ),
      const SizedBox12(),
      Icon(
        widget.profileModel.schoolProfile != null
            ? widget.profileModel.schoolProfile!.status == 'pending'
                ? FontAwesomeIcons.hourglass
                : widget.profileModel.schoolProfile!.status == 'verified'
                    ? Icons.check_circle
                    : Icons.error_outline
            : Icons.error_outline,
        size: 40.0,
        color: widget.profileModel.schoolProfile != null
            ? widget.profileModel.schoolProfile!.status == 'pending'
                ? myColor.primaryColorDark
                : widget.profileModel.schoolProfile!.status == 'verified'
                    ? kGreen
                    : kRed
            : kRed,
      ),
      const SizedBox12(),
      Text(
        widget.profileModel.schoolProfile == null
            ? 'Not defined'
            : widget.profileModel.schoolProfile!.status.toString(),
        style: kStyleNormal.copyWith(
          color: kBlack,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    ]);
  }

  Widget companyProfileCard() {
    return Column(
      children: [
        myRow(
            'Username:',
            widget.profileModel.schoolProfile != null
                ? widget.profileModel.schoolProfile!.userName ?? ''
                : ''),
        myRow(
            'Company name:',
            widget.profileModel.schoolProfile != null
                ? widget.profileModel.schoolProfile!.companyName ?? ''
                : ''),
        myRow(
          'Company Address:',
          widget.profileModel.schoolProfile != null
              ? widget.profileModel.schoolProfile!.companyAddress ?? ''
              : '',
        ),
        myRow(
            'Started Date:',
            widget.profileModel.schoolProfile != null
                ? widget.profileModel.schoolProfile!.companyStartDate ?? ''
                : ''),
        myRow(
            'Pan number:',
            widget.profileModel.schoolProfile != null
                ? widget.profileModel.schoolProfile!.panNumber ?? ''
                : ''),
        myRow(
            'Contact:',
            widget.profileModel.schoolProfile != null
                ? widget.profileModel.schoolProfile!.contactNumber ?? ''
                : ''),
      ],
    );
  }

  Widget myContainer(Widget myWidget, myWidget2) {
    return StreamBuilder<dynamic>(
        initialData: 'user',
        stream: widget.companyOrNormalProfileBloc.stateStream,
        builder: (ct, st) {
          return Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: st.data == 'user' ? myWidget : myWidget2,
              ),
              Positioned(
                  top: 1,
                  left: 1,
                  right: 1,
                  bottom: 1,
                  child: st.data == 'loading'
                      ? const LoadingShimmer()
                      : Container()),
            ],
          );
        });
  }

  Widget familyCard() {
    return StreamBuilder<dynamic>(
        initialData: widget.profileModel,
        stream: refreshMainSreenBloc.stateStream,
        builder: (context, profileSnapshot) {
          return Column(
            children: [
              profileSnapshot.data.memberType == 'Primary Member'
                  ? Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                        myColor.dialogBackgroundColor,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: ((builder) =>
                                        primaryMemberDetailsBottomSheet()));
                              },
                              child: Icon(
                                Icons.error_outline_outlined,
                                color: myColor.primaryColorDark,
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                profileSnapshot.data.familyname.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox8(),
                        myRow('Member Type:',
                            profileSnapshot.data.memberType ?? ''),
                        GestureDetector(
                          onTap: () {
                            goThere(context, const FamilyPage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                profileSnapshot.data.familyname == null
                                    ? 'Add Family'
                                    : 'View Family',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              // showCase3 == "show"
                              //     ? myShowCase(
                              //         keyOne,
                              //         'Add your family members',
                              //         'Tap here to add your family members',
                              //         () {},
                              //         CircleAvatar(
                              //           backgroundColor: myColor.primaryColorDark,
                              //           child: Icon(
                              //             Icons.keyboard_arrow_right_outlined,
                              //             color: kWhite,
                              //           ),
                              //         ),
                              //       )
                              //     :
                              CircleAvatar(
                                backgroundColor: myColor.primaryColorDark,
                                child: Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: kWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        myRow('Member Type:',
                            profileSnapshot.data.memberType ?? ''),
                        myRow('Family Name:',
                            profileSnapshot.data.familyname ?? ''),
                        GestureDetector(
                          onTap: () {
                            goThere(context, const FamilyPage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                profileSnapshot.data.familyname == null
                                    ? 'Add Family'
                                    : 'View Family',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: myColor.primaryColorDark,
                                child: Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: kWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          );
        });
  }

  Widget lockedBottomModalSheet() {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12.0,
          right: 12.0),
      child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.home_repair_service_rounded,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'You haven\'t bought any ',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '( Packages )',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' yet.',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox16(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: bloodPressureDescData.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: kWhite.withOpacity(0.4),
                            child: Text(
                              (i + 1).toString(),
                              style: kStyleNormal.copyWith(fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              bloodPressureDescData[i].desc.toString(),
                              style: kStyleNormal.copyWith(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox16(),
              GestureDetector(
                onTap: () {
                  goThere(
                      context,
                      const MainHomePage(
                        index: 2,
                        tabIndex: 0,
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('View Package',
                        style: kStyleNormal.copyWith(
                          color: myColor.primaryColorDark,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(width: 12.0),
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: myColor.primaryColorDark,
                        child: Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 18.0,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox16(),
            ],
          )),
    );
  }

  Widget physicalActivityPermissionBottomSheet(title, list, btnText) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12.0,
          right: 12.0),
      child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(title,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox16(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: bloodPressureDescData.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: kWhite.withOpacity(0.4),
                            child: Text(
                              (i + 1).toString(),
                              style: kStyleNormal.copyWith(fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              list[i].toString(),
                              style: kStyleNormal.copyWith(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox8(),
              GestureDetector(
                onTap: () {
                  if (btnText == 'Back') {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    AppSettings.openAppSettings();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(btnText,
                        style: kStyleNormal.copyWith(
                          color: myColor.primaryColorDark,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(width: 12.0),
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: myColor.primaryColorDark,
                        child: Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 18.0,
                          color: kWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox16(),
            ],
          )),
    );
  }

  Widget primaryMemberDetailsBottomSheet() {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12.0,
          right: 12.0),
      child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.groups,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'You are the head ',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '( ${widget.profileModel.memberType} )',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' of the family ',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '( ${widget.profileModel.familyname} )',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '.',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox16(),
              Text(
                'Head Member has following responsibilities:',
                style: kStyleNormal.copyWith(
                  fontSize: 14,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox16(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: familyDescData.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: kWhite.withOpacity(0.4),
                            child: Text(
                              (i + 1).toString(),
                              style: kStyleNormal.copyWith(fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              familyDescData[i].desc.toString(),
                              style: kStyleNormal.copyWith(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox8(),
            ],
          )),
    );
  }

  Widget profileCard(ProfileModel profileModel) {
    String formatAge(double years) {
      int fullYears = years.floor();
      int months = ((years - fullYears) * 12).floor();
      if (months == 0) {
        return '$fullYears yrs';
      } else {
        return '$fullYears yrs, $months mon';
      }
    }

    String formatHeight(meters) {
      double totalInches = double.parse(meters.toString()) / 0.0254;
      int feet = (totalInches / 12).floor();
      double inches = totalInches % 12;

      if (inches == 12) {
        inches = 0;
        feet++;
      }
      return inches.round() == 0
          ? '$feet ft.'
          : '$feet ft. ${inches.round()} in.';
    }

    return Column(
      children: [
        myRow('Phone:', profileModel.member!.phone ?? ''),
        myRow('Sex:', profileModel.gender ?? ''),
        myRow(
          'Age:',
          profileModel.dob == null
              ? ''
              : formatAge(double.parse((int.parse(DateTime.parse(
                              DateTime.now().toString().substring(0, 10))
                          .difference(
                              DateTime.parse(profileModel.dob.toString()))
                          .inDays
                          .toString()) /
                      365.25)
                  .toString())),
        ),
        myRow('Weight:', profileModel.weight ?? ''),
        myRow(
            'Height:',
            profileModel.height == null
                ? ''
                : formatHeight(profileModel.height)),
        myRow('DOB:', profileModel.dob ?? ''),
        myRow('Blood Group:', profileModel.bloodGroup ?? ''),
      ],
    );
  }

  Widget myRow(title, value) {
    return GestureDetector(
      onTap: () {
        if (value == '' && title != 'Family Type:') {
          goThere(
              context,
              EditProfile(
                profileModel: widget.profileModel,
              ));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  // fontWeight: FontWeight.bold,
                  color: value == '' ? kRed : kBlack,
                ),
              ),
              const SizedBox(width: 2),
              value == ''
                  ? Icon(Icons.error_outline_outlined, size: 11.0, color: kRed)
                  : Expanded(
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox8(),
        ],
      ),
    );
  }

  Widget waterCard() {
    waterDrankToday = sharedPrefs.getFromDevice("waterDrankToday") ?? '0';
    dailyWaterToDrinkPercent =
        sharedPrefs.getFromDevice("dailyWaterToDrinkPercent");
    showWaterNotification = sharedPrefs.getFromDevice("showWaterNotification");
    waterNotification = sharedPrefs.getFromDevice("waterNotification");
    return StreamBuilder<dynamic>(
        initialData: widget.profileModel,
        stream: refreshMainSreenBloc.stateStream,
        builder: (context, profileSnapshot) {
          return GestureDetector(
            onTap: () async {
              if (profileSnapshot.data.gender == null ||
                  profileSnapshot.data.weight == null) {
                GetIDNameModel getIDNameModel = await goThere(
                    context,
                    EditProfile(
                      profileModel: profileSnapshot.data,
                      showMessage: 'isDrinkingWater',
                    ));
                if (getIDNameModel.id == '1') {
                  goThere(context, const DrinkWater());
                  mySnackbar.mySnackBar(context, 'Profile Updated', kGreen);
                }
              } else {
                goThere(context, const DrinkWater());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Column(
                children: [
                  showWaterNotification == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'View',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: myColor.primaryColorDark,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: myColor.primaryColorDark,
                              size: 16.0,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'View',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: myColor.primaryColorDark,
                              ),
                            ),
                            StreamBuilder<dynamic>(
                                initialData:
                                    waterNotification == "waterStatusOn"
                                        ? true
                                        : false,
                                stream: waterNotificationBloc!.stateStream,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: Switch(
                                      value: snapshot.data,
                                      onChanged: (value) async {
                                        waterNotificationBloc!.storeData(value);
                                        int statusCode;
                                        statusCode = await API().postData(
                                            context,
                                            PostDrinkWaterTimingsModel(
                                              notificationStatus:
                                                  value == false ? 0 : 1,
                                            ),
                                            endpoints
                                                .postWaterNotifcationEndpoint);
                                        if (statusCode == 200) {
                                          if (value == false) {
                                            sharedPrefs.storeToDevice(
                                                "waterNotification",
                                                "waterStatusOn");

                                            mySnackbar.mySnackBar(
                                                context,
                                                'Water reminder notification off',
                                                kRed);
                                          } else {
                                            sharedPrefs.storeToDevice(
                                                "waterNotification",
                                                "waterStatusOff");
                                            mySnackbar.mySnackBar(
                                                context,
                                                'Water reminder notification on',
                                                kGreen);
                                          }
                                        } else {
                                          waterNotificationBloc!.storeData(
                                              value == false ? 1 : 0);
                                        }
                                      },
                                      activeTrackColor: myColor.primaryColorDark
                                          .withOpacity(0.3),
                                      activeColor: myColor.primaryColorDark,
                                      inactiveTrackColor:
                                          kWhite.withOpacity(0.4),
                                      inactiveThumbColor:
                                          kWhite.withOpacity(0.4),
                                    ),
                                  );
                                }),
                          ],
                        ),
                  const SizedBox12(),
                  CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    animation: true,
                    animationDuration: 2000,
                    percent: profileSnapshot.data.gender == null ||
                            profileSnapshot.data.weight == null
                        ? 0
                        : dailyWaterToDrinkPercent == null
                            ? 0
                            : double.parse(dailyWaterToDrinkPercent.toString()),
                    animateFromLastPercent: true,
                    backgroundColor: myColor.dialogBackgroundColor,
                    center: profileSnapshot.data.gender == null ||
                            profileSnapshot.data.weight == null
                        ? Icon(
                            Icons.error_outline_outlined,
                            color: kRed,
                            size: 22.0,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox2(),
                              FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    double.parse(waterDrankToday.toString()) %
                                                1 ==
                                            0
                                        ? double.parse(
                                                waterDrankToday.toString())
                                            .toStringAsFixed(0)
                                            .toString()
                                        : waterDrankToday!,
                                    style: kStyleNormal.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                              const SizedBox2(),
                              Text(
                                'ml',
                                style: kStyleNormal.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                            ],
                          ),
                    footer: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Drink Water",
                        style: kStyleNormal.copyWith(
                            color: profileSnapshot.data.gender == null ||
                                    profileSnapshot.data.weight == null
                                ? kRed
                                : kBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.square,
                    progressColor: myColor.primaryColorDark,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget stepsCountCard(context) {
    return GestureDetector(
      onTap: () async {
        String status = await checkPermissionStatus();
        if (status == 'isRestricted') {
          showModalBottomSheet(
              context: context,
              backgroundColor: myColor.dialogBackgroundColor,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: ((builder) => physicalActivityPermissionBottomSheet(
                    "Activity Permission Restricted",
                    activityPermissionRestrictedList,
                    'Back',
                  )));
        }
        if (status == 'isGranted') {
          goThere(context, const PedometerScreen());
        } else if (status == 'isDenied') {
          showModalBottomSheet(
              context: context,
              backgroundColor: myColor.dialogBackgroundColor,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: ((builder) => physicalActivityPermissionBottomSheet(
                    "Allow Activity Permission",
                    activityPermissionDeniedList,
                    'Go to settings',
                  )));
        } else if (status == 'isPermanentlyDenied') {
          showModalBottomSheet(
              context: context,
              backgroundColor: myColor.dialogBackgroundColor,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: ((builder) => physicalActivityPermissionBottomSheet(
                    "Allow Activity Permission",
                    activityPermissionDeniedList,
                    'Go to settings',
                  )));
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'View',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: myColor.primaryColorDark,
                ),
              ),
              const SizedBox(width: 4.0),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: myColor.primaryColorDark,
                size: 16.0,
              ),
            ],
          ),
          const SizedBox12(),
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 5.0,
            animation: true,
            animationDuration: 2000,
            percent: 0.5,
            animateFromLastPercent: true,
            backgroundColor: myColor.dialogBackgroundColor,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '53',
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Text(
                  'steps',
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 8.0),
                ),
              ],
            ),
            footer: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Steps Count",
                style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
            ),
            circularStrokeCap: CircularStrokeCap.square,
            progressColor: myColor.primaryColorDark,
          ),
        ],
      ),
    );
  }

  Widget lockedCard(myTap) {
    return Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: () {
            myTap();
          },
          child: SizedBox(
            height: 290.0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.lock,
                          color: kWhite,
                          size: 16.0,
                        ),
                        Row(children: [
                          Text(
                            'Locked',
                            style: kStyleNormal.copyWith(
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Icon(
                            Icons.error_outline_outlined,
                            color: kWhite,
                            size: 16.0,
                          ),
                        ]),
                      ]),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: kBlack.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  checkPermissionStatus() async {
    PermissionStatus status = await Permission.activityRecognition.status;
    if (status.isGranted) {
      return 'isGranted';
    } else if (status.isDenied) {
      return 'isDenied';
    } else if (status.isPermanentlyDenied) {
      return 'isPermanentlyDenied';
    } else if (status.isRestricted) {
      return 'isRestricted';
    }
  }
}
