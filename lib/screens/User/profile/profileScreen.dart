import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/CompanyDocuments.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/GeneralTabBarView.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/MyOrdersBookingsListTabView.dart';
import 'package:ghargharmadoctor/screens/User/profile/ProfileTabView/ProfileTabView.dart';
import 'package:ghargharmadoctor/screens/User/profile/editProfile.dart';
import 'package:ghargharmadoctor/screens/User/register/RegisterScreen.dart';
import 'package:ghargharmadoctor/screens/User/register/SelectUser.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GlobalForm/GlobalForm.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/CompanyProfileFormScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/QR/Qr.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

StateHandlerBloc refreshGlobalFormBloc = StateHandlerBloc();

class ProfileScreen extends StatefulWidget {
  final int tabIndex;
  const ProfileScreen({Key? key, required this.tabIndex}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  String? getToken;
  TabController? _tabController;
  TabController? _companyTabController;
  ProfileModel? profileModel;
  bool? customSwitchValue;
  final keyOne = GlobalKey();
  String? _weight,
      showGlobalFormUI,
      becomeMember,
      kycStatus,
      _height,
      _heightToPost,
      _upperBP,
      _lowerBP,
      _myBP,
      _bmiValue,
      _urlID,
      _gender;
  final bool _isBloodPressureLoading = false;
  final _form = GlobalKey<FormState>();
  StateHandlerBloc companyOrNormalProfileBloc = StateHandlerBloc();
  @override
  void initState() {
    super.initState();
    getProfileData();
    getToken = sharedPrefs.getFromDevice('token');
    _tabController =
        TabController(initialIndex: widget.tabIndex, length: 3, vsync: this);
    _companyTabController =
        TabController(initialIndex: 0, length: 2, vsync: this);

    showGlobalFormUI = sharedPrefs.getFromDevice('showGlobalFormUI') ?? 'empty';
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    becomeMember = sharedPrefs.getFromDevice("becomeMember");
    _urlID = profileModel!.id.toString();
    _weight = profileModel!.weight;
    _height = profileModel!.height;
    _myBP = profileModel!.bp;
    _gender = profileModel!.gender ?? 'Male';
    if (_weight != null && _height != null) {
      _calculateBMIWhenHeightInMeter();
    }
  }

  getProfileData() async {
    var profileResp =
        await API().getData(context, endpoints.getUserProfileEndpoint);
    ProfileModel profileModel = ProfileModel.fromJson(profileResp);
    sharedPrefs.storeToDevice("userProfile", jsonEncode(profileModel));
    if (profileModel.gender != null && profileModel.weight != null) {
      double genderConstant = (profileModel.gender == 'Male') ? 0.035 : 0.031;
      double waterIntake =
          double.parse(profileModel.weight.toString()) * genderConstant * 1000;
      if (waterIntake == waterIntake.toInt()) {
        sharedPrefs.storeToDevice("waterToDrinkDaily", waterIntake.toString());
      } else {
        sharedPrefs.storeToDevice(
            "waterToDrinkDaily", waterIntake.toStringAsFixed(2).toString());
      }
    }
  }

  void _calculateBMIWhenHeightInMeter() {
    double height = double.parse(_height.toString());
    double weight = double.parse(_weight.toString());

    double heightSquare = height * height;

    double result = (weight / heightSquare);

    setState(() {
      _bmiValue = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return getToken == null
        ? Scaffold(
            body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                width: maxWidth(context),
                height: 50,
                child: myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Register an account',
                    kStyleNormal.copyWith(
                      color: Colors.white,
                      fontSize: 15.0,
                    ), () {
                  goThere(context, const RegisterScreen());
                }),
              ),
              const SizedBox12(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: kStyleNormal,
                  ),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {
                      goThere(context, const LoginScreen());
                    },
                    child: Text(
                      'Login',
                      style: kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ))
        : Scaffold(
            backgroundColor: myColor.dialogBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 0.0,
              elevation: 0.0,
              backgroundColor: myColor.dialogBackgroundColor,
            ),
            body: SafeArea(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox12(),
                          myAppBarCard(),
                          const SizedBox12(),
                          profileInfoCard(),
                        ],
                      ),
                    ),
                    StreamBuilder<dynamic>(
                        initialData: 'user',
                        stream: companyOrNormalProfileBloc.stateStream,
                        builder: (compContext, compSnapshot) {
                          return compSnapshot.data != 'user'
                              ? Container()
                              : Column(
                                  children: [
                                    showGlobalFormUI == 'showGlobalFormUI'
                                        ? StreamBuilder<dynamic>(
                                            initialData: 0,
                                            stream: refreshGlobalFormBloc
                                                .stateStream,
                                            builder: (context, snapshot) {
                                              kycStatus = sharedPrefs
                                                  .getFromDevice("kycStatus");
                                              return Column(
                                                children: [
                                                  kycStatus ==
                                                              'kyc not verified.' ||
                                                          kycStatus ==
                                                              'kyc form not submitted.' ||
                                                          kycStatus ==
                                                              'kyc rejected.'
                                                      ? const SizedBox12()
                                                      : Container(),
                                                  kycStatus ==
                                                          'kyc not verified.'
                                                      ? kycCard(
                                                          () {
                                                            goThere(context,
                                                                const GlobalForm());
                                                          },
                                                          myColor
                                                              .scaffoldBackgroundColor
                                                              .withOpacity(0.4),
                                                          myColor
                                                              .primaryColorDark,
                                                          'Global Form Verification Pending',
                                                        )
                                                      : kycStatus ==
                                                              'kyc form not submitted.'
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12.0),
                                                              child:
                                                                  fillGlobalForm(
                                                                context,
                                                                'Please fill your global form.',
                                                              ),
                                                            )
                                                          : kycStatus ==
                                                                  'kyc rejected.'
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12.0),
                                                                  child:
                                                                      fillGlobalForm(
                                                                    context,
                                                                    'Your global form is rejected. Please re-fill with valid data.',
                                                                  ),
                                                                )
                                                              : Container(),
                                                ],
                                              );
                                            })
                                        : Container(),
                                  ],
                                );
                        }),
                    StreamBuilder<dynamic>(
                        initialData: 'user',
                        stream: companyOrNormalProfileBloc.stateStream,
                        builder: (compContext, compSnapshot) {
                          if ((_tabController!.index != 0 ||
                                  _companyTabController!.index != 0) &&
                              compSnapshot.data == 'loading') {
                            if (compSnapshot.data == 'user') {
                              companyOrNormalProfileBloc.storeData('company');
                            }
                            if (compSnapshot.data == 'company') {
                              companyOrNormalProfileBloc.storeData('user');
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                              child: LoadingShimmer(
                                width: maxWidth(context),
                                height: 300.0,
                              ),
                            );
                          } else {
                            return buildTabbarView(compSnapshot.data);
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
  }

  Widget myAppBarCard() {
    return SizedBox(
      width: maxWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          scannerCard(),
          switchUserCard(),
        ],
      ),
    );
  }

  Widget switchUserCard() {
    return StreamBuilder<dynamic>(
        initialData: profileModel,
        stream: refreshMainSreenBloc.stateStream,
        builder: (context, mySnapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mySnapshot.data.member!.roles!.length == 2
                  ? Container(
                      padding: const EdgeInsets.all(4.0),
                      child: customSwitch(
                          customSwitchValue ?? false,
                          mySnapshot.data.member!.roles![0].id! == 4
                              ? FontAwesomeIcons.userDoctor
                              : mySnapshot.data.member!.roles![0].id! == 5
                                  ? FontAwesomeIcons.userDoctor
                                  : mySnapshot.data.member!.roles![0].id! == 7
                                      ? FontAwesomeIcons.userNurse
                                      : mySnapshot.data.member!.roles![0].id! ==
                                              9
                                          ? FontAwesomeIcons.user
                                          : FontAwesomeIcons.user,
                          onValueChanged: (v) async {
                        customSwitchValue = v;
                        if (customSwitchValue == true) {
                          switchUserFunc(
                              context, mySnapshot.data.member!.roles![0].id!);
                        }
                      }),
                    )
                  : becomeMember == 'pending'
                      ? Tooltip(
                          decoration: BoxDecoration(
                            color: myColor.primaryColorDark,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          textStyle: kStyleNormal.copyWith(
                              fontSize: 12.0, color: kWhite),
                          triggerMode: TooltipTriggerMode.tap,
                          message: 'Partner Verification Pending',
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              FontAwesomeIcons.hourglass,
                              size: 14.0,
                              color: kBlack,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(4.0),
                          child:
                              // showCase2 == 'show'
                              //     ? myShowCase(
                              //         keyOne,
                              //         'Become a partner',
                              //         'Tap here to become our partner',
                              //         () {},
                              //         GestureDetector(
                              //           onTap: () {
                              //             goThere(context,
                              //                 const SelectUser());
                              //           },
                              //           child: Icon(
                              //             FontAwesomeIcons.userPlus,
                              //             size: 14.0,
                              //             color: kBlack,
                              //           ),
                              //         ),
                              //   )
                              // :
                              GestureDetector(
                            onTap: () {
                              goThere(context, const SelectUser());
                            },
                            child: Icon(
                              FontAwesomeIcons.userPlus,
                              size: 14.0,
                              color: kBlack,
                            ),
                          ),
                        ),
            ],
          );
        });
  }

  Widget scannerCard() {
    return GestureDetector(
        onTap: () {
          goThere(context, const QR());
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  8.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.qr_code,
                    color: myColor.primaryColorDark, size: 20.0),
                const SizedBox(width: 12.0),
                Text(
                  'Scanner',
                  textAlign: TextAlign.center,
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            )));
  }

  Widget profileInfoCard() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 40.0,
              color: kTransparent,
              alignment: Alignment.topCenter,
              width: maxWidth(context),
              child: StreamBuilder<dynamic>(
                  initialData: 'user',
                  stream: companyOrNormalProfileBloc.stateStream,
                  builder: (ct, st) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 12.0),
                        Text(
                          st.data == 'company' ? 'Company' : 'Profile',
                          textAlign: TextAlign.center,
                          style: kStyleNormal.copyWith(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        profileModel!.schoolProfile == null
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  companyOrNormalProfileBloc
                                      .storeData('loading');
                                  Future.delayed(
                                          const Duration(milliseconds: 500))
                                      .then((_) {
                                    if (st.data == 'company') {
                                      companyOrNormalProfileBloc
                                          .storeData('user');
                                    }
                                    if (st.data == 'user') {
                                      companyOrNormalProfileBloc
                                          .storeData('company');
                                    }
                                  });
                                },
                                child: const Icon(
                                  FontAwesomeIcons.repeat,
                                  size: 14.0,
                                ),
                              ),
                      ],
                    );
                  }),
            ),
            StreamBuilder<dynamic>(
                initialData: 'user',
                stream: companyOrNormalProfileBloc.stateStream,
                builder: (ctc, stc) {
                  if (stc.data == 'user') {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
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
                                  EditProfile(
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
                          RichText(
                            text: TextSpan(
                              style: kStyleNormal,
                              children: [
                                TextSpan(
                                  text: profileModel!.member!.name.toString(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${profileModel!.gdId}',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 16.0,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox2(),
                          Text(
                            profileModel!.member!.email.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox8(),
                          Container(
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              color: myColor.dialogBackgroundColor
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TabBar(
                                unselectedLabelColor: kBlack,
                                controller: _tabController,
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
                                  Tab(
                                    child: Text(
                                      'Settings',
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
                    );
                  } else if (stc.data == 'loading') {
                    return Stack(
                      children: [
                        companyProfileCard(),
                        const Positioned(
                            top: 1,
                            left: 1,
                            right: 1,
                            bottom: 1,
                            child: LoadingShimmer()),
                      ],
                    );
                  } else {
                    return companyProfileCard();
                  }
                }),
          ],
        ),
        Positioned(
          left: 12.0,
          child: StreamBuilder<dynamic>(
              initialData: 'user',
              stream: companyOrNormalProfileBloc.stateStream,
              builder: (compContext, compSnapshot) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        goThere(
                            context,
                            MyImageViewer(
                              url: compSnapshot.data == 'company'
                                  ? profileModel!
                                      .schoolProfile!.companyImagePath
                                      .toString()
                                  : profileModel!.imagePath.toString(),
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
                            backgroundColor: kWhite,
                            radius: 30.0,
                            child: myCachedNetworkImageCircle(
                                70.0,
                                70.0,
                                compSnapshot.data == 'company'
                                    ? profileModel!
                                        .schoolProfile!.companyImagePath
                                        .toString()
                                    : profileModel!.imagePath.toString(),
                                BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 1,
                        left: 1,
                        right: 1,
                        bottom: 1,
                        child: compSnapshot.data == 'loading'
                            ? const LoadingCircleShimmer()
                            : Container())
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget companyProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
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
              goThere(context, const CompanyProfileFormScreen());
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
          RichText(
            text: TextSpan(
              style: kStyleNormal,
              children: [
                TextSpan(
                  text: profileModel!.schoolProfile!.ownerName.toString(),
                  style: kStyleNormal.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' ${profileModel!.gdId}',
                  style: kStyleNormal.copyWith(
                    fontSize: 16.0,
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox2(),
          Text(
            profileModel!.member!.email.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox8(),
          Container(
            width: maxWidth(context),
            decoration: BoxDecoration(
              color: myColor.dialogBackgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TabBar(
                unselectedLabelColor: kBlack,
                controller: _companyTabController,
                labelColor: kWhite,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: myColor.primaryColorDark,
                ),
                tabs: [
                  Tab(
                    child: Text(
                      'Company Details',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Documents',
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
    );
  }

  Widget buildTabbarView(value) {
    return Expanded(
      child: value == 'company' && value != 'loading'
          ? TabBarView(
              controller: _companyTabController,
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileTabView(
                    profileModel: profileModel!,
                    companyOrNormalProfileBloc: companyOrNormalProfileBloc),
                CompanyDocuments(profileModel: profileModel!),
              ],
            )
          : TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileTabView(
                    profileModel: profileModel!,
                    companyOrNormalProfileBloc: companyOrNormalProfileBloc),
                MyOrdersBookingsListTabView(profileModel: profileModel!),
                GeneralTabView(profileModel: profileModel!),
              ],
            ),
    );
  }

  Widget kycCard(myTap, bgColor, borderColor, text) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline_outlined,
                  size: 17.0, color: borderColor),
              const SizedBox(width: 12.0),
              Text(
                text,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
            ],
          )),
    );
  }

  Widget myRadioButton(title, int index) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: kStyleNormal.copyWith(
                color: myColor.primaryColorDark, fontSize: 12.0),
          ),
          Radio(
            activeColor: myColor.primaryColorDark,
            value: index,
            groupValue: index,
            onChanged: (value) {
              setState(() {
                // test = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
