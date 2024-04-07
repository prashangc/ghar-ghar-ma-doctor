import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_html/flutter_html.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyLabsModel/MyLabsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/ReportPdfViewer.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LabReports extends StatefulWidget {
  const LabReports({Key? key}) : super(key: key);

  @override
  State<LabReports> createState() => _LabReportsState();
}

class _LabReportsState extends State<LabReports> with TickerProviderStateMixin {
  PdfViewerController? _pdfViewerController;
  ApiHandlerBloc? myReportBloc;
  StateHandlerBloc? tabBarBtnBloc,
      tabBarContentBtnBloc,
      dropDownBloc,
      graphBloc,
      dropDownValue;
  TabController? _tabController, _bottomTabController;
  List<MyLabsModel> scheduledModel = [],
      completedModel = [],
      notScheduledModel = [];
  List<Tab> tabs = <Tab>[];
  StateHandlerBloc viewPdfBloc = StateHandlerBloc();
  List<GetIDNameModel> list = [];
  GetIDNameModel dropDownValueModel = GetIDNameModel();
  // String? dropdownId, dropdownName;

  @override
  void initState() {
    myReportBloc = ApiHandlerBloc();
    dropDownBloc = StateHandlerBloc();
    myReportBloc!.fetchAPIList(endpoints.getmyReportDetailsEndpoint);
    _pdfViewerController = PdfViewerController();
    tabBarBtnBloc = StateHandlerBloc();
    graphBloc = StateHandlerBloc();
    tabBarContentBtnBloc = StateHandlerBloc();
    _bottomTabController =
        TabController(initialIndex: 0, length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'All Reports',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: StreamBuilder<ApiResponse<dynamic>>(
        stream: myReportBloc!.apiListStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return const Center(child: AnimatedLoading());
              case Status.COMPLETED:
                MyMedicalLabReportModel myMedicalLabReportModel =
                    MyMedicalLabReportModel.fromJson(snapshot.data!.data);
                if (myMedicalLabReportModel.message == 'success') {
                  _tabController = TabController(
                      initialIndex: 0,
                      length: myMedicalLabReportModel.labReportModel!.length,
                      vsync: this);
                  tabs.clear();
                  for (int i = 0;
                      i < myMedicalLabReportModel.labReportModel!.length;
                      i++) {
                    tabs.add(
                      Tab(
                        child: Text(
                          myMedicalLabReportModel.labReportModel![i]
                              .screeningdate!.screening!.screening
                              .toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    width: maxWidth(context),
                    height: maxHeight(context),
                    decoration: BoxDecoration(
                      color: myColor.dialogBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: myMedicalLabReportModel.message == 'success'
                        ? Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox12(),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    width: maxWidth(context),
                                    decoration: BoxDecoration(
                                      color: backgroundColor.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TabBar(
                                        isScrollable: true,
                                        onTap: (i) {
                                          if (_tabController!.indexIsChanging) {
                                            tabBarContentBtnBloc!.storeData(i);
                                            dropDownBloc!
                                                .storeData(GetIDNameModel());
                                          }
                                        },
                                        labelColor: kWhite,
                                        unselectedLabelColor: kBlack,
                                        controller: _tabController,
                                        indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: myColor.primaryColorDark,
                                        ),
                                        tabs: tabs,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder<dynamic>(
                                        initialData: 0,
                                        stream:
                                            tabBarContentBtnBloc!.stateStream,
                                        builder: (context,
                                            individualScreeningIndex) {
                                          return StreamBuilder<dynamic>(
                                              initialData: 0,
                                              stream:
                                                  tabBarBtnBloc!.stateStream,
                                              builder: (context, snapshot) {
                                                if (snapshot.data == 0) {
                                                  list.clear();
                                                  for (int i = 0;
                                                      i <
                                                          myMedicalLabReportModel
                                                              .labReportModel![
                                                                  individualScreeningIndex
                                                                      .data]
                                                              .labreports!
                                                              .length;
                                                      i++) {
                                                    if (myMedicalLabReportModel
                                                            .labReportModel![
                                                                individualScreeningIndex
                                                                    .data]
                                                            .labreports![i]
                                                            .labtest !=
                                                        null) {
                                                      list.add(GetIDNameModel(
                                                        id: i.toString(),
                                                        name: myMedicalLabReportModel
                                                            .labReportModel![
                                                                individualScreeningIndex
                                                                    .data]
                                                            .labreports![i]
                                                            .labtest!
                                                            .tests
                                                            .toString(),
                                                      ));
                                                    }
                                                  }

                                                  return SingleChildScrollView(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12.0),
                                                      child: Column(
                                                        children: [
                                                          const SizedBox12(),
                                                          StreamBuilder<
                                                                  dynamic>(
                                                              initialData:
                                                                  dropDownValueModel,
                                                              stream: dropDownBloc!
                                                                  .stateStream,
                                                              builder: (context,
                                                                  snapshot) {
                                                                return Column(
                                                                  children: [
                                                                    myMedicalLabReportModel
                                                                            .labReportModel![individualScreeningIndex
                                                                                .data]
                                                                            .labreports!
                                                                            .isEmpty
                                                                        ? infoCard(
                                                                            context,
                                                                            kWhite.withOpacity(0.4),
                                                                            myColor.primaryColorDark,
                                                                            'Please wait until lab technician uploads your report.')
                                                                        : myDropDown2(
                                                                            context,
                                                                            Icons.sort,
                                                                            myColor.primaryColorDark,
                                                                            kBlack,
                                                                            maxWidth(context),
                                                                            snapshot.data.name ??
                                                                                myMedicalLabReportModel.labReportModel![individualScreeningIndex.data].labreports![0].labtest!.tests.toString(),
                                                                            list,
                                                                            kWhite.withOpacity(0.4),
                                                                            onValueChanged:
                                                                                (v) {
                                                                              dropDownBloc!.storeData(GetIDNameModel(
                                                                                id: v.id,
                                                                                name: v.name,
                                                                              ));
                                                                              List<MyLabreports> tempList = [];
                                                                              tempList.clear();
                                                                              for (int i = 0; i < myMedicalLabReportModel.labReportModel!.length; i++) {
                                                                                if (int.parse(v.id.toString()) < myMedicalLabReportModel.labReportModel![i].labreports!.length) {
                                                                                  tempList.add(myMedicalLabReportModel.labReportModel![i].labreports![int.parse(v.id.toString())]);
                                                                                }
                                                                              }
                                                                              graphBloc!.storeData(tempList);
                                                                            },
                                                                          ),
                                                                    const SizedBox12(),
                                                                    myMedicalLabReportModel
                                                                            .labReportModel![individualScreeningIndex.data]
                                                                            .labreports!
                                                                            .isEmpty
                                                                        ? Container()
                                                                        : myReportCard(
                                                                            myMedicalLabReportModel.labReportModel![individualScreeningIndex.data].labreports![snapshot.data.id == null
                                                                                ? 0
                                                                                : int.parse(snapshot.data.id.toString())],
                                                                          ),
                                                                    const SizedBox12(),
                                                                    myMedicalLabReportModel
                                                                            .labReportModel![individualScreeningIndex
                                                                                .data]
                                                                            .labreports!
                                                                            .isEmpty
                                                                        ? Container()
                                                                        : StreamBuilder<
                                                                                dynamic>(
                                                                            initialData:
                                                                                0,
                                                                            stream:
                                                                                graphBloc!.stateStream,
                                                                            builder: (context, data) {
                                                                              if (data.data == 0) {
                                                                                return infoCard(context, kWhite.withOpacity(0.4), kRed, 'Select test');
                                                                              } else {
                                                                                return myGraph(context, data.data);
                                                                              }
                                                                            }),
                                                                  ],
                                                                );
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else if (snapshot.data == 2) {
                                                  return myMedicalLabReportModel
                                                              .labReportModel![
                                                                  individualScreeningIndex
                                                                      .data]
                                                              .pdf ==
                                                          null
                                                      ? Column(
                                                          children: [
                                                            const SizedBox12(),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12.0),
                                                              child: infoCard(
                                                                  context,
                                                                  kWhite
                                                                      .withOpacity(
                                                                          0.4),
                                                                  myColor
                                                                      .primaryColorDark,
                                                                  'Please wait until lab technician uploads your report.'),
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            const SizedBox12(),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (await checkStoragePermission(
                                                                    Permission
                                                                        .storage)) {
                                                                  final file = await API().downloadFile(
                                                                      myMedicalLabReportModel
                                                                          .labReportModel![individualScreeningIndex
                                                                              .data]
                                                                          .pdf!
                                                                          .reportPath
                                                                          .toString(),
                                                                      myMedicalLabReportModel
                                                                          .labReportModel![
                                                                              individualScreeningIndex.data]
                                                                          .pdf!
                                                                          .report
                                                                          .toString());
                                                                }
                                                              },
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'Download File',
                                                                  style: kStyleNormal
                                                                      .copyWith(
                                                                    color: myColor
                                                                        .primaryColorDark,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox12(),
                                                            myMedicalLabReportModel
                                                                        .labReportModel![individualScreeningIndex
                                                                            .data]
                                                                        .pdf ==
                                                                    null
                                                                ? infoCard(
                                                                    context,
                                                                    kWhite
                                                                        .withOpacity(
                                                                            0.4),
                                                                    myColor
                                                                        .primaryColorDark,
                                                                    'Please wait until lab technician uploads your report.')
                                                                : Expanded(
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              12.0),
                                                                      child: SfPdfViewer
                                                                          .network(
                                                                        myMedicalLabReportModel
                                                                            .labReportModel![individualScreeningIndex.data]
                                                                            .pdf!
                                                                            .reportPath
                                                                            .toString(),
                                                                        controller:
                                                                            _pdfViewerController,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        );
                                                } else {
                                                  return ListView.builder(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemCount:
                                                          myMedicalLabReportModel
                                                              .labReportModel![
                                                                  individualScreeningIndex
                                                                      .data]
                                                              .advice!
                                                              .length,
                                                      itemBuilder: (c, i) {
                                                        return myConsultatantReportCard(
                                                            myMedicalLabReportModel
                                                                .labReportModel![
                                                                    individualScreeningIndex
                                                                        .data]
                                                                .advice![i]);
                                                      });
                                                }
                                              });
                                        }),
                                  ),
                                  const SizedBox32(),
                                  const SizedBox32(),
                                  const SizedBox12(),
                                ],
                              ),
                              Positioned(
                                bottom: 12.0,
                                left: 12.0,
                                right: 12.0,
                                child: Container(
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
                                      onTap: (i) {
                                        if (_bottomTabController!
                                            .indexIsChanging) {
                                          tabBarBtnBloc!.storeData(i);
                                        }
                                      },
                                      controller: _bottomTabController,
                                      indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: myColor.primaryColorDark,
                                      ),
                                      tabs: [
                                        Tab(
                                          child: Text(
                                            'Lab Report',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.sourceSansPro(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'Consultant Report',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.sourceSansPro(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'View Pdf',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.sourceSansPro(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              infoCard(
                                  context,
                                  kWhite.withOpacity(0.4),
                                  myColor.primaryColorDark,
                                  myMedicalLabReportModel.message.toString()),
                            ],
                          ));
              case Status.ERROR:
                return Container(
                  width: maxWidth(context),
                  height: 135.0,
                  margin: const EdgeInsets.all(12.0),
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
      // bottomNavigationBar: Container(
      //   color: myColor.dialogBackgroundColor,
      //   width: maxWidth(context),
      //   height: 60,
      //   child: Container(
      //     margin: const EdgeInsets.only(top: 10.0),
      //     decoration: BoxDecoration(
      //       color: kWhite.withOpacity(0.4),
      //       borderRadius: const BorderRadius.only(
      //         topRight: Radius.circular(25),
      //         topLeft: Radius.circular(25),
      //       ),
      //     ),
      //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      //     width: maxWidth(context),
      //     height: 100,
      //     child:
      //   ),
      // ),
    );
  }

  Widget myGraph(BuildContext context, dynamic data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      width: maxWidth(context),
      height: 340,
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
            child: Text(
              '${data[0].labtest.tests} Chart',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 280,
            child: SfCartesianChart(
                // backgroundColor: Colors.amber,
                plotAreaBorderColor: Colors.green,

                // borderColor: Colors.red,
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                    minimum: 1,
                    maximum: double.parse(
                        data[data.length - 1].redMaxRange.toString()),
                    interval: 1,
                    plotBands: [
                      PlotBand(
                        isVisible: true,
                        opacity: 0.3,
                        borderColor: kTransparent,
                        start: double.parse(
                            data[data.length - 1].redMinRange.toString()),
                        end: double.parse(
                            data[data.length - 1].amberMinRange.toString()),
                        color: kRed,
                      ),
                      PlotBand(
                        borderColor: kTransparent,
                        isVisible: true,
                        opacity: 0.3,
                        start: double.parse(
                            data[data.length - 1].amberMinRange.toString()),
                        end: double.parse(
                            data[data.length - 1].minRange.toString()),
                        color: kAmber,
                      ),
                      PlotBand(
                        isVisible: true,
                        borderColor: kTransparent,
                        opacity: 0.3,
                        start: double.parse(
                            data[data.length - 1].maxRange.toString()),
                        end: double.parse(
                            data[data.length - 1].amberMaxRange.toString()),
                        color: kAmber,
                      ),
                      PlotBand(
                        borderColor: kTransparent,
                        isVisible: true,
                        opacity: 0.3,
                        start: double.parse(
                            data[data.length - 1].amberMaxRange.toString()),
                        end: double.parse(
                            data[data.length - 1].redMaxRange.toString()),
                        color: kRed,
                      ),
                    ]),
                legend: Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <LineSeries<dynamic, String>>[
                  LineSeries<dynamic, String>(
                      dataSource: data,
                      xValueMapper: (dynamic datum, _) =>
                          '${getMonth(datum.updatedAt.toString().substring(0, 10))} ${DateTime.parse(datum.updatedAt.toString().substring(0, 10)).day} ${DateTime.parse(datum.updatedAt.toString().substring(0, 10)).year} \n ( 1st Screening )',
                      yValueMapper: (dynamic datum, _) => datum.value,
                      dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: kStyleNormal.copyWith(
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                            color: myColor.primaryColorDark,
                          )))
                ]),
          ),
        ],
      ),
    );
  }

  Widget myReportCard(MyLabreports data) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(children: [
            const SizedBox12(),
            myTextRow(
                'Minimum Range:', '${data.minRange} ${data.labtest!.unit}'),
            myTextRow(
                'Maximum Range:', '${data.maxRange} ${data.labtest!.unit}'),
            myTextRow('Actual Range:', '${data.value} ${data.labtest!.unit}',
                divider: false),
            const SizedBox12(),
          ]),
        ),
      ],
    );
  }

  Widget myConsultatantReportCard(Advice data) {
    String? fileExtension, fileName, fileImage;
    bool? isPdf, isPng, isJpg;
    if (data.filePath != null) {
      fileExtension = path.extension(data.filePath.toString());
      if (fileExtension == '.pdf') {
        fileName = 'View pdf';
        fileImage = 'assets/pdfIconsSolid.png';
        isPdf = true;
      } else if (fileExtension == '.png') {
        fileName = 'View image';
        fileImage = data.filePath;
        isPng = true;
      } else {
        fileName = 'View image';
        fileImage = data.filePath;
        isJpg = true;
        // file has an unsup
        //ported extension
      }
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        width: maxWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Report Date',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.updatedAt.toString().substring(0, 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox12(),
            Row(
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
                      data.team!.type == 'Fitness Trainer'
                          ? Container()
                          : myRow(
                              data.team!.type == 'Nurse'
                                  ? 'NNC no.'
                                  : 'NMC no.',
                              data.team!.type == 'Nurse'
                                  ? data.team!.employee!.nncNo.toString()
                                  : data.team!.employee!.nmcNo.toString(),
                            ),
                      myRow(
                        'Name',
                        '${data.team!.employee!.salutation} ${data.team!.employee!.user!.name}',
                      ),
                      myRow(
                        'Phone',
                        data.team!.employee!.user!.phone,
                      ),
                      myRow(
                        'Type',
                        data.team!.type,
                        color: myColor.primaryColorDark,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox12(),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.black,
                primaryColor: Colors.black,
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                  iconColor: myColor.primaryColorDark,
                  childrenPadding: EdgeInsets.zero,
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    'View Feedback',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Html(
                      data: data.feedback == null
                          ? 'No Feedback added'
                          : data.feedback.toString(),
                      style: {
                        "*": Style(
                          fontSize: FontSize(12.0),
                          fontFamily: 'Futura',
                          textAlign: TextAlign.justify,
                        ),
                      },
                    ),
                    const SizedBox12(),
                  ]),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child: Row(
            //         children: [
            //           Icon(
            //             FontAwesomeIcons.userDoctor,
            //             size: 10.0,
            //             color: kBlack,
            //           ),
            //           const SizedBox(width: 10.0),
            //           Text(
            //             'Consultation Type:  ${data.team!.type}',
            //             style: kStyleNormal.copyWith(
            //               fontSize: 12.0,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Expanded(
            //         flex: 1,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             Text(
            //               'View Report',
            //               style: kStyleNormal.copyWith(
            //                 fontSize: 12.0,
            //                 color: myColor.primaryColorDark,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const SizedBox(width: 5.0),
            //             Icon(
            //               Icons.keyboard_arrow_right_outlined,
            //               size: 15.0,
            //               color: myColor.primaryColorDark,
            //             ),
            //           ],
            //         ))
            //   ],
            // ),
            // const SizedBox12(),
            // const SizedBox12(),
            // Text(
            //   'Report',
            //   style: kStyleNormal.copyWith(
            //     fontSize: 14.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox12(),
            data.filePath == null
                ? Container()
                : GestureDetector(
                    onTap: () {
                      goThere(
                          context,
                          ReportPdfViewer(
                            url: data.filePath.toString(),
                            type: isPdf == true ? 'pdf' : 'image',
                            fileName: data.file.toString(),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      margin: const EdgeInsets.only(bottom: 12.0),
                      width: maxWidth(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fileName == 'View image'
                              ? Hero(
                                  tag: 'imageHero',
                                  child: myCachedNetworkImage(
                                    30.0,
                                    30.0,
                                    fileImage!,
                                    const BorderRadius.all(
                                      Radius.circular(2.0),
                                    ),
                                    BoxFit.contain,
                                  ),
                                )
                              : Image.asset(
                                  fileImage!,
                                  width: 30,
                                ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                fileName!,
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
                          const SizedBox(width: 15.0),
                          GestureDetector(
                            onTap: () async {
                              if (await checkStoragePermission(
                                  Permission.storage)) {
                                final file = await API().downloadFile(
                                    data.filePath.toString(), '${data.file}');
                              }
                            },
                            child: const Icon(
                              Icons.download,
                              size: 20.0,
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
          showDivider == false ? Container(height: 6.0) : const Divider(),
        ],
      ),
    );
  }

  Widget myTextRow(title, value, {divider}) {
    return Column(
      children: [
        const SizedBox8(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                )),
            Text(value,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        const SizedBox8(),
        divider == false ? Container(height: 6.0) : const Divider(),
      ],
    );
  }
}
