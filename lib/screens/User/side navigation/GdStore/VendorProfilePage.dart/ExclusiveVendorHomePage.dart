import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/AllProductPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorPage/VendorAllProductsTabBarView.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorPage/VendorHomeTabBarView.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorPage/VendorProfileTabBarView.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';

enum ButtonState { init, loading, done }

class ExclusiveVendorHomePage extends StatefulWidget {
  final dynamic data;
  const ExclusiveVendorHomePage({Key? key, this.data}) : super(key: key);

  @override
  State<ExclusiveVendorHomePage> createState() =>
      _ExclusiveVendorHomePageState();
}

class _ExclusiveVendorHomePageState extends State<ExclusiveVendorHomePage>
    with TickerProviderStateMixin {
  ProfileModel? profileModel;
  TabController? _tabController;
  String _keyword = '';
  @override
  void initState() {
    super.initState();
    getFromLocalStorage();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  getFromLocalStorage() {
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(''),
        toolbarHeight: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: myColor.dialogBackgroundColor,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          myAppBarCard(),
          headingCard(),
          myTabBar(),
          const SizedBox8(),
          myTabBarView(),
        ],
      ),
    );
  }

  Widget myAppBarCard() {
    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox12(),
            searchBar(),
            const SizedBox12(),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        SizedBox(
          width: 30.0,
          height: 30.0,
          child: GestureDetector(
              onTap: () {
                goThere(context, const MyCart());
              },
              child: Image.asset(
                'assets/logo.png',
              )),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: GestureDetector(
            onTap: () {
              goThere(
                context,
                const AllProductPage(),
              );
            },
            child: Container(
                width: maxWidth(context),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'Search for products',
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          // color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      size: 18,
                      // color: Colors.grey[400],
                    ),
                    const SizedBox(width: 12.0),
                  ],
                )),
          ),
        ),
        const SizedBox(width: 20.0),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhite.withOpacity(0.4),
          ),
          child: GestureDetector(
              onTap: () {},
              child: myCachedNetworkImageCircle(
                30.0,
                30.0,
                profileModel!.imagePath.toString(),
                BoxFit.cover,
              )),
        ),
      ],
    );
  }

  Widget headingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      color: myColor.dialogBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: myColor.primaryColorDark, width: 2.0),
                ),
                child: myCachedNetworkImageCircle(
                  80.0,
                  80.0,
                  widget.data!.imagePath.toString(),
                  BoxFit.cover,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    followersCard(
                      widget.data!.followerCount.toString(),
                      'Followers',
                    ),
                    const SizedBox(width: 16.0),
                    followersCard(
                      widget.data!.createdAt.toString().substring(0, 4),
                      'Member Since',
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      widget.data!.storeName.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Icon(
                      Icons.verified,
                      color: myColor.primaryColorDark,
                      size: 15.0,
                    ),
                  ],
                ),
              ),
              Text(
                '${widget.data!.followerCount.toString()}% Positive Rating',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox2(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.data!.address.toString(),
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  ),
                ),
              ),
              Text(
                'Chat response: ${widget.data!.followerCount.toString()}%',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox8(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AnimatedSmoothIndicator(
              //   activeIndex: 0,
              //   count: 5,
              //   effect: ExpandingDotsEffect(
              //     activeDotColor: myColor.primaryColorDark,
              //     dotColor: kWhite.withOpacity(0.4),
              //     dotWidth: 6.0,
              //     dotHeight: 6.0,
              //   ),
              // ),
              SizedBox(
                width: 140.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    followBtnCard('Chat'),
                    const SizedBox(width: 12.0),
                    followBtnCard('Follow'),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: maxWidth(context) - 180,
                height: 35.0,
                child: TextFormField(
                  // textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  textCapitalization: TextCapitalization.words,
                  style: kStyleNormal.copyWith(fontSize: 12.0),
                  onChanged: (v) {
                    _keyword = v;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0), // contentPadding:
                    // const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: kBlack,
                      size: 16.0,
                    ),
                    suffixIcon: _keyword == ''
                        ? const SizedBox(
                            width: 0.0,
                            height: 0.0,
                          )
                        : Icon(
                            Icons.close,
                            color: kBlack,
                            size: 16.0,
                          ),
                    filled: true,
                    fillColor: kWhite.withOpacity(0.4),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                          color: kWhite.withOpacity(0.4), width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(
                          color: myColor.primaryColorDark, width: 1.5),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    hintText: 'Search in store',
                    hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
                  ),
                ),
              ),

              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              //   decoration: BoxDecoration(
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(8.0),
              //     ),
              //     color: kWhite.withOpacity(0.4),
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Certified Store',
              //         style: kStyleNormal.copyWith(
              //           color: myColor.primaryColorDark,
              //           fontSize: 12.0,
              //         ),
              //       ),
              //       const SizedBox(width: 8.0),
              //       Icon(
              //         Icons.verified,
              //         color: myColor.primaryColorDark,
              //         size: 15.0,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox8(),
        ],
      ),
    );
  }

  Widget followBtnCard(title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: myColor.primaryColorDark,
      ),
      child: Text(
        title,
        style: kStyleNormal.copyWith(
          color: kWhite,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget followersCard(value, title) {
    return Column(
      children: [
        Text(
          value,
          style: kStyleNormal.copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox2(),
        Text(
          title,
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget myTabBar() {
    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: kWhite.withOpacity(0.4),
          ),
          tabs: [
            myTab('Home'),
            myTab('All Products'),
            myTab('Profile'),
          ],
        ),
      ),
    );
  }

  Widget myTab(title) {
    return Tab(
      child: Text(
        title,
        style: kStyleNormal.copyWith(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget myTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: const [
          VendorHomeTabBarView(),
          VendorAllProductsTabBarView(),
          VendorProfileTabBarView(),
        ],
      ),
    );
  }
}
