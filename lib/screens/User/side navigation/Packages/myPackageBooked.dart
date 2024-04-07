import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/appointmentCard.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Insurance/InsuranceDetailsPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/LabReports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/ConsultationHistory.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/SubscriptionHistory.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';

StateHandlerBloc priceBloc = StateHandlerBloc();
MyPackageCalculation? myPackageCalculation;
List<int> listOfIndex = [];
String? paymentIntervalValue = 'Yearly';
StateHandlerBloc rescheduleBloc = StateHandlerBloc();
ScrollController? _timelineScrollController;
checkTimelineStatus(List<Dates>? mainDateList, myDate, myReport) {
  if (mainDateList!.isNotEmpty &&
      myDate.reports!.isNotEmpty &&
      myReport.status == 'Skipped') {
    return 4;
  } else if (mainDateList[mainDateList.length - 1].status == 'Pending') {
    return 8;
  } else {
    return mainDateList.isEmpty
        ? -1
        : myDate.reports!.isEmpty
            ? -1
            : myReport.status == 'Sample to be collected'
                ? 2
                : myReport.status == 'Sample Collected' ||
                        myReport.status == 'Sample Deposited' ||
                        myReport.status == "Draft Report" ||
                        myReport.status == 'Report Published'
                    ? 3
                    : myReport.status == 'Lab In Progress'
                        ? 1
                        : myReport.status == 'Report Verified' ||
                                myReport.status == 'Report Published'
                            ? 4
                            : myReport.status == 'Doctor Visit' &&
                                    (DateTime.now()
                                                .toString()
                                                .substring(0, 10) ==
                                            myDate.doctorvisitDate ||
                                        DateTime.parse(DateTime.now()
                                                .toString()
                                                .substring(0, 10)
                                                .toString())
                                            .isAfter(DateTime.parse(myDate
                                                .doctorvisitDate
                                                .toString())))
                                ? 6
                                : myReport.status == 'Doctor Visit'
                                    ? 5
                                    : myReport.status ==
                                                'Consultation Report' ||
                                            myReport.status ==
                                                'Consultation Skipped'
                                        ? 7
                                        : myReport.status == 'Completed'
                                            ? 8
                                            : mainDateList.length == 2
                                                ? 2
                                                : 0;
  }
}

