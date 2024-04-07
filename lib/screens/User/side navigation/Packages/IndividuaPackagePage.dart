import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/profile/editProfile.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/CompanyProfileFormScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PackageCalculator.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/packages.dart';
import 'package:ghargharmadoctor/widgets/SucessScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc isPackageBookingBloc = StateHandlerBloc();

class IndividuaPackagePage extends StatefulWidget {
  final PackagesModel packagesModel;
  final bool? isCorporate;
  const IndividuaPackagePage(
      {Key? key, required this.packagesModel, this.isCorporate})
      : super(key: key);

  @override
  State<IndividuaPackagePage> createState() => _IndividuaPackagePageState();
}

class _IndividuaPackagePageState extends State<IndividuaPackagePage> {
  bool overLapDropdown = true;
  bool isDropDownOpened = false;
  ProfileModel? profileModel;
  bool isSwitched = false;
  bool _isVisible = false;
  bool _isVisible2 = false;
  StateHandlerBloc loadingBtnBloc = StateHandlerBloc();
  StateHandlerBloc priceBloc = StateHandlerBloc();
  StateHandlerBloc showHideBookBtnBloc = StateHandlerBloc();
  StateHandlerBloc showFillCompanyProfileBloc = StateHandlerBloc();

  double? discount,
      totalPayableAmount,
      totalMonthlyFee,
      totalPayableAmountAfterDiscount;
  double? totalPayableAmount2,
      totalMonthlyFee2,
      totalPayableAmountAfterDiscount2;
  int? month;
  bool isPaymentIntervalDropDownOpened = false;
  bool isPaymentIntervalDropDownOpened2 = false;
  bool dropdownWhileBookingPackage = false;
  String selectedPaymentMethod = 'esewa';
  String? kycStatus,
      token,
      paymentIntervalValue,
      paymentIntervalValue2,
      _existingMemberYear,
      dateOfBirth,
      gender,
      memberType;
  int? familySize;
  double? oneRegistrationFee, oneMonthlyFee;
  GetPackageFamilySize? getPackageFamilySize;
  List<dynamic> familySizeList = [];
  PostPackageBooking? postPackageBooking;
  ApiHandlerBloc? profileBloc;
  @override
  void initState() {
    super.initState();
    profileBloc = ApiHandlerBloc();
    kycStatus = sharedPrefs.getFromDevice("kycStatus");
    getAllFamilySize();
  }

  getAllFamilySize() {
    setState(() {});
    familySizeList.clear();
    for (int i = 0; i < widget.packagesModel.fees!.length; i++) {
      familySizeList.add(widget.packagesModel.fees![i].familySize);
    }
  }

  calculateBtn() {
    if (formValidation()) {
      calculationMethod();
    }
  }

  calculationMethod() {
    setState(() {
      for (int i = 0; i < widget.packagesModel.fees!.length; i++) {
        if (widget.packagesModel.fees![i].familySize == familySize) {
          if (1 == 1) {
            // if (isMemberTypeRadioBtnSelected == 1) {
            oneRegistrationFee = double.parse(
                widget.packagesModel.fees![i].oneRegistrationFee.toString());
            oneMonthlyFee = double.parse(
                widget.packagesModel.fees![i].oneMonthlyFee.toString());
          } else {
            if (_existingMemberYear == 'Year 2') {
              oneRegistrationFee = double.parse(
                  widget.packagesModel.fees![i].twoContinuationFee.toString());
              oneMonthlyFee = double.parse(
                  widget.packagesModel.fees![i].twoMonthlyFee.toString());
            } else {
              oneRegistrationFee = double.parse(widget
                  .packagesModel.fees![i].threeContinuationFee
                  .toString());
              oneMonthlyFee = double.parse(
                  widget.packagesModel.fees![i].threeMonthlyFee.toString());
            }
          }
        }
      }
      _isVisible = true;

      formulaMethod();
    });
  }

  formulaMethod() {
    double a = double.parse(familySize.toString()) *
        double.parse(oneMonthlyFee.toString()) *
        double.parse(month.toString());
    totalPayableAmountAfterDiscount =
        a - (a * double.parse(discount.toString()));
    totalPayableAmount = oneRegistrationFee! +
        double.parse(totalPayableAmountAfterDiscount.toString());
  }

