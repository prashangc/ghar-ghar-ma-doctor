import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ClaimInsuranceDetailsPage extends StatefulWidget {
  final Claims getClaimInsuranceListModel;
  final String? claimedBy;
  final GetClaimInsuranceListModel company;
  const ClaimInsuranceDetailsPage(
      {Key? key,
      this.claimedBy,
      required this.getClaimInsuranceListModel,
      required this.company})
      : super(key: key);

  @override
  State<ClaimInsuranceDetailsPage> createState() =>
      _ClaimInsuranceDetailsPageState();
}

class _ClaimInsuranceDetailsPageState extends State<ClaimInsuranceDetailsPage> {
  StateHandlerBloc? handWrittenDownloadBtnBloc,
      medicalReportDownloadBtnBloc,
      invoiceDownloadBtnBloc;
  bool isLoading = false;
  File? medicalReport, handLetter, invoice;
  @override
  void initState() {
    super.initState();
    handWrittenDownloadBtnBloc = StateHandlerBloc();
    medicalReportDownloadBtnBloc = StateHandlerBloc();
    invoiceDownloadBtnBloc = StateHandlerBloc();
    getFiles();
  }

  getFiles() async {
    medicalReport = await convertNetworkPathToFile(
        widget.getClaimInsuranceListModel.medicalReport,
        widget.getClaimInsuranceListModel.medicalReportPath);
    handLetter = await convertNetworkPathToFile(
        widget.getClaimInsuranceListModel.handWrittenLetter,
        widget.getClaimInsuranceListModel.handWrittenLetterPath);
    invoice = await convertNetworkPathToFile(
        widget.getClaimInsuranceListModel.invoice,
        widget.getClaimInsuranceListModel.invoicePath);
  }

  Future convertNetworkPathToFile(fileName, url) async {
    print('url -> $url');
//     Container(
//      decoration: BoxDecoration(
//          image: DecorationImage(
//               image: FileImage(File(path))
//          )
//     )
// )
    final responseData = await http.get(Uri.parse(url));
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$fileName').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    print('file ${file.path}');

    // setState(() {
    //   fileScope = file.path;
    // });
    // print('invoice $invoice');
    return File(file.path);
  }