Widget myPackageBooked(context, IndividualPackagesListModel data,
    List<Reports> reportList, value, showPaymentUI) {
  final controller = PageController();
  StateHandlerBloc customIndicatorBloc = StateHandlerBloc();
  ProfileModel? profileModel;
  listOfIndex.clear();
  _timelineScrollController = ScrollController();
  var test = sharedPrefs.getFromDevice("userProfile");
  profileModel = ProfileModel.fromJson(json.decode(test));
  double animationPercent = 0;
  StateHandlerBloc bottomNavBloc = StateHandlerBloc();
  int month = 12;
  double discount = 0.05;
  String? kycStatus;
  kycStatus = sharedPrefs.getFromDevice("kycStatus");
  if (showPaymentUI != null) {
    print('hello there');
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: ((builder) =>
          packageCalculator(context, data, 'isPackagePaymentOnly')),
    );
  }
  ApiHandlerBloc onlineConsultationHistoryBloc = ApiHandlerBloc();
  onlineConsultationHistoryBloc
      .fetchAPIList(endpoints.postToGetPackageMeetingLinkEndpoint);
  ApiHandlerBloc getFamilySizeBloc = ApiHandlerBloc();
  getFamilySizeBloc.fetchAPIList(
      'admin/userpackage/calculate-amount/${data.myPackage!.packageId}');

  yearlyAnimationCalculation(value) {
    if (value > 365) {
      return 1.0;
    } else {
      animationPercent = value / 365;
      return animationPercent;
    }
  }

  monthlyAnimationCalculation(value) {
    if (value > 31) {
      return 1.0;
    } else {
      animationPercent = value / 31;
      return animationPercent;
    }
  }

  halfYearlyAnimationCalculation(value) {
    if (value > 180) {
      return 1.0;
    } else {
      animationPercent = value / 180;
      return animationPercent;
    }
  }

  quaterlyAnimationCalculation(value) {
    if (value > 90) {
      return 1.0;
    } else {
      animationPercent = value / 90;
      return animationPercent;
    }
  }

  completedDaysCalculation(completedDays, remainingDays) {
    animationPercent = completedDays / (completedDays + remainingDays);
    return animationPercent;
  }

  totalFamilySizeCalculation(familySize, totalSize) {
    animationPercent = familySize / totalSize;
    return animationPercent;
  }

  checkStatus() {
    if (data.myPackage!.status == 1) {
      if (data.prepay == true) {
        return 'Prepay';
      } else if (data.myPackage!.packageStatus == 'Expired') {
        return 'PackageExpired';
      } else if (data.myPackage!.packageStatus == 'Activated') {
        if (data.myPackage!.gracePeriod == 1) {
          return 'isInGracePeriod';
        } else if (data.myPackage!.gracePeriod == 2) {
          return 'gracePeriodOver';
        } else {
          return 'Activated';
        }
      } else if (data.myPackage!.packageStatus == 'Booked') {
        return 'Paid';
      } else {
        return 'empty';
      }
    } else {
      if (data.myPackage!.packageStatus == 'Deactivated') {
        return 'Deactivated';
      } else if (data.myPackage!.packageStatus == 'Not Booked') {
        return 'Unpaid';
      } else {
        return 'empty';
      }
    }
  }

  // calculation(IndividualPackagesListModel individualPackagesListModel) {
  //   totalMonthlyFee = double.parse(individualPackagesListModel
  //           .myPackage!.familyfee!.familySize
  //           .toString()) *
  //       double.parse(individualPackagesListModel
  //           .myPackage!.familyfee!.oneMonthlyFee
  //           .toString()) *
  //       double.parse(month.toString());
  //   totalPayableAmountAfterDiscount = double.parse(totalMonthlyFee.toString()) -
  //       (double.parse(totalMonthlyFee.toString()) *
  //           double.parse(discount.toString()));
  //   if (individualPackagesListModel.myPackage!.packageStatus == 'Not Booked') {
  //     totalPayableAmount = individualPackagesListModel
  //             .myPackage!.familyfee!.oneRegistrationFee! +
  //         double.parse(totalPayableAmountAfterDiscount.toString());
  //   } else {
  //     totalPayableAmount =
  //         double.parse(totalPayableAmountAfterDiscount.toString());
  //   }

  //   myPackageCalculation = MyPackageCalculation(
  //     totalFee: totalPayableAmount,
  //     totalMonthlyFeeAfterDiscount: totalPayableAmountAfterDiscount,
  //     totalMonthlyFee: totalMonthlyFee,
  //   );
  //   priceBloc.storeData(myPackageCalculation);
  // }

  checkStatus();
  // calculation(data);

  gracePeriodOverCard() {
    return Container();
  }

  activateCard() {
    return Container();
  }

  expireCard() {
    return SizedBox(
      height: 50.0,
      child: myCustomButton(
        context,
        myColor.primaryColorDark,
        'Book Package',
        kStyleNormal.copyWith(
            fontSize: 16.0,
            color: Colors.white,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold),
        () {
          refreshPackageBloc.storeData('showBuyPackageScreen');
        },
      ),
    );
  }

  Widget unPaidCard(title, paymentType) {
    return StreamBuilder<dynamic>(
      initialData: myPackageCalculation,
      stream: priceBloc.stateStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox8(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Price',
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Rs  ',
                              style: kStyleNormal.copyWith(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: snapshot.data.totalFee!
                                      .round()
                                      .toString(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50.0,
                      child: myCustomButton(
                        context,
                        myColor.primaryColorDark,
                        title,
                        kStyleNormal.copyWith(
                            fontSize: 14.0, color: Colors.white),
                        () {
                          // showModalBottomSheet(
                          //   context: context,
                          //   backgroundColor: backgroundColor,
                          //   isScrollControlled: true,
                          //   shape: const RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.vertical(
                          //           top: Radius.circular(20))),
                          //   builder: ((builder) =>
                          //       payNowBottomModel(paymentType, context, data)),
                          // );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget listCard(title, icon, myTap) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 12,
              color: myColor.primaryColorDark,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: myColor.primaryColorDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: myColor.primaryColorDark,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      size: 12,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  return RefreshIndicator(
    edgeOffset: 0,
    strokeWidth: 2.0,
    color: kWhite,
    backgroundColor: myColor.primaryColorDark,
    onRefresh: () async {
      var resp = await API().getData(context, endpoints.getkycStatusEndpoint);
      if (resp != null) {
        KycResponseModel kycResponseModel = KycResponseModel.fromJson(resp);
        sharedPrefs.storeToDevice("kycStatus", kycResponseModel.message);
        refreshPackageBloc.storeData('refresh');
      }
    },
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
          color: backgroundColor,
          width: maxWidth(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.myPackage!.package!.packageType.toString(),
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Your Subcribed Package',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/logo.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                ],
              ),
              const SizedBox12(),
              data.myPackage!.packageStatus == 'Not Booked'
                  ? validationCard(
                      context: context,
                      bgColor: const Color.fromARGB(255, 255, 205, 202),
                      borderColor: kRed,
                      msg: 'Please pay for your subscription package.',
                      text: 'Pay Now',
                      myTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: backgroundColor,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: ((builder) => packageCalculator(
                              context, data, 'isPackagePaymentOnly')),
                        );
                      },
                    )
                  : kycStatus == 'kyc not verified.'
                      ? infoCard(
                          context,
                          myColor.dialogBackgroundColor,
                          myColor.primaryColorDark,
                          'Please wait until your global form gets verified. It may take at least 2 days for verification.',
                        )
                      : kycStatus == 'kyc form not submitted.'
                          ? fillGlobalForm(
                              context,
                              profileModel.memberType == 'Dependent Member'
                                  ? 'Please fill your global form to activate your insurance.'
                                  : 'Please fill your global form to activate package.')
                          : kycStatus == 'kyc rejected.'
                              ? fillGlobalForm(
                                  context,
                                  'Your global form is rejected. Please re-fill with valid data.',
                                )
                              : kycStatus == 'kyc verified.'
                                  ? data.myPackage!.packageStatus == 'Booked'
                                      ? infoCard(
                                          context,
                                          kGreen.withOpacity(0.2),
                                          kGreen,
                                          'Your package is booked successfully! We will soon notify your first screening date.',
                                        )
                                      : data.myPackage!.packageStatus ==
                                              'Activated'
                                          ? data.myPackage!.gracePeriod == 1
                                              ? validationCard(
                                                  context: context,
                                                  bgColor: myColor
                                                      .dialogBackgroundColor,
                                                  borderColor:
                                                      myColor.primaryColorDark,
                                                  msg:
                                                      'Your subscription package has been extended until ${data.extendedDate}. Please pay for your subscription package.',
                                                  text: 'Pay Now',
                                                  myTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor:
                                                          backgroundColor,
                                                      isScrollControlled: true,
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20))),
                                                      builder: ((builder) =>
                                                          packageCalculator(
                                                              context,
                                                              data,
                                                              'isPackagePaymentOnly')),
                                                    );
                                                  },
                                                )
                                              : Container()
                                          : StreamBuilder<dynamic>(
                                              initialData: checkStatus(),
                                              stream: bottomNavBloc.stateStream,
                                              builder: ((ctx, snapshot) {
                                                if (snapshot.data == 'Paid') {
                                                  return Container();
                                                } else if (snapshot.data ==
                                                    'Unpaid') {
                                                  return validationCard(
                                                    context: context,
                                                    bgColor:
                                                        const Color.fromARGB(
                                                            255, 255, 205, 202),
                                                    borderColor: kRed,
                                                    msg:
                                                        'Subscription not booked. Please pay for your subscription package.',
                                                    text: 'Pay Now',
                                                    myTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            backgroundColor,
                                                        isScrollControlled:
                                                            true,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20))),
                                                        builder: ((builder) =>
                                                            packageCalculator(
                                                                context,
                                                                data,
                                                                'isPackagePaymentOnly')),
                                                      );
                                                    },
                                                  );
                                                } else if (snapshot.data ==
                                                    'Prepay') {
                                                  return validationCard(
                                                    context: context,
                                                    bgColor: myColor
                                                        .dialogBackgroundColor,
                                                    borderColor: myColor
                                                        .primaryColorDark,
                                                    msg:
                                                        'Your subscription package will be deactivated on ${data.myPackage!.payment![0].expiryDate}. Please pre-pay for your subscription package.',
                                                    text: 'Pay Now',
                                                    myTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            backgroundColor,
                                                        isScrollControlled:
                                                            true,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20))),
                                                        builder: ((builder) =>
                                                            packageCalculator(
                                                                context,
                                                                data,
                                                                'prePayPackage')),
                                                      );
                                                    },
                                                  );
                                                  // return prePaymentCard();
                                                } else if (snapshot.data ==
                                                    'PackageExpired') {
                                                  return validationCard(
                                                    context: context,
                                                    bgColor: myColor
                                                        .dialogBackgroundColor,
                                                    borderColor: myColor
                                                        .primaryColorDark,
                                                    msg:
                                                        'Your subscription package has expired! Either re-new or buy new package.',
                                                    text: 'Pay Now',
                                                    myTap: () {},
                                                  );
                                                } else if (snapshot.data ==
                                                    'Deactivated') {
                                                  return validationCard(
                                                    context: context,
                                                    bgColor: myColor
                                                        .dialogBackgroundColor,
                                                    borderColor: myColor
                                                        .primaryColorDark,
                                                    msg:
                                                        'Your subscription package has been deactivated. Please pay for your subscription package.',
                                                    text: 'Pay Now',
                                                    myTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            backgroundColor,
                                                        isScrollControlled:
                                                            true,
                                                        shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20))),
                                                        builder: ((builder) =>
                                                            packageCalculator(
                                                                context,
                                                                data,
                                                                'isPackagePaymentOnly')),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                            )
                                  : kycStatus == 'kyc rejected.'
                                      ? infoCard(
                                          context,
                                          kRed.withOpacity(0.2),
                                          kRed,
                                          'Your Global Form has been rejected. Please fill again to start your package.',
                                        )
                                      : Container(),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: maxWidth(context),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: myColor.dialogBackgroundColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox12(),
                        Container(
                          padding: const EdgeInsets.all(14.0),
                          width: maxWidth(context),
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(25.0),
                              topLeft: Radius.circular(25.0),
                              bottomRight: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 13.0,
                                    animation: true,
                                    animationDuration: 2000,
                                    progressColor:
                                        data.myPackage!.status == 0 ||
                                                data.myPackage!.packageStatus ==
                                                    'Booked'
                                            ? kRed.withOpacity(0.2)
                                            : myColor.primaryColorDark,
                                    percent: data.myPackage!.payment!.isNotEmpty &&
                                            data.myPackage!.payment![0].paymentInterval ==
                                                'Yearly'
                                        ? yearlyAnimationCalculation(
                                            data.remainingDays)
                                        : data.myPackage!.payment!.isNotEmpty &&
                                                data.myPackage!.payment![0]
                                                        .paymentInterval ==
                                                    'Monthly'
                                            ? monthlyAnimationCalculation(
                                                data.remainingDays)
                                            : data.myPackage!.payment!.isNotEmpty &&
                                                    data.myPackage!.payment![0]
                                                            .paymentInterval ==
                                                        'Half_Yearly'
                                                ? halfYearlyAnimationCalculation(
                                                    data.remainingDays)
                                                : data.myPackage!.payment!.isNotEmpty &&
                                                        data
                                                                .myPackage!
                                                                .payment![0]
                                                                .paymentInterval ==
                                                            'Quarterly'
                                                    ? quaterlyAnimationCalculation(data.remainingDays)
                                                    : 0,
                                    animateFromLastPercent: true,
                                    backgroundColor:
                                        data.myPackage!.status == 0 ||
                                                data.myPackage!.packageStatus ==
                                                    'Booked'
                                            ? kRed.withOpacity(0.2)
                                            : myColor.primaryColorDark,
                                    center: data.myPackage!.status == 0
                                        ? Icon(
                                            Icons.error_outline_outlined,
                                            color: kRed,
                                            size: 35,
                                          )
                                        : Text(
                                            data.remainingDays.toString(),
                                            style: kStyleNormal.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                    footer: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: data.myPackage!.status == 0
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                color: kRed,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(4.0),
                                                ),
                                              ),
                                              child: Text(
                                                'Payment Due',
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                  color: kWhite,
                                                ),
                                              ),
                                            )
                                          : data.myPackage!.packageStatus ==
                                                  'Booked'
                                              ? Text(
                                                  "Not Activated",
                                                  style: kStyleNormal.copyWith(
                                                      color: kRed,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                )
                                              : Text(
                                                  "Days Remaining",
                                                  style: kStyleNormal.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.square,
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        myLinearProgressIndicator(
                                            'Completed Days',
                                            data.completedDays.toString(),
                                            completedDaysCalculation(
                                                double.parse(data.completedDays
                                                    .toString()),
                                                double.parse(data.remainingDays
                                                    .toString()))),
                                        const SizedBox8(),
                                        StreamBuilder<ApiResponse<dynamic>>(
                                          stream:
                                              getFamilySizeBloc.apiListStream,
                                          builder: ((context, snapshot) {
                                            if (snapshot.hasData) {
                                              switch (snapshot.data!.status) {
                                                case Status.LOADING:
                                                  return myLinearProgressIndicator(
                                                    'Family Size',
                                                    '0',
                                                    0.0,
                                                  );

                                                case Status.COMPLETED:
                                                  if (snapshot
                                                      .data!.data.isEmpty) {
                                                    return myLinearProgressIndicator(
                                                      'Family Size',
                                                      '0',
                                                      0.0,
                                                    );
                                                  }
                                                  GetPackageFamilySize
                                                      getPackageFamilySize =
                                                      GetPackageFamilySize
                                                          .fromJson(snapshot
                                                              .data!.data);

                                                  return myLinearProgressIndicator(
                                                    'Family Size',
                                                    getPackageFamilySize
                                                        .packagefee!.familySize
                                                        .toString(),
                                                    totalFamilySizeCalculation(
                                                      double.parse(
                                                          getPackageFamilySize
                                                              .packagefee!
                                                              .familySize
                                                              .toString()),
                                                      8.0,
                                                    ),
                                                  );

                                                case Status.ERROR:
                                                  return myLinearProgressIndicator(
                                                    'Family Size',
                                                    '0',
                                                    0.0,
                                                  );
                                              }
                                            }
                                            return const SizedBox();
                                          }),
                                        ),
                                        const SizedBox8(),
                                        data.myPackage!.status == 0
                                            ? Container()
                                            : bookingDetailsRowCard(
                                                leadingText: 'Booked Date',
                                                trailingText: data
                                                    .myPackage!.bookedDate
                                                    .toString(),
                                              ),
                                        data.myPackage!.status == 0
                                            ? Container()
                                            : data.myPackage!.activatedDate ==
                                                    null
                                                ? Container()
                                                : const SizedBox8(),
                                        data.myPackage!.status == 0
                                            ? Container()
                                            : data.myPackage!.activatedDate ==
                                                    null
                                                ? Container()
                                                : bookingDetailsRowCard(
                                                    leadingText:
                                                        'Activated Date',
                                                    trailingText: data
                                                        .myPackage!
                                                        .activatedDate
                                                        .toString(),
                                                  ),
                                        data.myPackage!.status == 0
                                            ? Container()
                                            : data.myPackage!.expiryDate == null
                                                ? Container()
                                                : const SizedBox8(),
                                        data.myPackage!.status == 0
                                            ? Container()
                                            : data.myPackage!.expiryDate == null
                                                ? Container()
                                                : bookingDetailsRowCard(
                                                    leadingText: 'Expiry Date',
                                                    trailingText: data
                                                        .myPackage!.expiryDate
                                                        .toString(),
                                                  ),
                                        data.myPackage!.status == 0
                                            ? Container()
                                            : const SizedBox8(),
                                        bookingDetailsRowCard(
                                          leadingText: 'Subscription Status',
                                          trailingText:
                                              data.myPackage!.packageStatus,
                                          color:
                                              data.myPackage!.packageStatus ==
                                                          'Not Activated' ||
                                                      data.myPackage!
                                                              .packageStatus ==
                                                          'Expired' ||
                                                      data.myPackage!
                                                              .packageStatus ==
                                                          'Deactivated'
                                                  ? kRed
                                                  : kGreen,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              data.myPackage!.packageStatus == 'Booked'
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 12.0),
                                      child: infoCard(
                                        context,
                                        const Color.fromARGB(
                                            255, 255, 205, 202),
                                        kRed,
                                        'Your days count will start after first screening date',
                                      ),
                                    )
                                  : Container(),
                              const SizedBox2(),
                              data.myPackage!.packageStatus == 'Not Booked'
                                  ? Container()
                                  : listCard(
                                      'View Insurance',
                                      FontAwesomeIcons.handHoldingHeart,
                                      () {
                                        goThere(context,
                                            const InsuranceDetailsPage());
                                      },
                                    ),
                              data.myPackage!.dates!.isNotEmpty
                                  ? StreamBuilder<dynamic>(
                                      initialData: data
                                                      .myPackage!
                                                      .dates![data.myPackage!
                                                              .dates!.length -
                                                          1]
                                                      .screening!
                                                      .screening !=
                                                  'First Screening' &&
                                              data
                                                      .myPackage!
                                                      .dates![data.myPackage!
                                                              .dates!.length -
                                                          1]
                                                      .status ==
                                                  'Doctor Visit' &&
                                              data.myPackage!.package!
                                                      .scheduleFlexibility ==
                                                  1
                                          ? 1
                                          : 0,
                                      stream: rescheduleBloc.stateStream,
                                      builder: (cc, ss) {
                                        return ss.data == 1
                                            ? Column(
                                                children: [
                                                  const SizedBox2(),
                                                  listCard(
                                                    'Reschedule Screening',
                                                    FontAwesomeIcons.calendar,
                                                    () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          backgroundColor: myColor
                                                              .dialogBackgroundColor,
                                                          isScrollControlled:
                                                              true,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              20))),
                                                          builder: ((builder) =>
                                                              rescheduleScreeningBottomSheet(
                                                                  context,
                                                                  data)));
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      })
                                  : Container(),
                            ],
                          ),
                        ),
                        data.myPackage!.packageStatus != 'Activated' &&
                                data.myPackage!.dates!.isEmpty
                            ? Container()
                            : const SizedBox16(),
                        data.myPackage!.packageStatus != 'Activated' &&
                                data.myPackage!.dates!.isEmpty
                            ? Container()
                            : Text(
                                data.myPackage!.dates!.isEmpty
                                    ? 'First Screening'
                                    : data
                                                .myPackage!
                                                .dates![data.myPackage!.dates!
                                                        .length -
                                                    1]
                                                .status ==
                                            'Pending'
                                        ? data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    2]
                                            .screening!
                                            .screening
                                            .toString()
                                        : data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .screening!
                                            .screening
                                            .toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                        // data.myPackage!.packageStatus != 'Activated' &&
                        //         data.myPackage!.dates!.isEmpty
                        //     ? Container()
                        //     :
                        const SizedBox16(),
                        // data.myPackage!.packageStatus != 'Activated'
                        //     ? Container()
                        //     :
                        SizedBox(
                          width: maxWidth(context),
                          height:
                              // data.myPackage!.dates!.isEmpty
                              //     ? 0
                              //     : data
                              //             .myPackage!
                              //             .dates![data.myPackage!.dates!.length - 1]
                              //             .reports!
                              //             .isEmpty
                              //         ? 0
                              //         :
                              180.0,
                          child: StreamBuilder<dynamic>(
                              initialData: data.myPackage!.dates!.isEmpty
                                  ? 0
                                  : data
                                          .myPackage!
                                          .dates![
                                              data.myPackage!.dates!.length - 1]
                                          .reports!
                                          .isEmpty
                                      //     &&
                                      // data.myPackage!.dates![data.myPackage!.dates!.length - 1].status !=
                                      //     'Pending'
                                      ? 8
                                      : checkTimelineStatus(
                                          data.myPackage!.dates!,
                                          data.myPackage!.dates![
                                              data.myPackage!.dates!.length -
                                                  1],
                                          data
                                              .myPackage!
                                              .dates![data.myPackage!.dates!
                                                      .length -
                                                  1]
                                              .reports![data
                                                  .myPackage!
                                                  .dates![data.myPackage!.dates!
                                                          .length -
                                                      1]
                                                  .reports!
                                                  .length -
                                              1]),
                              stream: customIndicatorBloc.stateStream,
                              builder: (context, snapshot) {
                                return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: packageTimelinelist.length,
                                    shrinkWrap: true,
                                    controller: _timelineScrollController,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (c, i) {
                                      if (listOfIndex.isEmpty) {
                                        listOfIndex.add(i);
                                      }
                                      return mainTimelineCard(
                                          packageTimelinelist,
                                          i,
                                          data,
                                          reportList,
                                          snapshot,
                                          profileModel,
                                          i == 3 || i == 4
                                              ? (data.myPackage!.dates!.isNotEmpty &&
                                                          reportList
                                                              .isNotEmpty &&
                                                          reportList[0].status ==
                                                              'Skipped') ||
                                                      (snapshot.data >= 4 &&
                                                          reportList[0].sampleDate ==
                                                              null)
                                                  ? true
                                                  : false
                                              : i == 6
                                                  ? (snapshot.data == 6 &&
                                                              data
                                                                  .myPackage!
                                                                  .dates!
                                                                  .isNotEmpty &&
                                                              reportList
                                                                  .isNotEmpty &&
                                                              reportList[0].homeskip !=
                                                                  null) ||
                                                          (snapshot.data > 6 &&
                                                              data
                                                                  .myPackage!
                                                                  .dates!
                                                                  .isNotEmpty &&
                                                              reportList
                                                                  .isNotEmpty &&
                                                              reportList[0].consultationReportDate ==
                                                                  null)
                                                      ? true
                                                      : false
                                                  : i == 7
                                                      ? snapshot.data >= 7 &&
                                                              data
                                                                  .myPackage!
                                                                  .dates!
                                                                  .isNotEmpty &&
                                                              reportList
                                                                  .isNotEmpty &&
                                                              reportList[0].consultationReportDate ==
                                                                  null
                                                          ? true
                                                          : false
                                                      : i == 8
                                                          ? snapshot.data == 8 && data.myPackage!.dates!.isNotEmpty && data.myPackage!.dates![data.myPackage!.dates!.length - 1].isVerified == 0
                                                              ? true
                                                              : false
                                                          : false,
                                          dontShowSkip: i == 8
                                              ? snapshot.data == 8 && data.myPackage!.dates!.isNotEmpty && data.myPackage!.dates![data.myPackage!.dates!.length - 1].isVerified == 0
                                                  ? true
                                                  : null
                                              : null);
                                    });
                              }),
                        ),
                        data.myPackage!.dates!.isNotEmpty &&
                                data
                                        .myPackage!
                                        .dates![
                                            data.myPackage!.dates!.length - 1]
                                        .isVerified ==
                                    0
                            ? sampleValidationCard(
                                context,
                                3,
                                'Your screening date is not yet verified by GD, there might be some changes in date and time.',
                                '',
                                null)
                            : Container(),
                        data.myPackage!.dates!.isEmpty ||
                                data
                                    .myPackage!
                                    .dates![data.myPackage!.dates!.length - 1]
                                    .employees!
                                    .isEmpty
                            ? Container()
                            : const SizedBox16(),
                        data.myPackage!.dates!.isNotEmpty &&
                                reportList.isNotEmpty &&
                                reportList[0].homeskip != null
                            ? homeSkipCard(
                                context,
                                reportList[0].homeskip!,
                                reportList[0].online!,
                                reportList[0].online == null ? true : false,
                                reportList[0].online != null &&
                                        reportList[0].online!.reason != null
                                    ? true
                                    : false,
                              )
                            : Container(),

                        data.myPackage!.dates!.isNotEmpty &&
                                reportList.isNotEmpty &&
                                reportList[0].skipReason != null
                            ? sampleValidationCard(context, null,
                                reportList[0].skipReason!.toString(), '', null)
                            : Container(),
                        data.myPackage!.dates!.isNotEmpty &&
                                reportList.isNotEmpty &&
                                reportList[0].nosample != null
                            ? sampleValidationCard(
                                context,
                                '1',
                                reportList[0].nosample!.reason.toString(),
                                '${data.myPackage!.dates![data.myPackage!.dates!.length - 1].additionalScreeningDate}, [${data.myPackage!.dates![data.myPackage!.dates!.length - 1].additionalScreeningTime}] ',
                                data
                                    .myPackage!
                                    .dates![data.myPackage!.dates!.length - 1]
                                    .additionalScreeningDate)
                            : Container(),
                        data.myPackage!.dates!.isNotEmpty &&
                                reportList.isNotEmpty &&
                                reportList[0].additionalnosample != null
                            ? sampleValidationCard(
                                context,
                                '2',
                                reportList[0]
                                    .additionalnosample!
                                    .reason
                                    .toString(),
                                '',
                                null)
                            : Container(),
                        data.myPackage!.dates!.isNotEmpty ||
                                (data.myPackage!.dates!.isNotEmpty &&
                                    data
                                        .myPackage!
                                        .dates![
                                            data.myPackage!.dates!.length - 1]
                                        .employees!
                                        .isNotEmpty) ||
                                (data.myPackage!.dates!.isNotEmpty &&
                                    data.myPackage!.dates!.length > 1 &&
                                    data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .status ==
                                        "Pending")
                            ? labDiagnosticCard(
                                context,
                                data.myPackage!.dates!.isNotEmpty &&
                                        data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .reports!
                                            .isEmpty
                                    ? data.myPackage!.dates![
                                        data.myPackage!.dates!.length - 2]
                                    : data.myPackage!.dates![
                                        data.myPackage!.dates!.length - 1])
                            : Container(),
                        data.myPackage!.dates!.isNotEmpty ||
                                (data.myPackage!.dates!.isNotEmpty &&
                                    data
                                        .myPackage!
                                        .dates![
                                            data.myPackage!.dates!.length - 1]
                                        .employees!
                                        .isNotEmpty) ||
                                (data.myPackage!.dates!.isNotEmpty &&
                                    data.myPackage!.dates!.length > 1 &&
                                    data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .status ==
                                        "Pending")
                            ? const SizedBox16()
                            : Container(),
                        (data.myPackage!.dates!.isNotEmpty &&
                                    data.myPackage!.dates![data.myPackage!.dates!.length - 1].status ==
                                        "Doctor Visit") ||
                                (data.myPackage!.dates!.isNotEmpty &&
                                    data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .status ==
                                        "Doctor Visit Completed") ||
                                (data.myPackage!.dates!.isNotEmpty &&
                                    data.myPackage!.dates!.length > 1 &&
                                    data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .status ==
                                        "Pending")
                            ? doctorCard(
                                context,
                                data.myPackage!.dates!.isNotEmpty &&
                                        data
                                            .myPackage!
                                            .dates![data.myPackage!.dates!.length - 1]
                                            .reports!
                                            .isEmpty
                                    ? data.myPackage!.dates![data.myPackage!.dates!.length - 2]
                                    : data.myPackage!.dates![data.myPackage!.dates!.length - 1])
                            : Container(),
                        const SizedBox16(),
                        data.myPackage!.payment!.isEmpty
                            ? Container()
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subscription History',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          goThere(
                                              context,
                                              SubscriptionHistory(
                                                payment:
                                                    data.myPackage!.payment!,
                                              ));
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'View all',
                                              style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                  color:
                                                      myColor.primaryColorDark),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Icon(
                                                Icons
                                                    .keyboard_arrow_right_outlined,
                                                size: 14.0,
                                                color:
                                                    myColor.primaryColorDark),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox16(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0),
                                    width: maxWidth(context),
                                    decoration: BoxDecoration(
                                      color: kWhite.withOpacity(0.4),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox12(),
                                        SizedBox(
                                          width: maxWidth(context),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              myTitle('Payment\nInterval'),
                                              myTitle('Expiry\nDate'),
                                              myTitle('Paid\nAmount'),
                                              myTitle('Payment\nStatus'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox2(),
                                        const Divider(),
                                        ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                data.myPackage!.payment!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (ctx, i) {
                                              var list =
                                                  data.myPackage!.payment![i];
                                              return Column(
                                                children: [
                                                  Container(
                                                    width: maxWidth(context),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0),
                                                    child: Row(children: [
                                                      myTitle(
                                                          list.paymentInterval),
                                                      myTitle(list.expiryDate ??
                                                          'Not Activated'),
                                                      myTitle(
                                                          'Rs ${list.amount}'),
                                                      // myTitle(list.prepayDays == null
                                                      //     ? '0 days'
                                                      //     : '${list.prepayDays} days'),
                                                      // myTitle(list.graceDays ??
                                                      //     '0' ' days'),
                                                      myTitle(list.expiryDate ==
                                                              null
                                                          ? 'Paid'
                                                          : DateTime.parse(list
                                                                      .expiryDate
                                                                      .toString())
                                                                  .isAfter(
                                                                      DateTime
                                                                          .now())
                                                              ? 'Paid'
                                                              : 'Expired'),
                                                    ]),
                                                  ),
                                                  i ==
                                                          data
                                                                  .myPackage!
                                                                  .payment!
                                                                  .length -
                                                              1
                                                      ? Container()
                                                      : const Divider(),
                                                ],
                                              );
                                            }),
                                        const SizedBox12(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox16(),
                        StreamBuilder<ApiResponse<dynamic>>(
                          stream: onlineConsultationHistoryBloc.apiListStream,
                          builder: ((c, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status) {
                                case Status.LOADING:
                                  return const SizedBox(
                                    height: 240,
                                    child: Center(
                                      child: AnimatedLoading(),
                                    ),
                                  );
                                case Status.COMPLETED:
                                  if (snapshot.data!.data.isEmpty) {
                                    return Container();
                                  }
                                  List<OnlineConsultationHistoryModel>
                                      onlineConsultationHistoryModel =
                                      List<OnlineConsultationHistoryModel>.from(
                                          snapshot.data!.data.map((i) =>
                                              OnlineConsultationHistoryModel
                                                  .fromJson(i)));

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Consultation History',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              goThere(
                                                  context,
                                                  ConsultationHistory(
                                                    onlineConsultationHistoryModel:
                                                        onlineConsultationHistoryModel,
                                                  ));
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  'View all',
                                                  style: kStyleNormal.copyWith(
                                                      fontSize: 12.0,
                                                      color: myColor
                                                          .primaryColorDark),
                                                ),
                                                const SizedBox(width: 12.0),
                                                Icon(
                                                    Icons
                                                        .keyboard_arrow_right_outlined,
                                                    size: 14.0,
                                                    color: myColor
                                                        .primaryColorDark),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox16(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14.0),
                                        width: maxWidth(context),
                                        decoration: BoxDecoration(
                                          color: kWhite.withOpacity(0.4),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox12(),
                                            SizedBox(
                                              width: maxWidth(context),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  myTitle('Doctor\nName'),
                                                  myTitle('Date'),
                                                  myTitle('Start\nTime'),
                                                  myTitle('End\nTime'),
                                                  myTitle('Duration'),
                                                ],
                                              ),
                                            ),
                                            const SizedBox2(),
                                            const Divider(),
                                            ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    onlineConsultationHistoryModel
                                                        .length,
                                                shrinkWrap: true,
                                                itemBuilder: (ctx, i) {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width:
                                                            maxWidth(context),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5.0),
                                                        child: Row(children: [
                                                          myTitle(
                                                              onlineConsultationHistoryModel[
                                                                      i]
                                                                  .doctor!
                                                                  .user!
                                                                  .name
                                                                  .toString()),
                                                          myTitle(
                                                            '${getMonth(onlineConsultationHistoryModel[i].startTime)} ${onlineConsultationHistoryModel[i].startTime.toString().substring(5, 7)}, ${onlineConsultationHistoryModel[i].startTime.toString().substring(0, 4)}',
                                                          ),
                                                          myTitle(
                                                              onlineConsultationHistoryModel[
                                                                      i]
                                                                  .startTime!
                                                                  .toString()
                                                                  .substring(
                                                                      11, 19)),
                                                          myTitle(
                                                              onlineConsultationHistoryModel[
                                                                      i]
                                                                  .endTime!
                                                                  .toString()
                                                                  .substring(
                                                                      11, 19)),
                                                          myTitle((DateTime.parse(
                                                                      onlineConsultationHistoryModel[
                                                                              i]
                                                                          .endTime
                                                                          .toString())
                                                                  .difference(DateTime
                                                                      .parse(onlineConsultationHistoryModel[
                                                                              i]
                                                                          .startTime
                                                                          .toString())))
                                                              .inMinutes
                                                              .toString()),
                                                        ]),
                                                      ),
                                                      i ==
                                                              onlineConsultationHistoryModel
                                                                      .length -
                                                                  1
                                                          ? Container()
                                                          : const Divider(),
                                                    ],
                                                  );
                                                }),
                                            const SizedBox12(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );

                                case Status.ERROR:
                                  return Container(
                                    width: maxWidth(context),
                                    height: 135.0,
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
                        ),

                        const SizedBox32(),
                        const SizedBox32(),
                        const SizedBox32(),
                        const SizedBox32(),
                        const SizedBox32(),
                        const SizedBox32(),
                        const SizedBox32(),
                        const SizedBox32(),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<dynamic>(
                    initialData: 'empty',
                    stream: bottomNavBloc.stateStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == 'Paid') {
                        return Container();
                      }
                      if (snapshot.data == 'isInGracePeriod') {
                        return unPaidCard('Pay  Now', 'isPackagePaymentOnly');
                      }
                      if (snapshot.data == 'Unpaid') {
                        return unPaidCard('Pay  Now', 'isPackagePaymentOnly');
                      }
                      if (snapshot.data == 'Prepay') {
                        return unPaidCard('Pre-Pay', 'prePayPackage');
                        // return prePaymentCard();
                      }
                      if (snapshot.data == 'PackageExpired') {
                        return expireCard();
                      }
                      if (snapshot.data == 'gracePeriodOver') {
                        return gracePeriodOverCard();
                      }
                      if (snapshot.data == 'Deactivated') {
                        return unPaidCard('Pay Now', 'isPackagePaymentOnly');
                      }
                      if (snapshot.data == 'Activated') {
                        return activateCard();
                      } else {
                        return const SizedBox();
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget homeSkipCard(context, Homeskip homeSkip, OnlineConsultation online,
    dontShowOnline, videoMeetingAlsoSkipped) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: maxWidth(context),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline_outlined, size: 17.0, color: kRed),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  'Your doctor consultation has been skipped because of your absence.',
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox2(),
          Row(
            children: [
              Icon(Icons.error_outline_outlined,
                  size: 17.0, color: kTransparent),
              const SizedBox(width: 12.0),
              Text(
                'Reason: ',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: myColor.primaryColorDark,
                ),
              ),
              Expanded(child: htmlText(homeSkip.reason)),
            ],
          ),
          const SizedBox12(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myCachedNetworkImage(
                60.0,
                60.0,
                homeSkip.employee!.imagePath,
                const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                BoxFit.contain,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myRow(
                      'Name',
                      homeSkip.employee!.user!.name.toString(),
                    ),
                    myRow(
                      'Phone',
                      homeSkip.employee!.user!.phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox8(),
          const Divider(),
          const SizedBox8(),
          Row(
            children: [
              Icon(Icons.error_outline_outlined,
                  size: 17.0,
                  color: videoMeetingAlsoSkipped == false
                      ? dontShowOnline == true
                          ? kRed
                          : myColor.primaryColorDark
                      : kRed),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  videoMeetingAlsoSkipped == false
                      ? dontShowOnline == true
                          ? 'A video meeting with the doctor is available in case of missed consultation. Please wait for the meeting date and time.'
                          : "Please join the meeting in the give time for online doctor consultation."
                      : "You have missed both doctor visit at home and online doctor consultation.",
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          videoMeetingAlsoSkipped == false ? const SizedBox12() : Container(),
          videoMeetingAlsoSkipped == false
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 14.0,
                          color: myColor.primaryColorDark,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          dontShowOnline == true
                              ? 'Pending'
                              : online.startTime.toString(),
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (dontShowOnline == false) {
                          // joinMeeting(
                          //   context,
                          //   online.meetingId,
                          //   online.meetingPassword,
                          // );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 6.0),
                        decoration: BoxDecoration(
                          color: dontShowOnline == true
                              ? kGrey.withOpacity(0.4)
                              : myColor.primaryColorDark,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          'Join Meeting',
                          textAlign: TextAlign.center,
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                            color: myColor.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_outlined,
                        size: 17.0, color: kTransparent),
                    const SizedBox(width: 12.0),
                    Text(
                      'Reason: ',
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: myColor.primaryColorDark,
                      ),
                    ),
                    Expanded(child: htmlText(homeSkip.reason)),
                  ],
                ),
        ],
      ));
}

