import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GlobalForm/GlobalForm.dart';

Widget fillGlobalForm(context, text) {
  return GestureDetector(
    onTap: () {
      goThere(context, const GlobalForm());
    },
    child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 205, 202),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
          border: Border.all(color: kRed, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline_outlined, size: 17.0, color: kRed),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    text,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox8(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      'Fill Now',
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: kRed,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_outlined,
                      color: kRed,
                    ),
                  ],
                ),
              ],
            ),
          ],
        )),
  );
}