  downloadBtn(bloc, url, name) {
    print(bloc);
    bloc!.storeData(!isLoading);
    var test = API().downloadFile(url, name);
    print(test);
    if (test != null) {
      bloc!.storeData(isLoading);
    } else {
      bloc!.storeData(isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Insurance Details',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: maxWidth(context),
        height: maxHeight(context),
        padding: const EdgeInsets.fromLTRB(12.0, 18.0, 12.0, 0.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              insuranceTimelineCard(),
              const SizedBox12(),
              insuranceDetailsCard(),
              filesCard(
                'Hand Written Letter',
                widget.getClaimInsuranceListModel.handWrittenLetter.toString(),
                () {
                  OpenFile.open(handLetter!.path);
                },
                () {
                  downloadBtn(
                      handWrittenDownloadBtnBloc,
                      widget.getClaimInsuranceListModel.handWrittenLetterPath
                          .toString(),
                      widget.getClaimInsuranceListModel.handWrittenLetter
                          .toString());
                },
                handWrittenDownloadBtnBloc,
              ),
              filesCard('Medical Report',
                  widget.getClaimInsuranceListModel.medicalReport.toString(),
                  () {
                OpenFile.open(medicalReport!.path);
              }, () {
                downloadBtn(
                    medicalReportDownloadBtnBloc,
                    widget.getClaimInsuranceListModel.handWrittenLetterPath
                        .toString(),
                    widget.getClaimInsuranceListModel.handWrittenLetter
                        .toString());
              }, medicalReportDownloadBtnBloc),
              filesCard('Invoice',
                  widget.getClaimInsuranceListModel.invoice.toString(), () {
                OpenFile.open(invoice!.path);
              }, () {
                downloadBtn(
                    invoiceDownloadBtnBloc,
                    widget.getClaimInsuranceListModel.handWrittenLetterPath
                        .toString(),
                    widget.getClaimInsuranceListModel.handWrittenLetter
                        .toString());
              }, invoiceDownloadBtnBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget insuranceTimelineCard() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: maxWidth(context),
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: insuranceTrackList.length,
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    const SizedBox16(),
                    Row(
                      children: [
                        i == 0
                            ? Container()
                            : Container(
                                color: kWhite.withOpacity(0.4),
                                width: 10.0,
                                height: 2.0,
                              ),
                        Tooltip(
                          decoration: BoxDecoration(
                            color: myColor.primaryColorDark,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          textStyle: kStyleNormal.copyWith(
                              fontSize: 12.0, color: kWhite),
                          triggerMode: TooltipTriggerMode.tap,
                          message: i == 2
                              ? widget
                                  .getClaimInsuranceListModel.insuranceStatus
                                  .toString()
                              : insuranceTrackList[i].status[0].toString(),
                          child: Container(
                            width: (maxWidth(context) / 5) - 20,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: kWhite.withOpacity(0.4),
                                shape: BoxShape.circle),
                            child: Icon(
                              insuranceTrackList[i].iconData,
                              size: 20.0,
                              color: insuranceTrackList[i].status.contains(
                                      widget.getClaimInsuranceListModel
                                          .insuranceStatus
                                          .toString())
                                  ? myColor.primaryColorDark
                                  : myColor.primaryColorDark.withOpacity(0.3),
                            ),
                          ),
                        ),
                        i == insuranceTrackList.length - 1
                            ? Container()
                            : Container(
                                color: kWhite.withOpacity(0.4),
                                width: 10.0,
                                height: 2.0,
                              ),
                      ],
                    ),
                    const SizedBox8(),
                    Text(
                      insuranceTrackList[i].title.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 10.0,
                        color: insuranceTrackList[i].status.contains(widget
                                .getClaimInsuranceListModel.insuranceStatus
                                .toString())
                            ? myColor.primaryColorDark
                            : myColor.primaryColorDark.withOpacity(0.6),
                      ),
                    )
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget insuranceDetailsCard() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        color: kWhite.withOpacity(0.4),
      ),
      child: Column(
        children: [
          const SizedBox12(),
          myRow(
              'Insurance Type',
              widget.getClaimInsuranceListModel.insurance!.insurancetype!.type
                  .toString()),
          const Divider(),
          myRow('Insurance Claim Amount',
              'Rs ${widget.getClaimInsuranceListModel.claimAmount.toString()}'),
          const Divider(),
          myRow('Company Name', widget.company.companyName.toString()),
          widget.claimedBy == null ? Container() : const Divider(),
          widget.claimedBy == null
              ? Container()
              : myRow('Claimed For', widget.claimedBy),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Insurance Claim Status',
                style: kStyleNormal.copyWith(fontSize: 12.0),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: widget.getClaimInsuranceListModel.insuranceStatus !=
                          'Approved'
                      ? Colors.red.withOpacity(0.9)
                      : kGreen,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Text(
                  widget.getClaimInsuranceListModel.insuranceStatus.toString(),
                  style: kStyleNormal.copyWith(
                    color: kWhite,
                    fontSize: 12.0,
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

  Widget filesCard(title, fileName, view, download, bloc) {
    return GestureDetector(
      onTap: () {
        view();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox12(),
            Text(
              title,
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/pdfIconsSolid.png',
                  width: 30,
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      fileName,
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(fontSize: 12.0),
                    ),
                  ),
                ),
                const Icon(
                  Icons.visibility,
                  size: 20.0,
                ),
                const SizedBox(width: 15.0),
                GestureDetector(
                  onTap: () {
                    download();
                  },
                  child: StreamBuilder<dynamic>(
                      initialData: isLoading,
                      stream: bloc!.stateStream,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return SizedBox(
                              width: 15.0,
                              height: 15.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: kBlack,
                                backgroundColor: kBlack.withOpacity(0.3),
                              ));
                        } else {
                          return const Icon(
                            Icons.download,
                            size: 20.0,
                          );
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myRow(text, value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: kStyleNormal.copyWith(fontSize: 12.0),
            ),
            Text(
              value,
              style: kStyleNormal.copyWith(
                  fontSize: 12.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox8(),
      ],
    );
  }
}
