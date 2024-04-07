import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/OurServicesModel.dart';
import 'package:ghargharmadoctor/screens/User/home/OurServices/IndividualServicePage.dart';
import 'package:ghargharmadoctor/screens/User/home/LabServices/LabServices.dart';

class OurServices extends StatefulWidget {
  final List<OurServicesModel> ourServicesModel;

  const OurServices({Key? key, required this.ourServicesModel})
      : super(key: key);

  @override
  State<OurServices> createState() => _OurServicesState();
}

class _OurServicesState extends State<OurServices> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox12(),
        SizedBox(
          width: maxWidth(context),
          height: 130,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    goThere(context, const LabServices());
                  },
                  child: Container(
                    width: maxWidth(context) / 3,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: myColor.dialogBackgroundColor
                                  .withOpacity(0.4),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0),
                              ),
                            ),
                            width: maxWidth(context),
                            child: myCachedNetworkImage(
                              maxWidth(context),
                              maxHeight(context),
                              widget.ourServicesModel[0].imagePath.toString(),
                              const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                myColor.dialogBackgroundColor.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5.0),
                          width: maxWidth(context),
                          height: 30.0,
                          child: Center(
                            child: Text(
                              'Lab Service',
                              overflow: TextOverflow.ellipsis,
                              style: kStyleNormal.copyWith(
                                  fontSize: 10.0, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.ourServicesModel.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          goThere(
                              context,
                              IndividualServicePage(
                                  ourServiceModel: widget.ourServicesModel[i]));
                        },
                        child: Container(
                          width: maxWidth(context) / 3,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          margin: const EdgeInsets.only(right: 12.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: myColor.dialogBackgroundColor
                                        .withOpacity(0.4),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0),
                                    ),
                                  ),
                                  width: maxWidth(context),
                                  child: myCachedNetworkImage(
                                    maxWidth(context),
                                    maxHeight(context),
                                    widget.ourServicesModel[i].iconPath
                                        .toString(),
                                    const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12)),
                                    BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: myColor.dialogBackgroundColor
                                      .withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(12.0),
                                    bottomLeft: Radius.circular(12.0),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 5.0),
                                width: maxWidth(context),
                                height: 30.0,
                                child: Center(
                                  child: Text(
                                    widget.ourServicesModel[i].serviceTitle
                                        .toString(),
                                    // maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: kStyleNormal.copyWith(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
