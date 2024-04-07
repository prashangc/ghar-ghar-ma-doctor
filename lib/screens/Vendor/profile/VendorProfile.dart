import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/DoctorProfileTabView/DoctorProfileTabView.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/Vendor/profile/VendorProfileTabView/VendorMyDetailsTabView.dart';
import 'package:ghargharmadoctor/screens/Vendor/profile/VendorProfileTabView/VendorProfileTabView.dart';
import 'package:ghargharmadoctor/screens/Vendor/profile/editVendorProfile.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({Key? key}) : super(key: key);

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  VendorProfileModel? profileModel;
  String? _weight,
      _height,
      _heightToPost,
      _upperBP,
      _lowerBP,
      _myBP,
      _bmiValue,
      _urlID,
      _gender;
  final _form = GlobalKey<FormState>();
  bool? customSwitchValue;

  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("vendorProfile");
    profileModel = VendorProfileModel.fromJson(json.decode(test));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.dialogBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60.0,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: myColor.dialogBackgroundColor,
        title: Text(
          'Profile',
          style: kStyleNormal.copyWith(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customSwitch(
                    customSwitchValue ?? true, FontAwesomeIcons.userDoctor,
                    onValueChanged: (v) async {
                  customSwitchValue = v;
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (customSwitchValue == false) {
                      String image =
                          sharedPrefs.getFromDevice('userProfilePicture');
                      String name = sharedPrefs.getFromDevice('userName');
                      goThere(
                        context,
                        MainHomePage(
                          index: 4,
                          tabIndex: 0,
                          isSwitched: true,
                          image: image,
                          name: name,
                        ),
                      );
                    }
                  });
                })
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.0,
                      color: Colors.transparent,
                      width: maxWidth(context),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: myColor.scaffoldBackgroundColor
                                .withOpacity(0.4),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          width: maxWidth(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox8(),
                              StreamBuilder<dynamic>(
                                  initialData: profileModel!,
                                  stream: refreshDoctorProfileBloc.stateStream,
                                  builder: (c, s) {
                                    return GestureDetector(
                                      onTap: () {
                                        goThere(
                                            context,
                                            EditVendorProfileScreen(
                                              profileModel: s.data,
                                            ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 3.0),
                                                Text(
                                                  'Edit',
                                                  style: kStyleNormal.copyWith(
                                                    fontSize: 16.0,
                                                    color: myColor
                                                        .primaryColorDark,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Icon(
                                                  Icons.edit,
                                                  color:
                                                      myColor.primaryColorDark,
                                                  size: 14.0,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                              Text(
                                profileModel!.user!.name
                                    .toString()
                                    .capitalize(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox2(),
                              Text(
                                profileModel!.user!.email.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox8(),
                              Container(
                                width: maxWidth(context),
                                decoration: BoxDecoration(
                                  color: myColor.dialogBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TabBar(
                                    unselectedLabelColor: kBlack,
                                    labelColor: kWhite,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: myColor.primaryColorDark,
                                    ),
                                    tabs: [
                                      Tab(
                                        child: Text(
                                          'My Details',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.sourceSansPro(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Text(
                                          'My Lists',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.sourceSansPro(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox8(),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -35.0,
                          left: 12.0,
                          child: GestureDetector(
                            onTap: () {
                              goThere(
                                  context,
                                  MyImageViewer(
                                    url: profileModel!.imagePath.toString(),
                                  ));
                            },
                            child: Hero(
                              tag: 'profilePic',
                              child: Container(
                                width: 65.0,
                                height: 65.0,
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 0.3,
                                        color: myColor.dialogBackgroundColor
                                            .withOpacity(0.8),
                                        spreadRadius: 1)
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  child: myCachedNetworkImageCircle(
                                      70.0,
                                      70.0,
                                      profileModel!.imagePath.toString(),
                                      BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              buildTabbarView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabbarView() {
    return Expanded(
      child: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          VendorProfileTabView(profileModel: profileModel!),
          VendorMyDetailsTabView(profileModel: profileModel!),
        ],
      ),
    );
  }
}
