import 'package:flutter/material.dart';

import '../../../widgets/widgets_import.dart';

class GenderLoadingShimmer extends StatelessWidget {
  const GenderLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: const LoadingShimmer(
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
