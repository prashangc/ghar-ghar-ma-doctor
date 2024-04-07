import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfFamilyModel.dart';
import 'package:ghargharmadoctor/models/FamilyTypeModel/ListOfLeaveRequestModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/profile/editProfile.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyLeaveRequestList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/ListOfFamilyList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PaymentScreenForApproveRequest.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc confirmBloc = StateHandlerBloc();
StateHandlerBloc cancelBloc = StateHandlerBloc();
StateHandlerBloc approveBloc = StateHandlerBloc();
StateHandlerBloc rejectBloc = StateHandlerBloc();
StateHandlerBloc payBloc = StateHandlerBloc();
StateHandlerBloc listOfIDBloc = StateHandlerBloc();

Widget familyCard(context, memberType, ListOfFamilyModel data, type,
    {test,
    cancelEndpointType,
    confirmEndpointType,
    cancelSentReqEndpoint,
    stateStatus,
    List<int>? listOfID}) {
  return GestureDetector(
    onTap: () {
      if (stateStatus != null && stateStatus != 0) {
        if (listOfID!.contains(data.id)) {
          listOfID.removeWhere((element) => data.id == element);
          listOfIDBloc.storeData(listOfID); // payBloc.storeData(1);
        } else {
          listOfID.add(data.id!);
          listOfIDBloc.storeData(listOfID); // payBloc.storeData(1);
        }
      }
    },
    child: Container(
        decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
            border: Border.all(
                width: 1.0,
                color: stateStatus == null || stateStatus == 0
                    ? kTransparent
                    : stateStatus == 1 && listOfID!.contains(data.id)
                        ? myColor.primaryColorDark
                        : kGrey)),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                myCachedNetworkImage(
                  70.0,
                  70.0,
                  data.member!.imagePath.toString(),
                  const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  BoxFit.cover,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: SizedBox(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            memberType == 'Dependent Member' ||
                                    memberType == null
                                ? 'Family Name:'
                                : 'Name:',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              memberType == 'Dependent Member' ||
                                      memberType == null
                                  ? data.familyname!.familyName.toString()
                                  : data.member!.user!.name.toString(),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          stateStatus == null || stateStatus == 0
                              ? Container()
                              : stateStatus == 1 && listOfID!.contains(data.id)
                                  ? const SizedBox(width: 12.0)
                                  : const SizedBox(width: 12.0),
                          stateStatus == null || stateStatus == 0
                              ? Container()
                              : stateStatus == 1 && listOfID!.contains(data.id)
                                  ? Icon(
                                      Icons.check_circle,
                                      color: myColor.primaryColorDark,
                                      size: 18.0,
                                    )
                                  : Icon(
                                      Icons.check_circle_outline,
                                      color: kGrey,
                                      size: 18.0,
                                    )
                        ],
                      ),
                      const SizedBox2(),
                      const SizedBox2(),
                      data.familyRelation == null
                          ? Container()
                          : Column(
                              children: [
                                Text(
                                  'Relation: ${data.familyRelation.toString()}',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox2(),
                                const SizedBox2(),
                              ],
                            ),
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
                            memberType == 'Dependent Member' ||
                                    memberType == null
                                ? data.familyname!.primary!.user!.phone
                                    .toString()
                                : data.member!.user!.phone.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              ],
            ),
            type == 'familyList'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: backgroundColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: ((BuildContext context2) =>
                                addRelationBottomSheet(
                                    context2, context, data)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: myColor.primaryColorDark.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            data.familyRelation == null
                                ? 'Add Relation'
                                : 'Update Relation',
                            textAlign: TextAlign.center,
                            style: kStyleNormal.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: myColor.primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: backgroundColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: ((BuildContext context2) =>
                                removeFamilyBottomSheet(
                                    context2, context, data)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: data.remove!.isNotEmpty &&
                                    data.remove![0].status == 0
                                ? myColor.primaryColorDark
                                : kRed.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            data.remove!.isNotEmpty &&
                                    data.remove![0].status == 0
                                ? 'Pending'
                                : 'Remove',
                            textAlign: TextAlign.center,
                            style: kStyleNormal.copyWith(
                              fontSize: 10.0,
                              fontWeight: data.remove!.isNotEmpty &&
                                      data.remove![0].status == 0
                                  ? FontWeight.w100
                                  : FontWeight.bold,
                              color: data.remove!.isNotEmpty &&
                                      data.remove![0].status == 0
                                  ? kWhite
                                  : kRed,
                            ),
                          ),
                        ),
                      ),
                      data.paymentStatus == 0
                          ? const SizedBox(width: 8.0)
                          : Container(),
                      data.paymentStatus == 0
                          ? listOfID!.isNotEmpty
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    payBloc.storeData(1);
                                    if (listOfID.contains(data.id)) {
                                      listOfID.removeWhere(
                                          (element) => data.id == element);
                                      listOfIDBloc.storeData(
                                          listOfID); // payBloc.storeData(1);
                                    } else {
                                      listOfID.add(data.id!);
                                      listOfIDBloc.storeData(
                                          listOfID); // payBloc.storeData(1);
                                    }
                                    listOfIDBloc.storeData(listOfID);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: myColor.primaryColorDark,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Pay',
                                      textAlign: TextAlign.center,
                                      style: kStyleNormal.copyWith(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                )
                          : Container(),
                    ],
                  )
                : Container(),
            type == 'familyList' ? Container() : const SizedBox8(),
            type == 'requestList'
                ? test == 1
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
                                context, 'Family Request Cancelled ', kRed);
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
                                      ApproveRequestResponseModel.fromJson(
                                          resp);
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
                                  } else if (test.message ==
                                      'Family Request Approved! But Payment Due.') {
                                    confirmBloc.storeData('none}');
                                    refreshReqList.storeData('none');
                                    mySnackbar.mySnackBar(
                                        context, test.message, kRed);
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
                                  mySnackbar.mySnackBar(context,
                                      'Family Request Rejected ', kRed);
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
                : Container(),
          ],
        )),
  );
}

