import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/Vendor/Category/GetVendorReview.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

Widget reviewsStreamCard(context) {
  ApiHandlerBloc? vendorReviewsBloc;
  StateHandlerBloc? seeMoreBloc;
  seeMoreBloc = StateHandlerBloc();
  vendorReviewsBloc = ApiHandlerBloc();
  List<GetVendorReviewModel> getVendorReviewModel = [];
  vendorReviewsBloc.fetchAPIList('vendor-review?vendor_id=1');
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: StreamBuilder<ApiResponse<dynamic>>(
      stream: vendorReviewsBloc.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return Container(
                width: maxWidth(context),
                height: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const AnimatedLoading(),
              );
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text('no reviews yet'),
                  // child: writeOrReadFeedbackWidget(),
                );
              }
              getVendorReviewModel = List<GetVendorReviewModel>.from(snapshot
                  .data!.data
                  .map((i) => GetVendorReviewModel.fromJson(i)));
              return StreamBuilder<dynamic>(
                  initialData: 3,
                  stream: seeMoreBloc!.stateStream,
                  builder: (context, snapshot) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        color: myColor.dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                countCard('1020', 'Total Reviews'),
                                countCard('😃', '90% Happy Customers'),
                              ],
                            ),
                          ),
                          const SizedBox8(),
                          ListView.builder(
                              itemCount:
                                  getVendorReviewModel.length > snapshot.data
                                      ? snapshot.data
                                      : getVendorReviewModel.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    reviewsCard(
                                        context, getVendorReviewModel[index]),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      width: maxWidth(context),
                                      color: kWhite.withOpacity(0.4),
                                      height: 1.5,
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(
                            height: 5.0,
                          ),
                          getVendorReviewModel.length > snapshot.data
                              ? Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      seeMoreBloc!.storeData(
                                          getVendorReviewModel.length);
                                    },
                                    child: Text(
                                      'See more',
                                      style: kStyleNormal.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                )
                              : getVendorReviewModel.length < snapshot.data
                                  // &&
                                  //         getReviewModel.length ==
                                  //             initialLength
                                  ? Center(
                                      child: Text(
                                        'No more reviews',
                                        style: kStyleNormal.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        seeMoreBloc!.storeData(3);
                                      },
                                      child: Center(
                                        child: Text(
                                          'See less',
                                          style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    );
                  });
            //  Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       '${getVendorReviewModel.length} Reviews',
            //       textAlign: TextAlign.start,
            //       style: kStyleNormal.copyWith(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 13.0,
            //       ),
            //     ),
            //     const SizedBox12(),
            //     ListView.builder(
            //         itemCount: getVendorReviewModel.length > initialLength
            //             ? initialLength
            //             : getVendorReviewModel.length,
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           return reviewsCard(
            //               context, getVendorReviewModel[index]);
            //         }),
            //     const SizedBox(
            //       height: 5.0,
            //     ),
            //     getVendorReviewModel.length > initialLength
            //         ? Center(
            //             child: GestureDetector(
            //               onTap: () {
            //                 // setState(() {
            //                 //   initialLength = getVendorReviewModel.length;
            //                 // });
            //               },
            //               child: Text(
            //                 'See more',
            //                 style: kStyleNormal.copyWith(
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 12.0,
            //                 ),
            //               ),
            //             ),
            //           )
            //         : getVendorReviewModel.length < initialLength
            //             // &&
            //             //         getReviewModel.length ==
            //             //             initialLength
            //             ? Center(
            //                 child: Text(
            //                   'No more reviews',
            //                   style: kStyleNormal.copyWith(
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 12.0,
            //                   ),
            //                 ),
            //               )
            //             : GestureDetector(
            //                 onTap: () {
            //                   // setState(() {
            //                   //   initialLength = 3;
            //                   // });
            //                 },
            //                 child: Center(
            //                   child: Text(
            //                     'See less',
            //                     style: kStyleNormal.copyWith(
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 12.0,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //     const SizedBox12(),
            //     const Text('writeOrReadFeedbackWidget'),
            //     // writeOrReadFeedbackWidget(),
            //   ],
            // );

            case Status.ERROR:
              return Container(
                width: maxWidth(context),
                height: 135.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Server Error'),
                ),
              );
          }
        }
        return SizedBox(
          width: maxWidth(context),
        );
      }),
    ),
  );
}

Widget countCard(value, title) {
  return Column(
    children: [
      Text(
        value,
        style: kStyleNormal.copyWith(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox2(),
      Text(
        title,
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
        ),
      ),
    ],
  );
}

Widget reviewsCard(context, GetVendorReviewModel getReviewModel) {
  double rating = 5;
  return Container(
    width: maxWidth(context),
    decoration: BoxDecoration(
      // color: kWhite.withOpacity(0.4),
      borderRadius: BorderRadius.circular(0.0),
    ),
    margin: const EdgeInsets.only(bottom: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: maxWidth(context),
          padding: const EdgeInsets.fromLTRB(
            12.0,
            10.0,
            12.0,
            0.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myCachedNetworkImage(
                50.0,
                50.0,
                getReviewModel.id.toString(),
                const BorderRadius.all(Radius.circular(8.0)),
                BoxFit.cover,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getReviewModel.user!.name.toString(),
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox8(),
                    Text(
                      getReviewModel.comment.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBar.builder(
                          minRating:
                              double.parse(getReviewModel.rating.toString()),
                          itemBuilder: (context, _) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                          itemCount: 5,
                          initialRating: rating,
                          updateOnDrag: false,
                          itemSize: 12.0,
                          itemPadding: const EdgeInsets.only(right: 2.0),
                          onRatingUpdate: (rating) => () {},
                          // setState(() {
                          //   this.rating = rating;
                          // }),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.4),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          child: Text(
                            getReviewModel.updatedAt
                                .toString()
                                .substring(0, 10),
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
