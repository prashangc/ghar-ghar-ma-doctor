import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

import '../../../widgets/widgets_import.dart';

class ChooseTimeLoadingShimmer extends StatelessWidget {
  const ChooseTimeLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth(context),
      height: 40,
      child: ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
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
