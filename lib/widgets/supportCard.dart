import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/FAQ/Faq.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:url_launcher/url_launcher.dart';

Widget supportCard(context) {
  return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: 3,
              height: 100.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
      itemCount: supportSettingsList.length,
      itemBuilder: (BuildContext ctx, index) {
        return GestureDetector(
          onTap: () {
            switch (index) {
              case 0:
                showModalBottomSheet(
                    context: context,
                    backgroundColor: myColor.dialogBackgroundColor,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: ((builder) => reportProblemBottomSheet()));
                break;
              case 1:
                break;
              case 2:
                showModalBottomSheet(
                    context: context,
                    backgroundColor: myColor.dialogBackgroundColor,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: ((builder) => emergencyCallBottomSheet()));
                break;
              case 3:
                showModalBottomSheet(
                  context: context,
                  backgroundColor: myColor.dialogBackgroundColor,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: ((builder) => addReviewBottomSheet(context)),
                );
                break;
              case 4:
                goThere(context, const Faq());
                break;
              case 5:
                break;
              default:
            }
          },
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.4),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox8(),
                  Icon(
                    supportSettingsList[index].icon,
                    size: 22,
                  ),
                  const SizedBox12(),
                  SizedBox(
                    height: 34.0,
                    child: Text(
                      supportSettingsList[index].title.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: kStyleNormal.copyWith(
                        // color: myColor.primaryColorDark,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              )),
        );
      });
}

Widget reportProblemBottomSheet() {
  ApiHandlerBloc? reportIssueSubjectBloc;
  reportIssueSubjectBloc = ApiHandlerBloc();
  reportIssueSubjectBloc.fetchAPIList(endpoints.getSubjectListEndpoint);
  StateHandlerBloc? subjectStateBloc, submitIssueBloc;
  subjectStateBloc = StateHandlerBloc();
  submitIssueBloc = StateHandlerBloc();
  String? issue;

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
                  StreamBuilder<dynamic>(
                      initialData: ReportSubjectModel(),
                      stream: subjectStateBloc!.stateStream,
                      builder: (context, s) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.black,
                            primaryColor: Colors.black,
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                              maintainState: true,
                              iconColor: myColor.primaryColorDark,
                              childrenPadding: EdgeInsets.zero,
                              tilePadding: EdgeInsets.zero,
                              title: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: Text(
                                  s.data.selectedValue == null
                                      ? 'Select Subject'
                                      : s.data.value,
                                  style: kStyleNormal.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                              children: <Widget>[
                                StreamBuilder<ApiResponse<dynamic>>(
                                  stream: reportIssueSubjectBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            width: maxWidth(context),
                                            height: 140.0,
                                            child: const AnimatedLoading(),
                                          );
                                        case Status.COMPLETED:
                                          if (snapshot.data!.data.isEmpty) {
                                            return Container(
                                                height: 140,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      kWhite.withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Center(
                                                    child:
                                                        Text('No any issues')));
                                          }
                                          List<GetReportIssueDropDownListModel>
                                              getReportIssueDropDownListModel =
                                              List<GetReportIssueDropDownListModel>.from(
                                                  snapshot.data!.data.map((i) =>
                                                      GetReportIssueDropDownListModel
                                                          .fromJson(i)));
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  getReportIssueDropDownListModel
                                                      .length,
                                              itemBuilder: (ctx, i) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    subjectStateBloc!.storeData(
                                                        ReportSubjectModel(
                                                      subjectId:
                                                          getReportIssueDropDownListModel[
                                                                  i]
                                                              .id,
                                                      selectedValue:
                                                          '${getReportIssueDropDownListModel[i].subject}${getReportIssueDropDownListModel[i].id}',
                                                      value:
                                                          getReportIssueDropDownListModel[
                                                                  i]
                                                              .subject
                                                              .toString(),
                                                    ));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          width: 1.0,
                                                          color: i ==
                                                                  getReportIssueDropDownListModel
                                                                          .length -
                                                                      1
                                                              ? kTransparent
                                                              : kWhite
                                                                  .withOpacity(
                                                                      0.4),
                                                        ),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 12.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.check_box,
                                                            size: 14.0,
                                                            color: s.data
                                                                        .selectedValue ==
                                                                    '${getReportIssueDropDownListModel[i].subject}${getReportIssueDropDownListModel[i].id}'
                                                                ? myColor
                                                                    .primaryColorDark
                                                                : kWhite
                                                                    .withOpacity(
                                                                        0.4)),
                                                        const SizedBox(
                                                            width: 8.0),
                                                        Text(
                                                          getReportIssueDropDownListModel[
                                                                  i]
                                                              .subject
                                                              .toString(),
                                                          style: kStyleNormal
                                                              .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });

                                        case Status.ERROR:
                                          return Container(
                                            width: maxWidth(context),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            height: 50.0,
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
                                    return SizedBox(
                                      width: maxWidth(context),
                                    );
                                  }),
                                ),
                              ]),
                        );
                      }),
                  const SizedBox16(),
                  Text(
                    'Write your problem',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox16(),
                  myTextArea(context, kWhite.withOpacity(0.4),
                      'Explain about your selected problem',
                      onValueChanged: (v) {
                    issue = v;
                  }),
                  const SizedBox12(),
                  StreamBuilder<dynamic>(
                      initialData: ReportSubjectModel(),
                      stream: subjectStateBloc.stateStream,
                      builder: (context, data) {
                        return StreamBuilder<dynamic>(
                            initialData: 0,
                            stream: submitIssueBloc!.stateStream,
                            builder: (context, snapshot) {
                              if (snapshot.data == 0) {
                                return SizedBox(
                                  width: maxWidth(context),
                                  height: 50.0,
                                  child: myCustomButton(
                                    context,
                                    issue == null || data.data.subjectId == null
                                        ? myColor.primaryColorDark
                                            .withOpacity(0.12)
                                        : myColor.primaryColorDark,
                                    'Report Issue',
                                    kStyleNormal.copyWith(
                                        color: kWhite, fontSize: 14.0),
                                    () async {
                                      if (issue != null ||
                                          data.data.subjectId != null) {
                                        submitIssueBloc!.storeData(1);
                                        int? statusCode;
                                        statusCode = await API().postData(
                                            context,
                                            SubmitIssueModel(
                                              message: issue,
                                              subjectId: data.data.subjectId,
                                            ),
                                            endpoints
                                                .postReportProblemEndpoint);
                                        if (statusCode == 200) {
                                          submitIssueBloc.storeData(0);
                                          mySnackbar.mySnackBar(
                                              context,
                                              'Report Successfully Sent',
                                              kGreen);
                                          Navigator.pop(context);
                                        } else {
                                          submitIssueBloc.storeData(0);
                                        }
                                      }
                                    },
                                  ),
                                );
                              } else {
                                return myBtnLoading(context, 50.0);
                              }
                            });
                      }),
                  const SizedBox12(),
                ])),
      ),
    );
  });
}

