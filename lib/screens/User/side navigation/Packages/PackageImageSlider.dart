import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';

class PackageImageSlider extends StatefulWidget {
  final List<PackageImageSliderModel> imageSliderModel;

  const PackageImageSlider({Key? key, required this.imageSliderModel})
      : super(key: key);

  @override
  State<PackageImageSlider> createState() => _PackageImageSliderState();
}

class _PackageImageSliderState extends State<PackageImageSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
          height: maxHeight(context) / 4,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 400),
          viewportFraction: 0.85,
          onPageChanged: (index, reason) {
            setState(() {
              activeIndex = index;
            });
          }),
      itemCount: widget.imageSliderModel.length,
      itemBuilder: (context, index, realIndex) {
        return Stack(
          children: [
            myCachedNetworkImage(
              maxWidth(context),
              maxHeight(context) / 4,
              widget.imageSliderModel[index].imagePath.toString(),
              const BorderRadius.all(Radius.circular(12)),
              BoxFit.cover,
            ),
            Positioned(
              left: 14,
              right: 14,
              top: 23,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.imageSliderModel[index].bannerTitle.toString(),
                    style: kStyleTitle2.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.imageSliderModel[index].bannerBody.toString(),
                    style: kStyleNormal.copyWith(
                      color: kWhite,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
