import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/OurServicesModel.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class IndividualServicePage extends StatefulWidget {
  final OurServicesModel ourServiceModel;
  const IndividualServicePage({Key? key, required this.ourServiceModel})
      : super(key: key);

  @override
  State<IndividualServicePage> createState() => _IndividualServicePageState();
}

class _IndividualServicePageState extends State<IndividualServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const myCustomAppBar(
        title: '',
        color: Colors.transparent,
        borderRadius: 12.0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Stack(
            children: [
              myCachedNetworkImage(
                maxWidth(context),
                280.0,
                widget.ourServiceModel.imagePath.toString(),
                const BorderRadius.all(Radius.circular(0.0)),
                BoxFit.cover,
              ),
              Positioned(
                bottom: 10.0,
                left: 10.0,
                right: 10.0,
                child: SizedBox(
                  width: maxWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.ourServiceModel.serviceTitle.toString(),
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: myColor.primaryColorDark,
                              size: 12.0,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              widget.ourServiceModel.createdAt
                                  .toString()
                                  .substring(0, 10),
                              textAlign: TextAlign.justify,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                color: myColor.primaryColorDark,
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
            ],
          ),
          Expanded(
            child: Container(
              width: maxWidth(context),
              // height: maxWidth(context),
              decoration: BoxDecoration(
                color: myColor.dialogBackgroundColor,
                // color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: SizedBox(
                width: maxWidth(context),
                height: maxWidth(context),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: maxWidth(context),
                          child: htmlText(
                            widget.ourServiceModel.longDescription.toString(),
                          ),
                        ),
                        const SizedBox12(),
                        Text(
                          'Related Services',
                          style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox32(),
                        const SizedBox32(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
