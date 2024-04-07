import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PostFcmTokenModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/ForgetPassword/ChangePassword.dart';
import 'package:ghargharmadoctor/screens/User/profile/UpdatePhoneNumber/UpdatePhoneNumberScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/editProfile.dart';
import 'package:ghargharmadoctor/screens/User/profile/referFriend.dart';
import 'package:ghargharmadoctor/screens/User/profile/refreshMethod.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc switchBloc = StateHandlerBloc();

class GeneralTabView extends StatefulWidget {
  final ProfileModel profileModel;

  const GeneralTabView({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<GeneralTabView> createState() => _GeneralTabViewState();
}

class _GeneralTabViewState extends State<GeneralTabView> {
  final form = GlobalKey<FormState>();

  String? biometricUserID, biometricEmail, biometricType;
  bool? isSwitched, isBiometricSupported;
  Check2FactorModel? check2FactorModel;
  Check2FactorModel? check2FactorModelForGeneralNoti;
  StateHandlerBloc? notificationSwitchBloc,
      generalNotiSwitchBloc,
      enableDiable2FABloc;
  ApiHandlerBloc? twoFactorBloc, checkGeneralBloc;
  ReportSubjectModel reportSubjectModel = ReportSubjectModel();
  String? fcmToken;
  @override
  void initState() {
    super.initState();
    fcmToken = sharedPrefs.getFromDevice('fcm');
    twoFactorBloc = ApiHandlerBloc();
    checkGeneralBloc = ApiHandlerBloc();
    checkGeneralBloc!.fetchAPIList(endpoints.checkGeneralNotiEndpoint);
    twoFactorBloc!.fetchAPIList('check-2fa/${widget.profileModel.memberId}');
    enableDiable2FABloc = StateHandlerBloc();
    notificationSwitchBloc = StateHandlerBloc();
    generalNotiSwitchBloc = StateHandlerBloc();
    checkBiometric();
    // myCheckBiometricSupport();
  }

  checkBiometric() async {
    biometricType = await getBiometricType();
    print('biometricType $biometricType');
    if (biometricType != 'device doesnt support') {
      biometricUserID = sharedPrefs.getFromDevice('biometricUserID');
      biometricEmail = sharedPrefs.getFromDevice('biometricEmail');
      if (biometricUserID != null &&
          biometricUserID == widget.profileModel.member!.id.toString()) {
        switchBloc.storeData(true);
      } else {
        switchBloc.storeData(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
      child: RefreshIndicator(
        edgeOffset: 0,
        strokeWidth: 2.0,
        color: kWhite,
        backgroundColor: myColor.primaryColorDark,
        onRefresh: () async {
          await refresh(context);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _generalCard(context),
              const SizedBox12(),
              _settingsCard(context),
              const SizedBox12(),
              socialMediaCard(context),
              const SizedBox12(),
              Text(
                'Support',
                style: kStyleNormal.copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox12(),
              supportCard(context),
              const SizedBox16(),
              logout(context),
              const SizedBox32(),
              const SizedBox32(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _generalCard(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Text(
            'General',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox12(),
          sideNavList(
            Icons.perm_identity_outlined,
            'Refer a friend',
            16.0,
            () {
              goThere(
                  context, ReferFriendPage(profileModel: widget.profileModel));
            },
          ),
          sideNavList(
            Icons.call_outlined,
            'Update Mobile No.',
            16.0,
            () {
              widget.profileModel.dob == null ||
                      widget.profileModel.gender == null
                  ? goThere(
                      context,
                      EditProfile(
                        profileModel: widget.profileModel,
                      ))
                  : showModalBottomSheet(
                      context: context,
                      backgroundColor: backgroundColor,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: ((builder) => confirmPasswordBottomSheet(
                          context,
                          const UpdatePhoneNumberScreen(),
                          (biometricUserID != null &&
                                      biometricUserID !=
                                          widget.profileModel.member!.id
                                              .toString()) ||
                                  biometricType == 'not added in device' ||
                                  biometricType == 'device doesnt support'
                              ? false
                              : true)),
                    );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 17,
                color: kBlack,
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Authorize Notification\n',
                    style: kStyleNormal.copyWith(color: kBlack, fontSize: 13.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: '( Recommended )',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: myColor.primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: myColor.dialogBackgroundColor,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: ((builder) => authNotificationBottomSheet()));
                },
                child: Icon(
                  Icons.error_outline_outlined,
                  color: myColor.primaryColorDark,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 14.0),
              SizedBox(
                  width: 45,
                  child: StreamBuilder<dynamic>(
                      initialData: false,
                      stream: notificationSwitchBloc!.stateStream,
                      builder: (notiContext, notiSnapshot) {
                        return Switch(
                          value: notiSnapshot.data,
                          onChanged: (value) async {
                            if (notiSnapshot.data == false) {
                              notificationSwitchBloc!.storeData(true);

                              int code = await API().postData(
                                  context,
                                  PostFcmTokenModel(
                                    deviceKey: fcmToken,
                                    platform:
                                        Platform.isAndroid ? 'Android' : 'iOS',
                                  ),
                                  endpoints.postFCMTokenEndpoint);
                              if (code != 200) {
                                notificationSwitchBloc!.storeData(false);
                              }
                            } else {
                              notificationSwitchBloc!.storeData(false);
                              int code = await API().deleteData(
                                  context: context,
                                  Platform.isAndroid
                                      ? '${endpoints.deleteFCMWhileLogoutEndpoint}?platform=Android'
                                      : '${endpoints.deleteFCMWhileLogoutEndpoint}?platform=iOS',
                                  model: AppAnalyticsPostModel(
                                    platform:
                                        Platform.isAndroid ? 'Android' : 'iOS',
                                  ));
                              if (code != 200) {
                                notificationSwitchBloc!.storeData(true);
                              }
                            }
                          },
                          activeTrackColor:
                              myColor.primaryColorDark.withOpacity(0.3),
                          activeColor: myColor.primaryColorDark,
                          inactiveTrackColor: Colors.grey[200],
                        );
                      })),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_none,
                size: 17,
                color: kBlack,
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'General Notification',
                    style: kStyleNormal.copyWith(color: kBlack, fontSize: 13.0),
                    children: const <TextSpan>[],
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: myColor.dialogBackgroundColor,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: ((builder) => generalNotificationBottomSheet()));
                },
                child: Icon(
                  Icons.error_outline_outlined,
                  color: myColor.primaryColorDark,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 14.0),
              StreamBuilder<ApiResponse<dynamic>>(
                stream: checkGeneralBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return SizedBox(
                          width: 45,
                          child: Switch(
                            value: false,
                            onChanged: (value) async {},
                            activeTrackColor:
                                myColor.primaryColorDark.withOpacity(0.3),
                            activeColor: myColor.primaryColorDark,
                            inactiveTrackColor: Colors.grey[200],
                          ),
                        );
                      case Status.COMPLETED:
                        if (snapshot.data!.data!.isEmpty) {
                          return SizedBox(
                            width: 45,
                            child: Switch(
                              value: false,
                              onChanged: (value) async {},
                              activeTrackColor:
                                  myColor.primaryColorDark.withOpacity(0.3),
                              activeColor: myColor.primaryColorDark,
                              inactiveTrackColor: Colors.grey[200],
                            ),
                          );
                        }
                        check2FactorModelForGeneralNoti =
                            Check2FactorModel.fromJson(snapshot.data!.data);
                        return StreamBuilder<dynamic>(
                            initialData:
                                check2FactorModelForGeneralNoti!.fcmStored,
                            stream: enableDiable2FABloc!.stateStream,
                            builder: (context, s) {
                              return SizedBox(
                                  width: 45,
                                  child: StreamBuilder<dynamic>(
                                      initialData: false,
                                      stream:
                                          generalNotiSwitchBloc!.stateStream,
                                      builder:
                                          (notiContext, generalNotiSnapshot) {
                                        return Switch(
                                          value: generalNotiSnapshot.data,
                                          onChanged: (value) async {
                                            if (generalNotiSnapshot.data ==
                                                false) {
                                              generalNotiSwitchBloc!
                                                  .storeData(true);
                                              int code = await API().postData(
                                                  context,
                                                  TopicBasedNotiModel(
                                                      deviceKey: fcmToken),
                                                  endpoints
                                                      .postGeneralNotiEndpoint);
                                              if (code != 200) {
                                                generalNotiSwitchBloc!
                                                    .storeData(false);
                                              }
                                            } else {
                                              generalNotiSwitchBloc!
                                                  .storeData(false);

                                              int code = await API().deleteData(
                                                endpoints
                                                    .delGeneralNotiEndpoint,
                                                context: context,
                                                model: TopicBasedNotiModel(
                                                    deviceKey: fcmToken),
                                              );
                                              if (code != 200) {
                                                generalNotiSwitchBloc!
                                                    .storeData(true);
                                              }
                                            }
                                          },
                                          activeTrackColor: myColor
                                              .primaryColorDark
                                              .withOpacity(0.3),
                                          activeColor: myColor.primaryColorDark,
                                          inactiveTrackColor: Colors.grey[200],
                                        );
                                      }));
                            });
                      case Status.ERROR:
                        return SizedBox(
                          width: 45,
                          child: Switch(
                            value: false,
                            onChanged: (value) async {},
                            activeTrackColor:
                                myColor.primaryColorDark.withOpacity(0.3),
                            activeColor: myColor.primaryColorDark,
                            inactiveTrackColor: Colors.grey[200],
                          ),
                        );
                    }
                  }
                  return const SizedBox();
                }),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: kBlack,
                size: 17.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'OTP login\n',
                    style: kStyleNormal.copyWith(color: kBlack, fontSize: 13.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: '( Recommended )',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                          color: myColor.primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: myColor.dialogBackgroundColor,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: ((builder) => twoFactorAuthBottomSheet()));
                },
                child: Row(
                  children: [
                    Text(
                      '',
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Icon(
                      Icons.error_outline_outlined,
                      color: myColor.primaryColorDark,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14.0),
              StreamBuilder<ApiResponse<dynamic>>(
                stream: twoFactorBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return SizedBox(
                          width: 45,
                          child: Switch(
                            value: false,
                            onChanged: (value) async {},
                            activeTrackColor:
                                myColor.primaryColorDark.withOpacity(0.3),
                            activeColor: myColor.primaryColorDark,
                            inactiveTrackColor: Colors.grey[200],
                          ),
                        );
                      case Status.COMPLETED:
                        if (snapshot.data!.data!.isEmpty) {
                          return SizedBox(
                            width: 45,
                            child: Switch(
                              value: false,
                              onChanged: (value) async {},
                              activeTrackColor:
                                  myColor.primaryColorDark.withOpacity(0.3),
                              activeColor: myColor.primaryColorDark,
                              inactiveTrackColor: Colors.grey[200],
                            ),
                          );
                        }
                        check2FactorModel =
                            Check2FactorModel.fromJson(snapshot.data!.data);
                        notificationSwitchBloc!
                            .storeData(check2FactorModel!.fcmStored);

                        return StreamBuilder<dynamic>(
                            initialData: check2FactorModel!.isEnabled,
                            stream: enableDiable2FABloc!.stateStream,
                            builder: (context, s) {
                              return SizedBox(
                                width: 45,
                                child: Switch(
                                  value: s.data,
                                  onChanged: (value) async {
                                    enableDiable2FABloc!.storeData(value);
                                    post2FAMethod(value);
                                  },
                                  activeTrackColor:
                                      myColor.primaryColorDark.withOpacity(0.3),
                                  activeColor: myColor.primaryColorDark,
                                  inactiveTrackColor: Colors.grey[200],
                                ),
                              );
                            });
                      case Status.ERROR:
                        return SizedBox(
                          width: 45,
                          child: Switch(
                            value: false,
                            onChanged: (value) async {},
                            activeTrackColor:
                                myColor.primaryColorDark.withOpacity(0.3),
                            activeColor: myColor.primaryColorDark,
                            inactiveTrackColor: Colors.grey[200],
                          ),
                        );
                    }
                  }
                  return const SizedBox();
                }),
              ),
            ],
          ),
          Container(height: 6),
        ],
      ),
    );
  }

