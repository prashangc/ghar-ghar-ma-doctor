import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/NurseTabViews/NurseMyDetailsTab.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/NurseTabViews/NurseProfileTab.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/editNurseProfile.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class NurseProfileScreen extends StatefulWidget {
  const NurseProfileScreen({Key? key}) : super(key: key);

  @override
  State<NurseProfileScreen> createState() => _NurseProfileScreenState();
}

class _NurseProfileScreenState extends State<NurseProfileScreen> {
  NurseProfileModel? profileModel;
  bool? customSwitchValue;
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

  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("nurseProfile");
    profileModel = NurseProfileModel.fromJson(json.decode(test));
    _gender = profileModel!.gender ?? 'Male';
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
                    customSwitchValue ?? true, FontAwesomeIcons.userNurse,
                    onValueChanged: (v) async {
                  customSwitchValue = v;
                  if (customSwitchValue == false) {
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
                  }
                })
              ],
            ),
          ),
        ],
      ),
      body: DefaultTabController(
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
                          color:
                              myColor.scaffoldBackgroundColor.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        width: maxWidth(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox8(),
                            GestureDetector(
                              onTap: () {
                                goThere(
                                    context,
                                    EditNurseProfileScreen(
                                      profileModel: profileModel!,
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                            color: myColor.primaryColorDark,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Icon(
                                          Icons.edit,
                                          color: myColor.primaryColorDark,
                                          size: 14.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              profileModel!.user!.name.toString().capitalize(),
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
                                  physics: const BouncingScrollPhysics(),
                                  labelColor:
                                      Colors.white, //<-- selected text color
                                  unselectedLabelColor: Colors.black,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: myColor.scaffoldBackgroundColor
                                        .withOpacity(0.4),
                                  ),
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'My Details',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        'My Lists',
                                        style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.4,
                                            fontSize: 13.0),
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
                      )
                    ],
                  ),
                ],
              ),
            ),
            profileModel!.fee == null
                ? Container(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
                    child: infoCard(
                      context,
                      kWhite.withOpacity(0.4),
                      myColor.primaryColorDark,
                      'Please update your profile to receive appointments',
                    ),
                  )
                : Container(),
            buildTabbarView(),
            const SizedBox16(),
            const SizedBox32(),
          ],
        ),
      ),
    );
  }

  Widget buildTabbarView() {
    return Expanded(
      child: TabBarView(
        children: [
          NurseProfileTab(profileModel: profileModel!),
          NurseMyDetailsTab(profileModel: profileModel!),
        ],
      ),
    );
  }
}
