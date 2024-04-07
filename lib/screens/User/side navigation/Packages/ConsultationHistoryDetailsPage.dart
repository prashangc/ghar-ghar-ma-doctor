import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ConsultationHistoryDetailsPage extends StatefulWidget {
  final OnlineConsultationHistoryModel onlineConsultationHistoryModel;

  const ConsultationHistoryDetailsPage(
      {super.key, required this.onlineConsultationHistoryModel});

  @override
  State<ConsultationHistoryDetailsPage> createState() =>
      _ConsultationHistoryDetailsPageState();
}

class _ConsultationHistoryDetailsPageState
    extends State<ConsultationHistoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Consultation Details',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Container(
        width: maxWidth(context),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor Details',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              profileDetails(),
              Text(
                'Consultation',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              consultationDetails(),
              Text(
                'Medical History',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              medicalHistory(),
              const SizedBox12(),
              Text(
                'Examination',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              examinationCard(),
              const SizedBox12(),
              Text(
                'Treatment',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              treatmentCard(),
              const SizedBox12(),
              Text(
                'Progress',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              progressCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileDetails() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              myCachedNetworkImageCircle(
                60.0,
                60.0,
                widget.onlineConsultationHistoryModel.doctor!.imagePath,
                BoxFit.cover,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  widget.onlineConsultationHistoryModel.doctor!.user!.name
                      .toString(),
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Row(
                children: [
                  Icon(
                    Icons.add,
                    color: myColor.primaryColorDark,
                    size: 14.0,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'Add reviews',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myRow(
                        'NMC no',
                        widget.onlineConsultationHistoryModel.doctor!.nmcNo
                            .toString()),
                    const SizedBox8(),
                    myRow(
                        'Experience',
                        widget.onlineConsultationHistoryModel.doctor!
                                .yearPracticed ??
                            'No data'),
                    const SizedBox8(),
                    myRow(
                        'Address',
                        widget.onlineConsultationHistoryModel.doctor!.address
                            .toString()),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myRow(
                        'Qualification',
                        widget.onlineConsultationHistoryModel.doctor!
                                .qualification ??
                            'No data'),
                    const SizedBox8(),
                    myRow(
                        'Specification',
                        widget.onlineConsultationHistoryModel.doctor!
                                .specialization ??
                            'No data'),
                    const SizedBox8(),
                    myRow(
                        'Gender',
                        widget.onlineConsultationHistoryModel.doctor!.gender ??
                            'No data'),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget consultationDetails() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myRow('Consultation Date',
                        '${getMonth(widget.onlineConsultationHistoryModel.startTime)} ${widget.onlineConsultationHistoryModel.startTime.toString().substring(5, 7)}, ${widget.onlineConsultationHistoryModel.startTime.toString().substring(0, 4)}'),
                    const SizedBox8(),
                    myRow(
                      'Duration',
                      '${(DateTime.parse(widget.onlineConsultationHistoryModel.endTime.toString()).difference(DateTime.parse(widget.onlineConsultationHistoryModel.startTime.toString()))).inMinutes} mins',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myRow(
                        'Start Time',
                        widget.onlineConsultationHistoryModel.startTime!
                            .toString()
                            .substring(11, 19)),
                    const SizedBox8(),
                    myRow(
                      'End Time',
                      widget.onlineConsultationHistoryModel.endTime!
                          .toString()
                          .substring(11, 19),
                    ),
                    const SizedBox8(),
                  ],
                ),
              )
            ],
          ),
          const SizedBox8(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agenda',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                widget.onlineConsultationHistoryModel.agenda.toString(),
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget medicalHistory() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your medical history based on the consultation:',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Text(
            widget.onlineConsultationHistoryModel.history.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget examinationCard() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your examination details based on the consultation:',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Text(
            widget.onlineConsultationHistoryModel.examination.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget treatmentCard() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your treatment details based on the consultation:',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Text(
            widget.onlineConsultationHistoryModel.treatment.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget progressCard() {
    return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your progress details based on the consultation:',
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Text(
            widget.onlineConsultationHistoryModel.progress.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget myRow(title, value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
        ),
        const SizedBox2(),
        Text(
          value,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
            color: myColor.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