Widget mainTimelineCard(
    packageTimelinelist,
    i,
    IndividualPackagesListModel data,
    List<Reports> reportList,
    snapshot,
    profileModel,
    status,
    {dontShowSkip}) {
  double itemWidth = 300.0;
  double offset = itemWidth * listOfIndex[0];
  _timelineScrollController!.animateTo(
    offset,
    duration: const Duration(milliseconds: 500),
    curve: Curves.ease,
  );
  return Column(
    children: [
      myTimelineCard(
        status,
        i.isEven,
        packageTimelinelist[i].title,
        data.myPackage!.dates!.isNotEmpty && reportList.isNotEmpty
            ? i == 3
                ? reportList[0].sampleDate
                : i == 4
                    ? reportList[0].reportDate
                    : i == 5
                        ? 'Pending'
                        : i == 6
                            ? data
                                .myPackage!
                                .dates![data.myPackage!.dates!.length - 1]
                                .doctorvisitDate
                            : i == 7
                                ? reportList[0].consultationReportDate
                                : i == 8
                                    ? data
                                        .myPackage!
                                        .dates![
                                            data.myPackage!.dates!.length - 1]
                                        .screeningDate
                                    : i == 9
                                        ? 'Not Expired'
                                        : data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .screeningDate
            : null, // this is for index 1 and 2
        i,
        snapshot.data,
        dontShowSkip: dontShowSkip,
      ),
      Container(
        width: 2.0,
        height: i == snapshot.data ? 15.0 : 20.0,
        color: i.isOdd
            ? i < snapshot.data
                ? status == true
                    ? kRed
                    : myColor.primaryColorDark
                : i == snapshot.data
                    ? status == true
                        ? kRed
                        : myColor.primaryColorDark
                    : kWhite.withOpacity(0.4)
            : kTransparent,
      ),
      Row(
        children: [
          myTimelineHrzLine(
            i == 6 ? 'Waiting for Date' : packageTimelinelist[i].title,
            'date',
            i,
            snapshot.data,
            isLeft: true,
          ),
          Container(
            width: i == snapshot.data ? 30.0 : 20.0,
            height: i == snapshot.data ? 30.0 : 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < snapshot.data
                  ? status == true
                      ? kWhite.withOpacity(0.4)
                      : myColor.primaryColorDark
                  : kWhite.withOpacity(0.4),
              border: Border.all(
                  color: status == true ? kRed : myColor.primaryColorDark,
                  width: 1.5),
            ),
            child: i == snapshot.data
                ? myCachedNetworkImageCircle(
                    20.0,
                    20.0,
                    profileModel.imagePath.toString(),
                    BoxFit.cover,
                  )
                : i < snapshot.data
                    ? status == true
                        ? Icon(
                            FontAwesomeIcons.exclamation,
                            size: 12.0,
                            color: kRed,
                          )
                        : Icon(
                            Icons.check,
                            size: 10.0,
                            color: kWhite,
                          )
                    : Center(
                        child: Text(
                          (i + 1).toString(),
                          style: kStyleNormal.copyWith(
                            fontSize: 10.0,
                            color: myColor.primaryColorDark,
                          ),
                        ),
                      ),
          ),
          myTimelineHrzLine(
            i == 6 ? 'Waiting for Date' : packageTimelinelist[i].title,
            'date',
            i,
            snapshot.data,
            isRight: true,
          ),
        ],
      ),
      Container(
        width: 2.0,
        height: i == snapshot.data ? 15.0 : 20.0,
        color: i.isEven
            ? i < snapshot.data
                ? status == true
                    ? kRed
                    : myColor.primaryColorDark
                : i == snapshot.data
                    ? status == true
                        ? kRed
                        : myColor.primaryColorDark
                    : kWhite.withOpacity(0.4)
            : kTransparent,
      ),
      myTimelineCard(
        status,
        i.isOdd,
        packageTimelinelist[i].title,
        data.myPackage!.dates!.isNotEmpty && reportList.isNotEmpty
            ? i == 3
                ? reportList[0].sampleDate
                : i == 4
                    ? reportList[0].reportDate
                    : i == 5
                        ? 'Pending'
                        : i == 6
                            ? data
                                .myPackage!
                                .dates![data.myPackage!.dates!.length - 1]
                                .doctorvisitDate
                            : i == 7
                                ? reportList[0].consultationReportDate
                                : i == 8
                                    ? data
                                        .myPackage!
                                        .dates![
                                            data.myPackage!.dates!.length - 1]
                                        .screeningDate
                                    : i == 9
                                        ? 'Not Expired'
                                        : data
                                            .myPackage!
                                            .dates![
                                                data.myPackage!.dates!.length -
                                                    1]
                                            .screeningDate
            : null, // this is for index 1 and 2

        i,
        snapshot.data,
        dontShowSkip: dontShowSkip,
      ),
    ],
  );
}

