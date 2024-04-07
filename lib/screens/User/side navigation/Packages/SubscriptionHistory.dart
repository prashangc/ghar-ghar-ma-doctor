import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:timelines/timelines.dart';

class SubscriptionHistory extends StatefulWidget {
  final List<Payment> payment;

  const SubscriptionHistory({super.key, required this.payment});

  @override
  State<SubscriptionHistory> createState() => _SubscriptionHistoryState();
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Subscription History',
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
                    widget.payment[index].createdAt.toString().substring(0, 10),
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
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
                                  myRow('Amount',
                                      'Rs ${widget.payment[index].amount}'),
                                  myRow('Payment Interval',
                                      widget.payment[index].paymentInterval),
                                  myRow(
                                      'Expiry Date',
                                      widget.payment[index].expiryDate ??
                                          'Pending'),
                                  myRow(
                                    'Extended Days',
                                    widget.payment[index].graceDays == null
                                        ? '0 days'
                                        : '${widget.payment[index].graceDays} days',
                                  ),
                                  myRow(
                                    'Prepaid Days',
                                    widget.payment[index].prepayDays == null
                                        ? '0 days'
                                        : '${widget.payment[index].prepayDays} days',
                                    showDivider: false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox2(),
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
                                  '12:00 PM',
                                  overflow: TextOverflow.ellipsis,
                                  style: kStyleNormal.copyWith(
                                    fontSize: 16.0,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.payment[index].expiryDate == null
                                  ? 'Paid'
                                  : DateTime.parse(widget
                                              .payment[index].expiryDate
                                              .toString())
                                          .isAfter(DateTime.now())
                                      ? 'Paid'
                                      : 'Expired',
                              overflow: TextOverflow.ellipsis,
                              style: kStyleNormal.copyWith(
                                fontSize: 16.0,
                                color: myColor.primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     myCachedNetworkImage(
                    //       60.0,
                    //       60.0,
                    //       '',
                    //       const BorderRadius.all(
                    //         Radius.circular(8.0),
                    //       ),
                    //       BoxFit.cover,
                    //     ),
                    //     const SizedBox(width: 12.0),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'Package Payment',
                    //             overflow: TextOverflow.ellipsis,
                    //             maxLines: 2,
                    //             style: kStyleNormal.copyWith(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 14.0,
                    //             ),
                    //           ),
                    //           const SizedBox2(),
                    //           const SizedBox2(),
                    //           Text(
                    //             'Rs ${widget.payment[index].amount}}',
                    //             style: kStyleNormal.copyWith(
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 11.0,
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //           const SizedBox2(),
                    //           const SizedBox2(),
                    //           // Row(
                    //           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           //   children: [
                    //           //     Text(
                    //           //       'hello',
                    //           //       style: kStyleNormal.copyWith(
                    //           //         fontWeight: FontWeight.bold,
                    //           //         fontSize: 15.0,
                    //           //       ),
                    //           //     ),
                    //           //     Text(
                    //           //       'X 2',
                    //           //       style: kStyleNormal.copyWith(
                    //           //         fontSize: 12.0,
                    //           //       ),
                    //           //     ),
                    //           //   ],
                    //           // ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),
              connectorStyleBuilder: (context, index) =>
                  ConnectorStyle.solidLine,
              indicatorStyleBuilder: (context, index) =>
                  IndicatorStyle.outlined,
              itemCount: widget.payment.length,
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
