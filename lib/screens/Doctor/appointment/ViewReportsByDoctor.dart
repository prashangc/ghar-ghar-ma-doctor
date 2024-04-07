import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAppointmentsInDoctorSide.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ViewReportsByDoctor extends StatefulWidget {
  final GetAppointmentsInDoctorSide? appointment;
  const ViewReportsByDoctor({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<ViewReportsByDoctor> createState() => _ViewReportsByDoctorState();
}

class _ViewReportsByDoctorState extends State<ViewReportsByDoctor> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('ter');
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
          title: 'Reports',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          height: maxHeight(context),
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: maxWidth(context),
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
                const SizedBox24(),
                myCard('Follow Up',
                    widget.appointment!.report!.imagePath.toString()),
                myCard('Your Reports',
                    widget.appointment!.report!.imagePath.toString()),
                myCard(
                    'History', widget.appointment!.report!.history.toString()),
                myCard('Examination',
                    widget.appointment!.report!.examination.toString()),
                myCard('Treatment',
                    widget.appointment!.report!.treatment.toString()),
                myCard('Progress',
                    widget.appointment!.report!.progress.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myCard(title, value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const SizedBox16(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: htmlText(value.toString()),
        ),
        const SizedBox16(),
      ],
    );
  }
}
