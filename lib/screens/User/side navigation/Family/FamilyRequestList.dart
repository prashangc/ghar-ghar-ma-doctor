import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfFamilyModel.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfFamilyRequestModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/familyCard.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PaymentScreenForApproveRequest.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc radioBtnBloc = StateHandlerBloc();

class FamilyAllRequestList extends StatefulWidget {
  final String? memberType;
  const FamilyAllRequestList({super.key, required this.memberType});

  @override
  State<FamilyAllRequestList> createState() => _FamilyAllRequestListState();
}

class _FamilyAllRequestListState extends State<FamilyAllRequestList> {
  ApiHandlerBloc? familyListBloc,
      familyRequestListBloc,
      familyNoneTypeRequestListBloc;
  StateHandlerBloc? refreshListBloc;
  int filterValue = 0;
  bool showNoneReqList = false;
  List<ListOfFamilyModel> listOfFamilyModel = [];
  @override
  void initState() {
    super.initState();
    familyListBloc = ApiHandlerBloc();
    refreshListBloc = StateHandlerBloc();
    familyRequestListBloc = ApiHandlerBloc();
    familyNoneTypeRequestListBloc = ApiHandlerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.memberType != 'Dependent Member'
            ? SizedBox(
                width: maxWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    myRadioBtn(0, 'Received', onChange: (v) {
                      filterValue = v;
                      setState(() {});
                      refreshListBloc!.storeData('data');
                    }),
                    myRadioBtn(1, 'Sent', onChange: (v) {
                      print(v);
                      filterValue = v;
                      refreshListBloc!.storeData('data');
                      setState(() {});
                    }),
                    widget.memberType == 'Primary Member'
                        ? myRadioBtn(3, 'Switch', onChange: (v) {
                            filterValue = v;
                            if (filterValue == 3) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      backgroundColor:
                                          myColor.dialogBackgroundColor,
                                      content: WillPopScope(
                                          onWillPop: () => Future.value(false),
                                          child: switchPrimaryMember(context)),
                                    );
                                  });

                              // showModalBottomSheet(
                              //   context: context,
                              //   backgroundColor: backgroundColor,
                              //   isScrollControlled: true,
                              //   isDismissible: false,
                              //   enableDrag: false,
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.vertical(
                              //           top: Radius.circular(20))),
                              //   builder: ((builder) => WillPopScope(
                              //       onWillPop: () => Future.value(false),
                              //       child: switchPrimaryMember(context))),
                              // );
                            }
                          })
                        : Container(),
                  ],
                ),
              )
            : Container(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder<dynamic>(
                stream: refreshListBloc!.stateStream,
                builder: ((context, snapshot) {
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
                            listOfFamilyModel = List<ListOfFamilyModel>.from(
                                snapshot.data!.data
                                    .map((i) => ListOfFamilyModel.fromJson(i)));
                            List<ListOfFamilyModel> listOfFamilyModelApproved =
                                [];
                            if (widget.memberType == 'Primary Member') {
                              if (filterValue == 0) {
                                listOfFamilyModelApproved = listOfFamilyModel
                                    .where((element) =>
                                        element.approved == 0 &&
                                        element.primaryRequest == 0)
                                    .toList();
                              } else {
                                listOfFamilyModelApproved = listOfFamilyModel
                                    .where((element) =>
                                        element.approved == 0 &&
                                        element.primaryRequest == 1)
                                    .toList();
                              }
                            } else if (widget.memberType ==
                                'Dependent Member') {
                            } else {
                              showNoneReqList = true;
                              if (filterValue == 0) {
                                listOfFamilyModelApproved = listOfFamilyModel
                                    .where((element) =>
                                        element.approved == 0 &&
                                        element.primaryRequest == 1)
                                    .toList();
                              } else {
                                listOfFamilyModelApproved = listOfFamilyModel
                                    .where((element) =>
                                        element.approved == 0 &&
                                        element.primaryRequest == 0)
                                    .toList();
                              }
                            }
                            if (snapshot.data!.data.isEmpty) {
                              return Column(
                                children: [
                                  showNoneReqList == true && filterValue == 1
                                      ? noneRequestStreamBuilderWidget()
                                      : Container(),
                                  filterValue == 0
                                      ? familyRequestListBuilderWidget()
                                      : Container(),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                showNoneReqList == true && filterValue == 1
                                    ? noneRequestStreamBuilderWidget()
                                    : Container(),
                                ListView.builder(
                                    itemCount: listOfFamilyModelApproved.length,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (ctx, i) {
                                      return familyCard(
                                          context,
                                          widget.memberType,
                                          listOfFamilyModelApproved[i],
                                          'requestList',
                                          test: filterValue == 1 ? 1 : 0,
                                          confirmEndpointType:
                                              'admin/addfamily/approved',
                                          cancelEndpointType:
                                              'admin/addfamily/reject/${listOfFamilyModelApproved[i].id}',
                                          cancelSentReqEndpoint:
                                              'admin/addfamily/cancel/${listOfFamilyModelApproved[i].id}');
                                    }),
                                filterValue == 0
                                    ? familyRequestListBuilderWidget()
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
                      return const SizedBox();
                    }),
                  );
                })),
          ),
        ),
      ],
    );
  }

  Widget switchPrimaryMember(context) {
    String? relation, switchReason, newPrimaryMemberName, newPrimaryMemberID;
    StateHandlerBloc switchBtnBloc = StateHandlerBloc();
    ApiHandlerBloc checkSwitchPrimaryStatus = ApiHandlerBloc();
    checkSwitchPrimaryStatus
        .fetchAPIList(endpoints.checkSwitchPrimaryMemberStatusEndpoint);
    List<GetIDNameModel> listOfMember = [];
    final form = GlobalKey<FormState>();

    listOfMember.clear();
    for (int i = 0; i < listOfFamilyModel.length; i++) {
      listOfMember.add(GetIDNameModel(
        id: listOfFamilyModel[i].memberId.toString(),
        name: listOfFamilyModel[i].member!.user!.name.toString(),
      ));
    }
    switchBtn() async {
      var isValid = form.currentState?.validate();
      if (isValid!) {
        switchBtnBloc.storeData(true);
        int statusCode;
        statusCode = await API().postData(
            context,
            PostSwitchPrimaryMemberModel(
              changeReason: switchReason,
              familyRelation: relation,
              newmemberId: int.parse(newPrimaryMemberID.toString()),
            ),
            endpoints.postPrimaryMemberSwitchEndpoint);
        if (statusCode == 200) {
          radioBtnBloc.storeData(0);
          refreshListBloc!.storeData('data');
          Navigator.pop(context);
          switchBtnBloc.storeData(false);
        } else {
          switchBtnBloc.storeData(false);
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 18.0),
                child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: checkSwitchPrimaryStatus.apiListStream,
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
                            return Form(
                              key: form,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select new Primary Member',
                                      style: kStyleNormal.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox8(),
                                    myDropDown2(
                                      context,
                                      Icons.perm_identity_outlined,
                                      kBlack,
                                      kBlack,
                                      maxWidth(context),
                                      newPrimaryMemberName ?? 'Select Member',
                                      listOfMember,
                                      kWhite,
                                      onValueChanged: (v) {
                                        setState(() {
                                          newPrimaryMemberID = v.id;
                                          newPrimaryMemberName = v.name;
                                        });
                                      },
                                    ),
                                    const SizedBox12(),
                                    mytextFormField(
                                        context,
                                        'Family Relation',
                                        'Relation with selected member',
                                        'Enter your relation',
                                        relation, onValueChanged: (v) {
                                      relation = v;
                                    }),
                                    const SizedBox8(),
                                    Text(
                                      'Switch Reason',
                                      style: kStyleNormal.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox8(),
                                    myTextArea(context, kWhite, 'Switch Reason',
                                        errorMessage: 'Enter switch reason',
                                        onValueChanged: (v) {
                                      switchReason = v;
                                    }),
                                    const SizedBox12(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              radioBtnBloc.storeData(0);
                                              refreshListBloc!
                                                  .storeData('data');
                                              Navigator.pop(context);
                                            },
                                            child: SizedBox(
                                              height: 50.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      color: myColor
                                                          .primaryColorDark,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                width:
                                                    maxWidth(context) / 2 - 20,
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    'Back',
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      color: myColor
                                                          .primaryColorDark,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 2,
                                          child: StreamBuilder<dynamic>(
                                              initialData: false,
                                              stream: switchBtnBloc.stateStream,
                                              builder: (context, snapshot) {
                                                if (snapshot.data == true) {
                                                  return myBtnLoading(
                                                      context, 50.0);
                                                } else {
                                                  return SizedBox(
                                                    width: maxWidth(context),
                                                    height: 50.0,
                                                    child: myCustomButton(
                                                      context,
                                                      myColor.primaryColorDark,
                                                      'Switch',
                                                      kStyleNormal.copyWith(
                                                        fontSize: 16.0,
                                                        color: kWhite,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      () {
                                                        switchBtn();
                                                      },
                                                    ),
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ]),
                            );
                          } else {
                            return Column(
                              children: [
                                infoCard(
                                  context,
                                  myColor.dialogBackgroundColor,
                                  myColor.primaryColorDark,
                                  'Please wait until your primary member switch request gets approved.',
                                ),
                                const SizedBox12(),
                                GestureDetector(
                                  onTap: () {
                                    radioBtnBloc.storeData(0);
                                    refreshListBloc!.storeData('data');
                                    Navigator.pop(context);
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'View as Guest',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

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
                    return SizedBox(
                      width: maxWidth(context),
                    );
                  }),
                ),
              ),
            ],
          ));
    });
  }

  Widget myRadioBtn(value2, myTitle, {ValueChanged<int>? onChange}) {
    return Row(
      children: [
        StreamBuilder<dynamic>(
            initialData: 0,
            stream: radioBtnBloc.stateStream,
            builder: (context, snapshot) {
              return Radio(
                activeColor: myColor.primaryColorDark,
                value: int.parse(value2.toString()),
                groupValue: int.parse(snapshot.data.toString()),
                onChanged: (value) {
                  onChange!(int.parse(value.toString()));
                  radioBtnBloc.storeData(value);
                },
              );
            }),
        Text(
          myTitle,
          style: kStyleNormal.copyWith(),
        ),
      ],
    );
  }

  Widget familyRequestListBuilderWidget() {
    familyRequestListBloc!.fetchAPIList(endpoints.familyRequestListEndpoint);
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: familyRequestListBloc!.apiListStream,
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
              List<ListOfFamilyRequestModel> listOfFamilyRequestModel =
                  List<ListOfFamilyRequestModel>.from(snapshot.data!.data
                      .map((i) => ListOfFamilyRequestModel.fromJson(i)));
              if (listOfFamilyRequestModel.isEmpty &&
                  listOfFamilyModel.isEmpty) {
                return const Text('no data');
              }
              return ListView.builder(
                  itemCount: listOfFamilyRequestModel.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, i) {
                    return familyReqCard(
                      context,
                      widget.memberType,
                      listOfFamilyRequestModel[i],
                      test: filterValue == 1 ? 1 : 0,
                      confirmEndpointType:
                          'admin/addfamily/accept-family-request',
                      cancelEndpointType:
                          'admin/addfamily/reject-family-request/${listOfFamilyRequestModel[i].id}',
                      cancelSentReqEndpoint:
                          'admin/addfamily/cancel-family-request/${listOfFamilyRequestModel[i].id}',
                    );
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
        return SizedBox(
          width: maxWidth(context),
        );
      }),
    );
  }

  Widget noneRequestStreamBuilderWidget() {
    familyNoneTypeRequestListBloc!
        .fetchAPIList(endpoints.noneMemberTypeRequestListEndpoint);
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: familyNoneTypeRequestListBloc!.apiListStream,
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
              List<ListOfFamilyRequestModel> listOfFamilyRequestModel =
                  List<ListOfFamilyRequestModel>.from(snapshot.data!.data
                      .map((i) => ListOfFamilyRequestModel.fromJson(i)));
              if (listOfFamilyRequestModel.isEmpty) {
                return const Text('no more data');
              }
              return ListView.builder(
                  itemCount: listOfFamilyRequestModel.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, i) {
                    return familyReqCard(
                      context,
                      widget.memberType,
                      listOfFamilyRequestModel[i],
                      test: filterValue == 1 ? 1 : 0,
                      confirmEndpointType:
                          'admin/addfamily/accept-family-request',
                      cancelEndpointType:
                          'admin/addfamily/reject-family-request/${listOfFamilyRequestModel[i].id}',
                      cancelSentReqEndpoint:
                          'admin/addfamily/cancel-family-request/${listOfFamilyRequestModel[i].id}',
                    );
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
        return const SizedBox();
      }),
    );
  }

  Widget familyReqCard(context, memberType, ListOfFamilyRequestModel data,
      {test, cancelEndpointType, confirmEndpointType, cancelSentReqEndpoint}) {
    return Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                myCachedNetworkImage(
                  70.0,
                  70.0,
                  test == 0
                      ? data.sendmember!.imagePath.toString()
                      : data.receivemember!.imagePath.toString(),
                  const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  BoxFit.cover,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: SizedBox(
                      height: 70.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name:',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                test == 0
                                    ? data.sendmember!.user!.name.toString()
                                    : data.receivemember!.user!.name.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox2(),
                          Row(
                            children: [
                              Text(
                                'Phone:',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                test == 0
                                    ? data.sendmember!.user!.phone.toString()
                                    : data.receivemember!.user!.phone
                                        .toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox8(),
            test == 1
                ? myAcceptBtn(
                    'Cancel',
                    () async {
                      cancelBloc.storeData('loading${data.id}');
                      int statusCode;
                      statusCode = await API().deleteData(
                        cancelSentReqEndpoint,
                      );

                      if (statusCode == 200) {
                        cancelBloc.storeData('none');
                        refreshReqList.storeData('none');
                        mySnackbar.mySnackBar(
                            context, 'Family Request Rejected ', kRed);
                      } else {
                        cancelBloc.storeData('none');
                      }
                    },
                    cancelBloc,
                    data,
                    kRed.withOpacity(0.2),
                    kRed,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: myAcceptBtn(
                          'Confirm',
                          () async {
                            confirmBloc.storeData('loading${data.id}');
                            var resp = await API().getPostResponseData(
                              context,
                              ApproveRequestModel(id: data.id),
                              confirmEndpointType,
                            );
                            if (resp != null) {
                              ApproveRequestResponseModel test =
                                  ApproveRequestResponseModel.fromJson(resp);
                              if (test.message == 'Deactivated') {
                                List<int> listOfFamilyID = [];
                                listOfFamilyID.add(data.id!);
                                popUpHelper().popUpToNewScreen(
                                    context,
                                    CoolAlertType.error,
                                    'Package Subscription should be done!',
                                    PaymentScreenForApproveRequest(
                                        familyId: listOfFamilyID));
                              } else if (test.message == 'Payment Due') {
                                List<int> listOfFamilyID = [];
                                listOfFamilyID.add(data.id!);
                                goThere(
                                    context,
                                    PaymentScreenForApproveRequest(
                                        familyId: listOfFamilyID));
                              } else {
                                refreshReqList.storeData('none');
                              }
                              confirmBloc.storeData('none');
                            } else {
                              confirmBloc.storeData('none');
                            }
                          },
                          confirmBloc,
                          data,
                          kGreen.withOpacity(0.2),
                          kGreen,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        flex: 1,
                        child: myAcceptBtn(
                          'Cancel',
                          () async {
                            cancelBloc.storeData('loading${data.id}');
                            int statusCode;
                            statusCode = await API().deleteData(
                              cancelEndpointType,
                            );

                            if (statusCode == 200) {
                              cancelBloc.storeData('none');
                              refreshReqList.storeData('none');
                              mySnackbar.mySnackBar(
                                  context, 'Family Request Rejected ', kRed);
                            } else {
                              cancelBloc.storeData('none');
                            }
                          },
                          cancelBloc,
                          data,
                          kRed.withOpacity(0.2),
                          kRed,
                        ),
                      ),
                    ],
                  )
          ],
        ));
  }
}