  clearBtn() {
    setState(() {
      // _memberType = null;
      getAllFamilySize();
      packagepaymentIntervalList.clear();
      // isMemberTypeRadioBtnSelected = 0;
      _existingMemberYear == null;
      familySize == null;
      month == null;
      _isVisible = false;
    });
  }

  formValidation() {
    // if (isMemberTypeRadioBtnSelected == 0) {
    //   myToast.toast('Please select GD Member type');
    //   return false;
    // } else if (isMemberTypeRadioBtnSelected == 2 &&
    //     _existingMemberYear == null) {
    //   myToast.toast('Please select existing member year');
    //   return false;
    // } else
    if (familySize == null) {
      myToast.toast('Please select size of the family');
      return false;
    } else if (month == null) {
      myToast.toast('Please select payment interval');
      return false;
    } else {
      return true;
    }
  }

  dynamicCalculation(familySize, oneMonthlyFee, oneRegistrationFee) {
    totalMonthlyFee2 = double.parse(familySize.toString()) *
        double.parse(oneMonthlyFee.toString()) *
        double.parse(month.toString()); //
    totalPayableAmountAfterDiscount2 =
        double.parse(totalMonthlyFee2.toString()) -
            (double.parse(totalMonthlyFee2.toString()) *
                double.parse(discount.toString())); //
    totalPayableAmount2 = oneRegistrationFee! +
        double.parse(totalPayableAmountAfterDiscount2.toString());
    priceBloc.storeData(totalPayableAmount2);
  }

  bookPackageBtn(context, snapshotData) async {
    if (profileModel!.memberType == 'Dependent Member') {
      pop_upHelper.popUpNavigatorPop(context, 1, CoolAlertType.error,
          'Dependent family member cannot buy a package');
    } else {
      List<String> tempList = profileUpdateFormValidation();
      if (tempList.isEmpty) {
        bookingAPICall(context, snapshotData);
      } else {
        GetIDNameModel getIDNameModel = await goThere(
            context,
            EditProfile(
              profileModel: profileModel!,
              showMessage: 'isBuyingPackage',
            ));

        if (getIDNameModel.id == '1') {
          isPackageBookingBloc.storeData(true);
          mySnackbar.mySnackBar(context, 'Profile Updated', kGreen);
        }
      }
    }
  }

  bookPackageForUpdatedProfileBtn(context, price) {
    if (profileModel!.memberType == 'Dependent Member') {
      pop_upHelper.popUpNavigatorPop(context, 1, CoolAlertType.error,
          'Dependent family member cannot buy a package');
    } else {
      bookingAPICall(context, price);
    }
  }