Widget sampleValidationCard(context, index, text, dateTime, dateCondition) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline_outlined, size: 17.0, color: kRed),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index == 3
                        ? Text(
                            'Screening Date Verficiation Pending',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : index == null
                            ? Text(
                                'Lab Visit skipped reason:',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    '$index:  ',
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    index == ''
                                        ? 'First Sample not collected reason:'
                                        : 'Second Sample not collected reason:',
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                    const SizedBox2(),
                    index == 3
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              text,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          )
                        : htmlText(text),
                    dateCondition == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Sample Collection Date: ',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  dateTime,
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: myColor.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ));
}

Widget rescheduleScreeningBottomSheet(ctx, IndividualPackagesListModel data) {
  StateHandlerBloc arrowLoadingBloc = StateHandlerBloc();
  String? dateOfBirthNep, dateOfBirthEng, time;

  rescheduleScreeningBtn(ctx) async {
    arrowLoadingBloc.storeData(1);
    int statusCode = await API().postData(
        ctx,
        PostRescheduleScreeningModel(
          date: dateOfBirthEng ??
              '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
          screeningdateId: data
              .myPackage!.dates![data.myPackage!.dates!.length - 1].screeningId,
          time: time ?? '${DateTime.now().hour}: ${DateTime.now().minute}',
          userpackageId: data.myPackage!.id,
        ),
        endpoints.postRescheduleScreeningEndpoint);
    if (statusCode == 200) {
      arrowLoadingBloc.storeData(0);
      rescheduleBloc.storeData(0);
      Navigator.pop(ctx);
    } else {
      arrowLoadingBloc.storeData(0);
    }
  }

  return StatefulBuilder(builder: (c, setState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox12(),
          Text(
            'Reschedule Screening',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: myColor.primaryColorDark,
            ),
          ),
          const SizedBox24(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Date',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  color: kBlack,
                ),
              ),
              const SizedBox12(),
              widgetDatePickerWithoutPrefixIcon(
                ctx,
                kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                ),
                dateOfBirthNep ??
                    '${NepaliDateTime.now().year}-${NepaliDateTime.now().month}-${NepaliDateTime.now().day}',
                kWhite.withOpacity(0.4),
                12.0,
                onValueChanged: (value) {
                  setState(() {
                    dateOfBirthNep = value.nepaliDate;
                    dateOfBirthEng = value.englishDate;
                  });
                },
              ),
              const SizedBox12(),
              Text(
                'Select Time',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  color: kBlack,
                ),
              ),
              const SizedBox12(),
              myTimePicker(
                ctx,
                time,
                time ?? '${DateTime.now().hour}: ${DateTime.now().minute}',
                kWhite.withOpacity(0.4),
                '',
                onValueChanged: (v) {
                  time = v;
                },
              ),
            ],
          ),
          const SizedBox24(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Back',
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: myColor.primaryColorDark),
                ),
              ),
              StreamBuilder<dynamic>(
                  initialData: 0,
                  stream: arrowLoadingBloc.stateStream,
                  builder: (c, loadingSnap) {
                    return GestureDetector(
                      onTap: () {
                        if (loadingSnap.data == 0) {
                          rescheduleScreeningBtn(ctx);
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: myColor.primaryColorDark,
                            shape: BoxShape.circle,
                          ),
                          child: loadingSnap.data == 0
                              ? Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  color: kWhite,
                                  size: 17.0,
                                )
                              : SizedBox(
                                  width: 17.0,
                                  height: 17.0,
                                  child: CircularProgressIndicator(
                                    color: kWhite,
                                    strokeWidth: 1.0,
                                  ),
                                )),
                    );
                  }),
            ],
          ),
          const SizedBox16(),
        ],
      ),
    );
  });
}

