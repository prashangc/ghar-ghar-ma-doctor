import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/AllProductPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/allProductListWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/latestProductWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/productCardHrz.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PharmacyMainPage extends StatefulWidget {
  final int? vendorTypeID;
  final List<SubCategory>? allCategoryModel;
  const PharmacyMainPage({Key? key, this.vendorTypeID, this.allCategoryModel})
      : super(key: key);

  @override
  State<PharmacyMainPage> createState() => _PharmacyMainPageState();
}

class _PharmacyMainPageState extends State<PharmacyMainPage> {
  ApiHandlerBloc? subCategoryBloc, productBloc;
  StateHandlerBloc? carouselBloc;
  List<SubCategory> subCategory = [];
  ProductModel? productModel;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    productBloc = ApiHandlerBloc();
    productBloc!.fetchAPIList('products?vendor_type=${widget.vendorTypeID}');
    carouselBloc = StateHandlerBloc();
    subCategoryBloc = ApiHandlerBloc();
    subCategoryBloc!.fetchAPIList(
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
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: StreamBuilder<dynamic>(
          initialData: null,
          stream: scrollingBloc.stateStream,
          builder: (c, s) {
            if (s.data == 1) {
              _scrollController!.animateTo(0,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox12(),
                Container(
                  width: maxWidth(context),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subCategoryCard(),
                      const SizedBox(width: 12.0),
                      Expanded(child: latestProductSlider()),
                    ],
                  ),
                ),
                titleCard(
                  'Latest Products',
                  'See all',
                  () {},
                ),
                latestProductWidget(context, widget.vendorTypeID, '', setState),
                titleCard(
                  'All Products',
                  'See all',
                  () {},
                ),
                allProductListWidget(context, widget.vendorTypeID, ''),
              ],
            );
          }),
    );
  }

  Widget subCategoryCard() {
    return SizedBox(
      width: 60.0,
      height: 158.0,
      child: Column(
        children: [
          Text(
            'Category',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox8(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: StreamBuilder<ApiResponse<dynamic>>(
                stream: subCategoryBloc!.apiListStream,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return const AnimatedLoading();
                      case Status.COMPLETED:
                        subCategory = List<SubCategory>.from(snapshot.data!.data
                            .map((i) => SubCategory.fromJson(i)));
                        if (snapshot.data!.data.isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            child: const Icon(Icons.error_outline_outlined),
                          );
                        }
                        return ListView.builder(
                            itemCount: subCategory.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (ctx, i) {
                              return mySubCategoryCard(context, subCategory[i]);
                            });
                      case Status.ERROR:
                        return const Text('server error');
                    }
                  }
                  return const SizedBox();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mySubCategoryCard(context, SubCategory data) {
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
        padding: const EdgeInsets.only(bottom: 8.0),
        child: myCachedNetworkImageCircle(
          40.0,
          40.0,
          data.imagePath,
          BoxFit.cover,
        ),
      ),
    );
  }

  Widget latestProductSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<dynamic>(
                initialData: 0,
                stream: carouselBloc!.stateStream,
                builder: (context, snapshot) {
                  return AnimatedSmoothIndicator(
                    activeIndex: snapshot.data,
                    count: 5,
                    effect: ExpandingDotsEffect(
                      activeDotColor: myColor.primaryColorDark,
                      dotColor: myColor.dialogBackgroundColor,
                      dotWidth: 8.0,
                      dotHeight: 8.0,
                    ),
                  );
                }),
            Text(
              'Latest Arrivals',
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox2(),
        const SizedBox2(),
        StreamBuilder<ApiResponse<dynamic>>(
          stream: productBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Container(
                      width: maxWidth(context),
                      height: 135.0,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AnimatedLoading());

                case Status.COMPLETED:
                  productModel = ProductModel.fromJson(snapshot.data!.data);
                  return productModel!.data!.isEmpty
                      ? Container(
                          width: maxWidth(context),
                          height: 135.0,
                          padding: const EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                              child: Text('No any products added',
                                  style:
                                      kStyleNormal.copyWith(fontSize: 12.0))))
                      : CarouselSlider.builder(
                          options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 400),
                              viewportFraction: 1.1,
                              onPageChanged: (index, reason) {
                                carouselBloc!.storeData(index);
                              }),
                          itemCount: productModel!.data!.length,
                          itemBuilder: (context, index, realIndex) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: productCardHrz(
                                  productModel!.data![index], false, context),
                            );
                          },
                        );

                case Status.ERROR:
                  return Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    width: maxWidth(context),
                    height: 135.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0)),
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
      ],
    );
  }
}
