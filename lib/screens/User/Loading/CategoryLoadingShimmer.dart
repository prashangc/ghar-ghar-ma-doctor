import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class CategoryLoadingShimmer extends StatelessWidget {
  const CategoryLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth(context),
      height: 23.0,
      child: ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: const LoadingShimmer(
                  width: 100,
                ),
              ),
            );
          }),
    );
  }
}
