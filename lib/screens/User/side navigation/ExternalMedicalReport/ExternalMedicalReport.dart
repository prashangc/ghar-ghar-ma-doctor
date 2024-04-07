import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/ExternalMedicalReport/ExternalMedicalIndividualPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/ReportPdfViewer.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ExternalMedicalReportPage extends StatefulWidget {
  const ExternalMedicalReportPage({super.key});

  @override
  State<ExternalMedicalReportPage> createState() =>
      _ExternalMedicalReportPageState();
}

class _ExternalMedicalReportPageState extends State<ExternalMedicalReportPage> {
  ApiHandlerBloc? requestBloc;
  StateHandlerBloc submitBloc = StateHandlerBloc();
  StateHandlerBloc refreshState = StateHandlerBloc();
  StateHandlerBloc searchedDataBloc = StateHandlerBloc();
  StateHandlerBloc bottomNavigationBloc = StateHandlerBloc();
  List<String> listOfBase64Images = [];
  String? base64Image, search;
  List<MedicalReport> listOfReport = [];
  ApiHandlerBloc? packagesListBloc;
  @override
  void initState() {
    super.initState();
    packagesListBloc = ApiHandlerBloc();
    packagesListBloc!.fetchAPIList(endpoints.getIndividualPackageEndpoint);
    requestBloc = ApiHandlerBloc();
    requestBloc!.fetchAPIList(endpoints.getExternalMedicalDetailsEndpoint);
  }