Widget labDiagnosticCard(context, Dates date) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    width: maxWidth(context),
    child: Column(
      children: [
        const SizedBox12(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Diagnostic and Lab Team',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            date.status == 'Report Generated' ||
                    date.status == 'Doctor Visit Completed' ||
                    date.status == 'Doctor Visit' ||
                    date.status == 'Completed'
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        goThere(context, const LabReports());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'View Report',
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: myColor.primaryColorDark,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            size: 16.0,
                            color: myColor.primaryColorDark,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        const SizedBox8(),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: date.employees!
                .where((element) =>
                    element.type == 'Lab Technician' ||
                    element.type == 'Lab Nurse')
                .toList()
                .length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, i) {
              var myData = date.employees!
                  .where((element) =>
                      element.type == 'Lab Technician' ||
                      element.type == 'Lab Nurse')
                  .toList()[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  i == 0 ? Container(height: 6.0) : const Divider(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        myCachedNetworkImage(
                          60.0,
                          60.0,
                          myData.employee!.imagePath,
                          const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          BoxFit.contain,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myRow(
                                'Name',
                                myData.employee!.user!.name.toString(),
                              ),
                              myRow(
                                'Phone',
                                myData.employee!.user!.phone,
                              ),
                              myRow(
                                'Status',
                                date.status.toString(),
                                //  data
                                //         .myPackage!
                                //         .dates![data.myPackage!.dates!.length - 1]
                                //         .status ==
                                //     'Lab Visit Pending'
                                // ? kRed
                                // : myColor.primaryColorDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  i ==
                          date.employees!
                                  .where((element) =>
                                      element.type == 'Lab Technician' ||
                                      element.type == 'Lab Nurse')
                                  .toList()
                                  .length -
                              1
                      ? Container(height: 6.0)
                      : const Divider(),
                ],
              );
            }),
      ],
    ),
  );
}

