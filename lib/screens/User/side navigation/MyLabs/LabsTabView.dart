import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyLabsModel/MyLabsModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/LabDetailsScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/paymentBottomSheet.dart';

class LabsTabView extends StatefulWidget {
  final List<MyLabsModel> myLabsModel;
  const LabsTabView({Key? key, required this.myLabsModel}) : super(key: key);

  @override
  State<LabsTabView> createState() => _LabsTabViewState();
}

class _LabsTabViewState extends State<LabsTabView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.myLabsModel.length,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shrinkWrap: true,
          itemBuilder: (crx, i) {
            return labsCard(context, widget.myLabsModel[i]);
          }),
    );
  }

  Widget labsCard(BuildContext context, MyLabsModel labModel) {
    return GestureDetector(
      onTap: () {
        goThere(context, LabDetailsScreen(myLabsModel: labModel));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        margin: const EdgeInsets.only(bottom: 12.0),
        width: maxWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  labModel.labprofile != null
                      ? labModel.labprofile!.profileName.toString()
                      : labModel.labtest!.tests.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: kStyleNormal.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  labModel.labprofile != null
                      ? '( Lab Profile )'
                      : '( Lab Test )',
                  overflow: TextOverflow.ellipsis,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  labModel.createdAt.toString().substring(0, 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            const SizedBox2(),
            const SizedBox2(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time',
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  labModel.time.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            const SizedBox2(),
            Divider(color: myColor.dialogBackgroundColor),
            const SizedBox2(),
            const SizedBox2(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Total:  ',
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs  ${labModel.price.toString()}',
                        overflow: TextOverflow.ellipsis,
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          color: myColor.primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      labModel.bookingStatus == 'Not Scheduled'
                          ? statusCard(
                              'Proceed to Pay',
                              kGreen.withOpacity(0.9),
                              () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: backgroundColor,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20))),
                                  builder: ((builder) =>
                                      payNowBottomModel(context, labModel)),
                                );
                              },
                            )
                          : labModel.bookingStatus == 'Scheduled'
                              ? statusCard(
                                  'Sample Collection Pending',
                                  myColor.primaryColorDark,
                                  () {
                                    goThere(
                                        context,
                                        LabDetailsScreen(
                                            myLabsModel: labModel));
                                  },
                                )
                              : labModel.bookingStatus == 'Sample Collected'
                                  ? statusCard(
                                      'Sample Collected',
                                      myColor.primaryColorDark,
                                      () {
                                        goThere(
                                            context,
                                            LabDetailsScreen(
                                                myLabsModel: labModel));
                                      },
                                    )
                                  : labModel.bookingStatus == 'Completed'
                                      ? statusCard(
                                          'View Report',
                                          myColor.primaryColorDark,
                                          () {
                                            goThere(
                                                context,
                                                LabDetailsScreen(
                                                    myLabsModel: labModel));
                                          },
                                        )
                                      : Container(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox12(),
          ],
        ),
      ),
    );
  }

  Widget statusCard(title, color, myTap) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: kStyleNormal.copyWith(
            fontSize: 10.0,
            color: myColor.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
