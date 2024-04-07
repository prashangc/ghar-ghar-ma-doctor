import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/IndividuaPackagePage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PackageCalculator.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDescriptionPage extends StatefulWidget {
  final PackagesModel packagesModel;
  final bool? showCalculator;
  final bool? isCorporate;
  const PackageDescriptionPage(
      {super.key,
      required this.packagesModel,
      this.showCalculator,
      this.isCorporate});

  @override
  State<PackageDescriptionPage> createState() => _PackageDescriptionPageState();
}

class _PackageDescriptionPageState extends State<PackageDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
          title: widget.packagesModel.packageType.toString(),
          color: myColor.colorScheme.background,
          borderRadius: 0.0),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          children: [
            const SizedBox12(),
            widget.showCalculator == true ? schoolValidationUI() : Container(),
            Expanded(
              child: Container(
                width: maxWidth(context),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
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
                            packageDetailsCard(),
                            const SizedBox12(),
                            // ListView.builder(
                            //     itemCount: packageDescTimelineList.length,
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     itemBuilder: (ctx, i) {
                            //       return timelineCard(
                            //           packageDescTimelineList, i);
                            //     }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: myColor.dialogBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        width: maxWidth(context),
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.showCalculator == true) {
                  goThere(context,
                      PackageCalculator(packagesModel: widget.packagesModel));
                } else {
                  goThere(
                    context,
                    IndividuaPackagePage(
                      packagesModel: widget.packagesModel,
                      isCorporate: widget.isCorporate,
                    ),
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: myColor.primaryColorDark,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 6.0),
                    Text(
                      widget.showCalculator == true ? 'Calculator' : 'Next',
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: kWhite,
                      size: 24.0,
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

  Widget packageDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Package Description',
        //   style: kStyleNormal.copyWith(
        //     color: myColor.primaryColorDark,
        //     fontSize: 18.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox8(),
        ListView.builder(
            itemCount: packageDescTimelineList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) {
              return textCard(
                title: packageDescTimelineList[i].title.capitalize(),
                text: packageDescTimelineList[i].desc,
                value: packageDescTimelineList[i].title == 'family'
                    ? '${widget.packagesModel.fees![0].familySize}-${widget.packagesModel.fees![widget.packagesModel.fees!.length - 1].familySize}'
                    : packageDescTimelineList[i].title == 'test'
                        ? 'upto ${widget.packagesModel.tests}'
                        : packageDescTimelineList[i].title == 'visit'
                            ? '${widget.packagesModel.visits} times / year'
                            : packageDescTimelineList[i].title == 'consultation'
                                ? '${widget.packagesModel.onlineConsultation} times / year'
                                : packageDescTimelineList[i].title ==
                                        'ambulance'
                                    ? 'Available'
                                    : '${widget.packagesModel.insuranceAmount} /-',
              );
            }),
        const SizedBox8(),
        Text(
          'What\'s Included:',
          style: kStyleNormal.copyWith(
            color: myColor.primaryColorDark,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox8(),
        htmlText(widget.packagesModel.description.toString()),
      ],
    );
  }

  Widget textCard({title, value, text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kStyleNormal.copyWith(
            color: myColor.primaryColorDark,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox8(),
        Row(children: [
          Text(
            '$value  ',
            style: kStyleNormal.copyWith(
              color: myColor.primaryColorDark,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            text,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        ]),
        const SizedBox8(),
        Divider(color: kWhite),
        const SizedBox8(),
      ],
    );
  }

  Widget timelineCard(List<PackageDescTimelineList> list, i) {
    return SizedBox(
      width: maxWidth(context),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 14.0,
                  margin: const EdgeInsets.only(left: 5.0),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.4),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(i == 0 ? 8.0 : 0.0),
                      bottomLeft:
                          Radius.circular(i == (list.length - 1) ? 8.0 : 0.0),
                      topRight: Radius.circular(i == 0 ? 8.0 : 0.0),
                      bottomRight:
                          Radius.circular(i == (list.length - 1) ? 8.0 : 0.0),
                    ),
                  ),
                ),
                Container(
                  color: kWhite.withOpacity(0.4),
                  width: 30.0,
                  height: 3.0,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: myColor.primaryColorDark,
                      border: Border.all(color: kTransparent, width: 3.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              bottomLeft: Radius.circular(35.0),
                            ),
                            child: CustomPaint(
                              painter: PointedContainerPainter(),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        list[i].title == 'family'
                                            ? '${widget.packagesModel.fees![0].familySize}-${widget.packagesModel.fees![widget.packagesModel.fees!.length - 1].familySize}'
                                            : list[i].title == 'test'
                                                ? 'upto 43'
                                                : list[i].title == 'visit'
                                                    ? '${widget.packagesModel.visits} times / year'
                                                    : list[i].title ==
                                                            'consultation'
                                                        ? '${widget.packagesModel.onlineConsultation} times / year'
                                                        : list[i].title ==
                                                                'ambulance'
                                                            ? 'Available'
                                                            : '${widget.packagesModel.insuranceAmount} /-',
                                        style: kStyleNormal.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: myColor.primaryColorDark,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      const SizedBox2(),
                                      Text(
                                        list[i].desc,
                                        style: kStyleNormal.copyWith(
                                          color: myColor.primaryColorDark,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        CircleAvatar(
                          backgroundColor: kWhite,
                          // radius: 24.0,
                          child: Icon(
                            list[i].icon,
                            color: myColor.primaryColorDark,
                            size: list[i].title == 'ambulance' ||
                                    list[i].title == 'insurance'
                                ? 12.0
                                : 16.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: kWhite,
                radius: 12.0,
                child: CircleAvatar(
                  backgroundColor: myColor.primaryColorDark,
                  radius: 8.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget schoolValidationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            launchUrl(Uri.parse("tel://015917322"));
          },
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              width: maxWidth(context),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 205, 202),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
                border: Border.all(color: kRed, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.error_outline_outlined,
                          size: 17.0, color: kRed),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          'Please contact GD to buy ${widget.packagesModel.packageType} Package',
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox8(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Call Now',
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: kRed,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: kRed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ),
        const SizedBox16(),
      ],
    );
  }
}

class PointedContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tagWidth = size.width;
    final tagHeight = size.height;

    final paint = Paint()
      ..color = kWhite
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(tagWidth - 20, 0)
      ..lineTo(tagWidth, tagHeight / 2)
      ..lineTo(tagWidth - 20, tagHeight)
      ..lineTo(0, tagHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