  Widget generalNotificationBottomSheet() {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
          left: 12.0,
          right: 12.0),
      child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            'How it works ?',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox16(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: generalNotiDescList.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: kWhite.withOpacity(0.4),
                            child: Text(
                              (i + 1).toString(),
                              style: kStyleNormal.copyWith(fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              generalNotiDescList[i].desc.toString(),
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox8(),
            ],
          )),
    );
  }

  Widget authNotificationBottomSheet() {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12.0,
          right: 12.0),
      child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            'How it works ?',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox16(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: authNotiDescList.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: kWhite.withOpacity(0.4),
                            child: Text(
                              (i + 1).toString(),
                              style: kStyleNormal.copyWith(fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              authNotiDescList[i].desc.toString(),
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox8(),
            ],
          )),
    );
  }

  Widget twoFactorAuthBottomSheet() {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12.0,
          right: 12.0),
      child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            '2 Factor Authentication',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox16(),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: twoFactorDescList.length,
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 10.0,
                            backgroundColor: kWhite.withOpacity(0.4),
                            child: Text(
                              (i + 1).toString(),
                              style: kStyleNormal.copyWith(fontSize: 10.0),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: kStyleNormal,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: twoFactorDescList[i].one.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: twoFactorDescList[i].two.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: twoFactorDescList[i].three.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: twoFactorDescList[i].four.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: twoFactorDescList[i].five.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              const SizedBox8(),
            ],
          )),
    );
  }

  post2FAMethod(boolValue) async {
    int code;
    if (boolValue == false) {
      code = 0;
    } else {
      code = 1;
    }
    int statusCode;
    statusCode = await API().postData(context, Check2FactorModel(),
        'toggle-2fa/${widget.profileModel.memberId}/$code');
    if (statusCode == 200) {
    } else {
      enableDiable2FABloc!.storeData(!boolValue);
    }
  }

  Widget _settingsCard(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Text(
            'Privacy',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox12(),
          StreamBuilder<dynamic>(
              initialData: isSwitched ?? 'device has no biometric',
              stream: switchBloc.stateStream,
              builder: (context, snapshot) {
                return sideNavList(
                  Icons.lock_outline,
                  'Change Password',
                  16.0,
                  () {
                    goThere(context, const ChangePassword());
                  },
                  showDivider:
                      snapshot.data == 'device has no biometric' ? false : true,
                );
              }),
          biometricUserID != null &&
                  biometricUserID != widget.profileModel.member!.id.toString()
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  width: maxWidth(context),
                  child: StreamBuilder<dynamic>(
                      initialData: isSwitched ?? 'device has no biometric',
                      stream: switchBloc.stateStream,
                      builder: (c, snapshot) {
                        if (snapshot.data == 'device has no biometric') {
                          return Container();
                        } else {
                          return Row(
                            children: [
                              Icon(
                                Icons.fingerprint_outlined,
                                color: kBlack,
                                size: 17.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  'Setup Biometrics',
                                  style: kStyleNormal.copyWith(),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              SizedBox(
                                width: 45,
                                child: Switch(
                                  value: snapshot.data,
                                  onChanged: (value) async {
                                    final isBiometricAvialable =
                                        await LocalAuthApi.getBiometrics();
                                    if (snapshot.data == true) {
                                      pop_upHelper.popUpDelete(context, () {
                                        Navigator.pop(context);
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: backgroundColor,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          builder: ((builder) =>
                                              setupBiometricsBottomSheet(
                                                  context,
                                                  form,
                                                  'removingBiometric')),
                                        );
                                      });
                                    } else {
                                      if (biometricType ==
                                          'not added in device') {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                myColor.dialogBackgroundColor,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20))),
                                            builder: ((builder) =>
                                                goToSettingsBottomSheet()));
                                      } else {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: backgroundColor,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          builder: ((builder) =>
                                              setupBiometricsBottomSheet(
                                                  context,
                                                  form,
                                                  'addingBiometric')),
                                        );
                                      }
                                    }
                                  },
                                  activeTrackColor:
                                      myColor.primaryColorDark.withOpacity(0.3),
                                  activeColor: myColor.primaryColorDark,
                                  inactiveTrackColor: Colors.grey[200],
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
        ],
      ),
    );
  }

  Widget goToSettingsBottomSheet() {
    return StatefulBuilder(builder: (context, s) {
      return Container(
        width: maxWidth(context),
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 12.0,
            right: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox12(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                AppSettings.openAppSettings(type: AppSettingsType.security);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: myColor.primaryColorDark,
                          size: 25.0,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Please enable biometric on your device. ',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'Go To Settings',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' to enable biometric.',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        CircleAvatar(
                          backgroundColor: myColor.primaryColorDark,
                          child: Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: kWhite,
                            size: 18.0,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox16(),
          ],
        ),
      );
    });
  }
}
