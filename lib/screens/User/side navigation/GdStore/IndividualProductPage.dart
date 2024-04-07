import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/GetReviewModel.dart';
import 'package:ghargharmadoctor/models/WishListModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/CheckoutScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorProfilePage.dart/ExclusiveVendorHomePage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorProfilePage.dart/NormalVendorHomePage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/productCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:html/parser.dart' show parse;

class IndividualProductPage extends StatefulWidget {
  final ProductModelData productModelData;
  final String totalDiscountedPrice;

  const IndividualProductPage(
      {Key? key,
      required this.productModelData,
      required this.totalDiscountedPrice})
      : super(key: key);

  @override
  State<IndividualProductPage> createState() => _IndividualProductPageState();
}

class _IndividualProductPageState extends State<IndividualProductPage>
    with TickerProviderStateMixin {
  final TextEditingController _reviewController = TextEditingController();
  String? userID, wishListID;
  ApiHandlerBloc? wishlistBloc, reviewsBloc, checkFollowBloc;
  String? productID, token, wishListPrimaryID;
  FollowersCheckModel? followersCheckModel;
  List<WishListModel> wishListModel = [];
  List<MyCartDatabaseModel> myList = [];
  List<GetReviewModel> getReviewModel = [];
  List<GetReviewModel> myTestModel = [];
  int initialLength = 3;
  int maxDescriptionLine = 7;
  bool is_Liked = false;
  MyCartDatabaseModel? myCart;
  bool is_Loading = false;
  ProductModel? productModel;
  ApiHandlerBloc? productBloc, onlyVendorProductBloc;
  StateHandlerBloc? followBtnStateChange;
  bool isOutofStock = false;
  int quantity = 1;
  int activeIndex = 0;
  double rating = 5;
  int sellingPriceMultipleQuantity = 0;
  int totalPriceWithoutDiscountMultipleQuantity = 0;
  final int _deliveryCharge = 0;
  String ratingsText = 'Excellent';
  TabController? _tabController;
  int? isFollowedID;
  @override
  void initState() {
    var document = parse(widget.productModelData.description.toString());
    print('document.outerHtml ${document.outerHtml}');
    super.initState();
    userID = sharedPrefs.getUserID('userID');
    wishlistBloc = ApiHandlerBloc();
    reviewsBloc = ApiHandlerBloc();
    checkFollowBloc = ApiHandlerBloc();
    checkFollowBloc!.fetchAPIList(
        'isFollowed?vendor_id=${widget.productModelData.vendorDetails!.id}');
    _refreshReviews();
    _refresh();
    followBtnStateChange = StateHandlerBloc();
    calculation();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  calculation() {
    setState(() {
      sellingPriceMultipleQuantity =
          int.parse(widget.totalDiscountedPrice) * quantity;
      totalPriceWithoutDiscountMultipleQuantity =
          widget.productModelData.salePrice! * quantity;
    });
  }

  void _buyNowBtn() {
    token = sharedPrefs.getFromDevice('token');

    if (sellingPriceMultipleQuantity < 500) {
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.info, 'Minimum amount should be Rs. 500');
    } else {
      myList.clear();
      myList.add(
        MyCartDatabaseModel(
          productID: widget.productModelData.id,
          vendorID: widget.productModelData.vendorId,
          productImage: widget.productModelData.imagePath,
          productName: widget.productModelData.productName,
          productQuantity: quantity.toString(),
          productTotalAmount: sellingPriceMultipleQuantity.toString(),
        ),
      );
      token == null
          ? showLoginPopUp(
              context,
              'buyProduct',
              GuestLoginNavigationModel(
                amount: sellingPriceMultipleQuantity,
                buyProduct: myList,
              ),
            )
          : goThere(
              context,
              CheckoutScreen(
                cartDatabaseModel: myList,
                totalAmount: sellingPriceMultipleQuantity,
              ),
            );
    }
  }

  void _refresh() {
    wishlistBloc!.fetchAPIList(endpoints.getWishlistEndpoint);
    setState(() {
      is_Loading = false;
    });
  }

  void _refreshReviews() {
    reviewsBloc!
        .fetchAPIList('get_review?product_id=${widget.productModelData.id}');
  }

  void submitReviewBtn() async {
    int statusCode;
    if (_reviewController.text.toString().isEmpty) {
      print("is empty");
      myToast.toast('empty');
    } else {
      statusCode = await API().postData(
        context,
        PostReviewModel(
          productId: widget.productModelData.id.toString(),
          comment: _reviewController.text.toString(),
          rating: rating.toString().substring(0, 1),
        ),
        endpoints.postReviewEndpoint,
      );
      if (statusCode == 200) {
        Navigator.pop(context);
        _refreshReviews();
        setState(() {});
      }
    }
  }

  void addToCartBtn(context) async {
    token = sharedPrefs.getFromDevice('token');
    userID = sharedPrefs.getUserID('userID');
    myList = await MyDatabase.instance
        .fetchAddedProductFromCart(userID, widget.productModelData.id);
    if (token == null) {
      if (myList.isNotEmpty) {
        showLoginPopUp(
          context,
          'alreadyInCart',
          GuestLoginNavigationModel(),
        );
      } else {
        addingtoModel();

        showLoginPopUp(
          context,
          'addToCart',
          GuestLoginNavigationModel(myCart: myCart),
        );
      }
    } else {
      if (myList.isNotEmpty) {
        mySnackbar.mySnackBarCustomized(context, 'Already in cart', 'View', () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          goThere(context, const MyCart());
        }, Colors.black.withOpacity(0.7));
      } else {
        addToCartDatabase();
      }
      setState(() {});
    }
  }

  addingtoModel() {
    myCart = MyCartDatabaseModel(
      userID: int.parse(userID.toString()),
      productID: widget.productModelData.id,
      vendorID: widget.productModelData.vendorId,
      productTotalAmount: totalPriceWithoutDiscountMultipleQuantity.toString(),
      productPrice: widget.productModelData.salePrice.toString(),
      sellingPriceAfterDiscount: widget.totalDiscountedPrice.toString(),
      totalSellingPriceAfterDiscount: sellingPriceMultipleQuantity.toString(),
      discount: widget.productModelData.discountPercent.toString(),
      productName: widget.productModelData.productName.toString(),
      productQuantity: quantity.toString(),
      productUnit: widget.productModelData.unit.toString(),
      productImage: widget.productModelData.imagePath.toString(),
      stock: widget.productModelData.stock.toString(),
    );
  }

  addToCartDatabase() {
    addingtoModel();
    var dbHelper = MyDatabase.instance.addToCartLocalDB(myCart!);
    mySnackbar.mySnackBarCustomized(
        context, 'Added to cart succesfully', 'Go to Cart', () {
      goThere(context, const MyCart());
    }, Colors.black.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: widget.productModelData.productName.toString(),
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Stack(
              children: [
                SizedBox(
                  width: maxWidth(context),
                  height: 200.0,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 200,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 600),
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          // setState(() {
                          //   activeIndex = index;
                          // });
                        }),
                    itemCount: widget.productModelData.gallery!.isEmpty
                        ? 1
                        : widget.productModelData.gallery!.length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        color: myColor.dialogBackgroundColor,
                        width: maxWidth(context),
                        child: widget.productModelData.gallery!.isEmpty
                            ? myCachedNetworkImage(
                                maxWidth(context),
                                maxHeight(context),
                                widget.productModelData.imagePath.toString(),
                                const BorderRadius.all(Radius.circular(0.0)),
                                BoxFit.cover,
                              )
                            : myCachedNetworkImage(
                                maxWidth(context),
                                maxHeight(context),
                                widget
                                    .productModelData.gallery![index].imagePath
                                    .toString(),
                                const BorderRadius.all(Radius.circular(0.0)),
                                BoxFit.cover,
                              ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 15.0,
                  top: 15.0,
                  child: CircleAvatar(
                    backgroundColor: myColor.primaryColorDark,
                    radius: 27.4,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 26,
                      child: StreamBuilder<ApiResponse<dynamic>>(
                        stream: wishlistBloc!.apiListStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return SizedBox(
                                  width: 27.4,
                                  height: 27.4,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 27.4,
                                    child: CircularProgressIndicator(
                                      backgroundColor: myColor.primaryColorDark,
                                      color: myColor.primaryColor,
                                      strokeWidth: 1.4,
                                    ),
                                  ),
                                );

                              case Status.COMPLETED:
                                wishListModel = List<WishListModel>.from(
                                    snapshot.data!.data
                                        .map((i) => WishListModel.fromJson(i)));
                                // for (int i = 0; i < wishListModel.length; i++) {
                                //   print(
                                //       'object   ${wishListModel[0].id} ${widget.productModelData.id}');
                                //   wishListPrimaryID =
                                //       wishListModel[i].id.toString();
                                //   if (wishListModel[i].productId ==
                                //       widget.productModelData.id) {
                                //     print(is_Liked);
                                //     print('my print $is_Liked');

                                //     is_Liked = true;
                                //   }
                                // }
                                if (wishListModel.isNotEmpty) {
                                  for (var element in wishListModel) {
                                    if (element.productId ==
                                        widget.productModelData.id) {
                                      wishListID = element.id.toString();
                                      is_Liked = true;
                                    }
                                  }
                                } else {
                                  is_Liked = false;
                                }
                                return CircleAvatar(
                                  backgroundColor: myColor.primaryColorDark,
                                  radius: 27.4,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white, radius: 26,
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          is_Loading = true;
                                        });
                                        if (is_Liked == false) {
                                          int statusCode;
                                          statusCode = await API().postData(
                                            context,
                                            PostToWishListModel(
                                                productId: widget
                                                    .productModelData.id
                                                    .toString()),
                                            'admin/wishlist/addToWishlist',
                                          );
                                          if (statusCode == 200) {
                                            _refresh();
                                          }
                                        } else {
                                          int statusCode;
                                          print(
                                              'this is my wishlist id $wishListID');
                                          statusCode = await API().deleteData(
                                            'admin/wishlist/wishlistDelete/$wishListID',
                                          );
                                          print('heelo code $statusCode');
                                          if (statusCode == 200) {
                                            _refresh();
                                          }
                                        }
                                      },
                                      child: is_Loading
                                          ? SizedBox(
                                              width: 27.4,
                                              height: 27.4,
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    myColor.primaryColorDark,
                                                color: myColor.primaryColor,
                                                strokeWidth: 1.4,
                                              ),
                                            )
                                          : Icon(is_Liked
                                              ? Icons.favorite
                                              : Icons.favorite_border),
                                    ),
                                    // LikeButton(
                                    //   onTap: (isLiked) async {
                                    //     if (is_Liked) {
                                    //       int statusCode;
                                    //       statusCode = await API().deleteData(
                                    //         'admin/wishlist/wishlistDelete/$wishListID',
                                    //       );
                                    //       if (statusCode == 200) {
                                    //         ScaffoldMessenger.of(context)
                                    //             .showSnackBar(SnackBar(
                                    //           content:
                                    //               Text('DisLiked: $statusCode'),
                                    //           backgroundColor: Colors.red,
                                    //         ));
                                    //         wishlistBloc!.fetchAPIList(
                                    //             endpoints.getWishlistEndpoint);
                                    //         print(isLiked);
                                    //       }
                                    //     } else {
                                    //       int statusCode;
                                    //       statusCode = await API()
                                    //           .postDataWithAuthentication(
                                    //         context,
                                    //         PostToWishListModel(
                                    //             productId: widget
                                    //                 .productModelData.id
                                    //                 .toString()),
                                    //         'admin/wishlist/addToWishlist',
                                    //       );

                                    //       if (statusCode == 200) {
                                    //         ScaffoldMessenger.of(context)
                                    //             .showSnackBar(SnackBar(
                                    //           content:
                                    //               Text('Liked: $statusCode'),
                                    //           backgroundColor: Colors.green,
                                    //         ));
                                    //         wishlistBloc!.fetchAPIList(
                                    //             endpoints.getWishlistEndpoint);
                                    //         print('success $isLiked');
                                    //       }
                                    //     }

                                    //     return !isLiked;
                                    //   },
                                    //   size: 40.0,
                                    //   circleColor: CircleColor(
                                    //       start: myColor.primaryColor,
                                    //       end: myColor.primaryColor),
                                    //   bubblesColor: BubblesColor(
                                    //     dotPrimaryColor:
                                    //         myColor.primaryColorDark,
                                    //     dotSecondaryColor: myColor.primaryColor,
                                    //   ),
                                    //   likeBuilder: (bool isliked) {
                                    //     return Icon(
                                    //       is_Liked
                                    //           ? Icons.bookmark
                                    //           : Icons.bookmark_border,
                                    //       color: myColor.primaryColorDark,
                                    //       size: 33.0,
                                    //     );
                                    //   },
                                    // ),
                                  ),
                                );

                              case Status.ERROR:
                                return CircleAvatar(
                                  backgroundColor: myColor.primaryColorDark,
                                  radius: 27.4,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 26,
                                    child: Icon(
                                      Icons.bookmark_border,
                                      size: 30.0,
                                      color: myColor.primaryColorDark,
                                    ),
                                  ),
                                );
                            }
                          }
                          return SizedBox(
                            width: maxWidth(context),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox12(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              width: maxWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.productModelData.productName.toString(),
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Rs ${widget.totalDiscountedPrice.toString()}',
                          style: kStyleNormal.copyWith(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text:
                                  ' /${widget.productModelData.unit.toString()}',
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  GestureDetector(
                    onTap: () {
                      goToVendorProfile();
                    },
                    child: Text(
                      'Sold by ${widget.productModelData.vendorDetails!.storeName.toString()}',
                      style: kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox8(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          StatefulBuilder(builder: (context, setState) {
                            return RatingBar.builder(
                              minRating: 1,
                              allowHalfRating: true,
                              itemBuilder: (context, _) {
                                return const Icon(
                                  Icons.star,
                                  size: 5.0,
                                  color: Colors.amber,
                                );
                              },
                              initialRating:
                                  // widget.productModelData.averageRating
                                  double.parse(widget
                                      .productModelData.averageRating
                                      .toString()),
                              updateOnDrag: true,
                              itemSize: 18.0,
                              itemPadding: const EdgeInsets.only(right: 2.0),
                              onRatingUpdate: (rating) => setState(() {
                                this.rating = rating;
                              }),
                            );
                          }),
                          const SizedBox(width: 5.0),
                          Text(
                            widget.productModelData.averageRating.toString() ==
                                    '0.0'
                                ? '( 0/5 )'
                                : '( ${widget.productModelData.averageRating.toString()}/5 )',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      widget.productModelData.discountPercent.toString() == '0'
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: myColor.primaryColorDark,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(FontAwesomeIcons.tag,
                                      size: 14.0, color: kWhite),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '${widget.productModelData.discountPercent.toString()}% OFF',
                                    style: kStyleNormal.copyWith(
                                        fontSize: 12.0, color: kWhite),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  const SizedBox16(),
                  Container(
                      // margin: const EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: maxWidth(context),
                            child: Html(
                              data: widget.productModelData.description == null
                                  ? 'No description added'
                                  : widget.productModelData.description
                                      .toString(),
                              style: {
                                "*": Style(
                                  fontSize: FontSize(12.0),
                                  fontFamily: 'Futura',
                                  textAlign: TextAlign.justify,
                                ),
                              },
                            ),
                            // Text(
                            //   widget.productModelData.description == null
                            //       ? 'No description added'
                            //       : parse(widget.productModelData.description
                            //               .toString())
                            //           .outerHtml,
                            //   textAlign: TextAlign.justify,
                            //   maxLines: maxDescriptionLine,
                            //   style: kStyleNormal.copyWith(
                            //     fontSize: 12.0,
                            //   ),
                            // ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {});
                                },
                                child:
                                    widget.productModelData.description == null
                                        ? Container()
                                        : Text(
                                            'Read more',
                                            style: kStyleNormal.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: myColor.primaryColorDark,
                                              fontSize: 12.0,
                                            ),
                                          ),
                              ),
                            ],
                          ),
                          const SizedBox12(),
                          myRow(Icons.store, 'Brand:   ', 'Brand Name', () {}),
                          Divider(
                            color: myColor.primaryColorDark.withOpacity(0.3),
                          ),
                          myRow(
                              Icons.store,
                              'Total Reviews:   ',
                              '${widget.productModelData.totalReviews} Positive Reviews',
                              () {}),
                          Divider(
                            color: myColor.primaryColorDark.withOpacity(0.3),
                          ),
                          myRow(Icons.store, 'Brand', 'Brand Name', () {}),
                          const SizedBox(height: 8.0),
                          const SizedBox(height: 8.0),
                        ],
                      )),
                  const SizedBox16(),
                  StreamBuilder<ApiResponse<dynamic>>(
                    stream: reviewsBloc!.apiListStream,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return Container(
                              width: maxWidth(context),
                              height: 120.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const AnimatedLoading(),
                            );
                          case Status.COMPLETED:
                            if (snapshot.data!.data.isEmpty) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: backgroundColor,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        builder: ((builder) =>
                                            addReviewBottomSheet()),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: myColor.primaryColorDark,
                                          size: 16.0,
                                        ),
                                        Text(
                                          'Add Reviews',
                                          style: kStyleNormal.copyWith(
                                            color: myColor.primaryColorDark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'No reviews yet',
                                    style: kStyleNormal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0,
                                    ),
                                  ),
                                ],
                              );
                            }
                            getReviewModel = List<GetReviewModel>.from(snapshot
                                .data!.data
                                .map((i) => GetReviewModel.fromJson(i)));
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ratings and Reviews  ( ${getReviewModel.length} )',
                                      style: kStyleNormal.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     showModalBottomSheet(
                                    //       context: context,
                                    //       backgroundColor:
                                    //           backgroundColor,
                                    //       isScrollControlled: true,
                                    //       shape: const RoundedRectangleBorder(
                                    //           borderRadius:
                                    //               BorderRadius.vertical(
                                    //                   top:
                                    //                       Radius.circular(20))),
                                    //       builder: ((builder) =>
                                    //           addReviewBottomSheet()),
                                    //     );
                                    //   },
                                    //   child: Text(
                                    //     'Add Review',
                                    //     style: kStyleNormal.copyWith(
                                    //       fontWeight: FontWeight.bold,
                                    //       color: myColor.primaryColorDark,
                                    //       fontSize: 13.0,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox12(),
                                ListView.builder(
                                    itemCount:
                                        getReviewModel.length > initialLength
                                            ? initialLength
                                            : getReviewModel.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return reviewsCard(getReviewModel[index]);
                                    }),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                getReviewModel.length > initialLength
                                    ? Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              initialLength =
                                                  getReviewModel.length;
                                            });
                                          },
                                          child: Text(
                                            'See more',
                                            style: kStyleNormal.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      )
                                    : getReviewModel.length < initialLength
                                        // &&
                                        //         getReviewModel.length ==
                                        //             initialLength
                                        ? Text(
                                            'No more reviews',
                                            style: kStyleNormal.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                initialLength = 3;
                                              });
                                            },
                                            child: Text(
                                              'See less',
                                              style: kStyleNormal.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )
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
                      return SizedBox(
                        width: maxWidth(context),
                      );
                    }),
                  ),
                  const SizedBox16(),
                  vendorCard(),
                  const SizedBox16(),
                  Builder(builder: (context) {
                    _tabController!.addListener(() {
                      setState(() {});
                    });
                    return TabBar(
                      controller: _tabController,
                      labelColor: myColor.primaryColorDark,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 2.0, color: myColor.primaryColorDark),
                          insets: const EdgeInsets.symmetric(horizontal: 25.0)),
                      unselectedLabelColor: myColor.primaryColorDark,
                      // indicator: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(8.0),
                      //   color: myColor.primaryColorDark,
                      // ),
                      tabs: [
                        Tab(
                          child: Text('Related Products',
                              style: kStyleNormal.copyWith(
                                  fontSize: 14.0, fontWeight: FontWeight.bold)),
                        ),
                        Tab(
                          child: Text('This Vendor',
                              style: kStyleNormal.copyWith(
                                  fontSize: 14.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  }),
                  const SizedBox16(),
                  buildTabbarView(_tabController!.index),
                  const SizedBox16(),
                  titleCard('Most Popular', '', () {}),
                  const SizedBox16(),
                  // _productsWidget(context),
                ],
              ),
            ),
            const SizedBox16()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 165,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity',
                  style: kStyleNormal.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total',
                  style: kStyleNormal.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          quantity != 1 ? quantity-- : quantity;
                          quantity != widget.productModelData.stock
                              ? setState(() {
                                  isOutofStock = false;
                                })
                              : null;

                          sellingPriceMultipleQuantity =
                              int.parse(widget.totalDiscountedPrice) * quantity;

                          totalPriceWithoutDiscountMultipleQuantity =
                              widget.productModelData.salePrice! * quantity;
                          calculation();
                        });
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: quantity != 1
                              ? myColor.primaryColorDark
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.remove,
                            size: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      quantity.toString(),
                      style: kStyleNormal.copyWith(fontSize: 20.0),
                    ),
                    const SizedBox(width: 15.0),
                    GestureDetector(
                      onTap: () {
                        quantity == widget.productModelData.stock
                            ? setState(() {
                                isOutofStock = true;
                              })
                            : setState(() {
                                if (widget.productModelData.stock != 0) {
                                  quantity++;

                                  totalPriceWithoutDiscountMultipleQuantity =
                                      widget.productModelData.salePrice! *
                                          quantity;
                                  sellingPriceMultipleQuantity =
                                      int.parse(widget.totalDiscountedPrice) *
                                          quantity;
                                  calculation();
                                }
                              });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: myColor.primaryColorDark,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.add,
                          size: 15.0,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    !isOutofStock
                        ? Container()
                        : Container(
                            height: 25,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                'Out of Stock',
                                style: kStyleNormal.copyWith(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                Text(
                  'Rs ${sellingPriceMultipleQuantity.toString()}',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox8(),
            const Divider(),
            const SizedBox8(),
            widget.productModelData.stock == 0
                ? SizedBox(
                    width: maxWidth(context),
                    height: 50,
                    child: myCustomButton(
                        context,
                        Colors.red[200],
                        'Out of Stock',
                        kStyleNormal.copyWith(
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                        () {}),
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            addToCartBtn(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: myColor.primaryColorDark, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add to cart',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Container(
                                  margin: const EdgeInsets.only(top: 2.0),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: myColor.primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 50,
                          child: myCustomButton(
                              context,
                              myColor.primaryColorDark,
                              'Buy Now',
                              kStyleNormal.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.bold,
                              ), () {
                            _buyNowBtn();
                          }),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget myRow(icon, leading, trailing, myTap) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Icon(icon, size: 14.0, color: myColor.primaryColorDark),
          const SizedBox(width: 12.0),
          Text.rich(
            TextSpan(
              text: leading,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                color: myColor.primaryColorDark,
                fontWeight: FontWeight.bold,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: trailing,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: () {
          myTap();
        },
        child: Icon(
          Icons.keyboard_arrow_right,
          size: 22.0,
          color: myColor.primaryColorDark,
        ),
      ),
    ]);
  }

  Widget buildTabbarView(i) {
    return SizedBox(
      height: 220.0,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          relatedProducts(),
          thisVendorProducts(),
        ],
      ),
    );
  }

  Widget thisVendorProducts() {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: onlyVendorProductBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const AnimatedLoading();
            case Status.COMPLETED:
              productModel = ProductModel.fromJson(snapshot.data!.data);

              if (productModel!.data!.isEmpty) {
                return Container(
                    width: maxWidth(context),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        const Center(child: Text('No latest product added')));
              }
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      Colors.white,
                      0.0,
                    );
                  });

            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 210.0,
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

  Widget relatedProducts() {
    productBloc = ApiHandlerBloc();
    productBloc!.fetchAPIList('products?latest=desc');
    onlyVendorProductBloc = ApiHandlerBloc();
    onlyVendorProductBloc!.fetchAPIList(
        'products?vendor_id=${widget.productModelData.vendorId.toString()}&latest=desc');
    return _productsWidget(context);
  }

  Widget _productsWidget(BuildContext context) {
    return SizedBox(
      width: maxWidth(context),
      height: 220.0,
      child: StreamBuilder<ApiResponse<dynamic>>(
        stream: productBloc!.apiListStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return const AnimatedLoading();
              case Status.COMPLETED:
                if (snapshot.data!.data.isEmpty) {
                  return Container(
                      width: maxWidth(context),
                      height: maxHeight(context) / 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          const Center(child: Text('No any products added')));
                }

                productModel = ProductModel.fromJson(snapshot.data!.data);
                return productModel!.data!.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('No products found'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: productModel!.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return productCard(
                            context,
                            productModel!.data![index],
                            setState,
                            Colors.white,
                            10.0,
                          );
                        });
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
    );
  }

  goToVendorProfile() {
    if (widget.productModelData.vendorDetails!.isExculsive == 2) {
      goThere(
        context,
        ExclusiveVendorHomePage(
          data: widget.productModelData.vendorDetails,
        ),
      );
    } else {
      goThere(
        context,
        NormalVendorHomePage(
          data: widget.productModelData.vendorDetails,
        ),
      );
    }
  }

  Widget vendorCard() {
    return GestureDetector(
      onTap: () {
        goToVendorProfile();
      },
      child: Container(
        // margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.store,
                      size: 18.0,
                      color: myColor.primaryColorDark,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      widget.productModelData.vendorDetails!.storeName
                          .toString(),
                      style: kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      minRating: 1,
                      itemBuilder: (context, _) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      itemCount: 5,
                      initialRating: rating,
                      updateOnDrag: true,
                      itemSize: 20.0,
                      itemPadding: const EdgeInsets.only(right: 2.0),
                      onRatingUpdate: (rating) => setState(() {
                        this.rating = rating;
                      }),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      '( ${widget.productModelData.vendorDetails!.totalRating}/5 )',
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                followBtnWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Visit',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        color: myColor.primaryColorDark,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox8(),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: myColor.primaryColorDark,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void followBtn(followStateID) async {
    print('koko');
    followBtnStateChange!.storeData(2);
    int statusCode;
    statusCode = await API().postData(
        context,
        FollowVendorModel(vendorId: widget.productModelData.vendorDetails!.id),
        endpoints.postVendorFollowEndpoint);
    if (statusCode == 200) {
      if (followStateID == 1) {
        isFollowedID = 0;
        print('FollowedID =  0 ==> $isFollowedID');
        followBtnStateChange!.storeData(0);
      } else {
        isFollowedID = 1;
        print('FollowedID =  0 ==> $isFollowedID');
        followBtnStateChange!.storeData(1);
      }
    } else {
      followBtnStateChange!.storeData(followStateID);
    }
  }

  Widget followBtnWidget() {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: checkFollowBloc!.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return followBtnCard(FontAwesomeIcons.repeat, 'Loading', 12.0);

            case Status.COMPLETED:
              followersCheckModel =
                  FollowersCheckModel.fromJson(snapshot.data!.data);
              if (snapshot.data!.data.isEmpty) {
                return followBtnCard(
                    Icons.error_outline_outlined, 'Empty data', 14.0);
              }
              isFollowedID = followersCheckModel!.isfollowed!;
              return StreamBuilder<dynamic>(
                  initialData: isFollowedID,
                  stream: followBtnStateChange!.stateStream,
                  builder: ((context, snapshot) {
                    if (snapshot.data == 0) {
                      return GestureDetector(
                          onTap: () {
                            followBtn(isFollowedID);
                          },
                          child: followBtnCard(Icons.add, 'Follow', 14.0));
                    } else if (snapshot.data == 2) {
                      return followBtnCard(
                          FontAwesomeIcons.repeat, 'Loading', 12.0);
                    } else {
                      return GestureDetector(
                          onTap: () {
                            followBtn(isFollowedID);
                          },
                          child: followBtnCard(Icons.check, 'Following', 14.0));
                    }
                  }));

            case Status.ERROR:
              return followBtnCard(
                  Icons.error_outline_outlined, 'Server Error', 14.0);
          }
        }
        return SizedBox(
          width: maxWidth(context),
        );
      }),
    );
  }

  Widget followBtnCard(icon, title, iconSize) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        border: Border.all(
          color: myColor.primaryColorDark,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: myColor.primaryColorDark,
          ),
          const SizedBox(width: 6.0),
          Text(
            title,
            style: kStyleNormal.copyWith(
              color: myColor.primaryColorDark,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewsCard(GetReviewModel getReviewModel) {
    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: maxWidth(context),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  50.0,
                  50.0,
                  getReviewModel.member!.imagePath.toString(),
                  const BorderRadius.all(Radius.circular(8.0)),
                  BoxFit.cover,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getReviewModel.member!.user!.name.toString(),
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                minRating: 1,
                                itemBuilder: (context, _) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                itemCount: 1,
                                initialRating: rating,
                                updateOnDrag: true,
                                itemSize: 20.0,
                                itemPadding: const EdgeInsets.only(right: 2.0),
                                onRatingUpdate: (rating) => setState(() {
                                  this.rating = rating;
                                }),
                              ),
                              const SizedBox(width: 6.0),
                              Text('( ${getReviewModel.rating.toString()}/5 )',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          Text(
                            getReviewModel.updatedAt
                                .toString()
                                .substring(0, 10),
                            style: kStyleNormal,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              getReviewModel.comment.toString(),
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget addReviewBottomSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox12(),
                  Text(
                    'Give Ratings',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox12(),
                  Container(
                    width: maxWidth(context),
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                                minRating: 1,
                                itemBuilder: (context, _) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                initialRating: rating,
                                updateOnDrag: true,
                                itemSize: 30.0,
                                itemPadding: const EdgeInsets.only(right: 5),
                                onRatingUpdate: (newRatingValue) {
                                  setState(() {
                                    rating = newRatingValue;
                                    rating == 1
                                        ? ratingsText = 'Satisfactory'
                                        : rating == 2
                                            ? ratingsText = 'Good'
                                            : rating == 3
                                                ? ratingsText = 'Average'
                                                : rating == 4
                                                    ? ratingsText = 'Best'
                                                    : rating == 5
                                                        ? ratingsText =
                                                            'Excellent'
                                                        : 'Excellent';
                                  });
                                }),
                            const SizedBox(width: 10.0),
                            Text(
                              '${rating.toString()}  ( $ratingsText )',
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox12(),
                  Text(
                    'Write a Review',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox12(),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    width: 400.0,
                    child: TextField(
                      style: kStyleNormal.copyWith(fontSize: 12.0),
                      controller: _reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: myColor.primaryColorDark, width: 1.5),
                        ),
                        hintText:
                            'Would you like to write anything about this product?',
                        hintStyle: kStyleNormal.copyWith(
                            fontSize: 12.0, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  const SizedBox32(),
                  SizedBox(
                    width: maxWidth(context),
                    height: 50.0,
                    child: myCustomButton(
                      context,
                      myColor.primaryColorDark,
                      'Submit Review',
                      kStyleNormal.copyWith(
                          color: Colors.white, fontSize: 14.0),
                      () {
                        submitReviewBtn();
                      },
                    ),
                  ),
                  const SizedBox12(),
                ])),
      );
    });
  }
}
