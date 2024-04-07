import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

Widget storeLoading(context) {
  return Container(
      width: maxWidth(context),
      height: maxHeight(context) / 4,
      decoration: BoxDecoration(
        color: kTransparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const AnimatedLoading());
}
