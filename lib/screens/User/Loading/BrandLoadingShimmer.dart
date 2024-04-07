import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class BrandLoadingShimmer extends StatefulWidget {
  const BrandLoadingShimmer({Key? key}) : super(key: key);

  @override
  State<BrandLoadingShimmer> createState() => _BrandLoadingShimmerState();
}

class _BrandLoadingShimmerState extends State<BrandLoadingShimmer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth(context),
      height: 60.0,
      child: ListView.builder(
          itemCount: 50,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return Container(
                margin: const EdgeInsets.only(right: 10.0),
                width: 100,
                child: const LoadingShimmer(
                  height: 60,
                  width: 60,
                ));
          })),
    );
  }
}
