import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/constants/graph.dart';
import 'package:ghargharmadoctor/models/models.dart';

StateHandlerBloc refreshDoctorTimingBloc = StateHandlerBloc();

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({Key? key}) : super(key: key);

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  VendorProfileModel? profileModel;
  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("vendorProfile");
    profileModel = VendorProfileModel.fromJson(json.decode(test));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myColor.dialogBackgroundColor,
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: maxWidth(context),
          height: maxHeight(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: maxWidth(context),
                color: myColor.dialogBackgroundColor,
                height: 6.0,
              ),
              logoCard(),
              appointmentCard(),
              const SizedBox32(),
              const SizedBox12(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Product Orders Line Chart',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox16(),
                        myGraph(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      width: maxWidth(context),
      color: myColor.dialogBackgroundColor,
      child: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/gd_logo_banner.png',
                  width: maxWidth(context) / 2,
                  height: 70.0,
                  fit: BoxFit.cover,
                ),
                CircleAvatar(
                  backgroundColor: kWhite.withOpacity(0.4),
                  radius: 25.0,
                  child: myCachedNetworkImageCircle(
                    50.0,
                    50.0,
                    profileModel!.imagePath,
                    BoxFit.cover,
                  ),
                )
              ]),
          const SizedBox8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Followers : ${profileModel!.followerCount}',
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: myColor.primaryColorDark,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Rating : ${profileModel!.averageRating}',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: myColor.primaryColorDark,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(
                    Icons.star,
                    color: kAmber,
                    size: 14.0,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget appointmentCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: maxWidth(context),
          height: 70.0,
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          child: Row(
            children: [
              appointmentCountCard(kAmber, 'Total\nProduct', Icons.timer, '40'),
              const SizedBox(width: 12.0),
              appointmentCountCard(
                  kGreen, 'Total\nTags', Icons.check_circle_outline, '40'),
              const SizedBox(width: 12.0),
              appointmentCountCard(
                  kRed, 'Total\nSlider', Icons.remove_circle_outline, '40'),
              const SizedBox(width: 12.0),
              appointmentCountCard(myColor.primaryColorDark, 'Total\nOrders',
                  Icons.date_range, '40'),
            ],
          ),
        ),
      ],
    );
  }

  Widget appointmentCountCard(cardColor, text, icon, value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          border: Border.all(color: cardColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.4),
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              Text(
                text,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: kStyleNormal.copyWith(
                  fontSize: 10.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox8(),
              Icon(
                icon,
                size: 24.0,
                color: cardColor,
              ),
              const SizedBox8(),
              Text(
                value,
                style: kStyleNormal.copyWith(
                  fontSize: 16.0,
                  color: myColor.primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
