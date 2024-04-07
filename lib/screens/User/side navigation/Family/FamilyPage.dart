import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfFamilyModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/profile/editProfile.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyLeaveRequestList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyRequestList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/ListOfFamilyList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/SecondaryMemberBecomePrimaryPage/SecondaryMemberBecomePrimaryPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/SecondaryMemberBecomePrimaryPage/ViewPrimarySwitchListPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/familyCard.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PaymentScreenForApproveRequest.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pusher_client/pusher_client.dart';

StateHandlerBloc refreshReqList = StateHandlerBloc();
StateHandlerBloc refreshFamilyStateQr = StateHandlerBloc();
StateHandlerBloc isAddFamilyProfileUpdateBloc = StateHandlerBloc();

class FamilyPage extends StatefulWidget {
  final int? tabIndex;
  const FamilyPage({super.key, this.tabIndex});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> with TickerProviderStateMixin {
  TabController? _tabController;
  bool isKeyboard = false;
  StateHandlerBloc? bottomNavBloc,
      refreshListBloc,
      cancelBtnBloc,
      showHideQRBloc,
      showTabBarViewBloc,
      messageBloc;
  ApiHandlerBloc? profileBloc, familyListBloc;
  ProfileModel? profileModel;
  StateHandlerBloc? submitBloc = StateHandlerBloc();
  List<ListOfFamilyModel> listOfFamilyModel = [];
  String? phone;
  String? dateOfBirth, memberType, gender;
  bool isBottomSheetOpen = false;
  List<int> listOfID = [];
  @override
  void initState() {
    super.initState();
    profileBloc = ApiHandlerBloc();
    refreshListBloc = StateHandlerBloc();
    bottomNavBloc = StateHandlerBloc();
    cancelBtnBloc = StateHandlerBloc();
    showTabBarViewBloc = StateHandlerBloc();
    showHideQRBloc = StateHandlerBloc();
    messageBloc = StateHandlerBloc();
    _tabController = TabController(
      initialIndex: widget.tabIndex ?? 0,
      length: 3,
      vsync: this,
    );
  }

  profileUpdateFormValidation() {
    dateOfBirth = profileModel!.dob;
    memberType = profileModel!.memberType;
    gender = profileModel!.gender;
    List<String> testList = [];
    testList.clear();
    if (dateOfBirth == null) {
      testList.add('dobNull');
      return testList;
    } else if (gender == null) {
      testList.add('genderNull');
      return testList;
    } else if (memberType == null) {
      testList.add('memberTypeNull');
      return testList;
    } else {
      return testList;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      if (isKeyboard == false) {
        showHideQRBloc!.storeData(true);
      }
      isKeyboard = true;
    } else {
      isKeyboard = false;
      showHideQRBloc!.storeData(false);
    }
    return StreamBuilder<dynamic>(
        initialData: false,
        stream: refreshFamilyStateQr.stateStream,
        builder: (myCtx, mainSnapshot) {
          if (mainSnapshot.data == true) {
            if (isBottomSheetOpen == true) {
              print('work goblog isOPen');
            } else {
              print('work goblog isclosed');
            }
            // // Navigator.of(context).removeRoute(ModalRoute.of(context) as Route);
            // if (ModalRoute.of(context)?.isCurrent == true) {
            //   // Navigator.pop(context);
            //   print('work goblog isOPen');
            // } else {
            //   print('work goblog isclosed');
            // }
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: myColor.colorScheme.background,
            appBar: myCustomAppBar(
              title: 'Family Details',
              color: myColor.colorScheme.background,
              borderRadius: 0.0,
            ),
            floatingActionButton: StreamBuilder<dynamic>(
                initialData: false,
                stream: showHideQRBloc!.stateStream,
                builder: (context, showHideQRBlocSnap) {
                  return showHideQRBlocSnap.data == true
                      ? Container()
                      : FloatingActionButton.extended(
                          backgroundColor: myColor.primaryColorDark,
                          onPressed: () {
                            if (profileModel != null) {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: backgroundColor,
                                isScrollControlled: true,
                                routeSettings: ModalRoute.of(context)!.settings,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                builder: ((builder) =>
                                    qrBottomModalSheet(context, profileModel!)),
                              ).whenComplete(() {
                                setState(() {
                                  isBottomSheetOpen = false;
                                });
                              });
                            }
                          },
                          icon: Icon(
                            Icons.qr_code,
                            color: kWhite,
                            size: 25.0,
                          ),
                          label: Text(
                            'Add via QR',
                            style: kStyleNormal.copyWith(
                              color: kWhite,
                              fontSize: 12,
                            ),
                          ),
                        );
                }),
            body: Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: maxWidth(context),
              height: maxHeight(context),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: myColor.dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              child: StreamBuilder<dynamic>(
                  stream: refreshReqList.stateStream,
                  builder: ((context, snapshot) {
                    profileBloc!.fetchAPIList(endpoints.getUserProfileEndpoint);
                    return StreamBuilder<ApiResponse<dynamic>>(
                        stream: profileBloc!.apiListStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return SizedBox(
                                  width: maxWidth(context),
                                  height: maxHeight(context) / 3,
                                  child: const Center(
                                    child: AnimatedLoading(),
                                  ),
                                );
                              case Status.COMPLETED:
                                profileModel =
                                    ProfileModel.fromJson(snapshot.data!.data);
                                return StreamBuilder<dynamic>(
                                    stream: refreshListBloc!.stateStream,
                                    builder: (context, snapshot) {
                                      return profileModel!.memberType ==
                                              'Dependent Member'
                                          ? dependentFamilyMemberPage()
                                          : primaryFamilyMemberPage();
                                    });

                              case Status.ERROR:
                                return Container(
                                  width: maxWidth(context),
                                  margin: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('Server Error'),
                                  ),
                                );
                            }
                          }
                          return Container();
                        });
                  })),
            ),
            bottomNavigationBar: StreamBuilder<dynamic>(
                initialData: 'empty',
                stream: bottomNavBloc!.stateStream,
                builder: (context, snapshot) {
                  if (snapshot.data == 'empty') {
                    return Container(
                      color: myColor.dialogBackgroundColor,
                      width: maxWidth(context),
                      height: 0.0,
                    );
                  } else if (snapshot.data == 'admin verfication pending') {
                    return Container(
                      color: myColor.dialogBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: maxWidth(context),
                      height: 80.0,
                      child: infoCard(
                        context,
                        kWhite.withOpacity(0.2),
                        myColor.primaryColorDark,
                        'Your leave request is accepted by primary member of the family.Please wait for admin verification.',
                      ),
                    );
                  } else if (snapshot.data == 'pending') {
                    return Container(
                      color: myColor.dialogBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: maxWidth(context),
                      height: 70.0,
                      child: infoCard(
                        context,
                        kWhite.withOpacity(0.2),
                        myColor.primaryColorDark,
                        'Please wait until your leave request gets accepted.',
                      ),
                    );
                  } else if (snapshot.data == 'add family') {
                    return StreamBuilder<dynamic>(
                        initialData: profileModel!.gender != null &&
                                profileModel!.dob != null
                            ? true
                            : false,
                        stream: isAddFamilyProfileUpdateBloc.stateStream,
                        builder: (context, snapshot) {
                          return Container(
                            color: myColor.dialogBackgroundColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            width: maxWidth(context),
                            height: 70.0,
                            child: SizedBox(
                              height: 50.0,
                              child: StreamBuilder<dynamic>(
                                  initialData: listOfID,
                                  stream: listOfIDBloc.stateStream,
                                  builder: (c, s) {
                                    return myCustomButton(
                                      context,
                                      myColor.primaryColorDark,
                                      s.data.isEmpty ? 'Add Family' : 'Pay',
                                      kStyleNormal.copyWith(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold),
                                      () async {
                                        if (s.data.isEmpty) {
                                          if (snapshot.data == true) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    insetPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 16.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                    backgroundColor: myColor
                                                        .dialogBackgroundColor,
                                                    content: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: <Widget>[
                                                        Positioned(
                                                          right: -40.0,
                                                          top: -40.0,
                                                          child: InkResponse(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  myColor
                                                                      .primaryColorDark,
                                                              child: Icon(
                                                                  Icons.close,
                                                                  color:
                                                                      kWhite),
                                                            ),
                                                          ),
                                                        ),
                                                        Form(
                                                          // key: _formKey,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              const SizedBox16(),
                                                              Text(
                                                                'Phone Number',
                                                                style:
                                                                    kStyleNormal
                                                                        .copyWith(
                                                                  fontSize:
                                                                      13.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            12.0),
                                                                child:
                                                                    myCountryCodePicker(
                                                                  hintText: phone ??
                                                                      'Enter phone number',
                                                                  bgColor: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.4),
                                                                  isEditable:
                                                                      true,
                                                                  onValueChanged:
                                                                      (value) {
                                                                    phone =
                                                                        value;
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox12(),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        12.0),
                                                                width: maxWidth(
                                                                    context),
                                                                child: StreamBuilder<
                                                                        dynamic>(
                                                                    initialData:
                                                                        false,
                                                                    stream: submitBloc!
                                                                        .stateStream,
                                                                    builder:
                                                                        (context,
                                                                            snapshot) {
                                                                      if (snapshot
                                                                              .data ==
                                                                          true) {
                                                                        return myBtnLoading(
                                                                            context,
                                                                            50.0);
                                                                      } else {
                                                                        return SizedBox(
                                                                          width:
                                                                              maxWidth(context),
                                                                          height:
                                                                              50.0,
                                                                          child:
                                                                              myCustomButton(
                                                                            context,
                                                                            myColor.primaryColorDark,
                                                                            'Request',
                                                                            kStyleNormal.copyWith(
                                                                                fontSize: 16.0,
                                                                                color: kWhite),
                                                                            () {
                                                                              addFamilyBtn();
                                                                            },
                                                                          ),
                                                                        );
                                                                      }
                                                                    }),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                            // showModalBottomSheet(
                                            //   context: context,
                                            //   backgroundColor: backgroundColor,
                                            //   isScrollControlled: true,
                                            //   shape: const RoundedRectangleBorder(
                                            //       borderRadius: BorderRadius.vertical(
                                            //           top: Radius.circular(20))),
                                            //   builder: ((builder) =>
                                            //       addFamilyBottomSheet(context)),
                                            // );
                                          } else {
                                            // List<String> tempList =
                                            //     profileUpdateFormValidation();
                                            // showUpdateProfilePopUp(
                                            //     context, tempList, 'isAddFamily');
                                            GetIDNameModel getIDNameModel =
                                                await goThere(
                                                    context,
                                                    EditProfile(
                                                      profileModel:
                                                          profileModel!,
                                                      showMessage:
                                                          'isAddingFamily',
                                                    ));
                                            if (getIDNameModel.id == '1') {
                                              isAddFamilyProfileUpdateBloc
                                                  .storeData(true);

                                              mySnackbar.mySnackBar(context,
                                                  'Profile Updated', kGreen);
                                            }
                                          }
                                        } else {
                                          goThere(
                                              context,
                                              PaymentScreenForApproveRequest(
                                                  familyId: s.data));
                                        }
                                      },
                                    );
                                  }),
                            ),
                          );
                        });
                  } else if (snapshot.data == 'Cancel Request') {
                    return StreamBuilder<dynamic>(
                        initialData: false,
                        stream: cancelBtnBloc!.stateStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Container(
                              color: myColor.dialogBackgroundColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              width: maxWidth(context),
                              height: 70.0,
                              child: myLoadingBtn(
                                context,
                                50.0,
                                kRed.withOpacity(0.4),
                                kRed,
                                8.0,
                              ),
                            );
                          } else {
                            return Container(
                              color: myColor.dialogBackgroundColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              width: maxWidth(context),
                              height: 70.0,
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: myCustomButton(
                                  context,
                                  kRed.withOpacity(0.2),
                                  'Cancel Request',
                                  kStyleNormal.copyWith(
                                      fontSize: 16.0,
                                      color: kRed,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold),
                                  () async {
                                    cancelBtnBloc!.storeData(true);
                                    int statusCode;
                                    statusCode = await API().deleteData(
                                      'admin/addfamily/cancel/${listOfFamilyModel[0].id}',
                                    );
                                    if (statusCode == 200) {
                                      cancelBtnBloc!.storeData(false);
                                      refreshReqList.storeData('none');
                                    } else {
                                      cancelBtnBloc!.storeData(false);
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                        });
                  } else {
                    return Container(
                      color: myColor.dialogBackgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: maxWidth(context),
                      height: 70.0,
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: myCustomButton(
                          context,
                          kRed.withOpacity(0.2),
                          'Leave Family',
                          kStyleNormal.copyWith(
                              fontSize: 16.0,
                              color: kRed,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold),
                          () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: backgroundColor,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: ((builder) =>
                                  rejectLeaveRequestBottomSheet(context)),
                            );
                          },
                        ),
                      ),
                    );
                  }
                }),
          );
        });
  }

  Widget rejectLeaveRequestBottomSheet(context) {
    StateHandlerBloc? leaveBtnBloc;
    String? leaveReason;
    leaveBtnBloc = StateHandlerBloc();
    leaveBtn() async {
      leaveBtnBloc!.storeData(true);
      bottomNavBloc!.storeData('empty');
      int statusCode;
      statusCode = await API().postData(
          context,
          LeaveFamilyRequestModel(leaveReason: leaveReason),
          endpoints.leaveFamilyRequestByDependentEndpoint);

      if (statusCode == 200) {
        refreshListBloc!.storeData('data');
        Navigator.pop(context);
        leaveBtnBloc.storeData(false);
        pop_upHelper.popUpNavigatorPop(
            context, 1, CoolAlertType.success, 'Leave Request Successful');
      } else {
        leaveBtnBloc.storeData(false);
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox16(),
                      myTextArea(context, kWhite.withOpacity(0.4),
                          'Write Leave Reason', onValueChanged: (v) {
                        setState(() {
                          leaveReason = v;
                        });
                      }),
                      const SizedBox16(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              width: maxWidth(context),
              child: StreamBuilder<dynamic>(
                  initialData: false,
                  stream: leaveBtnBloc!.stateStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return myLoadingBtn(
                        context,
                        50.0,
                        kRed.withOpacity(0.4),
                        kRed,
                        8.0,
                      );
                    } else {
                      return SizedBox(
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          kRed.withOpacity(0.2),
                          'Leave Family',
                          kStyleNormal.copyWith(
                            fontSize: 16.0,
                            color: kRed,
                            fontWeight: FontWeight.bold,
                          ),
                          () {
                            leaveBtn();
                          },
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      );
    });
  }

  Widget dependentFamilyMemberPage() {
    familyListBloc = ApiHandlerBloc();
    familyListBloc!.fetchAPIList(endpoints.familyListEndpoint);
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: familyListBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return SizedBox(
                width: maxWidth(context),
                height: maxHeight(context) / 3,
                child: const Center(
                  child: AnimatedLoading(),
                ),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: 140,
                    margin: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('No family members')));
              }
              listOfFamilyModel = List<ListOfFamilyModel>.from(snapshot
                  .data!.data
                  .map((i) => ListOfFamilyModel.fromJson(i)));

              if (listOfFamilyModel.isNotEmpty) {
                if (listOfFamilyModel[0].approved == 0) {
                  messageBloc!.storeData('Cancel Request');
                  bottomNavBloc!.storeData('Cancel Request');
                } else {
                  if (listOfFamilyModel[0].leave!.isEmpty) {
                    bottomNavBloc!.storeData('leave family');
                  } else {
                    bottomNavBloc!.storeData('leave family');
                    if (listOfFamilyModel[0].leave!.isNotEmpty) {
                      int status = listOfFamilyModel[0].leave![0].status!;
                      if (status == 0) {
                        bottomNavBloc!.storeData('pending');
                      } else if (status == 1) {
                        bottomNavBloc!.storeData('admin verfication pending');
                      } else if (status == 2) {
                        bottomNavBloc!.storeData('leave family');
                        messageBloc!.storeData('rejected by primary');
                      } else if (status == 3) {
                        bottomNavBloc!.storeData('add family');
                      } else if (status == 4) {
                        bottomNavBloc!.storeData('leave family');
                        messageBloc!.storeData('rejected by admin');
                      }
                    }
                  }
                }
              }
              return Column(
                children: [
                  StreamBuilder<dynamic>(
                      initialData: 'empty',
                      stream: messageBloc!.stateStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == 'rejected by primary') {
                          return infoCard(
                            context,
                            kWhite.withOpacity(0.2),
                            myColor.primaryColorDark,
                            'Your family leave request has been rejected by primary member of the family.',
                          );
                        } else if (snapshot.data == 'Cancel Request') {
                          return infoCard(
                            context,
                            kWhite.withOpacity(0.2),
                            myColor.primaryColorDark,
                            'Your Request is pending.',
                          );
                        } else if (snapshot.data == 'rejected by admin') {
                          return infoCard(
                            context,
                            kRed.withOpacity(0.2),
                            kRed,
                            'Your family leave request has been rejected by admin. Re-leave again',
                          );
                        } else {
                          return Container();
                        }
                      }),
                  const SizedBox8(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            goThere(context,
                                const SecondaryMemberBecomePrimaryPage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Become\nPrimary Member',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: myColor.primaryColorDark,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            goThere(context, const ViewPrimarySwitchListPage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'View Primary\nSwitch List',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: myColor.primaryColorDark,
                                size: 14.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox12(),
                  listOfFamilyModel.isNotEmpty
                      ? ListView.builder(
                          itemCount: listOfFamilyModel.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx, i) {
                            return familyCard(
                              context,
                              profileModel!.memberType,
                              listOfFamilyModel[i],
                              'dependentFamily',
                            );
                          })
                      : Container(),
                  listOfFamilyModel.isNotEmpty &&
                          listOfFamilyModel[0].leave!.isNotEmpty &&
                          listOfFamilyModel[0].leave![0].rejectReason != null
                      ? Container(
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.4),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.error_outline_outlined,
                                      size: 17.0, color: kRed),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      listOfFamilyModel[0].leave![0].status == 4
                                          ? 'Your family leave request is rejected by admin.'
                                          : 'Your family leave request is rejected by primary family  member.',
                                      overflow: TextOverflow.clip,
                                      style: kStyleNormal.copyWith(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox16(),
                              Text(
                                'Reject Reason',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox12(),
                              Text(
                                listOfFamilyModel[0]
                                    .leave![0]
                                    .rejectReason
                                    .toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ))
                      : Container(),
                ],
              );

            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Server Error'),
                ),
              );
          }
        }
        return Container();
      }),
    );
  }

  Widget primaryFamilyMemberPage() {
    return Column(
      children: [
        Container(
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TabBar(
              labelColor: kWhite,
              unselectedLabelColor: kBlack,
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: myColor.primaryColorDark,
              ),
              tabs: [
                Tab(
                  child: GestureDetector(
                    onTap: () {
                      print('goblog isBottomSheetOpen $isBottomSheetOpen');
                    },
                    child: Text(
                      'My Family',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Family Request',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 14,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Leave Request',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox12(),
        buildTabbarView(profileModel!.memberType),
      ],
    );
  }

  addFamilyBtn() async {
    submitBloc!.storeData(true);
    int statusCode;

    statusCode = await API().postData(
        context, SendRequestModel(phone: phone), endpoints.sendFriendRequest);

    if (statusCode == 200) {
      Navigator.pop(context);
      submitBloc!.storeData(false);
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.success, 'Request successfully sent');
    } else {
      submitBloc!.storeData(false);
    }
  }

  Widget addFamilyBottomSheet(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Wrap(
        children: [
          const SizedBox16(),
          Text(
            'Phone Number',
            style: kStyleNormal.copyWith(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: myCountryCodePicker(
              hintText: phone ?? 'Enter phone number',
              bgColor: Colors.white.withOpacity(0.4),
              isEditable: true,
              onValueChanged: (value) {
                phone = value;
              },
            ),
          ),
          const SizedBox16(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            width: maxWidth(context),
            child: StreamBuilder<dynamic>(
                initialData: false,
                stream: submitBloc!.stateStream,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return myBtnLoading(context, 50.0);
                  } else {
                    return SizedBox(
                      height: 50.0,
                      child: myCustomButton(
                        context,
                        myColor.primaryColorDark,
                        'Request',
                        kStyleNormal.copyWith(fontSize: 16.0, color: kWhite),
                        () {
                          addFamilyBtn();
                        },
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildTabbarView(memberType) {
    bottomNavBloc!.storeData('add family');
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          const ListOfFamily(),
          FamilyAllRequestList(memberType: memberType),
          const FamilyLeaveRequestList(),
        ],
      ),
    );
  }

  connectSocketIO(ctx, ProfileModel data) async {
    PusherClient? pusher;
    Channel? channel;
    pusher = PusherClient(
      'cd3ed25c9be7e1f981d8',
      PusherOptions(
        cluster: 'ap2',
      ),
    );
    await pusher.connect();
    channel = pusher.subscribe('my-family-channel${data.id}');
    channel.bind('my-family-event${data.id}', (event) {
      // print('${event.data}');
    });
  }

  Widget qrBottomModalSheet(context, ProfileModel data) {
    connectSocketIO(context, data);
    return StatefulBuilder(builder: (context, setState) {
      setState(() {
        isBottomSheetOpen = true;
      });
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              GestureDetector(
                onTap: () {
                  print('goblog isBottomSheetOpen $isBottomSheetOpen');
                },
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: backgroundColor,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              Text(
                'My QR',
                style: kStyleNormal.copyWith(
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox16(),
              myQr(data.member!.phone.toString(), 'family'),
              const SizedBox24(),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'By scanning the ',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'QR ',
                        style: kStyleNormal.copyWith(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'you\'re sharing\n ',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                      TextSpan(
                        text: 'your phone number',
                        style: kStyleNormal.copyWith(
                            fontSize: 12.0, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '.',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
