import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/ConsultationHistoryDetailsPage.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:timelines/timelines.dart';

class ConsultationHistory extends StatefulWidget {
  final List<OnlineConsultationHistoryModel> onlineConsultationHistoryModel;

  const ConsultationHistory(
      {super.key, required this.onlineConsultationHistoryModel});

  @override
  State<ConsultationHistory> createState() => _ConsultationHistoryState();
}

class _ConsultationHistoryState extends State<ConsultationHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Consultation History',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Container(
        width: maxWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        margin: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: Column(children: [
          FixedTimeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0.0,
              indicatorPosition: 0.0,
              color: kWhite.withOpacity(0.4),
              indicatorTheme: IndicatorThemeData(
                color: myColor.primaryColorDark,
              ),
              direction: Axis.vertical,
              connectorTheme: ConnectorThemeData(
                color: kWhite.withOpacity(0.4),
                indent: 4.0,
                space: 30.0,
                thickness: 2.0,
              ),
            ),
            builder: TimelineTileBuilder.connectedFromStyle(
              contentsAlign: ContentsAlign.basic,
              contentsBuilder: (context, index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.onlineConsultationHistoryModel[index].startTime
                        .toString()
                        .substring(0, 10),
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      goThere(
                          context,
                          ConsultationHistoryDetailsPage(
                              onlineConsultationHistoryModel: widget
                                  .onlineConsultationHistoryModel[index]));
                    },
                    child: Container(
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        color: kWhite.withOpacity(0.4),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                BoxFit.cover,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myRow('Doctor Name',
                                        '${widget.onlineConsultationHistoryModel[index].member!.user!.name}'),
                                    myRow(
                                      'Consultation Date',
                                      '${getMonth(widget.onlineConsultationHistoryModel[index].startTime)} ${widget.onlineConsultationHistoryModel[index].startTime.toString().substring(5, 7)}, ${widget.onlineConsultationHistoryModel[index].startTime.toString().substring(0, 4)}',
                                    ),
                                    myRow(
                                        'Start Time',
                                        widget
                                            .onlineConsultationHistoryModel[
                                                index]
                                            .startTime!
                                            .toString()
                                            .substring(11, 19)),
                                    myRow(
                                      'End Time',
                                      widget
                                          .onlineConsultationHistoryModel[index]
                                          .endTime!
                                          .toString()
                                          .substring(11, 19),
                                      showDivider: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox2(),
                          myRow(
                            'Agenda',
                            widget.onlineConsultationHistoryModel[index].agenda
                                .toString(),
                            showDivider: false,
                          ),
                          Divider(color: myColor.dialogBackgroundColor),
                          const SizedBox2(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.clock,
                                    size: 15.0,
                                    color: myColor.primaryColorDark,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    '${(DateTime.parse(widget.onlineConsultationHistoryModel[index].endTime.toString()).difference(DateTime.parse(widget.onlineConsultationHistoryModel[index].startTime.toString()))).inMinutes} mins',
                                    overflow: TextOverflow.ellipsis,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 16.0,
                                      color: myColor.primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: myColor.primaryColorDark,
                                radius: 12.0,
                                child: Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  size: 14.0,
                                  color: kWhite,
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
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) =>
                  IndicatorStyle.outlined,
              itemCount: widget.onlineConsultationHistoryModel.length,
            ),
          ),
        ]),
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
          showDivider == false
              ? Container(height: 6.0)
              : Divider(color: myColor.dialogBackgroundColor),
        ],
      ),
    );
  }
}
