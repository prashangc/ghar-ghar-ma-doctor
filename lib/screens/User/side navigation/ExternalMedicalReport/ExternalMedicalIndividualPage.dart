import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/ReportPdfViewer.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ExternalMedicalIndividualPage extends StatefulWidget {
  final ExternalMedicalDetailsModel externalMedicalDetailsModel;
  const ExternalMedicalIndividualPage(
      {super.key, required this.externalMedicalDetailsModel});

  @override
  State<ExternalMedicalIndividualPage> createState() =>
      _ExternalMedicalIndividualPageState();
}

class _ExternalMedicalIndividualPageState
    extends State<ExternalMedicalIndividualPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 0.0),
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
                    Text(
                        widget.externalMedicalDetailsModel.status == 2
                            ? ''
                            : '* Please refer your original uploaded document incase of confusion or doubt.',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: kRed,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox8(),
                    doctorDetailsCard(
                        context, widget.externalMedicalDetailsModel),
                    const SizedBox12(),
                    widget.externalMedicalDetailsModel.status == 2
                        ? Container()
                        : medicalHistoryCard(
                            context, widget.externalMedicalDetailsModel),
                    widget.externalMedicalDetailsModel.status == 2
                        ? Container()
                        : findingsCard(
                            context,
                            'Observations',
                            'Your medical history based on the consultation',
                            widget.externalMedicalDetailsModel.observation ??
                                'No observation added yet.'),
                    widget.externalMedicalDetailsModel.status == 2
                        ? Container()
                        : findingsCard(
                            context,
                            'Findings',
                            'Your findings based on medical history',
                            widget.externalMedicalDetailsModel.finding ??
                                'No finding added yet.'),
                    widget.externalMedicalDetailsModel.status == 2
                        ? Container()
                        : findingsCard(
                            context,
                            'Medication',
                            'Your medication based on your medical history',
                            widget.externalMedicalDetailsModel.medication ??
                                'No medication added yet.'),
                    const SizedBox12(),
                    reportCard(context, widget.externalMedicalDetailsModel),
                    const SizedBox12(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myRow(title, value) {
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
          ),
        ),
      ],
    );
  }

  Widget doctorDetailsCard(context, ExternalMedicalDetailsModel data) {
    return data.doctor == null
        ? emptyPage(
            context,
            widget.externalMedicalDetailsModel.status == 2
                ? 'Your document has been rejected.'
                : 'Doctor Not Assigned Yet',
            'Please re-upload your document',
            '',
            () {},
            testColor: kRed,
            dynamicHeight: true)
        : Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              color: kWhite.withOpacity(0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doctor Details',
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
                      widget.externalMedicalDetailsModel.doctor!.imagePath
                          .toString(),
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
                              widget.externalMedicalDetailsModel.doctor!.user!
                                  .name
                                  .toString()),
                          const SizedBox2(),
                          const SizedBox2(),
                          myRow(
                              'NMC Number',
                              widget.externalMedicalDetailsModel.doctor ==
                                          null ||
                                      widget.externalMedicalDetailsModel.doctor!
                                              .nmcNo ==
                                          null
                                  ? 'No data'
                                  : widget
                                      .externalMedicalDetailsModel.doctor!.nmcNo
                                      .toString()),
                          const SizedBox2(),
                          const SizedBox2(),
                          myRow(
                              'Address',
                              widget.externalMedicalDetailsModel.doctor ==
                                          null ||
                                      widget.externalMedicalDetailsModel.doctor!
                                              .address ==
                                          null
                                  ? 'No data'
                                  : widget.externalMedicalDetailsModel.doctor!
                                      .address
                                      .toString()),
                          const SizedBox2(),
                          const SizedBox2(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                  ],
                ),
                const SizedBox12(),
                const SizedBox2(),
                const Divider(),
                const SizedBox2(),
                const SizedBox2(),
                myCustomRow(
                    'Gender',
                    widget.externalMedicalDetailsModel.doctor == null ||
                            widget.externalMedicalDetailsModel.doctor!.gender ==
                                null
                        ? 'No data'
                        : widget.externalMedicalDetailsModel.doctor!.gender
                            .toString(),
                    'Experience',
                    widget.externalMedicalDetailsModel.doctor == null ||
                            widget.externalMedicalDetailsModel.doctor!
                                    .yearPracticed ==
                                null
                        ? 'No data'
                        : widget
                            .externalMedicalDetailsModel.doctor!.yearPracticed
                            .toString()),
                const SizedBox8(),
                myCustomRow(
                    'Specilization',
                    widget.externalMedicalDetailsModel.doctor == null ||
                            widget.externalMedicalDetailsModel.doctor!
                                    .specialization ==
                                null
                        ? 'No data'
                        : widget
                            .externalMedicalDetailsModel.doctor!.specialization
                            .toString(),
                    'Qualification',
                    widget.externalMedicalDetailsModel.doctor == null ||
                            widget.externalMedicalDetailsModel.doctor!
                                    .qualification ==
                                null
                        ? 'No data'
                        : widget
                            .externalMedicalDetailsModel.doctor!.qualification
                            .toString()),
                const SizedBox8(),
              ],
            ),
          );
  }

  myCustomRow(title1, value1, title2, value2) {
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '$title1:\n',
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: value1,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '$title2:\n',
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: value2,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget medicalHistoryCard(context, ExternalMedicalDetailsModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
        color: kWhite.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Details',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox12(),
          myRow(
              'Checked By',
              widget.externalMedicalDetailsModel.doctorName ??
                  'No doctor added'),
          const SizedBox2(),
          const SizedBox2(),
          myRow('NMC',
              widget.externalMedicalDetailsModel.doctorNmc ?? 'No NMC added'),
          const SizedBox2(),
          const SizedBox2(),
          myRow(
              'Hospital Name',
              widget.externalMedicalDetailsModel.hospital ??
                  'No hospital added'),
          const SizedBox8(),
        ],
      ),
    );
  }

  Widget findingsCard(context, title, subtitle, detailText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
        color: kWhite.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Text(
            subtitle,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
          const SizedBox12(),
          Text(
            detailText,
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget reportCard(context, ExternalMedicalDetailsModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Reports',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          GestureDetector(
            onTap: () {
              goThere(
                  context,
                  ReportPdfViewer(
                    url: widget.externalMedicalDetailsModel.medicalReport![0]
                        .reportPath
                        .toString(),
                    type: 'pdf',
                    fileName: widget
                        .externalMedicalDetailsModel.medicalReport![0].report
                        .toString(),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      widget
                          .externalMedicalDetailsModel.medicalReport![0].report
                          .toString(),
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
        ],
      ),
    );
  }
}
