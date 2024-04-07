import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/LabServices/IndividualLabDetails.dart';

Widget labTestCard(context, Labtests data) {
  return GestureDetector(
    onTap: () {
      goThere(
          context,
          IndividualLabDetails(
            labtests: data,
          ));
    },
    child: Container(
        width: 160.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        // margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox12(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  40.0,
                  40.0,
                  'dynamic myImage',
                  const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  BoxFit.cover,
                ),
                const SizedBox8(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.tests.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox8(),
            Text(
              'Rs ${data.price.toString()}',
              style: kStyleNormal.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: myColor.primaryColorDark,
              ),
            ),
            const SizedBox8(),
            SizedBox(
              width: maxWidth(context),
              child: myCustomButton(
                context,
                myColor.primaryColorDark,
                'Book',
                kStyleNormal.copyWith(
                  fontSize: 12.0,
                  color: kWhite,
                ),
                () {
                  goThere(
                      context,
                      IndividualLabDetails(
                        labtests: data,
                      ));
                },
              ),
            )
          ],
        )),
  );
}