Widget familyLeaveCard(context, ListOfLeaveRequestModel data) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              myCachedNetworkImage(
                70.0,
                70.0,
                data.member!.imagePath.toString(),
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
                        Text(
                          data.member!.user!.name.toString(),
                          style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox2(),
                        const SizedBox2(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.member!.user!.phone.toString(),
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
          const SizedBox2(),
          const SizedBox2(),
          Text(
            'Leave Reason',
            textAlign: TextAlign.justify,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Text(
            data.leaveReason.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
          const SizedBox8(),
          data.status == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: myLeaveAcceptRejectBtn(
                        'Approve',
                        () async {
                          if (data.status == 1) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: backgroundColor,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: ((c) =>
                                  showPendingBottomSheet(c, 'text')),
                            );
                          } else {
                            approveBloc.storeData('loading${data.id}');
                            int statusCode;
                            statusCode = await API().postData(
                              context,
                              ApproveRequestModel(id: data.id),
                              endpoints.familyLeaveReqApprove,
                            );

                            if (statusCode == 200) {
                              approveBloc.storeData('none');
                              refreshLeaveList.storeData('none');
                              mySnackbar.mySnackBar(
                                  context, 'Family Member Removed ', kGreen);
                            } else {
                              approveBloc.storeData('none');
                            }
                          }
                        },
                        approveBloc,
                        data,
                        kGreen.withOpacity(0.2),
                        kGreen,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      flex: 1,
                      child: myLeaveAcceptRejectBtn(
                        'Reject',
                        () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: backgroundColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: ((c) =>
                                rejectLeaveRequestBottomSheet(c, data)),
                          );
                        },
                        rejectBloc,
                        data,
                        kRed.withOpacity(0.2),
                        kRed,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      textAlign: TextAlign.justify,
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: backgroundColor,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: ((c) => showPendingBottomSheet(
                              c,
                              data.status == 1
                                  ? 'Please wait for admin verification.'
                                  : data.status == 2
                                      ? 'Leave Request is rejected by primary family member.'
                                      : data.status == 3
                                          ? 'Leave Request is approved by admin.'
                                          : 'Leave Request is rejected by admin.')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: data.status == 1
                              ? myColor.primaryColorDark
                              : data.status == 3
                                  ? kGreen
                                  : kRed,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          data.status == 1
                              ? 'Pending'
                              : data.status == 3
                                  ? 'Approved.'
                                  : 'Rejected',
                          textAlign: TextAlign.center,
                          style: kStyleNormal.copyWith(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w100,
                            color: kWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ));
}

Widget rejectLeaveRequestBottomSheet(c, ListOfLeaveRequestModel data) {
  StateHandlerBloc? rejectBtnBloc;
  String? rejectReason;
  rejectBtnBloc = StateHandlerBloc();
  rejectBtn() async {
    rejectBtnBloc!.storeData(true);
    int statusCode;
    statusCode = await API().postData(
        checkBiometricSupport(),
        RejectLeaveRequest(rejectReason: rejectReason),
        'admin/family/leave-request/reject/${data.id}');

    if (statusCode == 200) {
      Navigator.pop(c);
      rejectBtnBloc.storeData(false);
      mySnackbar.mySnackBar(c, 'Reject leave request successful.', kGreen);
    } else {
      rejectBtnBloc.storeData(false);
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
                    myTextArea(
                        context, kWhite.withOpacity(0.4), 'Write Reject Reason',
                        onValueChanged: (v) {
                      setState(() {
                        rejectReason = v;
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
                stream: rejectBtnBloc!.stateStream,
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
                        'Reject',
                        kStyleNormal.copyWith(
                          fontSize: 16.0,
                          color: kRed,
                          fontWeight: FontWeight.bold,
                        ),
                        () {
                          rejectBtn();
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

Widget showPendingBottomSheet(context, text) {
  return Wrap(children: [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      child: infoCard(
        context,
        myColor.dialogBackgroundColor.withOpacity(0.7),
        myColor.primaryColorDark,
        text,
        // 'Please wait until leave approve request gets verified'
      ),
    ),
  ]);
}

Widget addRelationBottomSheet(ctx, context, ListOfFamilyModel data) {
  StateHandlerBloc? addRelationBtnBloc;
  String? relation;
  addRelationBtnBloc = StateHandlerBloc();
  addRelationBtn() async {
    addRelationBtnBloc!.storeData(true);
    int statusCode;
    statusCode = await API().postData(
        ctx,
        AddRelationModel(familyRelation: relation),
        'admin/family/add-relation/${data.id}');

    if (statusCode == 200) {
      // Navigator.pop(ctx);
      Navigator.of(ctx).pop();
      refreshFamilyList.storeData('data');
      addRelationBtnBloc.storeData(false);
      pop_upHelper.customAlert(ctx, 'SUCCESS', 'Relation Added');
    } else {
      addRelationBtnBloc.storeData(false);
    }
  }

  return StatefulBuilder(builder: (context, setState) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox16(),
                  myTextArea(context, kWhite.withOpacity(0.4), 'Write Relation',
                      onValueChanged: (v) {
                    setState(() {
                      relation = v;
                    });
                  }),
                  const SizedBox16(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            width: maxWidth(context),
            child: StreamBuilder<dynamic>(
                initialData: false,
                stream: addRelationBtnBloc!.stateStream,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return myLoadingBtn(
                      context,
                      50.0,
                      myColor.primaryColorDark,
                      kWhite,
                      8.0,
                    );
                  } else {
                    return SizedBox(
                      height: 50.0,
                      child: myCustomButton(
                        context,
                        myColor.primaryColorDark,
                        data.familyRelation == null
                            ? 'Add Relation'
                            : 'Update Relation',
                        kStyleNormal.copyWith(
                          fontSize: 16.0,
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                        () {
                          addRelationBtn();
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

Widget removeFamilyBottomSheet(ctx, context, ListOfFamilyModel data) {
  StateHandlerBloc? removeBtnBloc;
  String? removeReason;
  removeBtnBloc = StateHandlerBloc();
  removeBtn() async {
    removeBtnBloc!.storeData(true);
    int statusCode;
    statusCode = await API().postData(
        ctx,
        RemoveFamilyModel(removeReason: removeReason),
        'admin/family/remove-request/${data.id}');

    if (statusCode == 200) {
      // Navigator.pop(ctx);
      Navigator.of(ctx).pop();
      refreshFamilyList.storeData('data');
      removeBtnBloc.storeData(false);
      pop_upHelper.customAlert(ctx, 'SUCCESS', 'Request successfully sent');
    } else {
      removeBtnBloc.storeData(false);
    }
  }

  return data.remove!.isNotEmpty && data.remove![0].status == 0
      ? Wrap(children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: infoCard(
                ctx,
                myColor.dialogBackgroundColor.withOpacity(0.7),
                myColor.primaryColorDark,
                'Please wait until remove request gets verified'),
          ),
        ])
      : StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox16(),
                        myTextArea(context, kWhite.withOpacity(0.4),
                            'Write Remove Reason', onValueChanged: (v) {
                          setState(() {
                            removeReason = v;
                          });
                        }),
                        const SizedBox16(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  margin: const EdgeInsets.only(bottom: 12.0),
                  width: maxWidth(context),
                  child: StreamBuilder<dynamic>(
                      initialData: false,
                      stream: removeBtnBloc!.stateStream,
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
                              'Remove',
                              kStyleNormal.copyWith(
                                fontSize: 16.0,
                                color: kRed,
                                fontWeight: FontWeight.bold,
                              ),
                              () {
                                removeBtn();
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

Widget myLoadingBtn(context, height, cardColor, Color loadingColor, padding) {
  return SizedBox(
    width: maxWidth(context),
    height: height,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cardColor,
        elevation: 0.0,
        padding: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      onPressed: () {},
      child: Container(
        width: height,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: loadingColor,
          backgroundColor: loadingColor.withOpacity(0.2),
        ),
      ),
    ),
  );
  //  Padding(
  //   padding: const EdgeInsets.symmetric(vertical: 10.0),
  //   child: Center(
  //     child: CircularProgressIndicator(
  //         color: myColor.primaryColor,
  //         backgroundColor: myColor.primaryColorDark),
  //   ),
  // );
}

Widget myAcceptBtn(text, myTap, bloc, data, cardColor, textColor) {
  ProfileModel? profileModel;
  var test = sharedPrefs.getFromDevice("userProfile");
  profileModel = ProfileModel.fromJson(json.decode(test));
  return StreamBuilder<dynamic>(
      initialData: 'notLoading',
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.data == 'loading${data.id}') {
          return myLoadingBtn(
            context,
            40.0,
            cardColor,
            textColor,
            7.0,
          );
        } else {
          return GestureDetector(
            onTap: () {
              if (text == 'Confirm') {
                if (profileModel!.dob == null && profileModel.gender == null) {
                  goThere(
                      context,
                      EditProfile(
                        profileModel: profileModel,
                        showMessage: 'confirmReq',
                      ));
                } else {
                  myTap();
                }
              } else {
                myTap();
              }
            },
            child: Container(
              height: 40.0,
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          );
        }
      });
}

Widget myLeaveAcceptRejectBtn(
    text, myTap, bloc, ListOfLeaveRequestModel data, cardColor, textColor) {
  return StreamBuilder<dynamic>(
      initialData: 'notLoading',
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.data == 'loading${data.id}') {
          return myLoadingBtn(
            context,
            40.0,
            cardColor,
            textColor,
            8.0,
          );
        } else {
          return GestureDetector(
            onTap: () {
              myTap();
            },
            child: Container(
              height: 40.0,
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          );
        }
      });
}
