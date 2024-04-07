import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/Products%20Model/BrandModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/productCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class AllProductPage extends StatefulWidget {
  final int? categoryID;
  const AllProductPage({Key? key, this.categoryID}) : super(key: key);

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final PageStorageKey _endDrawerKey = const PageStorageKey('endDrawer');
  ApiHandlerBloc? productBloc,
      productListBloc,
      brandBloc,
      categoriesBloc,
      searchHistoryApiBloc;
  StateHandlerBloc? selectedBloc, refreshBloc, loadingBloc, searchHistoryBloc;
  ProductModel? productModel;
  ScrollController? _scrollController;
  RangeValues values = const RangeValues(0, 1000);
  final String _url = '';
  String _search = '';
  String _min = '';
  String _max = '';
  String? categoryID = '';
  String brandID = '';
  String ratingID = '';
  final TextEditingController _myController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<SubCategory> allCategoryModel = [];
  List<BrandModel> brandModel = [];
  GetIDNameModel? getIDNameModel;
  List<ProductModelData> testProductData = [];
  int page = 1;
  bool allowScrolling = true;
  ProfileModel? profileModel;
  @override
  void initState() {
    super.initState();
    testProductData.clear();

    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));

    if (widget.categoryID == null) {
      categoryID = '';
    } else {
      categoryID = widget.categoryID.toString();
    }
    categoriesBloc = ApiHandlerBloc();
    brandBloc = ApiHandlerBloc();
    categoriesBloc!.fetchAPIList(endpoints.getCategoryEndpoint);
    brandBloc!.fetchAPIList(endpoints.getBrandEndpoint);
    selectedBloc = StateHandlerBloc();
    searchHistoryBloc = StateHandlerBloc();
    refreshBloc = StateHandlerBloc();
    loadingBloc = StateHandlerBloc();
    _scrollController = ScrollController()..addListener(loadMore);
  }

  void loadMore() async {
    if (allowScrolling == true) {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        loadingBloc!.storeData(1);
      }
    }
  }

  getProductResp(myPageNo) async {
    var resp = await API().getData(context,
        'products?min_price=$_min&max_price=$_max&keyword=$_search&brand=$brandID&category_id=$categoryID&rating=$ratingID&page=$myPageNo');
    ProductModel productModel = ProductModel.fromJson(resp);
    if (productModel.data!.isNotEmpty) {
      testProductData.addAll(productModel.data!);
      loadingBloc!.storeData(2);
    } else {
      loadingBloc!.storeData(0);
    }
  }

  // getProductFromAPI() {
  //   productBloc = ApiHandlerBloc();
  //   productBloc!.fetchAPIList(
  //       'products?min_price=$_min&max_price=$_max&keyword=$_search&brand=$brandID&category_id=$categoryID&rating=$ratingID');
  //   // &type=product&user_id=10
  //   refreshBloc!.storeData(true);
  // }

  // getSearchProductFromAPI() {
  //   productBloc!.fetchAPIList(
  //       'products?min_price=$_min&max_price=$_max&keyword=$_search&brand=$brandID&category_id=$categoryID&rating=$ratingID&type=product&user_id=${profileModel!.memberId}');
  //   myfocusRemover(context);
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      endDrawer: Drawer(
        key: _endDrawerKey,
        child: filterDrawer(),
      ),
      appBar: AppBar(
        title: const Text(''),
        toolbarHeight: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0.0,
      ),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          children: [
            myAppBarCard(),
            Expanded(
              child: StreamBuilder<dynamic>(
                  initialData: false,
                  stream: refreshBloc!.stateStream,
                  builder: (context, s) {
                    return LayoutBuilder(builder: (context, constraints) {
                      double contentHeight = constraints.biggest.height;
                      if (contentHeight < maxHeight(context) - 100) {
                        loadingBloc!.storeData(null);
                      } else {
                        loadingBloc!.storeData(2);
                      }
                      return SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: StreamBuilder<dynamic>(
                              initialData: 0,
                              stream: searchHistoryBloc!.stateStream,
                              builder: (context, myStateSnapshot) {
                                return myStateSnapshot.data == 0
                                    ? productListCard()
                                    : productGridCard(s);
                              }),
                        ),
                      );
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget productListCard() {
    searchHistoryApiBloc = ApiHandlerBloc();
    searchHistoryApiBloc!.fetchAPIList(
        'search-history?user_id=${profileModel!.memberId}&type=product');
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      width: maxWidth(context),
      child: Column(
        children: [
          _search != ''
              ? Container()
              : StreamBuilder<ApiResponse<dynamic>>(
                  stream: searchHistoryApiBloc!.apiListStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return Container(
                            width: maxWidth(context),
                            height: maxHeight(context) / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const AnimatedLoading(),
                          );
                        case Status.COMPLETED:
                          List<SearchHistoryModel> searchHistoryModel =
                              List<SearchHistoryModel>.from(snapshot.data!.data
                                  .map((i) => SearchHistoryModel.fromJson(i)));
                          if (searchHistoryModel.isEmpty) {
                            return const Text(
                              'No any search history',
                            );
                          } else {
                            return _search != ''
                                ? Container()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: searchHistoryModel.length,
                                    itemBuilder: (c, i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _search = searchHistoryModel[i]
                                                .query
                                                .toString();
                                          });
                                          // getSearchProductFromAPI();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kWhite,
                                                ),
                                                child: Icon(
                                                  Icons.timer_outlined,
                                                  size: 14.0,
                                                  color: kBlack,
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Expanded(
                                                child: Text(
                                                  searchHistoryModel[i]
                                                      .query
                                                      .toString(),
                                                  style: kStyleNormal.copyWith(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kWhite,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14.0,
                                                  color: kBlack,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                          }
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
                    return const SizedBox();
                  }),
                ),
          _search == ''
              ? Container()
              : StreamBuilder<ApiResponse<dynamic>>(
                  stream: productListBloc!.apiListStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return productModel == null ||
                                  productModel!.data!.isEmpty
                              ? Container()
                              : myProductList('loading');
                        case Status.COMPLETED:
                          productModel =
                              ProductModel.fromJson(snapshot.data!.data);
                          if (productModel!.data!.isEmpty) {
                            return const Text('No match');
                          }
                          return myProductList('completed');
                        case Status.ERROR:
                          return Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            width: maxWidth(context),
                            height: 135.0,
                            decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: const Center(
                              child: Text('Server Error'),
                            ),
                          );
                      }
                    }
                    return const SizedBox();
                  }),
                ),
        ],
      ),
    );
  }

  Widget myProductList(type) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: productModel!.data!.length,
        itemBuilder: (c, i) {
          return GestureDetector(
            onTap: () {
              if (type == 'completed') {
                setState(() {
                  _search = productModel!.data![i].productName.toString();
                });
                // getSearchProductFromAPI();
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kWhite,
                    ),
                    child: Icon(
                      Icons.search,
                      size: 14.0,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      productModel!.data![i].productName.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget productGridCard(s) {
    // getProductFromAPI();
    return Column(
      children: [
        StreamBuilder<ApiResponse<dynamic>>(
          stream: productBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Container(
                    width: maxWidth(context),
                    height: maxHeight(context) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const AnimatedLoading(),
                  );
                case Status.COMPLETED:
                  productModel = ProductModel.fromJson(snapshot.data!.data);
                  if (productModel!.data!.isEmpty) {
                    return emptyPage(
                        context,
                        'No any products',
                        'No any product is available for the selected field',
                        'Back', () {
                      Navigator.pop(context);
                    });
                  } else {
                    if (s.data == false) {
                      loadingBloc!.storeData(2);
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2 / 2.7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemCount: productModel!.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return productCard(
                            context,
                            productModel!.data![index],
                            setState,
                            kWhite,
                            0.0,
                          );
                        });
                  }
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
            return const SizedBox();
          }),
        ),
        const SizedBox12(),
        StreamBuilder<dynamic>(
            initialData: null,
            stream: loadingBloc!.stateStream,
            builder: (context, snapshot) {
              return testProductData.isEmpty
                  ? Container()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 2.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: testProductData.length,
                      itemBuilder: (BuildContext ctx, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: productCard(
                            context,
                            productModel!.data![i],
                            setState,
                            kWhite,
                            0.0,
                          ),
                        );
                      });
            }),
        const SizedBox12(),
        StreamBuilder<dynamic>(
            initialData: null,
            stream: loadingBloc!.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else if (snapshot.data == 1) {
                page = page + 1;
                getProductResp(page);
                return const AnimatedLoading();
              } else if (snapshot.data == 0) {
                allowScrolling = false;
                return Text('No more products',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ));
              } else if (snapshot.data == 2) {
                return Text('Scroll more products',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ));
              } else {
                return Container();
              }
            }),
        const SizedBox12(),
      ],
    );
  }

  Widget filterDrawer() {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
        color: myColor.dialogBackgroundColor,
        width: maxWidth(context) / 1.3,
        height: maxHeight(context),
        child: StatefulBuilder(builder: (context, s) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Container(
                  color: myColor.dialogBackgroundColor,
                  width: maxWidth(context),
                  height: 130.0,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Filter\n',
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
                      CircleAvatar(
                        backgroundColor: kWhite.withOpacity(0.4),
                        radius: 14.0,
                        child: Icon(Icons.sort,
                            size: 15.0, color: myColor.primaryColorDark),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myExpansionTile('Category', categoriesBloc),
                      const SizedBox12(),
                      myExpansionTile('Brand', brandBloc),
                      const SizedBox12(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: kWhite.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rating',
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox8(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar.builder(
                                    unratedColor: myColor.dialogBackgroundColor,
                                    itemBuilder: (context, _) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      );
                                    },
                                    updateOnDrag: false,
                                    initialRating: 0,
                                    itemSize: 28.0,
                                    itemPadding:
                                        const EdgeInsets.only(right: 5),
                                    onRatingUpdate: (newRatingValue) {
                                      ratingID = newRatingValue.toString();
                                      // getProductFromAPI();
                                    }),
                                Text(
                                  '& Up',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox12(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: kWhite.withOpacity(0.4),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox8(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: myNumberTextFormFieldWithoutIcon(
                                    _min == '' ? 'Min' : _min,
                                    '',
                                    _min,
                                    myColor.dialogBackgroundColor,
                                    onValueChanged: (v) {
                                      _min = v;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                const Text('-'),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: myNumberTextFormFieldWithoutIcon(
                                    _max == '' ? 'Max' : _max,
                                    '',
                                    _max,
                                    myColor.dialogBackgroundColor,
                                    onValueChanged: (v) {
                                      _max = v;
                                    },
                                    myOnFieldSubmitted: (v) {
                                      if (_min != '' && _max != '') {
                                        // getProductFromAPI();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox8(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryID = '';
                            ratingID = '';
                            brandID = '';
                            _max = '';
                            _min = '';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: myColor.primaryColorDark, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 50,
                          child: Center(
                            child: Text(
                              'Clear',
                              style: kStyleNormal.copyWith(
                                color: myColor.primaryColorDark,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Apply',
                          kStyleNormal.copyWith(
                            fontSize: 16.0,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                          () {
                            applyBtn(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox12(),
              ],
            ),
          );
        }),
      ),
    );
  }

  applyBtn(context) {
    Navigator.pop(context);
  }

  Widget myExpansionTile(title, bloc) {
    return Column(
      children: [
        Theme(
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
            child: ExpansionTile(
                maintainState: true,
                iconColor: myColor.primaryColorDark,
                childrenPadding: EdgeInsets.zero,
                tilePadding: EdgeInsets.zero,
                title: Text(
                  title,
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  StreamBuilder<ApiResponse<dynamic>>(
                    key: _endDrawerKey,
                    stream: bloc!.apiListStream,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return SizedBox(
                              width: maxWidth(context),
                              height: maxHeight(context) / 2,
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
                                  child: const Center(child: Text('No data')));
                            }
                            if (title == 'Category') {
                              allCategoryModel = List<SubCategory>.from(snapshot
                                  .data!.data
                                  .map((i) => SubCategory.fromJson(i)));
                            } else if (title == 'Brand') {
                              brandModel = List<BrandModel>.from(snapshot
                                  .data!.data
                                  .map((i) => BrandModel.fromJson(i)));
                            }

                            return StreamBuilder<dynamic>(
                                initialData: getIDNameModel,
                                stream: selectedBloc!.stateStream,
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Container(
                                      width: maxWidth(context),
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.start,
                                        spacing: 10.0,
                                        runSpacing: 10.0,
                                        children: List.generate(
                                            title == 'Category'
                                                ? allCategoryModel.length
                                                : brandModel.length,
                                            (index) => GestureDetector(
                                                  onTap: () {
                                                    selectedBloc!.storeData(
                                                        GetIDNameModel(
                                                            id: index
                                                                .toString(),
                                                            name: title == 'Category'
                                                                ? allCategoryModel[
                                                                        index]
                                                                    .name
                                                                : brandModel[
                                                                        index]
                                                                    .brandName
                                                                    .toString()));

                                                    if (title == 'Category') {
                                                      categoryID =
                                                          allCategoryModel[
                                                                  index]
                                                              .id
                                                              .toString();
                                                    } else {
                                                      brandID =
                                                          brandModel[index]
                                                              .id
                                                              .toString();
                                                    }

                                                    // getProductFromAPI();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      color: kWhite
                                                          .withOpacity(0.4),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 8.0),
                                                    child: Text(
                                                      title == 'Category'
                                                          ? allCategoryModel[
                                                                  index]
                                                              .name
                                                              .toString()
                                                          : brandModel[index]
                                                              .brandName
                                                              .toString(),
                                                      style:
                                                          kStyleNormal.copyWith(
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                      ),
                                    );
                                  } else {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          selectedBloc!.storeData(null);
                                          if (title == 'Category') {
                                            categoryID = '';
                                          } else {
                                            brandID = '';
                                          }
                                          // getProductFromAPI();
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 12.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                border: Border.all(
                                                  color: myColor
                                                      .dialogBackgroundColor,
                                                ),
                                                color: kWhite.withOpacity(0.4),
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12.0, 8.0, 25.0, 8.0),
                                              child: Text(
                                                snapshot.data.name.toString(),
                                                style: kStyleNormal.copyWith(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 8.0,
                                              child: Icon(
                                                Icons.close,
                                                size: 14.0,
                                                color: myColor.primaryColorDark
                                                    .withOpacity(0.4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                });

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
                      return const SizedBox();
                    }),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  Widget myAppBarCard() {
    return Container(
      width: maxWidth(context),
      color: backgroundColor,
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
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: myColor.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left_outlined,
              size: 28.0,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
            child: StreamBuilder<dynamic>(
                initialData: 0,
                stream: searchHistoryBloc!.stateStream,
                builder: (context, mySnap) {
                  return searchField(
                      context,
                      _search == '' ? 'Search for products' : _search,
                      _search, onValueChanged: (v) {
                    setState(() {
                      if (v.isNotEmpty) {
                        _search = v;
                      } else {
                        _search = '';
                      }
                    });
                    if (mySnap.data == 0) {
                      productListBloc = ApiHandlerBloc();
                      productListBloc!.fetchAPIList(
                          'products?min_price=$_min&max_price=$_max&keyword=$v&brand=$brandID&category_id=$categoryID&rating=$ratingID');
                    } else {}
                    // getProductFromAPI();
                  });
                })),
        const SizedBox(width: 8.0),
        SizedBox(
          width: 45,
          height: 45,
          child: StreamBuilder<dynamic>(
              initialData: 0,
              stream: searchHistoryBloc!.stateStream,
              builder: (context, searchHistorySnapshot) {
                return GestureDetector(
                  onTap: () {
                    if (searchHistorySnapshot.data == 0) {
                      searchHistoryBloc!.storeData(1);
                    } else {
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
                      searchHistorySnapshot.data == 0
                          ? Icons.search
                          : Icons.sort,
                      color: myColor.scaffoldBackgroundColor,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget searchField(context, hintText, textValue,
      {required ValueChanged<String>? onValueChanged}) {
    _myController.text = textValue ?? '';
    _myController.selection =
        TextSelection.collapsed(offset: _myController.text.length);
    return StreamBuilder<dynamic>(
        initialData: 0,
        stream: searchHistoryBloc!.stateStream,
        builder: (context, searchHistorySnapshot) {
          return SizedBox(
            height: 45,
            child: TextFormField(
              controller: _myController,
              cursorColor: myColor.primaryColorDark,
              textCapitalization: TextCapitalization.words,
              style: kStyleNormal.copyWith(
                  fontSize: 12.0, color: Colors.grey[400]),
              onChanged: (String value) {
                onValueChanged!(value);
              },
              onTap: () {},
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                filled: true,
                fillColor: kWhite,
                prefixIcon: Icon(
                  Icons.search,
                  size: 17,
                  color: Colors.grey[400],
                ),
                suffixIcon: GestureDetector(
                    onTap: () {
                      _myController.clear();
                      _search = '';
                      // getProductFromAPI();
                      // getSearchProductFromAPI();
                    },
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey[400],
                    )),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide: BorderSide(color: kWhite, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  borderSide:
                      BorderSide(color: myColor.primaryColorDark, width: 1.5),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                hintText: hintText,
                hintStyle: kStyleNormal.copyWith(
                    fontSize: 12.0, color: Colors.grey[400]),
              ),
              onSaved: (v) {
                textValue = v;
              },
            ),
          );
        });
  }
}
