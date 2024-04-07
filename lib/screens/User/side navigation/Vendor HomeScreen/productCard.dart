import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/IndividualProductPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';

Widget productCard(BuildContext context, ProductModelData productModelData,
    setState, Color cardColor, margin) {
  double priceAfterDiscount() {
    double discountPercent =
        (double.parse(productModelData.discountPercent.toString()) / 100);
    double sellingPrice = double.parse(productModelData.salePrice.toString());
    double toBeSubstractedValue = discountPercent * sellingPrice;
    double discountedPrice = sellingPrice - toBeSubstractedValue;
    return discountedPrice;
  }

  return GestureDetector(
      onTap: () {
        goThere(
          context,
          IndividualProductPage(
            productModelData: productModelData,
            totalDiscountedPrice: priceAfterDiscount().round().toString(),
          ),
        );
      },
      child: Container(
        width: 160.0,
        margin: EdgeInsets.only(right: margin),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: myCachedNetworkImage(
                  maxWidth(context),
                  maxHeight(context),
                  productModelData.imagePath.toString(),
                  const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox2(),
                    const SizedBox2(),
                    Text(
                      productModelData.productName.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox2(),
                    const SizedBox2(),
                    SizedBox(
                      width: maxWidth(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Per ${productModelData.unit.toString()}',
                            overflow: TextOverflow.ellipsis,
                            style: kStyleNormal.copyWith(
                              fontSize: 10.0,
                            ),
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                itemCount: 1,
                                itemBuilder: (context, _) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                initialRating: double.parse(
                                    productModelData.averageRating.toString()),
                                updateOnDrag: false,
                                itemSize: 13.0,
                                itemPadding: const EdgeInsets.only(right: 2.0),
                                onRatingUpdate: (rating) => setState(() {
                                  rating = rating;
                                }),
                              ),
                              Text(
                                productModelData.averageRating.toString(),
                                style: kStyleNormal.copyWith(fontSize: 11.0),
                              ),
                              Text(
                                ' (${productModelData.totalReviews.toString()} Reviews)',
                                style: kStyleNormal.copyWith(fontSize: 10.0),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox2(),
                    const SizedBox2(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Rs ${productModelData.salePrice.toString()}',
                                    overflow: TextOverflow.ellipsis,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 10.0,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '- ${productModelData.discountPercent.toString()}%',
                                    overflow: TextOverflow.ellipsis,
                                    style: kStyleNormal.copyWith(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rs',
                                    overflow: TextOverflow.ellipsis,
                                    style: kStyleNormal.copyWith(
                                      color: myColor.primaryColorDark,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    priceAfterDiscount().round().toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: kStyleNormal.copyWith(
                                      color: myColor.primaryColorDark,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            addToCartBtn(context, productModelData,
                                priceAfterDiscount().round().toString());
                          },
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              color: myColor.primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 16.0,
                              color: Colors.white,
                            ),
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
      ));
}

void addToCartBtn(BuildContext context, ProductModelData productModelData,
    priceAfterDiscount) async {
  List<MyCartDatabaseModel> myList = [];
  int userID = int.parse(sharedPrefs.getUserID('userID'));
  print('my user id: $userID');
  myList = await MyDatabase.instance
      .fetchAddedProductFromCart(userID, productModelData.id);
  if (myList.isNotEmpty) {
    mySnackbar.mySnackBar(
        context, 'Already in cart', Colors.black.withOpacity(0.7));
  } else {
    addToCartDatabase(context, productModelData, priceAfterDiscount);
  }
}

void addToCartDatabase(BuildContext context, ProductModelData productModelData,
    priceAfterDiscount) {
  String UserID = sharedPrefs.getUserID('userID');
  var myCart = MyCartDatabaseModel(
    userID: int.parse(UserID.toString()),
    productID: productModelData.id,
    vendorID: productModelData.vendorId,
    productTotalAmount: productModelData.salePrice.toString(),
    productPrice: productModelData.salePrice.toString(),
    sellingPriceAfterDiscount: priceAfterDiscount.toString(),
    totalSellingPriceAfterDiscount: priceAfterDiscount.toString(),
    productName: productModelData.productName.toString(),
    productQuantity: '1',
    discount: productModelData.discountPercent.toString(),
    productUnit: productModelData.unit.toString(),
    productImage: productModelData.imagePath.toString(),
    stock: productModelData.stock.toString(),
  );

  var dbHelper = MyDatabase.instance.addToCartLocalDB(myCart);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Added to cart succesfully',
          style: kStyleNormal.copyWith(color: Colors.white),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              goThere(context, const MyCart());
            },
            child: Text(
              'Go to Cart',
              style: kStyleNormal.copyWith(color: myColor.primaryColorDark),
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.black.withOpacity(0.7),
  ));
}
