import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/Insurance/PostDeathClaimInsuranceModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class InsuranceDetailsPage extends StatefulWidget {
  const InsuranceDetailsPage({Key? key}) : super(key: key);

  @override
  State<InsuranceDetailsPage> createState() => _InsuranceDetailsPageState();
}

class _InsuranceDetailsPageState extends State<InsuranceDetailsPage>
    with TickerProviderStateMixin {
  ApiHandlerBloc? insuranceListBloc, insuranceTypeBloc;
  StateHandlerBloc? btnBloc;
  String? _handWrittenBase64, _medicalReportBase64, _invoiceBase64;
  List<GetIDNameModel> getInsuranceType = [];
  List<GetIDNameModel> getDeathInsuranceType = [];
  List<GetIDNameModel> getMemberName = [];
  String? _insuranceType, _insuranceTypeID, _amount, _userName, _userId;
  bool isLoading = false;
  TabController? _tabController;
  DeathGetInsuranceTypeListModel? deathGetInsuranceTypeListModel;
  @override
  void initState() {
    insuranceListBloc = ApiHandlerBloc();
    insuranceTypeBloc = ApiHandlerBloc();
    btnBloc = StateHandlerBloc();
    insuranceListBloc!.fetchAPIList(endpoints.getInsuranceDetailsEndpoint);
    insuranceTypeBloc!.fetchAPIList(endpoints.getInsuranceTypeEndpoint);
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  validationForm() {
    if (_insuranceTypeID == null) {
      myToast.toast('Please select insurance type');
      return false;
    } else if (_amount == null) {
      myToast.toast('Please enter claim amount');
      return false;
    } else if (_invoiceBase64 == null) {
      myToast.toast('Please upload your invoice');
      return false;
    } else if (_medicalReportBase64 == null) {
      myToast.toast('Please upload medical report');
      return false;
    } else if (_handWrittenBase64 == null) {
      myToast.toast('Please upload handwritten letter');
      return false;
    } else {
      return true;
    }
  }

  getDeathClaimData(context) async {
    var resp =
        await API().getData(context, endpoints.getDeathInsuranceTypeEndpoint);
    if (resp != null) {
      deathGetInsuranceTypeListModel =
          DeathGetInsuranceTypeListModel.fromJson(resp);
      getDeathInsuranceType.clear();
      for (int i = 0;
          i < deathGetInsuranceTypeListModel!.insuranceTypes!.length;
          i++) {
        getDeathInsuranceType.add(GetIDNameModel(
          id: deathGetInsuranceTypeListModel!
              .insuranceTypes![i].insurancetype!.id
              .toString(),
          name: deathGetInsuranceTypeListModel!
              .insuranceTypes![i].insurancetype!.type
              .toString(),
        ));
      }
      getMemberName.clear();
      for (int i = 0;
          i < deathGetInsuranceTypeListModel!.members!.length;
          i++) {
        getMemberName.add(GetIDNameModel(
          id: deathGetInsuranceTypeListModel!.members![i].memberId.toString(),
          name:
              deathGetInsuranceTypeListModel!.members![i].user!.name.toString(),
        ));
      }
      setState(() {});
    }
  }

  submitBtn(context) async {
    if (validationForm()) {
      btnBloc!.storeData(!isLoading);
      int statusCode;
      statusCode = await API().postData(
          context,
          _tabController!.index == 0
              ? PostClaimInsuranceModel(
                  claimAmount: double.parse(_amount.toString()),
                  handWrittenLetter: _handWrittenBase64,
                  insuranceId: int.parse(_insuranceTypeID.toString()),
                  invoice: _invoiceBase64,
                  medicalReport: _medicalReportBase64,
                )
              : PostDeathClaimInsuranceModel(
                  userID: int.parse(_userId.toString()),
                  claimAmount: double.parse(_amount.toString()),
                  handWrittenLetter: _handWrittenBase64,
                  packageInsuranceID: int.parse(_insuranceTypeID.toString()),
                  invoice: _invoiceBase64,
                  medicalReport: _medicalReportBase64,
                ),
          _tabController!.index == 0
              ? endpoints.postClaimInsuranceEndpoint
              : endpoints.postDeathInsuranceClaimEndpoint);
      if (statusCode == 200) {
        btnBloc!.storeData(isLoading);
        pop_upHelper.popUpNavigatorPop(context, 2, CoolAlertType.success,
            'Insurance claim request has been made');
      } else {
        btnBloc!.storeData(isLoading);
        mySnackbar.mySnackBar(context, 'Error $statusCode', kRed);
      }
    }
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
          title: 'Insurance',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
          margin: const EdgeInsets.only(top: 12.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder<ApiResponse<dynamic>>(
              stream: insuranceTypeBloc!.apiListStream,
              builder: ((c, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return SizedBox(
                        width: maxWidth(context),
                        height: maxHeight(context) / 1.4,
                        child: const AnimatedLoading(),
                      );
                    case Status.COMPLETED:
                      if (snapshot.data!.data.isEmpty) {
                        return Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'No insurance added',
                              style: kStyleNormal,
                            ),
                          ),
                        );
                      }
                      GetInsuranceTypeListModel getInsuranceTypeListModel =
                          GetInsuranceTypeListModel.fromJson(
                              snapshot.data!.data);
                      getInsuranceType.clear();
                      for (int i = 0;
                          i < getInsuranceTypeListModel.coverage!.length;
                          i++) {
                        getInsuranceType.add(GetIDNameModel(
                          id: getInsuranceTypeListModel.coverage![i].id
                              .toString(),
                          name: getInsuranceTypeListModel
                              .coverage![i].insurancetype!.type
                              .toString(),
                        ));
                      }
                      if (getInsuranceTypeListModel.insurance!.status == 1) {
                        getDeathClaimData(context);
                      }
                      return getInsuranceTypeListModel.insurance!.status == 0
                          ? emptyPage(
                              context,
                              'Insurance Not Activated',
                              'Your insurance has not been activated yet.',
                              'Back',
                              () {
                                Navigator.pop(context);
                              },
                              testColor: kBlack,
                            )
                          : getInsuranceTypeListModel.insurance!.status == 2
                              ? emptyPage(
                                  context,
                                  'Insurance De-activated',
                                  'Your insurance has been deactivated.',
                                  'Back',
                                  () {
                                    Navigator.pop(context);
                                  },
                                  testColor: kBlack,
                                )
                              : StreamBuilder<ApiResponse<dynamic>>(
                                  stream: insuranceListBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return SizedBox(
                                            width: maxWidth(context),
                                            height: maxHeight(context) / 1.4,
                                            child: const AnimatedLoading(),
                                          );
                                        case Status.COMPLETED:
                                          if (snapshot.data!.data.isEmpty) {
                                            return Container(
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'No insurance added',
                                                  style: kStyleNormal,
                                                ),
                                              ),
                                            );
                                          }
                                          GetInsuranceDetailsModel
                                              insuranceModel =
                                              GetInsuranceDetailsModel.fromJson(
                                                  snapshot.data!.data);

                                          return myInsuranceDetails(
                                              insuranceModel);

                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            height: 135.0,
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
                return const SizedBox();
              }),
            ),
          ),
        ),
      ),
    );
  }

  double animationPercentCalculator(total, type) {
    double percentage = type / total;
    double value = 1.0 - percentage;
    return value;
  }

  Widget myInsuranceDetails(GetInsuranceDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          myCircularCard(
            'Claimed Amount',
            'Rs. ${data.claimed}',
            animationPercentCalculator(double.parse(data.total.toString()),
                double.parse(data.claimed.toString())),
          ),
          const SizedBox(width: 12.0),
          myCircularCard(
            'Remaining Amount',
            'Rs. ${data.remaining}',
            animationPercentCalculator(double.parse(data.total.toString()),
                double.parse(data.remaining.toString())),
          ),
        ]),
        const SizedBox12(),
        Container(
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            children: [
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 12.0,
                isRTL: true,
                backgroundColor: myColor.primaryColorDark,
                animation: true,
                animationDuration: 1000,
                percent: animationPercentCalculator(
                    double.parse(data.total.toString()),
                    double.parse(data.remaining.toString())),
                progressColor: myColor.dialogBackgroundColor,
              ),
              const SizedBox8(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Insurance',
                    style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14.0),
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
                          text: data.remaining.toString(),
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
            ],
          ),
        ),
        const SizedBox12(),
        Container(
            width: maxWidth(context),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox12(),
                myRow('Insurance Criteria', 'Remaining Amount', 'Total Amount',
                    makeBold: true),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: data.insurance!.length,
                    itemBuilder: (ctx, i) {
                      return myRow(
                        data.insurance![i].type,
                        'Rs ${data.insurance![i].remaining}',
                        'Rs ${data.insurance![i].total}',
                        showDivider:
                            i == data.insurance!.length - 1 ? false : true,
                      );
                    }),
                const SizedBox12(),
              ],
            )),
        const SizedBox16(),
        insuranceClaimForm(),
      ],
    );
  }

  Widget myCircularCard(title, amount, percent) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: CircularPercentIndicator(
          radius: 30.0,
          lineWidth: 4.0,
          animation: true,
          animationDuration: 2000,
          progressColor: myColor.dialogBackgroundColor,
          percent: percent,
          animateFromLastPercent: true,
          backgroundColor: myColor.primaryColorDark,
          center: Icon(
            Icons.monetization_on_outlined,
            color: myColor.primaryColorDark,
            size: 15,
          ),
          footer: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: kStyleNormal.copyWith(fontSize: 12.0),
                ),
                const SizedBox2(),
                Text(
                  amount,
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ],
            ),
          ),
          circularStrokeCap: CircularStrokeCap.square,
        ),
      ),
    );
  }

  Widget myRow(one, two, three, {showDivider, makeBold}) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  width: maxWidth(context) / 2.5,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 2.0,
                        color: myColor.dialogBackgroundColor,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      makeBold == true
                          ? Text(
                              one,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              one,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 2.0,
                          color: myColor.dialogBackgroundColor,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 18.0),
                    child: Text(
                      two,
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 2.0,
                          color: kTransparent,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 18.0),
                    child: Text(
                      three,
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        showDivider == false
            ? Container()
            : Container(
                color: myColor.dialogBackgroundColor,
                height: 2,
                width: maxWidth(context),
              ),
      ],
    );
  }

  Widget insuranceClaimForm() {
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
              onTap: (i) {
                setState(() {
                  _tabController!.index = i;
                });
              },
              tabs: [
                Tab(
                  child: Text(
                    'Claim Normal Insurance',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 12,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Claim Death Insurance',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox12(),
        Container(
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox12(),
              Text(
                'Insurance Claim Form',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox8(),
              Text(
                'Fill the fields below accurately and we will get back to you in short time',
                style: kStyleNormal.copyWith(fontSize: 12.0, color: kBlack),
              ),
              const SizedBox24(),
              _tabController!.index == 0
                  ? Container()
                  : myDropdownsWidget(
                      'Select Username',
                      myDropDown2(
                          context,
                          FontAwesomeIcons.user,
                          Colors.black,
                          Colors.black,
                          maxWidth(context),
                          _userName == null
                              ? '   Select Username'
                              : '   $_userName',
                          getMemberName,
                          kWhite.withOpacity(0.4), onValueChanged: (value) {
                        setState(() {
                          _userId = value.id;
                          _userName = value.name;
                        });
                      })),
              const SizedBox16(),
              myDropdownsWidget(
                  'Select Insurance Type',
                  myDropDown2(
                      context,
                      FontAwesomeIcons.handHoldingHeart,
                      Colors.black,
                      Colors.black,
                      maxWidth(context),
                      _insuranceType == null
                          ? '   Select Insurance Type'
                          : '   $_insuranceType',
                      _tabController!.index == 0
                          ? getInsuranceType
                          : getDeathInsuranceType,
                      kWhite.withOpacity(0.4), onValueChanged: (value) {
                    setState(() {
                      _insuranceTypeID = value.id;
                      _insuranceType = value.name;
                    });
                  })),
              const SizedBox16(),
              myNumberTextFormField(
                  'Claim Amount',
                  'Claim Amount',
                  'Enter claim amount',
                  _amount,
                  Icons.attach_money_outlined,
                  kWhite.withOpacity(0.4), onValueChanged: (v) {
                _amount = v;
              }),
              const SizedBox8(),
              Text(
                'Upload Documents',
                style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 13.0),
              ),
              const SizedBox16(),
              myFilePicker(
                textValue: 'Upload Invoice',
                color: kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  setState(() {
                    _invoiceBase64 = value.base64String;
                  });
                },
              ),
              const SizedBox8(),
              myFilePicker(
                textValue: 'Upload Medical Report',
                color: kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  setState(() {
                    _medicalReportBase64 = value.base64String;
                  });
                },
              ),
              const SizedBox12(),
              myFilePicker(
                textValue: 'Upload Handwritten letter',
                color: kWhite.withOpacity(0.4),
                onValueChanged: (value) {
                  setState(() {
                    _handWrittenBase64 = value.base64String;
                  });
                },
              ),
              const SizedBox8(),
              StreamBuilder<dynamic>(
                  initialData: isLoading,
                  stream: btnBloc!.stateStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return myCircularIndicator();
                    } else {
                      return SizedBox(
                        width: maxWidth(context),
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Submit',
                          kStyleNormal.copyWith(
                            fontSize: 14.0,
                            color: kWhite,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.bold,
                          ),
                          () {
                            submitBtn(context);
                          },
                        ),
                      );
                    }
                  }),
              const SizedBox16(),
            ],
          ),
        ),
      ],
    );
  }

  Widget myDropDown2Loading(
      BuildContext context,
      titleText,
      icon,
      Color iconColor,
      Color titleTextColor,
      width,
      hintText,
      List<GetIDNameModel> listItemData,
      {required ValueChanged<GetIDNameModel>? onValueChanged}) {
    String? selectedValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
            color: titleTextColor,
          ),
        ),
        const SizedBox16(),
        DropdownButtonHideUnderline(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: SizedBox(
                width: maxWidth(context),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: iconColor,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        hintText,
                        overflow: TextOverflow.ellipsis,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              items: listItemData
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: SizedBox(
                          width: maxWidth(context),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.perm_identity,
                                size: 16,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                item.name.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
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
              buttonPadding: const EdgeInsets.only(left: 8),
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

  Widget myDropdownsWidget(titleText, Widget myWidget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        myWidget,
      ],
    );
  }

  Widget insuranceDetailsCard() {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: insuranceListBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return SizedBox(
                width: maxWidth(context),
                height: maxHeight(context) / 1.4,
                child: const AnimatedLoading(),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'No insurance added',
                      style: kStyleNormal,
                    ),
                  ),
                );
              }
              GetInsuranceDetailsModel insuranceModel =
                  GetInsuranceDetailsModel.fromJson(snapshot.data!.data);

              return myInsuranceDetails(insuranceModel);

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
        return const SizedBox();
      }),
    );
  }
}