  postMedicalReport(context) async {
    if (listOfBase64Images.isEmpty) {
      myToast.toast("Upload medical report");
    } else {
      submitBloc.storeData(1);
      int statusCode = await API().postData(
          context,
          PostExternalMedicalDetailsModel(report: listOfBase64Images),
          endpoints.postExternalMedicalDetailsEndpoint);
      if (statusCode == 200) {
        submitBloc.storeData(0);
        Navigator.pop(context);
        listOfReport.clear();
        refreshState.storeData('refresh');
        mySnackbar.mySnackBar(context, 'Report uploaded successfully ', kGreen);
      } else {
        submitBloc.storeData(0);
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
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Medical History',
          color: backgroundColor,
          borderRadius: 0.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 8.0),
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
                child: StreamBuilder<ApiResponse<dynamic>>(
                  stream: packagesListBloc!.apiListStream,
                  builder: ((c, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return SizedBox(
                            width: maxWidth(context),
                            height: maxHeight(context) / 2,
                            child: const Center(
                              child: AnimatedLoading(),
                            ),
                          );
                        case Status.COMPLETED:
                          IndividualPackagesListModel
                              individualPackagesListModel =
                              IndividualPackagesListModel.fromJson(
                                  snapshot.data!.data);
                          return StreamBuilder<dynamic>(
                              initialData: 1,
                              stream: refreshState.stateStream,
                              builder: (ct, st) {
                                if (st.data == 'refresh') {
                                  requestBloc = ApiHandlerBloc();
                                  requestBloc!.fetchAPIList(endpoints
                                      .getExternalMedicalDetailsEndpoint);
                                }
                                return StreamBuilder<ApiResponse<dynamic>>(
                                  stream: requestBloc!.apiListStream,
                                  builder: ((c, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            width: maxWidth(context),
                                            height: maxHeight(context) / 4,
                                            decoration: BoxDecoration(
                                              color:
                                                  myColor.dialogBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const AnimatedLoading(),
                                          );
                                        case Status.COMPLETED:
                                          List<ExternalMedicalDetailsModel>
                                              externalMedicalDetailsModel =
                                              List<ExternalMedicalDetailsModel>.from(
                                                  snapshot.data!.data.map((i) =>
                                                      ExternalMedicalDetailsModel
                                                          .fromJson(i)));
                                          return (individualPackagesListModel.myPackage !=
                                                      null &&
                                                  individualPackagesListModel
                                                          .myPackage!
                                                          .packageStatus !=
                                                      'Not Booked')
                                              ? packageBookedCaseCard(
                                                  externalMedicalDetailsModel)
                                              : packageNotBookedCaseCard(
                                                  context,
                                                  externalMedicalDetailsModel,
                                                  individualPackagesListModel
                                                              .myPackage!
                                                              .packageStatus ==
                                                          'Not Booked'
                                                      ? true
                                                      : false);

                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            height: 135.0,
                                            decoration: BoxDecoration(
                                              color: kWhite.withOpacity(0.4),
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
                              });
                        case Status.ERROR:
                          return Container(
                            width: maxWidth(context),
                            height: 135.0,
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Server yhis error'),
                            ),
                          );
                      }
                    }
                    return const SizedBox();
                  }),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: StreamBuilder<dynamic>(
            initialData: 'loading',
            stream: bottomNavigationBloc.stateStream,
            builder: (c, s) {
              return s.data == 'loading'
                  ? SizedBox(
                      width: maxWidth(context),
                      height: 0.0,
                    )
                  : Container(
                      color: myColor.dialogBackgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      width: maxWidth(context),
                      height: 60.0,
                      child: Row(
                        children: [
                          s.data == 'dontshow'
                              ? Container()
                              : Expanded(
                                  child: SizedBox(
                                    height: 50.0,
                                    child: myCustomButton(
                                        context,
                                        myColor.primaryColorDark,
                                        s.data == 'showPayNow'
                                            ? 'Pay Now'
                                            : 'Buy Package',
                                        kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          color: kWhite,
                                        ), () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainHomePage(
                                                    index: 2,
                                                    tabIndex: 0,
                                                    showPaymentUI:
                                                        s.data == 'showPayNow'
                                                            ? true
                                                            : null,
                                                  )),
                                          (route) => false);
                                    }),
                                  ),
                                ),
                          s.data == 'dontshow'
                              ? Container()
                              : const SizedBox(width: 12.0),
                          Expanded(
                            child: SizedBox(
                              height: 50.0,
                              child: myCustomButton(
                                  context,
                                  myColor.primaryColorDark,
                                  'Add Report',
                                  kStyleNormal.copyWith(
                                    fontSize: 14.0,
                                    color: kWhite,
                                  ), () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                        myColor.dialogBackgroundColor,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: ((builder) =>
                                        addReportBottomSheet(context)));
                              }),
                            ),
                          )
                        ],
                      ),
                    );
            }),
      ),
    );
  }

  packageBookedCaseCard(externalMedicalDetailsModel) {
    bottomNavigationBloc.storeData('dontshow');
    return Column(
      children: [
        mytextFormFieldWithPrefixIcon(
          context,
          FocusNode(),
          null,
          search ?? 'Search here',
          '',
          search,
          Icons.search,
          kWhite.withOpacity(0.4),
          onValueChanged: (v) {
            List<ExternalMedicalDetailsModel> results =
                externalMedicalDetailsModel.where((detail) {
              final lowerCaseQuery = v.toLowerCase();
              return detail.toJson().values.any((value) {
                return value.toString().toLowerCase().contains(lowerCaseQuery);
              });
            }).toList();
            searchedDataBloc.storeData(results);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder<dynamic>(
                initialData: externalMedicalDetailsModel,
                stream: searchedDataBloc.stateStream,
                builder: (searchContext, searchSnapshot) {
                  return ListView.builder(
                      itemCount: searchSnapshot.data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return requestCard(
                          context,
                          searchSnapshot.data[i],
                        );
                      });
                }),
          ),
        ),
      ],
    );
  }

  Widget requestCard(context, ExternalMedicalDetailsModel data) {
    return GestureDetector(
      onTap: () {
        goThere(context,
            ExternalMedicalIndividualPage(externalMedicalDetailsModel: data));
      },
      child: Container(
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
            dateDetails(data),
            doctorDetails(data),
            statusDetails(data),
          ],
        ),
      ),
    );
  }

  Widget dateDetails(ExternalMedicalDetailsModel data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Checked Date :',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.createdAt!.substring(0, 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox2(),
        const SizedBox2(),
        Divider(
          color: myColor.dialogBackgroundColor,
        ),
        const SizedBox2(),
        const SizedBox2(),
      ],
    );
  }

  Widget myRow(title, value, {color}) {
    return Row(
      children: [
        Text(
          '$title : ',
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            color: color ?? kBlack,
          ),
        ),
      ],
    );
  }

  Widget doctorDetails(ExternalMedicalDetailsModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        data.status == 2
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor Details:',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      color: myColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox12(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myCachedNetworkImage(
                        60.0,
                        60.0,
                        data.doctor == null ? null : data.doctor!.imagePath,
                        const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        BoxFit.cover,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            myRow(
                                'Translated By',
                                data.doctor == null
                                    ? 'Pending'
                                    : data.doctor!.user!.name),
                            const SizedBox2(),
                            const SizedBox2(),
                            myRow(
                                'Hospital',
                                data.doctor == null ||
                                        data.doctor!.hospital!.isEmpty
                                    ? 'Pending'
                                    : data.doctor!.hospital![0].toString()),
                            const SizedBox2(),
                            const SizedBox2(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                    ],
                  ),
                  const SizedBox8(),
                  const Divider(),
                  const SizedBox8(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Checked By:',
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          color: myColor.primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox12(),
                      myRow('Doctor', data.doctorName ?? 'Pending'),
                      const SizedBox2(),
                      const SizedBox2(),
                      myRow('NMC Number', data.doctorNmc ?? 'Pending'),
                      const SizedBox2(),
                      const SizedBox2(),
                      myRow('Hospital', data.hospital ?? 'Pending'),
                      const SizedBox2(),
                      const SizedBox2(),
                    ],
                  ),
                  const SizedBox(width: 12.0),
                  const SizedBox12(),
                ],
              ),
        data.status != 2
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myRow('Rejected reason',
                      data.rejectReason ?? data.doctorRejectReason,
                      color: kRed),
                  const SizedBox12(),
                ],
              ),
      ],
    );
  }

  Widget statusDetails(ExternalMedicalDetailsModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'View More',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12.0),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: 14.0,
              color: myColor.primaryColorDark,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Status :',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: data.status == 0
                    ? myColor.primaryColorDark
                    : data.status == 1
                        ? kGreen
                        : kRed,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                data.status == 0
                    ? 'Pending'
                    : data.status == 1
                        ? 'Approved'
                        : 'Rejected',
                textAlign: TextAlign.center,
                style: kStyleNormal.copyWith(
                  fontSize: 10.0,
                  color: myColor.scaffoldBackgroundColor,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget addReportBottomSheet(context) {
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
                    color: const Color.fromARGB(255, 255, 205, 202),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                    border: Border.all(color: kRed, width: 1)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: kRed,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                              '* Please upload medical reports that belong to you',
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
              myFilePicker(
                  textValue: 'Medical Report',
                  color: kWhite.withOpacity(0.4),
                  onValueChanged: (v) {
                    if (v.base64String == null) {
                      listOfBase64Images = v.listOfBase64Images!;
                    } else {
                      listOfBase64Images.add(v.base64String!);
                    }
                  }),
              const SizedBox8(),
              StreamBuilder<dynamic>(
                  initialData: 0,
                  stream: submitBloc.stateStream,
                  builder: (c, s) {
                    return GestureDetector(
                      onTap: () {
                        if (s.data == 0) {
                          postMedicalReport(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Submit',
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
                                child: s.data == 0
                                    ? Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        size: 18.0,
                                        color: kWhite,
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: kWhite,
                                          strokeWidth: 1,
                                        ),
                                      )),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox16(),
            ],
          )),
    );
  }

  Widget packageNotBookedCaseCard(
      context, List<ExternalMedicalDetailsModel> data, paymentUnpaid) {
    if (paymentUnpaid = true) {
      bottomNavigationBloc.storeData('showPayNow');
    } else {
      bottomNavigationBloc.storeData('show');
    }
    for (var element in data) {
      for (var i in element.medicalReport!) {
        listOfReport.add(MedicalReport(
            reportPath: i.reportPath.toString(), report: i.report.toString()));
      }
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 205, 202),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      border: Border.all(color: kRed, width: 1)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: kRed,
                            size: 25.0,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                                paymentUnpaid == true
                                    ? '* Please pay for your subscription package to activate external medical history translation by GD Doctor.'
                                    : '* Buy Package in order to activate external medical history translation by GD Doctor.',
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
                const SizedBox12(),
                listOfReport.isEmpty
                    ? emptyPage(context, 'No any Reports',
                        'You haven\'t uploaded any medical report.', '', () {},
                        testColor: kBlack)
                    : ListView.builder(
                        itemCount: listOfReport.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            onTap: () {
                              goThere(
                                  context,
                                  ReportPdfViewer(
                                      url:
                                          listOfReport[i].reportPath.toString(),
                                      type: 'pdf',
                                      fileName:
                                          listOfReport[i].report.toString()));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                color: kWhite.withOpacity(0.4),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Hero(
                                    tag: 'imageHero',
                                    child: myCachedNetworkImage(
                                      30.0,
                                      30.0,
                                      '',
                                      const BorderRadius.all(
                                        Radius.circular(2.0),
                                      ),
                                      BoxFit.contain,
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        listOfReport[i].report.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.visibility,
                                    size: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
              ],
            ),
          ),
        ),
      ],
    );
  }
}
