import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyOrdersModel.dart';

Widget orderProductCard(Products myProducts) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12.0),
    padding: const EdgeInsets.only(left: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myCachedNetworkImage(
          60.0,
          60.0,
          myProducts.imagePath.toString(),
          const BorderRadius.all(
            Radius.circular(8.0),
          ),
          BoxFit.cover,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                myProducts.productName.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: kStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox2(),
              const SizedBox2(),
              Text(
                'Price/${myProducts.unit.toString()}: Rs ${myProducts.salePrice.toString()}',
                style: kStyleNormal.copyWith(
                  // fontWeight: FontWeight.bold,
                  fontSize: 11.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox2(),
              const SizedBox2(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (double.parse(myProducts.salePrice.toString()) *
                            double.parse(myProducts.pivot!.quantity.toString()))
                        .toString(),
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    'X ${myProducts.pivot!.quantity.toString()}',
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    ),
  );
}