Widget doctorCard(context, Dates date) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
    ),
    width: maxWidth(context),
    child: Column(
      children: [
        const SizedBox12(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Consultant Team',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox8(),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: date.employees!
                .where((element) =>
                    element.type != 'Lab Technician' &&
                    element.type != 'Lab Nurse')
                .toList()
                .length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, i) {
              var myData = date.employees!
                  .where((element) =>
                      element.type != 'Lab Technician' &&
                      element.type != 'Lab Nurse')
                  .toList()[i];
              return date.employees!
                      .where((element) =>
                          element.type != 'Lab Technician' &&
                          element.type != 'Lab Nurse')
                      .toList()
                      .isEmpty
                  ? infoCard(context, myColor.primaryColorDark, kRed,
                      'Doctor consulation is available after consultant team is assigned.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myCachedNetworkImage(
                                60.0,
                                60.0,
                                '',
                                const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                BoxFit.contain,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myRow(
                                      'Name',
                                      myData.employee!.user!.name.toString(),
                                    ),
                                    myRow(
                                      'Phone',
                                      myData.employee!.user!.phone.toString(),
                                    ),
                                    myRow(
                                      'Status',
                                      date.status.toString(),
                                    ),
                                    const SizedBox8(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                myColor.dialogBackgroundColor,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20))),
                                            builder: ((builder) =>
                                                addReviewBottomSheet(
                                                    context,
                                                    date
                                                        .employees!
                                                        .where((element) =>
                                                            element.type !=
                                                                'Lab Technician' &&
                                                            element.type !=
                                                                'Lab Nurse')
                                                        .toList()[i]
                                                        .employeeId,
                                                    date.employees!
                                                        .where((element) =>
                                                            element.type !=
                                                                'Lab Technician' &&
                                                            element.type !=
                                                                'Lab Nurse')
                                                        .toList()[i]
                                                        .screeningdateId)),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color:
                                                      myColor.primaryColorDark,
                                                  size: 12.0,
                                                ),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  'Add Feedback',
                                                  style: kStyleNormal.copyWith(
                                                    color: myColor
                                                        .primaryColorDark,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        i ==
                                date.employees!
                                        .where((element) =>
                                            element.type != 'Lab Technician' &&
                                            element.type != 'Lab Nurse')
                                        .toList()
                                        .length -
                                    1
                            ? Container(height: 6.0)
                            : const Divider(),
                      ],
                    );
            }),
        date.consultationType == 2
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (date.online!.isEmpty) {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: myColor.dialogBackgroundColor,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: ((builder) => meetingValidationBtnSheet(
                              context,
                              'Please wait ! Doctor has not started meeting yet.')),
                        );
                      } else {
                        // joinMeeting(
                        //   context,
                        //   date.online![date.online!.length - 1].meetingId,
                        //   date.online![date.online!.length - 1].meetingPassword,
                        // );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 6.0),
                      decoration: BoxDecoration(
                        color: myColor.primaryColorDark,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        'Join Meeting',
                        textAlign: TextAlign.center,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: myColor.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  date.status == 'Report Generated'
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              goThere(context, const LabReports());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'View Report',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: myColor.primaryColorDark,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  size: 16.0,
                                  color: myColor.primaryColorDark,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              )
            : Container(),
        const SizedBox8(),
      ],
    ),
  );
}

