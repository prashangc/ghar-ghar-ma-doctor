import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCircleShimmer extends StatelessWidget {
  final double? height, width;
  const LoadingCircleShimmer({Key? key, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: myColor.dialogBackgroundColor,
      baseColor: kWhite,
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  final double? height, width;
  const LoadingShimmer({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kWhite,
      highlightColor: myColor.dialogBackgroundColor,
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
