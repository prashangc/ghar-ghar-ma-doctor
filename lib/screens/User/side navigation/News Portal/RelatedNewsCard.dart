import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget relatedNewsCard(BuildContext context, myImage) {
  return GestureDetector(
    onTap: () {
      // goThere(context, const IndividualNewsDetails());
    },
    child: Container(
      width: maxWidth(context),
      height: 100.0,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              margin: const EdgeInsets.only(right: 10.0),
              child: myCachedNetworkImage(
                  maxWidth(context),
                  maxHeight(context),
                  myImage,
                  const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        'Those above 60, immuno compromised, health workers to get second booster shots',
                        // textAlign: Te9xtAlign.justify,
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'By Rajesh Kandel',
                          textAlign: TextAlign.justify,
                          style: kStyleNormal.copyWith(
                            fontSize: 12.0,
                            color: myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              color: myColor.primaryColorDark.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4)),
                          margin: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: myColor.primaryColorDark,
                                size: 12.0,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                'Today',
                                textAlign: TextAlign.justify,
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