Widget myTimelineCard(greyStatus, a, value, date, i, data, {dontShowSkip}) {
  String? kycStatus;
  kycStatus = sharedPrefs.getFromDevice("kycStatus");
  if (i == 0) {
    if (kycStatus == 'kyc form not submitted.') {
      date = 'Not Submitted';
    } else if (kycStatus == 'kyc not verified.') {
      date = 'Pending';
    } else {
      date = 'Verified';
    }
  }
  if (i > data) {
    date = null;
  }

  return Container(
    decoration: BoxDecoration(
      border: Border.all(
          color: a == false
              ? (i == data || i < data)
                  ? greyStatus == true
                      ? kRed
                      : myColor.primaryColorDark
                  : kWhite.withOpacity(0.4)
              : kTransparent,
          width: 2.0),
      color: a == false
          ? (i == data || i < data)
              ? greyStatus == true
                  ? const Color.fromARGB(255, 255, 205, 202)
                  : myColor.primaryColorDark
              : greyStatus == true
                  ? const Color.fromARGB(255, 255, 205, 202)
                  : kWhite.withOpacity(0.4)
          : kTransparent,
      borderRadius: const BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
    margin: const EdgeInsets.only(right: 10.0),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: Column(
      children: [
        Text(
          value,
          // value.toString(),
          style: kStyleNormal.copyWith(
            color: a == false
                ? (i == data || i < data)
                    ? greyStatus == true
                        ? kBlack
                        : kWhite
                    : kBlack
                : kTransparent,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox2(),
        Text(
          greyStatus == true && dontShowSkip != null
              ? date
              : greyStatus == true
                  ? 'Skipped'
                  : date ?? 'Pending',
          style: kStyleNormal.copyWith(
            color: a == false
                ? (i == data || i < data)
                    ? greyStatus == true
                        ? kBlack
                        : kWhite
                    : kBlack
                : kTransparent,
            fontSize: 12.0,
          ),
        ),
      ],
    ),
  );
}

Widget myTimelineHrzLine(value, date, i, data, {isLeft, isRight}) {
  return Container(
    height: 2.0,
    color: i < data
        ? myColor.primaryColorDark
        : i == data && isLeft == true
            ? myColor.primaryColorDark
            : kWhite.withOpacity(0.4),
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      children: [
        SizedBox(
          height: 1.0,
          child: Text(
            value.substring(0, (value.toString().length / 2).round()),
            maxLines: 1,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
        ),
        SizedBox(
          height: 1.0,
          child: Text(
            date == null ? '' : 'date',
            // date.substring(0, (value.toString().length / 2).round()),
            // value.toString().substring(0, (value.toString().length / 2.5).round()),
            maxLines: 1,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: kWhite,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget myTitle(title) {
  return Expanded(
    flex: 1,
    child: Text(
      title.toString(),
      textAlign: TextAlign.start,
      style: kStyleNormal.copyWith(
        fontSize: 12.0,
        color: title == 'Paid'
            ? kGreen
            : title == 'Not Activated'
                ? kRed
                : kBlack,
      ),
    ),
  );
}

Widget myRow(title, text, {color, showDivider}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                )),
            Text(text,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: color ?? kBlack,
                )),
          ],
        ),
        showDivider == true ? const Divider() : Container(height: 6.0),
      ],
    ),
  );
}

Widget bookingDetailsRowCard(
    {@required leadingText, @required trailingText, color}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        leadingText,
        style: kStyleNormal.copyWith(fontSize: 11.0),
      ),
      Text(
        trailingText,
        style: kStyleNormal.copyWith(fontSize: 11.0, color: color ?? kBlack),
      ),
    ],
  );
}

// Widget payNowBottomModel(type, context, IndividualPackagesListModel data) {
//   String selectedPaymentMethod = 'esewa';

//   payBtn(paymentType) {
//     switch (selectedPaymentMethod) {
//       case 'esewa':
//         // myEsewa(context, widget.totalAmount.toString());
//         break;

//       case 'khalti':
//         myKhalti(
//           context,
//           totalPayableAmount!.round(),
//           paymentType,
//           data.myPackage!.id,
//           paymentInterval: paymentIntervalValue,
//         );
//         break;

//       case '2':
//         // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
//         break;

//       case '3':
//         // myKhalti(context, widget.totalAmount, 'isProductOrder');
//         break;

//       case '4':
//         // goThere(context, const EsewaTestScreen());
//         break;

//       case '5':
//         // myKhalti(context, widget.totalAmount, 'isProductOrder');
//         break;

//       default:
//     }
//   }

//   return StatefulBuilder(builder: (context, setState) {
//     return GestureDetector(
//       onTap: () {
//         myfocusRemover(context);
//       },
//       child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox12(),
//                 paymentMethod(context, false, true, onValueChanged: (v) {
//                   selectedPaymentMethod = v;
//                 }),
//                 StreamBuilder<dynamic>(
//                     initialData: myPackageCalculation,
//                     stream: priceBloc.stateStream,
//                     builder: (context, snapshot) {
//                       return SizedBox(
//                         width: maxWidth(context),
//                         height: 56.0,
//                         child: myCustomButton(
//                           context,
//                           myColor.primaryColorDark,
//                           'Rs. ${snapshot.data.totalMonthlyFee.round()}',
//                           kStyleNormal.copyWith(
//                               fontSize: 16.0, color: Colors.white),
//                           () {
//                             payBtn(type);
//                           },
//                         ),
//                       );
//                     }),
//                 const SizedBox12(),
//               ])),
//     );
//   });
// }

Widget myLinearProgressIndicator(leadingText, value, percent) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 70.0,
        child: Text(
          leadingText,
          style: kStyleNormal.copyWith(fontSize: 11.0),
        ),
      ),
      Expanded(
        child: LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 12.0,
          isRTL: true,
          backgroundColor: myColor.dialogBackgroundColor,
          center: Text(
            value,
            style: kStyleNormal.copyWith(fontSize: 11.0),
          ),
          animation: true,
          animationDuration: 1000,
          percent: percent,
          progressColor: myColor.primaryColorDark,
        ),
      ),
    ],
  );
}

Widget validationCard({context, text, msg, borderColor, bgColor, myTap}) {
  return GestureDetector(
    onTap: () {
      myTap();
    },
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline_outlined,
                    size: 17.0, color: borderColor),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    msg,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      text,
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: borderColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        )),
  );
}

