import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/WishListModel.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class MyWishlist extends StatefulWidget {
  const MyWishlist({Key? key}) : super(key: key);

  @override
  State<MyWishlist> createState() => _MyWishlistState();
}

class _MyWishlistState extends State<MyWishlist> {
  ApiHandlerBloc? wishlistBloc;
  String? productID;
  bool showBottomNav = false;
  List<WishListModel> wishListModel = [];
  @override
  void initState() {
    wishlistBloc = ApiHandlerBloc();
    _refresh();
    super.initState();
  }

  void DeleteOneItemInWishList(wishlistID) async {
    int statusCode;
    statusCode =
        await API().deleteData('admin/wishlist/wishlistDelete/$wishlistID');

    if (statusCode == 200) {
      _refresh();
    }
  }

  void stateOfBottomNav() async {
    setState(() {
      showBottomNav = !showBottomNav;
    });
  }

  void removeAllBtn() async {
    int statusCode;
    statusCode =
        await API().deleteData(endpoints.deleteAllFromWishListEndpoint);

    if (statusCode == 200) {
      _refresh();
    }
  }

  void _refresh() {
    setState(() {});
    wishlistBloc!.fetchAPIList(endpoints.getWishlistEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'My Wishlist',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder<ApiResponse<dynamic>>(
          stream: wishlistBloc!.apiListStream,
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
                  showBottomNav = true;
                  if (snapshot.data!.data.isNotEmpty) {
                    stateOfBottomNav();
                  }
                  if (snapshot.data!.data.isEmpty) {
                    return emptyPage(
                      context,
                      'Your Wishlist is Empty',
                      'Tap Bookmark Button to start saving your favourite items.',
                      'Add Item',
                      () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainHomePage(
                                      tabIndex: 0,
                                      index: 1,
                                    )),
                            (route) => false);
                      },
                    );
                  }
                  wishListModel = List<WishListModel>.from(snapshot.data!.data
                      .map((i) => WishListModel.fromJson(i)));

                  return Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    width: maxWidth(context),
                    height: maxHeight(context),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: myColor.dialogBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                    ),
                    child: buildWishlist(wishListModel),
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
      ),
      bottomNavigationBar: wishListModel.isEmpty
          ? Container(
              height: 0,
            )
          : Container(
              color: myColor.dialogBackgroundColor,
              width: maxWidth(context),
              height: 75,
              child: GestureDetector(
                onTap: () async {
                  var statusCode;
                  statusCode = await API()
                      .deleteData(endpoints.deleteAllFromWishListEndpoint);
                  if (statusCode == 200) {
                    _refresh();
                    print('success');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: myColor.dialogBackgroundColor,
                    border:
                        Border.all(color: myColor.primaryColorDark, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 18.0),
                  width: maxWidth(context),
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
    );
  }

  Widget buildWishlist(List<WishListModel> wishListModel) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: maxWidth(context),
              child: Text(
                '${wishListModel.length.toString()} Items',
                style: kStyleNormal.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: wishListModel.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    width: maxWidth(context),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  margin: const EdgeInsets.all(8.0),
                                  child: myCachedNetworkImage(
                                      maxWidth(context),
                                      maxHeight(context),
                                      wishListModel[i]
                                          .product!
                                          .imagePath
                                          .toString(),
                                      const BorderRadius.all(
                                          Radius.circular(12.0)),
                                      BoxFit.cover)),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 100.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  wishListModel[i]
                                                      .product!
                                                      .productName
                                                      .toString(),
                                                  style: kStyleNormal.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                  )),
                                              Text('Price/Kg',
                                                  style: kStyleNormal.copyWith(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 17.0,
                                                    color: Colors.grey[500],
                                                  )),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              int statusCode;
                                              statusCode =
                                                  await API().deleteData(
                                                'admin/wishlist/wishlistDelete/${wishListModel[i].id}',
                                              );
                                              if (statusCode == 200) {
                                                mySnackbar.mySnackBar(
                                                    context,
                                                    'removed: $statusCode',
                                                    Colors.red);
                                                _refresh();
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                              width: 35.0,
                                              height: 35.0,
                                              child: const Icon(
                                                FontAwesomeIcons.trashCan,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        width: maxWidth(context),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Rs',
                                                  style: kStyleNormal.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                const SizedBox(width: 3.0),
                                                Text(
                                                  wishListModel[i]
                                                      .product!
                                                      .salePrice
                                                      .toString(),
                                                  style: kStyleNormal.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          width: maxWidth(context),
                          height: 55.0,
                          child: myCustomButton(
                            context,
                            myColor.primaryColorDark,
                            'Add to cart',
                            kStyleNormal.copyWith(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                            () {},
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}
