import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/ListOfAddressScreen.dart';
import 'package:ghargharmadoctor/screens/User/Loading/loading_imports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/AllProductPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/Gym/GymMainPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/HealthyFood/HealthyFoodMainPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/Pharmacy/PharmacyMainPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreMainPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Wishlist/MyWishlist.dart';

class GdStore extends StatefulWidget {
  const GdStore({Key? key}) : super(key: key);

  @override
  State<GdStore> createState() => _GdStoreState();
}

class _GdStoreState extends State<GdStore>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<GdStore> {
  @override
  bool get wantKeepAlive => true;
  int _vendorTypeID = 0;
  ApiHandlerBloc? vendorTypeBloc;

  List<AllListOfVendorsModel> allListOfVendorsModel = [];
  List<Widget> screens = [];
  List<SubCategory> allCategoryModel = [];

  @override
  void initState() {
    super.initState();
    getApiData();
    vendorTypeBloc = ApiHandlerBloc();
    vendorTypeBloc!.fetchAPIList(endpoints.getAllVendorsEndpoint);
  }

  getApiData() async {
    var myResp = await API().getData(
        context, 'categories/vendortype?vendor_type_id=$_vendorTypeID');

    allCategoryModel =
        List<SubCategory>.from(myResp.map((i) => SubCategory.fromJson(i)));
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    screens = [
      const StoreMainPage(vendorTypeID: 0),
      HealthyFoodMainPage(
        vendorTypeID: _vendorTypeID,
        allCategoryModel: allCategoryModel,
      ),
      PharmacyMainPage(
        vendorTypeID: _vendorTypeID,
        allCategoryModel: allCategoryModel,
      ),
      GymMainPage(
        vendorTypeID: _vendorTypeID,
        allCategoryModel: allCategoryModel,
      ),
    ];
    return WillPopScope(
      onWillPop: () async {
        _scaffoldKey.currentState!.closeEndDrawer();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(''),
          toolbarHeight: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: myColor.dialogBackgroundColor,
          elevation: 0.0,
        ),
        backgroundColor: backgroundColor,
        endDrawer: sideNavBar(),
        body: SafeArea(
          child: Column(
            children: [
              myAppBarCard(),
              Container(
                color: myColor.dialogBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox12(),
                    StreamBuilder<ApiResponse<dynamic>>(
                      stream: vendorTypeBloc!.apiListStream,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.LOADING:
                              return const CategoryLoadingShimmer();
                            case Status.COMPLETED:
                              allListOfVendorsModel =
                                  List<AllListOfVendorsModel>.from(
                                      snapshot.data!.data.map((i) =>
                                          AllListOfVendorsModel.fromJson(i)));
                              if (snapshot.data!.data.isEmpty) {
                                return const Text('empty');
                              }

                              return SizedBox(
                                width: maxWidth(context),
                                height: 50.0,
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _vendorTypeID = 0;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 10.0),
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: _vendorTypeID == 0
                                                ? myColor.primaryColorDark
                                                : kWhite.withOpacity(0.4),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(children: [
                                            Text(
                                              'Store',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 12.0,
                                                color: _vendorTypeID == 0
                                                    ? kWhite
                                                    : myColor.primaryColorDark,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Icon(
                                              FontAwesomeIcons.shopify,
                                              color: _vendorTypeID == 0
                                                  ? kWhite
                                                  : myColor.primaryColorDark,
                                              size: 12.0,
                                            ),
                                          ]),
                                        ),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              allListOfVendorsModel.length,
                                          itemBuilder: (ctx, i) {
                                            return listOfCategoryCard(
                                                allListOfVendorsModel[i],
                                                i + 1);
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            case Status.ERROR:
                              return const Text('server error');
                          }
                        }
                        return const SizedBox();
                      }),
                    ),
                    const SizedBox12(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  goThere(context, const ListOfAddressScreen());
                },
                child: Container(
                  color: myColor.dialogBackgroundColor,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    color: kWhite.withOpacity(0.4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: myColor.primaryColorDark,
                          size: 14.0,
                        ),
                        const SizedBox(width: 15.0),
                        Text(
                          'Add Shipping Address',
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                            color: myColor.primaryColorDark,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: screens[_vendorTypeID],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listOfCategoryCard(AllListOfVendorsModel data, i) {
    return GestureDetector(
      onTap: () {
        if (_vendorTypeID != data.id!) {
          setState(() {
            // allCategoryModel = data.category!;
            _vendorTypeID = data.id!;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: _vendorTypeID == i
              ? myColor.primaryColorDark
              : kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
          // CircleAvatar(
          //   radius: 20.0,
          //   child: data.image,
          // ),
          // const SizedBox(width: 10.0),
          Text(
            data.vendorType.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
              color: _vendorTypeID == i ? kWhite : myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10.0),
          Icon(
            FontAwesomeIcons.seedling,
            color: _vendorTypeID == i ? kWhite : myColor.primaryColorDark,
            size: 12.0,
          ),
        ]),
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
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        SizedBox(
          width: 45,
          height: 45,
          child: GestureDetector(
            onTap: () {
              goThere(context, const MyCart());
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: myColor.primaryColorDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shopping_cart,
                color: myColor.scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
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
                  color: kWhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 45.0,
                child: Row(
                  children: [
                    const SizedBox(width: 10.0),
                    Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'Search for products',
                        style: kStyleNormal.copyWith(
                            fontSize: 14.0, color: Colors.grey[400]),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        const SizedBox(width: 8.0),
        SizedBox(
          width: 45,
          height: 45,
          child: GestureDetector(
            onTap: () {
              if (allCategoryModel.isNotEmpty) {
                _scaffoldKey.currentState!.openEndDrawer();
              }
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: myColor.primaryColorDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.menu,
                color: myColor.scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sideNavBar() {
    return SizedBox(
      width: maxWidth(context) / 1.3,
      height: maxHeight(context),
      child: StatefulBuilder(builder: (context, s) {
        return Column(
          children: [
            Container(
              color: myColor.dialogBackgroundColor,
              width: maxWidth(context),
              height: 130.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Find\n',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Products',
                          style: kStyleNormal.copyWith(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      circularCard(
                        Icons.shopping_cart,
                        () {
                          goThere(context, const MyCart());
                        },
                      ),
                      const SizedBox(width: 5.0),
                      circularCard(
                        Icons.favorite,
                        () {
                          goThere(context, const MyWishlist());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: maxWidth(context),
                height: maxHeight(context),
                color: myColor.dialogBackgroundColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 0.0, top: 12.0, left: 12.0),
                      width: 70,
                      margin: const EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: ListView.builder(
                          itemCount: allCategoryModel.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (ctx, i) {
                            return verticalCard(allCategoryModel[i]);
                          }),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: allListOfVendorsModel.length,
                          itemBuilder: (ctx, i) {
                            return dropDownCategoryCard(
                                allListOfVendorsModel[i]);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget dropDownCategoryCard(AllListOfVendorsModel data) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.black,
        primaryColor: Colors.black,
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 12.0),
        child: ExpansionTile(
            iconColor: myColor.primaryColorDark,
            childrenPadding: EdgeInsets.zero,
            tilePadding: EdgeInsets.zero,
            title: Text(
              data.vendorType.toString(),
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.category!.length,
                  itemBuilder: (ctx, index) {
                    var item = data.category![index];
                    return GestureDetector(
                      onTap: () {
                        print('data.id ${data.id}');
                        goThere(
                          context,
                          AllProductPage(
                            categoryID: data.id,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  myColor.primaryColorDark.withOpacity(0.1),
                              radius: 10.0,
                              child: const Icon(
                                Icons.keyboard_arrow_right,
                                size: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              item.name.toString(),
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ]),
      ),
    );
  }

  Widget circularCard(icon, myTap) {
    return CircleAvatar(
      backgroundColor: kWhite.withOpacity(0.4),
      radius: 14.0,
      child: GestureDetector(
        onTap: () {
          myTap();
        },
        child: Icon(icon, size: 15.0, color: myColor.primaryColorDark),
      ),
    );
  }

  Widget verticalCard(SubCategory data) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kWhite.withOpacity(0.4),
            ),
            child: myCachedNetworkImageCircle(
              40.0,
              40.0,
              data.imagePath,
              BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