  bookingAPICall(context, price) async {
    if (isSwitched == true) {
      loadingBtnBloc.storeData(true);
      PostPackageBooking postPackageBooking = PostPackageBooking(
          year: 1, packageId: widget.packagesModel.id, renewStatus: 1);
      int statusCode;

      statusCode = await API().postData(
          context, postPackageBooking, endpoints.postBookPackageEndpoint);

      if (statusCode == 200) {
        loadingBtnBloc.storeData(false);
        goThere(
          context,
          SucessScreen(
            btnText: 'View Package',
            screen: goThere(
              context,
              const MainHomePage(
                index: 2,
                tabIndex: 0,
              ),
            ),
            subTitle: 'Tap View Button to view package details.',
            title: 'Packaged Booked',
            model: postPackageBooking,
          ),
        );
      } else {
        loadingBtnBloc.storeData(false);
      }
    } else {
      postPackageBooking = PostPackageBooking(
          year: 1, packageId: widget.packagesModel.id, renewStatus: 1);
      switch (selectedPaymentMethod) {
        case 'esewa':
          // myEsewa(context, totalPayableAmount2.toString());
          break;

        case 'khalti':
          myKhalti(context, price, 'isPackageBooking', postPackageBooking,
              paymentInterval: paymentIntervalValue2,
              detailsModel: widget.packagesModel);
          break;

        case 'fonePay':
          // myEsewaFlutter(
          //     context, double.parse(totalPayableAmount2.toString()));
          break;

        case 'imePay':
          // myKhalti(context, totalPayableAmount2, 'isPackageBooking');
          break;

        case 'connectIPS':
          // goThere(context, const EsewaTestScreen());
          break;

        case 'prabhuPay':
          // myKhalti(context, totalPayableAmount2, 'isPackageBooking');
          break;

        default:
      }
    }
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
    return Scaffold(
      backgroundColor: myColor.colorScheme.background,
      appBar: myCustomAppBar(
          title: widget.packagesModel.packageType.toString(),
          color: myColor.colorScheme.background,
          borderRadius: 0.0),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                goThere(context,
                    PackageCalculator(packagesModel: widget.packagesModel));
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  width: maxWidth(context),
                  decoration: BoxDecoration(
                    color: myColor.dialogBackgroundColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    border:
                        Border.all(color: myColor.primaryColorDark, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error_outline_outlined,
                              size: 17.0, color: myColor.primaryColorDark),
                          const SizedBox(width: 12.0),
                          Text(
                            'You can calculate the package payment details here.',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
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
                                'Calculate',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: myColor.primaryColorDark,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: myColor.primaryColorDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Container(
                width: maxWidth(context),
                margin: const EdgeInsets.only(top: 12.0),
                decoration: BoxDecoration(
                  color: myColor.dialogBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22.0),
                    topRight: Radius.circular(22.0),
                  ),
                ),
                child: StreamBuilder<dynamic>(
                    initialData: 0,
                    stream: refreshPackageBloc.stateStream,
                    builder: (context, refreshSnapshot) {
                      token = sharedPrefs.getFromDevice('token');
                      if (token != null) {
                        profileBloc!
                            .fetchAPIList(endpoints.getUserProfileEndpoint);
                      }
                      return token == null
                          ? myPackageDetailsCard()
                          : StreamBuilder<ApiResponse<dynamic>>(
                              stream: profileBloc!.apiListStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.LOADING:
                                      return SizedBox(
                                        width: maxWidth(context),
                                        height: maxHeight(context),
                                        child: const Center(
                                          child: AnimatedLoading(),
                                        ),
                                      );
                                    case Status.COMPLETED:
                                      profileModel = ProfileModel.fromJson(
                                          snapshot.data!.data);
                                      return myPackageDetailsCard(
                                          showFillCompanyProfile: widget
                                                          .isCorporate ==
                                                      true &&
                                                  profileModel!.schoolProfile ==
                                                      null
                                              ? null
                                              : profileModel!.schoolProfile);
                                    case Status.ERROR:
                                      return Container(
                                        width: maxWidth(context),
                                        margin: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text('Server this Error'),
                                        ),
                                      );
                                  }
                                }
                                return Container();
                              });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myPackageDetailsCard({showFillCompanyProfile}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(14.0, 0, 14.0,
              isPaymentIntervalDropDownOpened2 == true ? 200 : 80),
          height: maxHeight(context),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: kBlack,
                    primaryColor: kBlack,
                    dividerColor: kTransparent,
                  ),
                  child: ExpansionTile(
                      iconColor: myColor.primaryColorDark,
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: Text(
                          'Package Details',
                          style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      children: <Widget>[
                        Container(
                          width: maxWidth(context),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: kWhite.withOpacity(0.4),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: htmlText(
                              widget.packagesModel.description.toString()),
                        ),
                      ]),
                ),
                const SizedBox8(),
                token == null ? myPackageFeeCard() : familySizeStreamBuilder()
              ],
            ),
          ),
        ),

        // Column(
        //   children: [
        //     !_isVisible
        //         ? Container()
        //         : Column(
        //             children: [
        //               calculateAmountRow(
        //                   'GD Enrollment Fee', 'Rs $oneRegistrationFee'),
        //               calculateAmountRow(
        //                   'Monthly Fee Per Person', 'Rs $oneMonthlyFee'),
        //               calculateAmountRow('Monthly Fee After Discount',
        //                   'Rs $totalPayableAmountAfterDiscount'),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     'Total Payable Amount',
        //                     style: kStyleNormal.copyWith(fontSize: 14.0),
        //                   ),
        //                   Text(
        //                     'Rs $totalPayableAmount',
        //                     style: kStyleNormal.copyWith(fontSize: 14.0),
        //                   ),
        //                 ],
        //               ),
        //               const SizedBox16(),
        //             ],
        //           ),
        //   ],
        // )
        Positioned(
          bottom: 1,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            width: maxWidth(context),
            child: StreamBuilder<dynamic>(
                initialData: showFillCompanyProfile,
                stream: showFillCompanyProfileBloc.stateStream,
                builder: (compContext, compSnapshot) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: StreamBuilder<dynamic>(
                            initialData: -1,
                            stream: priceBloc.stateStream,
                            builder: (context, snapshot) {
                              return SizedBox(
                                // padding: const EdgeInsets.only(left: 3.0),
                                height: 60.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total',
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
                                            text: snapshot.data == -1
                                                ? '0'
                                                : totalPayableAmount2
                                                    .toString(),
                                            style: kStyleNormal.copyWith(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox2(),
                                    const SizedBox2(),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: StreamBuilder<dynamic>(
                            initialData: profileModel != null &&
                                    profileModel!.gender != null &&
                                    profileModel!.dob != null
                                ? true
                                : false,
                            stream: isPackageBookingBloc.stateStream,
                            builder: (c, snapshot) {
                              if (snapshot.data == true) {
                                return StreamBuilder<dynamic>(
                                    initialData: false,
                                    stream: loadingBtnBloc.stateStream,
                                    builder: (c, snapshot) {
                                      if (snapshot.data == true) {
                                        return myBtnLoading(context, 50.0);
                                      } else {
                                        return StreamBuilder<dynamic>(
                                            initialData: -1,
                                            stream: priceBloc.stateStream,
                                            builder: (c, s) {
                                              return SizedBox(
                                                height: 50.0,
                                                child: StreamBuilder<dynamic>(
                                                    initialData: null,
                                                    stream: showHideBookBtnBloc
                                                        .stateStream,
                                                    builder: (showHideCntext,
                                                        showHideSnapshot) {
                                                      return myCustomButton(
                                                        context,
                                                        myColor
                                                            .primaryColorDark,
                                                        'Book Package',
                                                        kStyleNormal.copyWith(
                                                            fontSize: 16.0,
                                                            color: kWhite,
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        () {
                                                          if (token == null) {
                                                            showLoginPopUp(
                                                              context,
                                                              'buyPackage',
                                                              GuestLoginNavigationModel(),
                                                            );
                                                          } else {
                                                            if (widget.isCorporate ==
                                                                    false &&
                                                                compSnapshot
                                                                        .data !=
                                                                    null) {
                                                              pop_upHelper
                                                                  .popUpNavigatorPop(
                                                                context,
                                                                1,
                                                                CoolAlertType
                                                                    .error,
                                                                'Since you have a company profile, you can only buy corporate package.',
                                                              );
                                                            } else {
                                                              if (compSnapshot
                                                                          .data ==
                                                                      null &&
                                                                  widget.isCorporate ==
                                                                      true) {
                                                                pop_upHelper.popUpToNewScreen(
                                                                    context,
                                                                    CoolAlertType
                                                                        .info,
                                                                    'In order to buy a corporate package you need to fill up your company profile.',
                                                                    const CompanyProfileFormScreen());
                                                              } else {
                                                                if (compSnapshot
                                                                            .data !=
                                                                        null &&
                                                                    compSnapshot
                                                                            .data
                                                                            .status ==
                                                                        'pending' &&
                                                                    widget.isCorporate ==
                                                                        true) {
                                                                  pop_upHelper.popUpNavigatorPop(
                                                                      context,
                                                                      1,
                                                                      CoolAlertType
                                                                          .info,
                                                                      'Please wait until your company profile get\'s verfied.');
                                                                } else {
                                                                  if (showHideSnapshot
                                                                          .data !=
                                                                      null) {
                                                                    pop_upHelper.popUpNavigatorPop(
                                                                        context,
                                                                        1,
                                                                        CoolAlertType
                                                                            .info,
                                                                        showHideSnapshot
                                                                            .data
                                                                            .toString());
                                                                  } else {
                                                                    bookPackageForUpdatedProfileBtn(
                                                                        context,
                                                                        s.data);
                                                                  }
                                                                }
                                                              }
                                                            }
                                                          }
                                                        },
                                                      );
                                                    }),
                                              );
                                            });
                                      }
                                    });
                              } else {
                                return StreamBuilder<dynamic>(
                                    initialData: -1,
                                    stream: priceBloc.stateStream,
                                    builder: (c, s) {
                                      return SizedBox(
                                        height: 50.0,
                                        child: StreamBuilder<dynamic>(
                                            initialData: null,
                                            stream:
                                                showHideBookBtnBloc.stateStream,
                                            builder: (showHideCntext,
                                                showHideSnapshot) {
                                              return myCustomButton(
                                                context,
                                                myColor.primaryColorDark,
                                                'Book Package',
                                                kStyleNormal.copyWith(
                                                    fontSize: 16.0,
                                                    color: kWhite,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                () {
                                                  if (token == null) {
                                                    showLoginPopUp(
                                                      context,
                                                      'buyPackage',
                                                      GuestLoginNavigationModel(),
                                                    );
                                                  } else {
                                                    if (widget.isCorporate ==
                                                            false &&
                                                        compSnapshot.data !=
                                                            null) {
                                                      pop_upHelper
                                                          .popUpNavigatorPop(
                                                        context,
                                                        1,
                                                        CoolAlertType.error,
                                                        'Since you have a company profile, you can only buy corporate package.',
                                                      );
                                                    } else {
                                                      if (compSnapshot.data ==
                                                              null &&
                                                          widget.isCorporate ==
                                                              true) {
                                                        pop_upHelper.popUpToNewScreen(
                                                            context,
                                                            CoolAlertType.info,
                                                            'In order to buy a corporate package you need to fill up your company profile.',
                                                            const CompanyProfileFormScreen());
                                                      } else {
                                                        if (compSnapshot.data !=
                                                                null &&
                                                            compSnapshot.data
                                                                    .status ==
                                                                'pending' &&
                                                            widget.isCorporate ==
                                                                true) {
                                                          pop_upHelper
                                                              .popUpNavigatorPop(
                                                                  context,
                                                                  1,
                                                                  CoolAlertType
                                                                      .info,
                                                                  'Please wait until your company profile get\'s verfied.');
                                                        } else {
                                                          if (showHideSnapshot
                                                                  .data !=
                                                              null) {
                                                            pop_upHelper.popUpNavigatorPop(
                                                                context,
                                                                1,
                                                                CoolAlertType
                                                                    .info,
                                                                showHideSnapshot
                                                                    .data
                                                                    .toString());
                                                          } else {
                                                            bookPackageBtn(
                                                                context,
                                                                s.data);
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                },
                                              );
                                            }),
                                      );
                                    });
                              }
                            }),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget familySizeStreamBuilder() {
    ApiHandlerBloc? packageFamilySizeBloc;
    packageFamilySizeBloc = ApiHandlerBloc();
    if (token != null) {
      packageFamilySizeBloc.fetchAPIList(
          'admin/userpackage/calculate-amount/${widget.packagesModel.id}');
    }

    return StreamBuilder<ApiResponse<dynamic>>(
      stream: packageFamilySizeBloc.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Container(
                width: maxWidth(context),
                height: maxHeight(context) / 2,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: const AnimatedLoading(),
              );
            case Status.COMPLETED:
              getPackageFamilySize =
                  GetPackageFamilySize.fromJson(snapshot.data!.data);
              paymentIntervalValue2 =
                  packagepaymentIntervalList[0].name.toString();
              month = packagepaymentIntervalList[0].month;
              discount = packagepaymentIntervalList[0].discount;
              dynamicCalculation(
                double.parse(
                    getPackageFamilySize!.packagefee!.familySize.toString()),
                double.parse(
                    getPackageFamilySize!.packagefee!.oneMonthlyFee.toString()),
                double.parse(getPackageFamilySize!
                    .packagefee!.oneRegistrationFee
                    .toString()),
              );
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                        child: Text(
                      'No family added',
                      style: kStyleNormal,
                    )));
              }
              if (getPackageFamilySize!.message != 'success') {
                showHideBookBtnBloc.storeData(getPackageFamilySize!.message);
              }
              return
                  // getPackageFamilySize!.message != 'success'
                  //     ? infoCard(
                  //         context,
                  //         kWhite.withOpacity(0.2),
                  //         myColor.primaryColorDark,
                  //         getPackageFamilySize!.message.toString())
                  // :
                  myPackageFeeCard();
            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 135.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('Server Error', style: kStyleNormal),
                ),
              );
          }
        }
        return const SizedBox();
      }),
    );
  }

  Widget myPackageFeeCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Details',
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox12(),
        Container(
            width: maxWidth(context),
            decoration: BoxDecoration(
              borderRadius: isSwitched == true
                  ? const BorderRadius.all(
                      Radius.circular(12.0),
                    )
                  : !isPaymentIntervalDropDownOpened2
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
              color: Colors.white.withOpacity(0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox12(),
                token == null
                    ? const SizedBox()
                    : bookingDetailsCard(
                        getPackageFamilySize!.message != 'success'
                            ? 'Minimum family size'
                            : 'Your Family Size',
                        getPackageFamilySize!.packagefee!.familySize
                            .toString()),
                token == null ? const SizedBox() : paddingDivider(),
                bookingDetailsCard(
                    'Registration Fee/Family',
                    token == null
                        ? 'Rs 0'
                        : 'Rs  ${getPackageFamilySize!.packagefee!.oneRegistrationFee.toString()}'),
                paddingDivider(),
                bookingDetailsCard(
                    'Monthly Fee/Person',
                    token == null
                        ? 'Rs 0'
                        : 'Rs  ${getPackageFamilySize!.packagefee!.oneMonthlyFee.toString()}'),
                const SizedBox12(),
              ],
            )),
        StatefulBuilder(builder: (context, myState) {
          return Column(
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    onMenuStateChange: (v) {
                      myState(() {
                        isPaymentIntervalDropDownOpened2 = v;
                        dropdownWhileBookingPackage = true;
                      });
                    },
                    isExpanded: true,
                    hint: Text(
                      'as',
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                    ),
                    items: packagepaymentIntervalList
                        .map((item) => DropdownMenuItem<String>(
                              value: item.name,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month_outlined,
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
                    value: paymentIntervalValue2 ??
                        packagepaymentIntervalList[0].name,
                    onChanged: (value) {
                      myState(() {
                        _isVisible2 = true;

                        paymentIntervalValue2 = value as String;
                        for (int i = 0;
                            i < packagepaymentIntervalList.length;
                            i++) {
                          if (packagepaymentIntervalList[i].name ==
                              paymentIntervalValue2) {
                            month = packagepaymentIntervalList[i].month;
                            discount = packagepaymentIntervalList[i].discount;
                          }
                        }
                        dynamicCalculation(
                          double.parse(getPackageFamilySize!
                              .packagefee!.familySize
                              .toString()),
                          double.parse(getPackageFamilySize!
                              .packagefee!.oneMonthlyFee
                              .toString()),
                          double.parse(getPackageFamilySize!
                              .packagefee!.oneRegistrationFee
                              .toString()),
                        );
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
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: !isPaymentIntervalDropDownOpened2
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            )
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                            ),
                    ),
                    itemHeight: 35,
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 150,
                    dropdownPadding:
                        const EdgeInsets.fromLTRB(0.0, 0.0, 14.0, 14.0),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: isPaymentIntervalDropDownOpened2
                          ? const BorderRadius.all(Radius.circular(12.0))
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            ),
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              isPaymentIntervalDropDownOpened2 == true
                  ? const SizedBox(height: 148.0)
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          );
        }),
        StatefulBuilder(builder: (context, myState) {
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox12(),
                  Text(
                    'Select Payment Method',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox12(),
                  paymentMethod(context, false, true,
                      onValueChanged: (String value) {
                    selectedPaymentMethod = value;
                  }),
                ],
              ),
              const SizedBox12(),
              // Container(
              //   decoration:
              //       BoxDecoration(
              //     color: Colors
              //         .white
              //         .withOpacity(0.4),
              //     borderRadius:
              //         const BorderRadius.all(
              //       Radius.circular(
              //           12.0),
              //     ),
              //   ),
              //   padding: const EdgeInsets
              //           .fromLTRB(
              //       14.0,
              //       2.0,
              //       2.0,
              //       2.0),
              //   child:
              //       Row(
              //     mainAxisAlignment:
              //         MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Pay Later',
              //         style:
              //             kStyleNormal.copyWith(
              //           fontSize: 14.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Switch(
              //         value:
              //             isSwitched,
              //         onChanged:
              //             (value) async {
              //           myState(() {
              //             isSwitched = value;
              //           });
              //           print(isSwitched);
              //         },
              //         activeTrackColor:
              //             myColor.primaryColorDark.withOpacity(0.3),
              //         activeColor:
              //             myColor.primaryColorDark,
              //         inactiveTrackColor:
              //             Colors.grey[200],
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox12(),
              const SizedBox32(),
            ],
          );
        }),
      ],
    );
  }

  Widget bookingDetailsCard(textValue, amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            textValue,
            style: kStyleNormal.copyWith(fontSize: 12.0),
          ),
          Text(
            amount,
            style: kStyleNormal.copyWith(
                fontSize: 14.0, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget paddingDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: const [
          SizedBox8(),
          Divider(),
          SizedBox8(),
        ],
      ),
    );
  }
}
