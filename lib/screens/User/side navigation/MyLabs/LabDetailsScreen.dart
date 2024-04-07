import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyLabsModel/MyLabsModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/paymentBottomSheet.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class LabDetailsScreen extends StatefulWidget {
  final MyLabsModel myLabsModel;
  const LabDetailsScreen({Key? key, required this.myLabsModel})
      : super(key: key);

  @override
  State<LabDetailsScreen> createState() => _LabDetailsScreenState();
}

class _LabDetailsScreenState extends State<LabDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: widget.myLabsModel.labprofile != null
            ? widget.myLabsModel.labprofile!.profileName.toString()
            : widget.myLabsModel.labtest!.tests.toString(),
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Container(
        height: maxHeight(context),
        margin: const EdgeInsets.only(top: 15.0),
        // padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            children: [
              const SizedBox16(),
              statusCard(),
              const SizedBox16(),
              widget.myLabsModel.reports!.isNotEmpty
                  ? reportCard()
                  : Container(),
              widget.myLabsModel.reports!.isNotEmpty
                  ? const SizedBox16()
                  : Container(),
              widget.myLabsModel.labtechnicianId != null
                  ? labTechnicianCard()
                  : Container(),
              widget.myLabsModel.labtechnicianId != null
                  ? const SizedBox16()
                  : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.myLabsModel.status == 1
          ? const SizedBox(width: 0.0, height: 0.0)
          : Container(
              color: myColor.dialogBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              width: maxWidth(context),
              height: 85.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox8(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 60.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Price',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                ),
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
                                      text: widget.myLabsModel.price.toString(),
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
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 50.0,
                          child: myCustomButton(
                            context,
                            myColor.primaryColorDark,
                            'Pay Now',
                            kStyleNormal.copyWith(
                                fontSize: 16.0, color: kWhite),
                            () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: backgroundColor,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                builder: ((builder) => payNowBottomModel(
                                    context, widget.myLabsModel)),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget labTechnicianCard() {
    return Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lab Technician Details ',
                  style: kStyleNormal.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                myCachedNetworkImageCircle(
                  20.0,
                  20.0,
                  widget.myLabsModel.lab!.imagePath,
                  BoxFit.cover,
                ),
              ],
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                deliveryAddressCard(
                  Icons.perm_identity_outlined,
                  'Name',
                  widget.myLabsModel.lab!.user!.name,
                ),
                const SizedBox16(),
                deliveryAddressCard(
                  Icons.call_outlined,
                  'Phone',
                  widget.myLabsModel.lab!.user!.phone,
                ),
                const SizedBox16(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusCard() {
    return Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Payment Details',
              style: kStyleNormal.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                deliveryAddressCard(
                  Icons.numbers_outlined,
                  'Type',
                  widget.myLabsModel.labprofile != null
                      ? 'Lab Profile'
                      : 'Lab Test',
                ),
                const SizedBox16(),
                deliveryAddressCard(
                  Icons.date_range,
                  'Booked On',
                  '${widget.myLabsModel.createdAt.toString().substring(0, 10)} [ ${widget.myLabsModel.time.toString()} ]',
                ),
                const SizedBox12(),
                deliveryAddressCard(
                  Icons.date_range,
                  'Sample No.',
                  '${widget.myLabsModel.createdAt.toString().substring(0, 10)} [ ${widget.myLabsModel.time.toString()} ]',
                ),
                const SizedBox12(),
                deliveryAddressCard(
                  Icons.date_range,
                  'Reporting Date',
                  '${widget.myLabsModel.createdAt.toString().substring(0, 10)} [ ${widget.myLabsModel.time.toString()} ]',
                ),
                const SizedBox12(),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      size: 15.0,
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.myLabsModel.status == 1
                                  ? 'Payment Method'
                                  : 'Payment Status',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          widget.myLabsModel.status == 1
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                      color: widget.myLabsModel.paymentMethod
                                                  .toString() ==
                                              'Khalti'
                                          ? const Color(0xFF56328c)
                                          : kGreen.withOpacity(0.7),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0))),
                                  child: Text(
                                    widget.myLabsModel.paymentMethod.toString(),
                                    textAlign: TextAlign.end,
                                    style: kStyleNormal.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.0,
                                      color: myColor.scaffoldBackgroundColor,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    color: kRed,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Payment Due',
                                    textAlign: TextAlign.center,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 10.0,
                                      color: myColor.scaffoldBackgroundColor,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox16(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget reportCard() {
    return Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Report Details',
              style: kStyleNormal.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox8(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                const SizedBox12(),
                SizedBox(
                  width: maxWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Test',
                          textAlign: TextAlign.start,
                          style: kStyleNormal,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Result',
                          textAlign: TextAlign.start,
                          style: kStyleNormal,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Units',
                          textAlign: TextAlign.start,
                          style: kStyleNormal,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Range',
                          textAlign: TextAlign.start,
                          style: kStyleNormal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox2(),
                const Divider(),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.myLabsModel.reports!.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      var data = widget.myLabsModel.reports![i];
                      return Container(
                        width: maxWidth(context),
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              data.labtest!.tests.toString(),
                              textAlign: TextAlign.start,
                              style: kStyleNormal.copyWith(fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              data.value.toString(),
                              textAlign: TextAlign.start,
                              style: kStyleNormal.copyWith(fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              data.labtest!.unit.toString(),
                              textAlign: TextAlign.start,
                              style: kStyleNormal.copyWith(fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${data.minRange.toString()} - ${data.maxRange.toString()}',
                              textAlign: TextAlign.start,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                color: kGreen,
                              ),
                            ),
                          ),
                          const Divider(),
                        ]),
                      );
                    }),
                const SizedBox12(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget deliveryAddressCard(myIcon, titleText, text) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              myIcon,
              size: 15.0,
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleText,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.end,
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