Widget emergencyCallBottomSheet() {
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
                    'Call',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox16(),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: emergencyPhoneNumberList.length,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse(
                                "tel://${emergencyPhoneNumberList[i].number}"));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              color: kWhite.withOpacity(0.4),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 8.0),
                                SizedBox(
                                  width: 30.0,
                                  child: emergencyPhoneNumberList[i].image !=
                                          null
                                      ? Image.asset(
                                          emergencyPhoneNumberList[i]
                                              .image
                                              .toString(),
                                          width: 14.0,
                                          height: 18.0,
                                        )
                                      : Icon(
                                          emergencyPhoneNumberList[i].icon,
                                          size:
                                              emergencyPhoneNumberList[i].size,
                                          color: myColor.primaryColorDark,
                                        ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    emergencyPhoneNumberList[i].title,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Icon(
                                  Icons.call_outlined,
                                  size: 18.0,
                                  color: myColor.primaryColorDark,
                                ),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        );
                      }),
                  const SizedBox8(),
                ])),
      ),
    );
  });
}

Widget addReviewBottomSheet(context) {
  StateHandlerBloc? submitFeedbackBloc;
  submitFeedbackBloc = StateHandlerBloc();
  double rating = 5;
  String ratingsText = 'Excellent';
  String? review;
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
                    'Give Ratings',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox16(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                          minRating: 1,
                          itemBuilder: (context, _) {
                            return Icon(
                              Icons.star,
                              color: kAmber,
                            );
                          },
                          initialRating: rating,
                          updateOnDrag: true,
                          itemSize: 30.0,
                          itemPadding: const EdgeInsets.only(right: 5),
                          onRatingUpdate: (newRatingValue) {
                            setState(() {
                              rating = newRatingValue;
                              rating == 1
                                  ? ratingsText = 'Satisfactory'
                                  : rating == 2
                                      ? ratingsText = 'Good'
                                      : rating == 3
                                          ? ratingsText = 'Average'
                                          : rating == 4
                                              ? ratingsText = 'Best'
                                              : rating == 5
                                                  ? ratingsText = 'Excellent'
                                                  : 'Excellent';
                            });
                          }),
                      const SizedBox(width: 10.0),
                      Text(
                        '${rating.toString()}  ( $ratingsText )',
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
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
                  }),
                  const SizedBox12(),
                  StreamBuilder<dynamic>(
                      initialData: 0,
                      stream: submitFeedbackBloc!.stateStream,
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
                                  color: Colors.white, fontSize: 14.0),
                              () async {
                                if (review != null) {
                                  submitFeedbackBloc!.storeData(1);
                                  int? statusCode;
                                  statusCode = await API().postData(
                                      context,
                                      PostGdFeedBack(
                                        rating: rating.round(),
                                        feedback: review,
                                      ),
                                      endpoints.postGdFeedbackEndpoint);
                                  if (statusCode == 200) {
                                    submitFeedbackBloc.storeData(0);
                                    mySnackbar.mySnackBar(context,
                                        'Review Successfully Sent', kGreen);
                                    Navigator.pop(context);
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

class ReportSubjectModel {
  String? value;
  String? selectedValue;
  int? subjectId;

  ReportSubjectModel({this.value, this.selectedValue, this.subjectId});
}
