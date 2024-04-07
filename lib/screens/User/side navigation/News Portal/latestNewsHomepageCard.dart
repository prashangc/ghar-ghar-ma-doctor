import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/News%20Portal/IndividualNewsDetails.dart';

Widget latestNewsHomepageCard(
    BuildContext context, NewsData newsData, List<NewsData> newsList) {
  return GestureDetector(
    onTap: () {
      goThere(
          context,
          IndividualNewsDetails(
            news: newsData,
            newsList: newsList,
            popCount: 1,
          ));
    },
    child: Container(
      width: maxWidth(context),
      height: 100.0,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
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
                  newsData.imagePath.toString(),
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
                      width: maxWidth(context),
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        newsData.titleEn.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //   Html(
                      //     data: newsData.descriptionEn.toString(),
                      //     style: {
                      //       "*": Style(
                      //         fontSize: FontSize(14.0),
                      //         fontFamily: 'Futura',
                      //         textAlign: TextAlign.justify,
                      //         lineHeight: const LineHeight(1.5),
                      //       ),
                      //     },
                      //   ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          newsData.user == null
                              ? 'Ghargharma Doctor'
                              : newsData.user!.name.toString(),
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
                              color: myColor.dialogBackgroundColor
                                  .withOpacity(0.4),
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
                                newsData.createdAt.toString().substring(0, 10),
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
