import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget vendorAdvertisementSlider(BuildContext context) {
  return CarouselSlider.builder(
    options: CarouselOptions(
        height: maxHeight(context) / 4,
        // enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 600),
        viewportFraction: 1,
        onPageChanged: (index, reason) {}),
    itemCount: 1,
    itemBuilder: (context, index, realIndex) {
      return Container(
        // margin: const EdgeInsets.symmetric(horizontal: 12.0),
        width: maxWidth(context),
        height: maxHeight(context) / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: myColor.dialogBackgroundColor,
          image: const DecorationImage(
            image: NetworkImage(
                'https://www.najmc.com/wp-content/uploads/2020/08/ecommerce-marketing.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        // child: Image.asset('assets/prevention.png'),
      );
    },
  );
}
