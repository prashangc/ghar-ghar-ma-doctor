import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/AllProductPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/allProductListWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/latestProductWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/storeImageSlider.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/vendorsListWidget.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class StoreMainPage extends StatefulWidget {
  final int vendorTypeID;
  const StoreMainPage({Key? key, required this.vendorTypeID}) : super(key: key);

  @override
  State<StoreMainPage> createState() => _StoreMainPageState();
}

class _StoreMainPageState extends State<StoreMainPage> {
  ApiHandlerBloc? vendorTypeBloc, vendorWiseCategoryBloc, productBloc;
  StateHandlerBloc? carouselBloc;
  List<SubCategory> allCategoryModel = [];
  List<AllVendorsModel> allVendorsModel = [];
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    vendorTypeBloc = ApiHandlerBloc();
    // productBloc = ApiHandlerBloc();
    // productBloc!
    //     .fetchAPIList('products?vendor_type=${widget.vendorTypeID}&vendor_id=');
    carouselBloc = StateHandlerBloc();
    vendorWiseCategoryBloc = ApiHandlerBloc();
    vendorWiseCategoryBloc!.fetchAPIList(
        'categories/vendortype?vendor_type_id=${widget.vendorTypeID}');
    _scrollController = ScrollController()..addListener(loadMore);
  }

  void loadMore() async {
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      loadingBloc!.storeData(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          vendorAdvertisementSlider(context),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  width: maxWidth(context),
                  height: 120.0,
                  color: kTransparent,
                  child: const Text('')),
              Positioned(
                bottom: 5.0,
                left: 12.0,
                right: 12.0,
                child: SizedBox(
                  width: maxWidth(context),
                  child: categoryStreamBuilder(),
                ),
              ),
            ],
          ),
          titleCard('Latest Products', 'See All', () {}),
          latestProductWidget(context, 1, '', setState),
          titleCard('Exclusive Vendors', 'See All', () {}),
          vendorListWidget(context, widget.vendorTypeID),
          titleCard('All Products', 'See all', () {}),
          allProductListWidget(context, widget.vendorTypeID, ''),
          const SizedBox32(),
        ],
      ),
    );
  }

  Widget categoryStreamBuilder() {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: vendorWiseCategoryBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return SizedBox(
                width: maxWidth(context),
                height: 100.0,
                child: const AnimatedLoading(),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    width: maxWidth(context),
                    height: 110.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('No categories added')));
              }
              allCategoryModel = List<SubCategory>.from(
                  snapshot.data!.data.map((i) => SubCategory.fromJson(i)));
              return SizedBox(
                width: maxWidth(context),
                height: 130.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    // physics: const NeverScrollableScrollPhysics(),
                    physics: const BouncingScrollPhysics(),
                    itemCount: allCategoryModel.length > 4
                        ? 4
                        : allCategoryModel.length,
                    // itemCount: allCategoryModel.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return categoryCard(
                        allCategoryModel[i],
                      );
                    }),
              );
            // CarouselSlider.builder(
            //   options: CarouselOptions(
            //       height: 100.0,
            //       // enlargeCenterPage: true,
            //       // autoPlay: true,
            //       aspectRatio: 16 / 9,
            //       autoPlayCurve: Curves.fastOutSlowIn,
            //       enableInfiniteScroll: true,
            //       autoPlayAnimationDuration:
            //           const Duration(milliseconds: 600),
            //       viewportFraction: 1,
            //       onPageChanged: (index, reason) {
            //         carouselBloc!.storeData(index);
            //       }),
            //   itemCount: 3,
            //   itemBuilder: (context, index, realIndex) {
            //     return SizedBox(
            //       width: maxWidth(context),
            //       height: 110.0,
            //       child: ListView.builder(
            //           shrinkWrap: true,
            //           padding: EdgeInsets.zero,
            //           physics: const NeverScrollableScrollPhysics(),
            //           // physics: const BouncingScrollPhysics(),
            //           itemCount: allCategoryModel.length > 4
            //               ? 4
            //               : allCategoryModel.length,
            //           // itemCount: allCategoryModel.length,
            //           scrollDirection: Axis.horizontal,
            //           itemBuilder: (ctx, i) {
            //             return categoryCard(
            //               allCategoryModel[i],
            //             );
            //           }),
            //     );
            //   },
            // );

            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 110.0,
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
        return SizedBox(
          width: maxWidth(context),
        );
      }),
    );
  }

  Widget categoryCard(SubCategory data) {
    return GestureDetector(
      onTap: () {
        goThere(
          context,
          AllProductPage(
            categoryID: data.id,
          ),
        );
      },
      child: Container(
        width: 100.0,
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: myCachedNetworkImage(
                100.0,
                100.0,
                data.imagePath,
                const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              width: maxWidth(context),
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                color: myColor.dialogBackgroundColor,
              ),
              child: Center(
                child: Text(
                  data.name.toString(),
                  textAlign: TextAlign.center,
                  // maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget categoryGrid(context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //     child: GridView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 4,
  //             childAspectRatio: 2 / 2.7,
  //             crossAxisSpacing: 10,
  //             mainAxisSpacing: 10),
  //         itemCount: listofStaticCategory.length,
  //         itemBuilder: (BuildContext ctx, index) {
  //           return staticCategoryCard(listofStaticCategory[index]);
  //         }),
  //   );
  // }

  // Widget staticCategoryCard(ListofStaticCategoryModel data) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
  //     decoration: BoxDecoration(
  //       color: myColor.dialogBackgroundColor,
  //       borderRadius: const BorderRadius.all(
  //         Radius.circular(8.0),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Image.asset(
  //           'assets/prevention.png',
  //         ),
  //         Text(
  //           data.name.toString(),
  //           style: kStyleNormal.copyWith(
  //             fontSize: 12.0,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _mainCategoryType(context) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //     width: maxWidth(context),
  //     height: 50.0,
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         padding: EdgeInsets.zero,
  //         physics: const BouncingScrollPhysics(),
  //         itemCount: listofStaticCategory.length,
  //         scrollDirection: Axis.horizontal,
  //         itemBuilder: (ctx, i) {
  //           return _mainCategoryCard(
  //             listofStaticCategory[i],
  //           );
  //         }),
  //   );
  // }

  // Widget _mainCategoryCard(ListofStaticCategoryModel data) {
  //   return GestureDetector(
  //     onTap: () {},
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
  //       margin: const EdgeInsets.only(right: 10.0),
  //       decoration: BoxDecoration(
  //         color: myColor.dialogBackgroundColor,
  //         borderRadius: const BorderRadius.all(
  //           Radius.circular(15.0),
  //         ),
  //       ),
  //       child: Row(
  //         children: [
  //           CircleAvatar(
  //             backgroundColor: myColor.primaryColorDark,
  //             child: Icon(
  //               data.icon,
  //               size: 15.0,
  //               color: kWhite,
  //             ),
  //           ),
  //           const SizedBox8(),
  //           Text(
  //             data.name.toString(),
  //             textAlign: TextAlign.center,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: kStyleNormal.copyWith(
  //               fontSize: 12.0,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
