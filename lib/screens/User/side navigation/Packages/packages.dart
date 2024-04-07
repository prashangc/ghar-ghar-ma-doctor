import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PackageModel/IndividualPackagesListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/ComparePackage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PackageDescriptionPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/PackageImageSlider.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/myPackageBooked.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc refreshPackageBloc = StateHandlerBloc();

class Packages extends StatefulWidget {
  final bool? isBtnNav;
  final bool? showPaymentUI;
  const Packages({Key? key, this.isBtnNav, this.showPaymentUI})
      : super(key: key);

  @override
  State<Packages> createState() => _PackagesState();
}

class _PackagesState extends State<Packages>
    with
        AutomaticKeepAliveClientMixin<Packages>,
        SingleTickerProviderStateMixin<Packages> {
  @override
  bool get wantKeepAlive => true;
  List<PackagesModel> budget = [],
      corporate = [],
      school = [],
      premium = [],
      mergedList = [];
  ApiHandlerBloc? packagesListBloc;
  List<PackagesModel> packagesModel = [];
  bool isExpanded = false;
  PageController controller = PageController();
  StateHandlerBloc btnBloc = StateHandlerBloc();
  StateHandlerBloc joinCallBtnStateBloc = StateHandlerBloc();
  double percent = 0.4;
  IndividualPackagesListModel? individualPackagesListModel;
  String? getToken;
  ScrollController? _scrollController;
  String? kycStatus;
  StateHandlerBloc showCallGDStateBloc = StateHandlerBloc();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    packagesListBloc = ApiHandlerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          toolbarHeight: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          elevation: 0.0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: StreamBuilder<dynamic>(
            initialData: false,
            stream: showCallGDStateBloc.stateStream,
            builder: (cc, ss) {
              return StreamBuilder<dynamic>(
                  stream: refreshPackageBloc.stateStream,
                  initialData: 0,
                  builder: (c, s) {
                    return ss.data == true &&
                            individualPackagesListModel != null &&
                            individualPackagesListModel!.myPackage != null &&
                            s.data != 'showBuyPackageScreen'
                        ? Padding(
                            padding: EdgeInsets.only(
                                bottom: widget.isBtnNav == true ? 70.0 : 0.0),
                            child: FloatingActionButton.extended(
                              backgroundColor: myColor.primaryColorDark,
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                        myColor.dialogBackgroundColor,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: ((builder) =>
                                        contactGdBottomSheet(context)));
                              },
                              icon: Icon(
                                Icons.call,
                                color: kWhite,
                                size: 25.0,
                              ),
                              label: Text(
                                'Contact GD',
                                style: kStyleNormal.copyWith(
                                  color: kWhite,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : Container();
                  });
            }),
        backgroundColor: backgroundColor,
        body: SizedBox(
          width: maxWidth(context),
          height: maxHeight(context),
          child: StreamBuilder<dynamic>(
              initialData: 0,
              stream: refreshPackageBloc.stateStream,
              builder: (c, s) {
                getToken = sharedPrefs.getFromDevice('token');
                kycStatus = sharedPrefs.getFromDevice("kycStatus");
                packagesListBloc!
                    .fetchAPIList(endpoints.getIndividualPackageEndpoint);
                return getToken == null
                    ? buyPackage()
                    : StreamBuilder<ApiResponse<dynamic>>(
                        stream: packagesListBloc!.apiListStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return SizedBox(
                                  width: maxWidth(context),
                                  height: maxHeight(context) / 2,
                                  child: const Center(
                                    child: AnimatedLoading(),
                                  ),
                                );
                              case Status.COMPLETED:
                                individualPackagesListModel =
                                    IndividualPackagesListModel.fromJson(
                                        snapshot.data!.data);
                                if (individualPackagesListModel!.myPackage !=
                                        null &&
                                    s.data != 'showBuyPackageScreen') {
                                  showCallGDStateBloc.storeData(true);
                                  sharedPrefs.storeToDevice(
                                      'showGlobalFormUI', 'showGlobalFormUI');
                                  List<Reports> reportList = [];

                                  if (individualPackagesListModel!
                                      .myPackage!.dates!.isNotEmpty) {
                                    if (individualPackagesListModel!
                                        .myPackage!
                                        .dates![individualPackagesListModel!
                                                .myPackage!.dates!.length -
                                            1]
                                        .reports!
                                        .isEmpty) {
                                      reportList = individualPackagesListModel!
                                          .myPackage!
                                          .dates![individualPackagesListModel!
                                                  .myPackage!.dates!.length -
                                              2]
                                          .reports!;
                                    } else {
                                      reportList = individualPackagesListModel!
                                          .myPackage!
                                          .dates![individualPackagesListModel!
                                                  .myPackage!.dates!.length -
                                              1]
                                          .reports!;
                                    }
                                  }
                                  return myPackageBooked(
                                    context,
                                    individualPackagesListModel!,
                                    reportList,
                                    checkStatus(),
                                    widget.showPaymentUI,
                                  );
                                } else {
                                  return buyPackage();
                                }
                              case Status.ERROR:
                                return Container(
                                  width: maxWidth(context),
                                  height: 135.0,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('Server yhis error'),
                                  ),
                                );
                            }
                          }
                          return const SizedBox();
                        }),
                      );
              }),
        ));
  }

  checkStatus() {
    if (individualPackagesListModel!.myPackage!.status == 1) {
      if (individualPackagesListModel!.prepay == true) {
        return 'Prepay';
      } else if (individualPackagesListModel!.myPackage!.packageStatus ==
          'Expired') {
        return 'PackageExpired';
      } else if (individualPackagesListModel!.myPackage!.packageStatus ==
          'Activated') {
        if (individualPackagesListModel!.myPackage!.gracePeriod == 1) {
          return 'isInGracePeriod';
        } else if (individualPackagesListModel!.myPackage!.gracePeriod == 2) {
          return 'gracePeriodOver';
        } else {
          return 'Activated';
        }
      } else if (individualPackagesListModel!.myPackage!.packageStatus ==
          'Booked') {
        return 'Paid';
      }
    } else {
      if (individualPackagesListModel!.myPackage!.packageStatus ==
          'Deactivated') {
        return 'Deactivated';
      } else if (individualPackagesListModel!.myPackage!.packageStatus ==
          'Not Booked') {
        return 'Unpaid';
      }
    }
  }

  Widget buyPackage() {
    ApiHandlerBloc imageSliderBloc = ApiHandlerBloc();
    imageSliderBloc.fetchAPIList(endpoints.getPackageSliderEndpoint);
    ApiHandlerBloc packagesBloc = ApiHandlerBloc();
    packagesBloc.fetchAPIList(endpoints.getPackagesEndpoint);

    return Column(
      children: [
        Container(
          color: backgroundColor,
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to get started with',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Ghargharma Doctor',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/logo.png',
                width: 50.0,
                height: 50.0,
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: StreamBuilder<dynamic>(
                initialData: null,
                stream: scrollingBloc.stateStream,
                builder: (c, s) {
                  if (s.data == 2) {
                    _scrollController!.animateTo(0,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 500));
                  }
                  return Container(
                    color: backgroundColor,
                    child: Column(
                      children: [
                        const SizedBox12(),
                        StreamBuilder<ApiResponse<dynamic>>(
                          stream: imageSliderBloc.apiListStream,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              switch (snapshot.data!.status) {
                                case Status.LOADING:
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    width: maxWidth(context),
                                    height: maxHeight(context) / 4,
                                    decoration: BoxDecoration(
                                      color: myColor.dialogBackgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const AnimatedLoading(),
                                  );
                                case Status.COMPLETED:
                                  if (snapshot.data!.data.isEmpty) {
                                    return Container(
                                        height: maxHeight(context) / 4,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                            child: Text('No image added')));
                                  }
                                  List<PackageImageSliderModel>
                                      packageImageSliderModel =
                                      List<PackageImageSliderModel>.from(
                                          snapshot.data!.data.map((i) =>
                                              PackageImageSliderModel.fromJson(
                                                  i)));
                                  return PackageImageSlider(
                                    imageSliderModel: packageImageSliderModel,
                                  );
                                case Status.ERROR:
                                  return Container(
                                    width: maxWidth(context),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    height: maxHeight(context) / 4,
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: Text('Server Error'),
                                    ),
                                  );
                              }
                            }
                            return SizedBox(
                              width: maxWidth(context),
                            );
                          }),
                        ),
                        const SizedBox16(),
                        Container(
                          color: backgroundColor,
                          child: StreamBuilder<ApiResponse<dynamic>>(
                            stream: packagesBloc.apiListStream,
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                switch (snapshot.data!.status) {
                                  case Status.LOADING:
                                    return Container(
                                      height: 240,
                                      color: backgroundColor,
                                      child: const Center(
                                        child: AnimatedLoading(),
                                      ),
                                    );
                                  case Status.COMPLETED:
                                    if (snapshot.data!.data.isEmpty) {
                                      return Container(
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text('No packages added'),
                                        ),
                                      );
                                    } else {
                                      packagesModel = List<PackagesModel>.from(
                                          snapshot.data!.data.map((i) =>
                                              PackagesModel.fromJson(i)));
                                      btnBloc.storeData(1);
                                      budget.clear();
                                      mergedList.clear();
                                      corporate.clear();
                                      premium.clear();
                                      school.clear();

                                      budget = packagesModel
                                          .where((element) => element.type == 1)
                                          .toList();
                                      school = packagesModel
                                          .where((element) => element.type == 4)
                                          .toList();
                                      premium = packagesModel
                                          .where((element) => element.type == 2)
                                          .toList();
                                      if (budget.any((element) =>
                                          element.packageType ==
                                          "Gold Membership")) {
                                        budget.sort((a, b) {
                                          if (a.packageType ==
                                              "Gold Membership") {
                                            return -1;
                                          } else if (b.packageType ==
                                              "Gold Membership") {
                                            return 1;
                                          } else {
                                            return 0;
                                          }
                                        });
                                      }
                                      corporate = packagesModel
                                          .where((element) => element.type == 3)
                                          .toList();
                                    }
                                    mergedList.addAll(budget);
                                    mergedList.addAll(premium);

                                    return Column(
                                      children: [
                                        silderCard('Budget Packages', budget,
                                            allList: mergedList),
                                        silderCard('Premium Packages', premium,
                                            allList: mergedList),
                                        silderCard(
                                            'Corporate Packages', corporate,
                                            allList: mergedList),
                                        silderCard('School Packages', school,
                                            showCompare: false),
                                      ],
                                    );
                                  case Status.ERROR:
                                    return Container(
                                      width: maxWidth(context),
                                      height: 135.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Text('Server Error'),
                                      ),
                                    );
                                }
                              }
                              return const SizedBox();
                            }),
                          ),
                        ),
                        const SizedBox16(),
                        const SizedBox32(),
                        const SizedBox16(),
                      ],
                    ),
                  );
                }),
          ),
        ),
        // StreamBuilder<dynamic>(
        //     initialData: 0,
        //     stream: btnBloc.stateStream,
        //     builder: (context, snapshot) {
        //       if (snapshot.data == 0) {
        //         return Container();
        //       } else {
        //         return GestureDetector(
        //           onTap: () {
        //             goThere(
        //                 context,
        //                 ComparePackage(
        //                   packagesModel: packagesModel,
        //                 ));
        //           },
        //           child: Container(
        //             margin: const EdgeInsets.symmetric(
        //                 horizontal: 12.0, vertical: 5.0),
        //             padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //             width: maxWidth(context),
        //             height: 50.0,
        //             decoration: BoxDecoration(
        //               color: myColor.primaryColorDark,
        //               borderRadius: const BorderRadius.all(
        //                 Radius.circular(12.0),
        //               ),
        //             ),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Text(
        //                   'Compare Package',
        //                   style: kStyleNormal.copyWith(
        //                       fontWeight: FontWeight.bold,
        //                       fontSize: 14.0,
        //                       color: kWhite),
        //                 ),
        //                 Icon(
        //                   Icons.keyboard_arrow_right_outlined,
        //                   color: kWhite,
        //                   size: 17.0,
        //                 )
        //               ],
        //             ),
        //           ),
        //         );
        //       }
        //     }),
      ],
    );
  }

  Widget silderCard(title, List<PackagesModel> list,
      {showCompare, List<PackagesModel>? allList}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              showCompare == null
                  ? GestureDetector(
                      onTap: () {
                        goThere(
                            context,
                            ComparePackage(
                              packagesModel: allList!,
                              corporatePackagesModel: corporate,
                              isCorporate:
                                  title == 'Corporate Packages' ? true : false,
                            ));
                      },
                      child: Row(
                        children: [
                          Text(
                            'Compare Package',
                            style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: myColor.primaryColorDark),
                          ),
                          const SizedBox(width: 8.0),
                          Icon(Icons.keyboard_arrow_right_outlined,
                              size: 20.0, color: myColor.primaryColorDark),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox24(),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                    crossAxisCount: 2,
                    height: 226,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
            itemCount: list.length,
            itemBuilder: (BuildContext ctx, index) {
              return packageCard(
                  list[index],
                  title == 'School Packages' ? true : false,
                  title == 'Corporate Packages' ? true : false);
            },
          ),

          //   );
          // }),

          // CarouselSlider.builder(
          //   options: CarouselOptions(
          //       // enlargeCenterPage: true,
          //       // autoPlay: true,
          //       autoPlayCurve: Curves.fastOutSlowIn,
          //       enableInfiniteScroll: true,
          //       autoPlayAnimationDuration: const Duration(milliseconds: 600),
          //       viewportFraction: 0.8,
          //       onPageChanged: (index, reason) {}),
          //   itemCount: list.length,
          //   itemBuilder: (context, index, realIndex) {
          //     return packageCard(list[index]);
          //   },
          // ),

          const SizedBox12(),
        ],
      ),
    );
  }

  Widget packageAdvertisementSlider(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
          height: 160,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 600),
          viewportFraction: 0.8,
          onPageChanged: (index, reason) {}),
      itemCount: 4,
      itemBuilder: (context, index, realIndex) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            color: myColor.dialogBackgroundColor,
            image: const DecorationImage(
              image: NetworkImage(
                  'https://propellerads.com/blog/wp-content/uploads/2022/09/propellerads-publishers-app-banner.png'),
              fit: BoxFit.fill,
            ),
          ),
          // child: Image.asset('assets/prevention.png'),
        );
      },
    );
  }

  Widget infoCard(context, icon, text, Function myTap) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Column(
        children: [
          Container(
            width: (maxWidth(context) / 4) - 12,
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              color: myColor.dialogBackgroundColor,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 16,
                color: myColor.primaryColorDark,
              ),
            ),
          ),
          const SizedBox8(),
          Text(
            text,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: myColor.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget priceDetailsCard(textValue, priceValue, periodValue) {
    return Expanded(
      child: Column(
        children: [
          Text(
            textValue,
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Text(
            priceValue,
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Text(
            periodValue,
            style: kStyleNormal.copyWith(
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget packageCard(PackagesModel data, isSchool, isCorporate) {
    return GestureDetector(
      onTap: () {
        goThere(
            context,
            PackageDescriptionPage(
              packagesModel: data,
              showCalculator: isSchool,
              isCorporate: isCorporate,
            ));
        // goThere(context, IndividuaPackagePage(packagesModel: data));
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: myColor.dialogBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox12(),
            SizedBox(
              height: 25.0,
              child: Text(
                data.packageType.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: kStyleNormal.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox12(),
            SizedBox(
              height: 50.0,
              child: myRow(
                'Registration Fee',
                'Rs ${data.registrationFee.toString()}',
              ),
            ),
            SizedBox(
              height: 50.0,
              child: myRow(
                'No. of visits',
                '${data.visits} / year',
              ),
            ),
            SizedBox(
              height: 40.0,
              child: Column(
                children: [
                  Text(
                    'Monthy Fee / person',
                    style: kStyleNormal.copyWith(
                      fontSize: 10.0,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Rs ',
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: data.monthlyFee.toString(),
                          style: kStyleNormal.copyWith(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                      color: myColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: myColor.primaryColorDark,
                    child: Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: kWhite,
                      size: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myRow(title, text, {color}) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon(Icons.perm_identity_outlined,
            //     size: 13.0, color: myColor.primaryColorDark),
            Text(title,
                overflow: TextOverflow.ellipsis,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                )),
            const SizedBox2(),
            Text(text,
                overflow: TextOverflow.ellipsis,
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: color ?? kBlack,
                )),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget contactGdBottomSheet(ctx) {
    postJoinCallBtn() async {
      joinCallBtnStateBloc.storeData(true);
      var resp = await API().getPostResponseData(ctx, PackageImageSliderModel(),
          endpoints.postToGetPackageMeetingLinkEndpoint);
      if (resp != null) {
        Navigator.pop(ctx);
        PackageMeetingRespModel packageMeetingRespModel =
            PackageMeetingRespModel.fromJson(resp);
        // joinMeeting(
        //   ctx,
        //   packageMeetingRespModel.meetingId,
        //   packageMeetingRespModel.meetingPassword,
        // );
        joinCallBtnStateBloc.storeData(false);
      } else {
        joinCallBtnStateBloc.storeData(false);
      }
    }

    return StatefulBuilder(builder: (c, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox12(),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
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
                        Icons.call,
                        color: myColor.primaryColorDark,
                        size: 25.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child:
                            Text('You are calling GD for online consultation.',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                )),
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
                itemCount: bloodPressureDescData.length,
                itemBuilder: (ctx, i) {
                  return;
                }),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 10.0,
                    backgroundColor: kWhite.withOpacity(0.4),
                    child: Text(
                      '1',
                      style: kStyleNormal.copyWith(fontSize: 10.0),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: kStyleNormal,
                        children: [
                          TextSpan(
                            text: 'You have '.toString(),
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${individualPackagesListModel!.myPackage!.familyname!.onlineConsultation} ',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              color: myColor.primaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'consultation call left.',
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
            ),
            const SizedBox8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Back',
                    style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                        color: myColor.primaryColorDark),
                  ),
                ),
                StreamBuilder<dynamic>(
                    initialData: false,
                    stream: joinCallBtnStateBloc.stateStream,
                    builder: (c, s) {
                      return GestureDetector(
                        onTap: () {
                          if (s.data == false) {
                            postJoinCallBtn();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
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
                                'Join Call',
                                style: kStyleNormal.copyWith(
                                  fontSize: 14.0,
                                  color: kWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              s.data == false
                                  ? Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: kWhite,
                                      size: 24.0,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(6.0),
                                      child: SizedBox(
                                        width: 12.0,
                                        height: 12.0,
                                        child: CircularProgressIndicator(
                                          color: kWhite,
                                          strokeWidth: 1,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
            const SizedBox16(),
          ],
        ),
      );
    });
  }
}
