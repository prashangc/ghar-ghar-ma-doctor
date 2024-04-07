import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget infoCard(context, bgColor, borderColor, text) {
  return Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_outlined, size: 17.0, color: borderColor),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.clip,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ));
}
