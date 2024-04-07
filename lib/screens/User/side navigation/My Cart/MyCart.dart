import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/CheckoutScreen.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<int> quantityValue = [];
  List<int> individualProductPrice = [];
  int selectedIndex = -1;
  int subTotal = 0;
  int _deliveryCharge = 0;
  final int _cartTotal = 0;
  List<MyCartDatabaseModel> cartDatabaseModel = [];
  List<CheckProductInStockModel> checkProductInStockModel = [];
  bool isLoading = false;
  List<bool> boolList = [];
  List<MyCartDatabaseModel> tempTappedList = [];
  ApiHandlerBloc? productBloc;
  List<String> listOfID = [];
  String productIDListEndpoint = '';

  @override
  void initState() {
    super.initState();
    refresh();
    boolList.clear();
  }

  refresh() async {
    await getLocalData();
    productBloc = ApiHandlerBloc();
    productBloc!.fetchAPIList('check-stock$productIDListEndpoint');
  }

  @override
  void dispose() {
    MyDatabase.instance.close();
    super.dispose();
  }

  updateQuantity(MyCartDatabaseModel cartDatabaseModel, i) {
    int? newTotalAfterDiscount;
    int? newTotal;
    setState(() {
      newTotal = quantityValue[i] *
          int.parse(cartDatabaseModel.productPrice.toString());
      newTotalAfterDiscount = quantityValue[i] *
          int.parse(cartDatabaseModel.sellingPriceAfterDiscount.toString());
    });
    MyDatabase.instance.updateQuantityInLocalDB(
      quantityValue[i],
      newTotal,
      newTotalAfterDiscount,
      cartDatabaseModel.stock,
      cartDatabaseModel.id,
    );
    getLocalData();
  }

  Future getLocalData() async {
    int userID = int.parse(sharedPrefs.getUserID('userID'));
    cartDatabaseModel = await MyDatabase.instance.fetchDataFromCart(userID);
    for (var element in cartDatabaseModel) {
      quantityValue.add(int.parse(element.productQuantity.toString()));
      productIDListEndpoint =
          '${productIDListEndpoint}list[]=${element.productID}&';
      boolList.add(false);
    }
    productIDListEndpoint = '?$productIDListEndpoint';
    getSingleProductData();
    setState(() {});
  }

  Future getSingleProductData() async {
    tempTappedList.clear();
    listOfID.clear();
    subTotal = 0;

    for (int i = 0; i < boolList.length; i++) {
      if (boolList[i]) {
        listOfID.add(cartDatabaseModel[i].id.toString());
        tempTappedList.add(cartDatabaseModel[i]);
      }
    }
    calculation(tempTappedList);
  }

  calculation(List<MyCartDatabaseModel> tempTappedList) {
    subTotal = 0;
    _deliveryCharge = 0;
    for (var element in tempTappedList) {
      subTotal = subTotal +
          int.parse(element.totalSellingPriceAfterDiscount.toString());
    }
    setState(() {});
  }

  proceedBtn() async {
    if (subTotal < 500) {
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.info, 'Minimum amount should be Rs. 500');
    } else {
      goThere(
          context,
          CheckoutScreen(
            cartDatabaseModel: cartDatabaseModel,
            totalAmount: subTotal,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'My Cart',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: cartDatabaseModel.isEmpty
          ? emptyPage(
              context,
              'Your Cart is Empty',
              'Start Adding items to your cart to buy products.',
              'Add Item', () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainHomePage(
                            tabIndex: 0,
                            index: 1,
                          )),
                  (route) => false);
            })
          : myCartCard(),
      extendBody: true,
      bottomNavigationBar: cartDatabaseModel.isEmpty
          ? Container(
              height: 0,
            )
          : Container(
              decoration: BoxDecoration(
                color: myColor.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              width: maxWidth(context),
              height: 190,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: kStyleNormal.copyWith(fontSize: 14.0),
                      ),
                      Text(
                        'Rs. ${subTotal.toString()}',
                        style: kStyleNormal.copyWith(fontSize: 14.0),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery',
                        style: kStyleNormal.copyWith(fontSize: 14.0),
                      ),
                      Text(
                        'Rs. ${_deliveryCharge.toString()}',
                        style: kStyleNormal.copyWith(fontSize: 14.0),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cart Total',
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs ${_cartTotal.toString()}',
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tempTappedList.isNotEmpty) {
                            popUpHelper().popUpDelete(context, () {
                              MyDatabase.instance.delete(listOfID);
                              getLocalData();
                              Navigator.pop(context);
                              // boolList.add(false);
                            });
                          }
                        },
                        child: SizedBox(
                          width: 110,
                          height: 55.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: myColor.primaryColorDark, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: maxWidth(context) / 2 - 20,
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
                        child: SizedBox(
                          height: 55.0,
                          child: myCustomButton(
                              context,
                              myColor.primaryColorDark,
                              'Proceed',
                              kStyleNormal.copyWith(
                                fontSize: 16.0,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ), () {
                            proceedBtn();
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

  Widget myCartCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      height: maxHeight(context),
      child: StreamBuilder<ApiResponse<dynamic>>(
        stream: productBloc!.apiListStream,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.LOADING:
                return Container(
                  width: maxWidth(context),
                  height: maxHeight(context) / 2,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: myColor.dialogBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const AnimatedLoading(),
                );
              case Status.COMPLETED:
                List<CheckProductInStockModel> test = [];
                checkProductInStockModel = List<CheckProductInStockModel>.from(
                    snapshot.data!.data
                        .map((i) => CheckProductInStockModel.fromJson(i)));
                test.clear();
                for (int j = 0; j < cartDatabaseModel.length; j++) {
                  for (int i = 0; i < checkProductInStockModel.length; i++) {
                    if (cartDatabaseModel[j].productID ==
                        checkProductInStockModel[i].id) {
                      test.add(checkProductInStockModel[i]);
                      // MyDatabase.instance.updateQuantityInLocalDB(checkProductInStockModel[i].stock, newTOtal, totalSellingPriceAfterDiscount, stock, id)
                    }
                  }
                }
                print(test.length);
                for (var e in test) {
                  print(e.id);
                }
                checkProductInStockModel.clear();
                checkProductInStockModel.addAll(test);
                // print(test[0].id);
                // print(test[1].id);
                return buildCart();
              case Status.ERROR:
                return Container(
                  width: maxWidth(context),
                  height: 135.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
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
            height: 200,
          );
        }),
      ),
    );
  }

  Widget buildCart() => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: maxWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        cartDatabaseModel.length.toString(),
                        style:
                            kStyleNormal.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 3.0),
                      Text(
                        cartDatabaseModel.length == 1 ? 'Item' : 'Items',
                        style:
                            kStyleNormal.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        boolList.clear();
                        for (int i = 0; i < cartDatabaseModel.length; i++) {
                          boolList.add(true);
                        }
                        getSingleProductData();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            // selectedIndexs == i
                            //     ? Icons.check_circle
                            //     :
                            Icons.circle,
                            color:
                                //  selectedIndexs == index
                                //     ? Colors.green
                                //     :
                                Colors.white.withOpacity(0.3),
                            size: 16.0,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            'All',
                            style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox12(),
            ListView.builder(
              itemCount: cartDatabaseModel.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, i) {
                boolList.add(false);
                return buildCartItem(cartDatabaseModel[i], i);
              },
            ),
          ],
        ),
      );

  Widget buildCartItem(MyCartDatabaseModel cartDatabaseModel, i) {
    // if (int.parse(cartDatabaseModel.productQuantity.toString()) >
    //     checkProductInStockModel[i].stock!) {
    //   quantityValue[i] = checkProductInStockModel[i].stock!;
    //   print('my q = $quantityValue[i]');
    //   int? newTotalAfterDiscount;
    //   int? newTotal;
    //   newTotal = quantityValue[i] *
    //       int.parse(cartDatabaseModel.productPrice.toString());
    //   newTotalAfterDiscount = quantityValue[i] *
    //       int.parse(cartDatabaseModel.sellingPriceAfterDiscount.toString());
    //   MyDatabase.instance.updateQuantityInLocalDB(
    //     quantityValue[i],
    //     newTotal,
    //     newTotalAfterDiscount,
    //     cartDatabaseModel.stock,
    //     cartDatabaseModel.id,
    //   );
    // }
    return GestureDetector(
      onTap: () {
        print(checkProductInStockModel[i].id);
        print(cartDatabaseModel.productID);
        if ((checkProductInStockModel[i].id ==
                int.parse(cartDatabaseModel.productID.toString())) &&
            checkProductInStockModel[i].stock != 0) {
          setState(() {
            boolList[i] = !boolList[i];

            getSingleProductData();
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  // width: 100.0,
                  // height: 100.0,
                  decoration: BoxDecoration(
                    color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      myCachedNetworkImage(
                        maxWidth(context),
                        100.0,
                        cartDatabaseModel.productImage.toString(),
                        const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                        ),
                        BoxFit.cover,
                      ),
                      (checkProductInStockModel[i].id ==
                                  int.parse(cartDatabaseModel.productID
                                      .toString())) &&
                              checkProductInStockModel[i].stock == 0
                          ? Positioned(
                              child: Container(
                                width: maxWidth(context),
                                height: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 34.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox8(),
                                    Text('Out of Stock',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 12.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartDatabaseModel.productID.toString(),
                              // maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                            ),
                            const SizedBox2(),
                            Text(
                                'Price/${cartDatabaseModel.productUnit.toString()}: Rs ${cartDatabaseModel.productPrice.toString()}',
                                style: kStyleNormal.copyWith(
                                  fontSize: 10.0,
                                )),
                            const SizedBox8(),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: (checkProductInStockModel[i].id ==
                                      int.parse(cartDatabaseModel.productID
                                          .toString())) &&
                                  checkProductInStockModel[i].stock == 0
                              ? Icon(Icons.error_outline_outlined,
                                  color: boolList[i]
                                      ? myColor.primaryColorDark
                                      : myColor.dialogBackgroundColor,
                                  size: 18.0)
                              : Icon(
                                  boolList[i]
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: boolList[i]
                                      ? myColor.primaryColorDark
                                      : myColor.dialogBackgroundColor,
                                  size: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rs ${cartDatabaseModel.productTotalAmount.toString()}',
                                  overflow: TextOverflow.ellipsis,
                                  style: kStyleNormal.copyWith(
                                    fontSize: 10.0,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '- ${cartDatabaseModel.discount.toString()}%',
                                  overflow: TextOverflow.ellipsis,
                                  style: kStyleNormal.copyWith(
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Rs ${cartDatabaseModel.totalSellingPriceAfterDiscount}',
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: myColor.primaryColorDark,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantityValue[i] != 1
                                        ? quantityValue[i]--
                                        : quantityValue[i];
                                  });
                                  updateQuantity(cartDatabaseModel, i);
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: quantityValue[i] != 1
                                        ? myColor.primaryColorDark
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.remove,
                                        size: 15.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Text(
                                quantityValue[i].toString(),
                                style: kStyleNormal.copyWith(fontSize: 20.0),
                              ),
                              const SizedBox(width: 15.0),
                              GestureDetector(
                                onTap: () {
                                  if (quantityValue[i] !=
                                      int.parse(
                                          cartDatabaseModel.stock.toString())) {
                                    setState(() {
                                      quantityValue[i]++;
                                    });

                                    updateQuantity(cartDatabaseModel, i);
                                  }
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: quantityValue[i] !=
                                            int.parse(cartDatabaseModel.stock
                                                .toString())
                                        ? myColor.primaryColorDark
                                        : Colors.grey[300],
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
