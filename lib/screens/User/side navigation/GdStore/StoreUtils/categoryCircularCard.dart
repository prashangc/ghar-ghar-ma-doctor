import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget categoryCard(dynamic data) {
  return GestureDetector(
    onTap: () {
      // goThere(
      //   context,
      //   AllProductsPage(
      //     vendorDetails: vendor,
      //     categoryID: vendorWiseCategoryModel.id,
      //   ),
      // );
    },
    child: Container(
      width: 70.0,
      margin: const EdgeInsets.only(right: 10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: myCachedNetworkImageCircle(
              70.0,
              70.0,
              data.imagePath ?? '',
              BoxFit.cover,
            ),
          ),
          const SizedBox8(),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                data.name.toString(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 12.0),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