Widget packageCalculator(
    context, IndividualPackagesListModel data, paymentType) {
  bool isPaymentIntervalDropDownOpened = false;
  int month = 12;
  double discount = 0.05;
  double? oneRegistrationFee, oneMonthlyFee, totalQuaterlyFee, totalDiscount;
  double? totalPayableAmount, totalMonthlyFee, totalPayableAmountAfterDiscount;
  String selectedPaymentMethod = 'esewa';

  payBtn() {
    switch (selectedPaymentMethod) {
      case 'esewa':
        // myEsewa(context, widget.totalAmount.toString());
        break;

      case 'khalti':
        myKhalti(
          context,
          totalPayableAmount!.round(),
          paymentType,
          data.myPackage!.id,
          paymentInterval: paymentIntervalValue,
          detailsModel: data.myPackage!.package,
        );
        break;

      case '2':
        // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
        break;

      case '3':
        // myKhalti(context, widget.totalAmount, 'isProductOrder');
        break;

      case '4':
        // goThere(context, const EsewaTestScreen());
        break;

      case '5':
        // myKhalti(context, widget.totalAmount, 'isProductOrder');
        break;

      default:
    }
  }

  calculateBtn() {
    if (data.myPackage!.renewStatus == 1) {
      oneRegistrationFee = double.parse(
          data.myPackage!.familyfee!.oneRegistrationFee.toString());
      oneMonthlyFee =
          double.parse(data.myPackage!.familyfee!.oneMonthlyFee.toString());
    } else if (data.myPackage!.renewStatus == 2) {
      oneRegistrationFee = double.parse(
          data.myPackage!.familyfee!.twoContinuationFee.toString());
      oneMonthlyFee =
          double.parse(data.myPackage!.familyfee!.twoMonthlyFee.toString());
    } else {
      oneRegistrationFee = double.parse(
          data.myPackage!.familyfee!.threeContinuationFee.toString());
      oneMonthlyFee =
          double.parse(data.myPackage!.familyfee!.threeMonthlyFee.toString());
    }
    totalQuaterlyFee =
        double.parse(data.myPackage!.familyfee!.familySize.toString()) *
            double.parse(oneMonthlyFee!.toString()) *
            double.parse(month.toString());
    totalDiscount = totalQuaterlyFee! * double.parse(discount.toString());
    totalPayableAmountAfterDiscount = totalQuaterlyFee! - totalDiscount!;
    totalPayableAmount = oneRegistrationFee! +
        double.parse(totalPayableAmountAfterDiscount.toString());
  }

  calculateBtn();
  String formatNumber(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  return StatefulBuilder(builder: (context, setState) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox12(),
                Text(
                  'Your Family Size',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox16(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    color: kWhite,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.perm_identity,
                        size: 16,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        data.myPackage!.familyfee!.familySize.toString(),
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox16(),
                Text(
                  'Select Payment Interval',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox16(),
                DropdownButtonHideUnderline(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      onMenuStateChange: (v) {
                        setState(() {
                          isPaymentIntervalDropDownOpened = v;
                        });
                      },
                      isExpanded: true,
                      hint: Row(
                        children: [
                          const Icon(
                            Icons.perm_identity,
                            size: 16,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            paymentIntervalValue.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      items: packagepaymentIntervalList
                          .map((item) => DropdownMenuItem<String>(
                                value: item.name,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.perm_identity,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      item.name.toString(),
                                      style: kStyleNormal.copyWith(
                                        fontSize: 12.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                      value: paymentIntervalValue,
                      onChanged: (value) {
                        setState(() {
                          paymentIntervalValue = value as String;
                          for (int i = 0;
                              i < packagepaymentIntervalList.length;
                              i++) {
                            if (packagepaymentIntervalList[i].name ==
                                paymentIntervalValue) {
                              month = packagepaymentIntervalList[i].month;
                              discount = packagepaymentIntervalList[i].discount;
                            }
                          }
                          calculateBtn();
                        });
                      },
                      dropdownOverButton: false,
                      iconSize: 20,
                      iconEnabledColor: myColor.primaryColorDark,
                      iconDisabledColor: Colors.grey,
                      buttonElevation: 0,
                      buttonHeight: 53.0,
                      buttonWidth: maxWidth(context),
                      dropdownElevation: 0,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: !isPaymentIntervalDropDownOpened
                            ? const BorderRadius.all(Radius.circular(12.0))
                            : const BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0),
                              ),
                        color: kWhite,
                      ),
                      itemHeight: 35,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 150,
                      dropdownPadding:
                          const EdgeInsets.fromLTRB(0.0, 0.0, 14.0, 14.0),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: isPaymentIntervalDropDownOpened
                            ? const BorderRadius.all(Radius.circular(12.0))
                            : const BorderRadius.only(
                                bottomLeft: Radius.circular(12.0),
                                bottomRight: Radius.circular(12.0),
                              ),
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox16(),
                SizedBox(
                  width: maxWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Fee Type',
                          overflow: TextOverflow.clip,
                          style: kStyleNormal.copyWith(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            'Amount',
                            overflow: TextOverflow.clip,
                            style: kStyleNormal.copyWith(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox8(),
                const Divider(),
                calculateAmountRow(context, 'Total GD Enrollment Fee',
                    'Rs ${formatNumber(oneRegistrationFee!)}'),
                calculateAmountRow(
                    context,
                    'Package Subscription Fee per Person (Monthly)',
                    'Rs ${formatNumber(oneMonthlyFee!)}'),
                calculateAmountRow(
                    context,
                    'Total Package Subscription Fee (Yearly)',
                    'Rs ${formatNumber(totalQuaterlyFee!)}'),
                calculateAmountRow(
                    context,
                    'Discount on total package subscription fee (Yearly) 5%',
                    '- Rs ${formatNumber(totalDiscount!)}',
                    showDivider: false,
                    color: kRed),
                const SizedBox16(),
                paymentMethod(context, false, true, onValueChanged: (v) {
                  selectedPaymentMethod = v;
                }),
                const SizedBox16(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 60.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total',
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                color: myColor.primaryColorDark,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Rs  ',
                                style: kStyleNormal.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: formatNumber(totalPayableAmount!),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 22.0,
                                      color: myColor.primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Pay now',
                          kStyleNormal.copyWith(
                              fontSize: 14.0, color: Colors.white),
                          () {
                            payBtn();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ])),
    );
  });
}

Widget calculateAmountRow(context, textValue, amount,
    {showDivider, color, size}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: maxWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                textValue,
                overflow: TextOverflow.clip,
                style: kStyleNormal.copyWith(fontSize: 12.0),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  amount,
                  overflow: TextOverflow.clip,
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: size ?? 14.0,
                      color: color ?? kBlack),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox8(),
      showDivider == false ? Container(height: 6.0) : const Divider(),
    ],
  );
}

Widget addReviewBottomSheet(context, employeeID, screeningDateID) {
  String? review;
  StateHandlerBloc submitFeedbackBloc = StateHandlerBloc();
  return StatefulBuilder(builder: (context, setState) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  const SizedBox16(),
                  Text(
                    'Write a Review',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox16(),
                  myTextArea(context, kWhite.withOpacity(0.4),
                      'Would you like to write anything about this app?',
                      onValueChanged: (v) {
                    review = v;
                    if (v.isEmpty) {
                      review = null;
                    }
                    setState(() {});
                  }),
                  const SizedBox12(),
                  StreamBuilder<dynamic>(
                      initialData: 0,
                      stream: submitFeedbackBloc.stateStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == 1) {
                          return myBtnLoading(context, 50.0);
                        } else {
                          return SizedBox(
                            width: maxWidth(context),
                            height: 50.0,
                            child: myCustomButton(
                              context,
                              review == null
                                  ? myColor.primaryColorDark.withOpacity(0.12)
                                  : myColor.primaryColorDark,
                              'Submit Review',
                              kStyleNormal.copyWith(
                                  color: kWhite, fontSize: 14.0),
                              () async {
                                if (review != null) {
                                  submitFeedbackBloc.storeData(1);
                                  int? statusCode;
                                  statusCode = await API().postData(
                                      context,
                                      AddScreeningFeedbackModel(
                                        comment: review,
                                        employeeId: employeeID,
                                        screeningdateId: screeningDateID,
                                      ),
                                      endpoints.postScreeningFeedbackEndpoint);
                                  if (statusCode == 200) {
                                    submitFeedbackBloc.storeData(0);
                                    Navigator.pop(context);
                                    mySnackbar.mySnackBar(
                                        context, 'Feedback Sent', kGreen);
                                  } else {
                                    submitFeedbackBloc.storeData(0);
                                  }
                                }
                              },
                            ),
                          );
                        }
                      }),
                  const SizedBox12(),
                ])),
      ),
    );
  });
}
