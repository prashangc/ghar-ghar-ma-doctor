import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/IndividualProductPage.dart';

Widget productCardHrz(ProductModelData data, bool showAll, context) {
  double priceAfterDiscount() {
    double discountPercent =
        (double.parse(data.discountPercent.toString()) / 100);
    double sellingPrice = double.parse(data.salePrice.toString());
    double toBeSubstractedValue = discountPercent * sellingPrice;
    double discountedPrice = sellingPrice - toBeSubstractedValue;
    return discountedPrice;
  }

  return GestureDetector(
    onTap: () {
      goThere(
          context,
          IndividualProductPage(
            productModelData: data,
            totalDiscountedPrice: priceAfterDiscount().round().toString(),
          ));
    },
    child: Row(
      children: [
        Container(
          width: 120.0,
          height: 130.0,
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              topLeft: Radius.circular(12.0),
            ),
          ),
          child: myCachedNetworkImage(
            120.0,
            130.0,
            data.imagePath,
            const BorderRadius.only(
              bottomLeft: Radius.circular(12.0),
              topLeft: Radius.circular(12.0),
            ),
            BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              height: 130.0,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.productName.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: kStyleNormal.copyWith(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox2(),
                  const SizedBox2(),
                  Text(
                    'Per ${data.unit.toString()}',
                    overflow: TextOverflow.ellipsis,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox2(),
                  const SizedBox2(),
                  Row(
                    children: [
                      Text(
                        'Rs ${data.salePrice.toString()}',
                        overflow: TextOverflow.ellipsis,
                        style: kStyleNormal.copyWith(
                          fontSize: 10.0,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '- ${data.discountPercent.toString()}%',
                        overflow: TextOverflow.ellipsis,
                        style: kStyleNormal.copyWith(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RatingBar.builder(
                          itemCount: 5,
                          itemBuilder: (context, _) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                          initialRating: 2.2,
                          updateOnDrag: false,
                          itemSize: 13.0,
                          itemPadding: const EdgeInsets.only(right: 2.0),
                          onRatingUpdate: (rating) => () {}
                          // setState(() {
                          //   rating = rating;
                          // }),
                          ),
                      showAll == false
                          ? Container()
                          : Row(
                              children: [
                                Text(
                                  '${data.averageRating.toString()}/5',
                                  style: kStyleNormal.copyWith(fontSize: 11.0),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '(${data.totalReviews.toString()} Reviews)',
                                  style: kStyleNormal.copyWith(fontSize: 10.0),
                                ),
                              ],
                            ),
                    ],
                  ),
                  // const SizedBox2(),
                  // const SizedBox2(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
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
                      ),
                      showAll == false
                          ? Container()
                          : GestureDetector(
                              onTap: () {},
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
              )),
        )
      ],
    ),
  );
}
