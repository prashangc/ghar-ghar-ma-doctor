import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/ImageSliderModel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  final List<ImageSliderModel> imageSliderModel;

  const ImageSlider({Key? key, required this.imageSliderModel})
      : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int activeIndex = 0;
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
              height: maxHeight(context) / 4,
              enlargeCenterPage: true,
              autoPlay: true,
              // aspectRatio: 2 / 4,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 400),
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
                _pageController = PageController(initialPage: index);
              }),
          itemCount: widget.imageSliderModel.length,
          itemBuilder: (context, index, realIndex) {
            return SizedBox(
              width: maxWidth(context),
              height: maxHeight(context) / 4,
              child: Stack(
                children: [
                  myCachedNetworkImage(
                    maxWidth(context),
                    maxHeight(context),
                    widget.imageSliderModel[index].imagePath.toString(),
                    const BorderRadius.all(Radius.circular(12)),
                    BoxFit.cover,
                  ),
                  Positioned(
                    child: Container(
                      height: maxHeight(context) / 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              myColor.dialogBackgroundColor.withOpacity(0.3)),
                    ),
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
              ),
            );
          },
        ),
        const SizedBox12(),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.imageSliderModel.length,
          effect: ExpandingDotsEffect(
              dotWidth: 6,
              dotHeight: 6,
              activeDotColor: myColor.primaryColorDark,
              spacing: 8,
              dotColor: myColor.dialogBackgroundColor),
        ),
      ],
    );
  }
}
