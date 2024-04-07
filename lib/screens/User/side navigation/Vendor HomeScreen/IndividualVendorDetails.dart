// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:ghargharmadoctor/api/api_imports.dart';
// import 'package:ghargharmadoctor/constants/constants_imports.dart';
// import 'package:ghargharmadoctor/models/Vendor/Category/GetVendorReview.dart';
// import 'package:ghargharmadoctor/models/models.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/productCard.dart';
// import 'package:ghargharmadoctor/widgets/widgets_import.dart';

// enum ButtonState { init, loading, done }

// class IndividualVendorDetails extends StatefulWidget {
//   final VendorDetails vendorDetails;
//   const IndividualVendorDetails({Key? key, required this.vendorDetails})
//       : super(key: key);

//   @override
//   State<IndividualVendorDetails> createState() =>
//       _IndividualVendorDetailsState();
// }

// class _IndividualVendorDetailsState extends State<IndividualVendorDetails> {
//   ButtonState state = ButtonState.init;
//   double rating = 5;
//   int initialLength = 3;
//   String ratingsText = 'Excellent';
//   String? token;
//   int activeIndex = 0;
//   final TextEditingController _reviewController = TextEditingController();
//   final TextEditingController _myController = TextEditingController();
//   ApiHandlerBloc? imageSliderBloc,
//       vendorWiseCategoryBloc,
//       latestProductBloc,
//       vendorReviewsBloc,
//       checkFollowBloc;
//   List<ImageSliderModel> imageSliderModel = [];
//   List<VendorWiseCategoryModel> vendorWiseCategoryModel = [];
//   List<GetVendorReviewModel> getVendorReviewModel = [];
//   ProductModel? productModel;
//   FollowersCheckModel? followersCheckModel;

//   @override
//   void initState() {
//     super.initState();
//     token = sharedPrefs.getFromDevice('token');
//     getDataFromAPI();
//     vendorReviewsBloc = ApiHandlerBloc();
//     checkFollowBloc = ApiHandlerBloc();
//     checkFollowBloc!
//         .fetchAPIList('isFollowed?vendor_id=${widget.vendorDetails.id}');

//     _refreshVendorReviews();
//   }

//   void _refreshVendorReviews() {
//     vendorReviewsBloc!.fetchAPIList(
//         'vendor-review?vendor_id=${widget.vendorDetails.id.toString()}');
//   }

//   Future getDataFromAPI() async {
//     imageSliderBloc = ApiHandlerBloc();
//     imageSliderBloc!.fetchAPIList(
//         'vendor-slider?vendor_type=${widget.vendorDetails.vendorId.toString()}');
//     vendorWiseCategoryBloc = ApiHandlerBloc();
//     print(
//         '{widget.vendorDetails.id.toString()} ${widget.vendorDetails.id.toString()}');

//     vendorWiseCategoryBloc!.fetchAPIList(
//         'categories/vendortype?vendor_type_id=${widget.vendorDetails.vendorType.toString()}');
//     latestProductBloc = ApiHandlerBloc();
//     latestProductBloc!.fetchAPIList(
//         'products?vendor_id=${widget.vendorDetails.id.toString()}&latest=desc');
//   }

//   void followBtn() async {
//     int statusCode;
//     statusCode = await API().postData(
//         context,
//         FollowVendorModel(vendorId: widget.vendorDetails.id),
//         endpoints.postVendorFollowEndpoint);
//     if (statusCode == 200) {
//       setState(() {
//         checkFollowBloc!
//             .fetchAPIList('isFollowed?vendor_id=${widget.vendorDetails.id}');
//       });
//     } else {
//       mySnackbar.mySnackBar(
//           context, 'Unable to follow this vendor $statusCode', Colors.red);
//     }
//   }

//   void submitReviewBtn() async {
//     int statusCode;
//     if (_reviewController.text.toString().isEmpty) {
//       print("is empty");
//       myToast.toast('empty');
//     } else {
//       statusCode = await API().postData(
//         context,
//         PostVendorReview(
//           vendorId: widget.vendorDetails.id,
//           comment: _reviewController.text.toString(),
//           rating: rating.toString().substring(0, 1),
//         ),
//         endpoints.postVendorReviewEndpoint,
//       );
//       if (statusCode == 200) {
//         Navigator.pop(context);
//         _refreshVendorReviews();
//         setState(() {});
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: myCustomAppBar(
//         title: widget.vendorDetails.user!.name.toString(),
//         color: myColor.dialogBackgroundColor,
//         borderRadius: 0.0,
//       ),
//       body: Column(
//         children: [
//           Container(
//             width: maxWidth(context),
//             decoration: BoxDecoration(
//               color: myColor.dialogBackgroundColor,
//               borderRadius: const BorderRadius.only(
//                 bottomRight: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//               ),
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 // goThere(
//                 //   context,
//                 //   AllProductsPage(vendorDetails: widget.vendorDetails),
//                 // );
//               },
//               child: Container(
//                   margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
//                   width: maxWidth(context),
//                   decoration: BoxDecoration(
//                     color: myColor.scaffoldBackgroundColor,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   height: 55.0,
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 10.0),
//                       Icon(
//                         Icons.search,
//                         size: 18,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(width: 12.0),
//                       Expanded(
//                         child: Text(
//                           'Search in Store',
//                           style: kStyleNormal.copyWith(
//                               fontSize: 14.0, color: Colors.grey[400]),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           goThere(context, const MyCart());
//                         },
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: myColor.primaryColorDark,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Icon(
//                             Icons.shopping_cart,
//                             color: myColor.scaffoldBackgroundColor,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10.0),
//                     ],
//                   )),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0, vertical: 10.0),
//                 child: Column(
//                   children: [
//                     StreamBuilder<ApiResponse<dynamic>>(
//                       stream: imageSliderBloc!.apiListStream,
//                       builder: ((context, snapshot) {
//                         if (snapshot.hasData) {
//                           switch (snapshot.data!.status) {
//                             case Status.LOADING:
//                               return Container(
//                                 width: maxWidth(context),
//                                 height: 135.0,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const AnimatedLoading(),
//                               );
//                             case Status.COMPLETED:
//                               if (snapshot.data!.data.isEmpty) {
//                                 return Container(
//                                     height: 135.0,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Center(
//                                         child: Text('No images added')));
//                               }
//                               imageSliderModel = List<ImageSliderModel>.from(
//                                   snapshot.data!.data.map(
//                                       (i) => ImageSliderModel.fromJson(i)));
//                               return vendorAdvertisementSlider(
//                                   context, imageSliderModel);
//                             case Status.ERROR:
//                               return Container(
//                                 width: maxWidth(context),
//                                 height: 135.0,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Center(
//                                   child: Text('Server Error'),
//                                 ),
//                               );
//                           }
//                         }
//                         return SizedBox(
//                           width: maxWidth(context),
//                         );
//                       }),
//                     ),
//                     const SizedBox16(),
//                     widget.vendorDetails.vendorType == 2
//                         ? Column(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 50.0),
//                                 width: maxWidth(context),
//                                 height: 45,
//                                 child: myCustomButton(
//                                     context,
//                                     myColor.primaryColorDark,
//                                     'Upload Prescription',
//                                     kStyleNormal.copyWith(
//                                       fontSize: 15.0,
//                                       color: Colors.white,
//                                     ),
//                                     () {}),
//                               ),
//                               const SizedBox24(),
//                             ],
//                           )
//                         : Container(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       width: maxWidth(context),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           const SizedBox8(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Categories',
//                                 style: kStyleNormal.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {},
//                                 child: Icon(
//                                   Icons.keyboard_arrow_right,
//                                   size: 28.0,
//                                   color: myColor.primaryColorDark,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox16(),
//                           StreamBuilder<ApiResponse<dynamic>>(
//                             stream: vendorWiseCategoryBloc!.apiListStream,
//                             builder: ((context, snapshot) {
//                               if (snapshot.hasData) {
//                                 switch (snapshot.data!.status) {
//                                   case Status.LOADING:
//                                     return Container(
//                                       width: maxWidth(context),
//                                       height: 110.0,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: const AnimatedLoading(),
//                                     );
//                                   case Status.COMPLETED:
//                                     if (snapshot.data!.data.isEmpty) {
//                                       return Container(
//                                           width: maxWidth(context),
//                                           height: 110.0,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           child: const Center(
//                                               child:
//                                                   Text('No categories added')));
//                                     }
//                                     vendorWiseCategoryModel =
//                                         List<VendorWiseCategoryModel>.from(
//                                             snapshot.data!.data.map((i) =>
//                                                 VendorWiseCategoryModel
//                                                     .fromJson(i)));
//                                     return SizedBox(
//                                       width: maxWidth(context),
//                                       height: 110.0,
//                                       child: ListView.builder(
//                                           shrinkWrap: true,
//                                           itemCount:
//                                               vendorWiseCategoryModel.length,
//                                           scrollDirection: Axis.horizontal,
//                                           itemBuilder: (ctx, i) {
//                                             return categoryData(
//                                               vendorWiseCategoryModel[i],
//                                               widget.vendorDetails,
//                                             );
//                                           }),
//                                     );
//                                   // CarouselSlider.builder(
//                                   //   options: CarouselOptions(
//                                   //       // height: 130,
//                                   //       // enlargeCenterPage: true,
//                                   //       // autoPlay: true,
//                                   //       // aspectRatio: 16 / 9,
//                                   //       // autoPlayCurve: Curves.fastOutSlowIn,
//                                   //       // enableInfiniteScroll: true,
//                                   //       autoPlayAnimationDuration:
//                                   //           const Duration(milliseconds: 600),
//                                   //       viewportFraction: 1,
//                                   //       onPageChanged: (index, reason) {
//                                   //         setState(() {
//                                   //           activeIndex = index;

//                                   //           print(activeIndex);
//                                   //         });
//                                   //       }),
//                                   //   itemCount: vendorWiseCategoryModel.length,
//                                   //   itemBuilder: (context, index, realIndex) {
//                                   //     return Container(
//                                   //       color: Colors.amber,
//                                   //       width: maxWidth(context),
//                                   //       height: 400.0,
//                                   //       child: ListView.builder(
//                                   //           itemCount: vendorWiseCategoryModel
//                                   //                       .length >
//                                   //                   4
//                                   //               ? vendorWiseCategoryModel
//                                   //                   .length
//                                   //               : 4,
//                                   //           scrollDirection: Axis.horizontal,
//                                   //           physics:
//                                   //               const NeverScrollableScrollPhysics(),
//                                   //           shrinkWrap: true,
//                                   //           itemBuilder: (ctx, i) {
//                                   //             return Container(
//                                   //               width:
//                                   //                   (maxWidth(context) - 62) /
//                                   //                       4,
//                                   //               margin: const EdgeInsets.only(
//                                   //                   right: 6.0),
//                                   //               color: Colors.red,
//                                   //               child: Row(
//                                   //                 children: [
//                                   //                   Text(
//                                   //                     vendorWiseCategoryModel[
//                                   //                             i]
//                                   //                         .name
//                                   //                         .toString(),
//                                   //                   ),
//                                   //                 ],
//                                   //               ),
//                                   //             );
//                                   //           }),
//                                   //     );
//                                   //   },
//                                   // );

//                                   case Status.ERROR:
//                                     return Container(
//                                       width: maxWidth(context),
//                                       height: 110.0,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: const Center(
//                                         child: Text('Server Error'),
//                                       ),
//                                     );
//                                 }
//                               }
//                               return SizedBox(
//                                 width: maxWidth(context),
//                               );
//                             }),
//                           ),
//                           const SizedBox16(),
//                         ],
//                       ),
//                     ),
//                     const SizedBox16(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                       width: maxWidth(context),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         children: [
//                           const SizedBox8(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Latest Product',
//                                 style: kStyleNormal.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   // swipeTo(
//                                   //     context,
//                                   //     AllProductsPage(
//                                   //       isLatest: true,
//                                   //       vendorDetails: widget.vendorDetails,
//                                   //     ));
//                                 },
//                                 child: Icon(
//                                   Icons.keyboard_arrow_right,
//                                   size: 28.0,
//                                   color: myColor.primaryColorDark,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox16(),
//                           StreamBuilder<ApiResponse<dynamic>>(
//                             stream: latestProductBloc!.apiListStream,
//                             builder: ((context, snapshot) {
//                               if (snapshot.hasData) {
//                                 switch (snapshot.data!.status) {
//                                   case Status.LOADING:
//                                     return Container(
//                                       width: maxWidth(context),
//                                       height: 200.0,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: const AnimatedLoading(),
//                                     );
//                                   case Status.COMPLETED:
//                                     productModel = ProductModel.fromJson(
//                                         snapshot.data!.data);

//                                     if (productModel!.data!.isEmpty) {
//                                       return Container(
//                                           width: maxWidth(context),
//                                           height: 200,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           child: const Center(
//                                               child: Text(
//                                                   'No latest product added')));
//                                     }
//                                     return SizedBox(
//                                       width: maxWidth(context),
//                                       height: 230.0,
//                                       child: ListView.builder(
//                                           shrinkWrap: true,
//                                           physics:
//                                               const BouncingScrollPhysics(),
//                                           scrollDirection: Axis.horizontal,
//                                           itemCount: productModel!.data!.length,
//                                           itemBuilder: (ctx, i) {
//                                             return productCard(
//                                               context,
//                                               productModel!.data![i],
//                                               setState,
//                                               myColor.dialogBackgroundColor
//                                                   .withOpacity(0.3),
//                                               12.0,
//                                             );
//                                           }),
//                                     );

//                                   case Status.ERROR:
//                                     return Container(
//                                       width: maxWidth(context),
//                                       height: 210.0,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: const Center(
//                                         child: Text('Server Error'),
//                                       ),
//                                     );
//                                 }
//                               }
//                               return SizedBox(
//                                 width: maxWidth(context),
//                               );
//                             }),
//                           ),
//                           const SizedBox16(),
//                         ],
//                       ),
//                     ),
//                     const SizedBox16(),

//                     StreamBuilder<ApiResponse<dynamic>>(
//                       stream: vendorReviewsBloc!.apiListStream,
//                       builder: ((context, snapshot) {
//                         if (snapshot.hasData) {
//                           switch (snapshot.data!.status) {
//                             case Status.LOADING:
//                               return Container(
//                                 width: maxWidth(context),
//                                 height: 120.0,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const AnimatedLoading(),
//                               );
//                             case Status.COMPLETED:
//                               if (snapshot.data!.data.isEmpty) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(top: 10.0),
//                                   child: writeOrReadFeedbackWidget(),
//                                 );
//                               }
//                               getVendorReviewModel =
//                                   List<GetVendorReviewModel>.from(
//                                       snapshot.data!.data.map((i) =>
//                                           GetVendorReviewModel.fromJson(i)));
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     '${getVendorReviewModel.length} Reviews',
//                                     textAlign: TextAlign.start,
//                                     style: kStyleNormal.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 13.0,
//                                     ),
//                                   ),
//                                   const SizedBox12(),
//                                   ListView.builder(
//                                       itemCount: getVendorReviewModel.length >
//                                               initialLength
//                                           ? initialLength
//                                           : getVendorReviewModel.length,
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         return reviewsCard(
//                                             getVendorReviewModel[index]);
//                                       }),
//                                   const SizedBox(
//                                     height: 5.0,
//                                   ),
//                                   getVendorReviewModel.length > initialLength
//                                       ? Center(
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 initialLength =
//                                                     getVendorReviewModel.length;
//                                               });
//                                             },
//                                             child: Text(
//                                               'See more',
//                                               style: kStyleNormal.copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12.0,
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                       : getVendorReviewModel.length <
//                                               initialLength
//                                           // &&
//                                           //         getReviewModel.length ==
//                                           //             initialLength
//                                           ? Center(
//                                               child: Text(
//                                                 'No more reviews',
//                                                 style: kStyleNormal.copyWith(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             )
//                                           : GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   initialLength = 3;
//                                                 });
//                                               },
//                                               child: Center(
//                                                 child: Text(
//                                                   'See less',
//                                                   style: kStyleNormal.copyWith(
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                   const SizedBox12(),
//                                   writeOrReadFeedbackWidget(),
//                                 ],
//                               );
//                             case Status.ERROR:
//                               return Container(
//                                 width: maxWidth(context),
//                                 height: 135.0,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Center(
//                                   child: Text('Server Error'),
//                                 ),
//                               );
//                           }
//                         }
//                         return SizedBox(
//                           width: maxWidth(context),
//                         );
//                       }),
//                     ),

//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //   children: [
//                     //     Text(
//                     //       'Stores Nearby',
//                     //       style: kStyleNormal.copyWith(
//                     //         fontWeight: FontWeight.bold,
//                     //         fontSize: 16.0,
//                     //       ),
//                     //     ),
//                     //     Text(
//                     //       'See all',
//                     //       style: kStyleNormal.copyWith(
//                     //           fontWeight: FontWeight.bold,
//                     //           fontSize: 15.0,
//                     //           color: myColor.primaryColorDark),
//                     //     ),
//                     //   ],
//                     // ),
//                     // const SizedBox12(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 135.0,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(25),
//             topLeft: Radius.circular(25),
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//         child: Column(
//           children: [
//             const SizedBox16(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: myColor.primaryColorDark,
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: const Icon(
//                     FontAwesomeIcons.shop,
//                     size: 16.0,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 12.0,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             widget.vendorDetails.user!.name.toString(),
//                             style: kStyleNormal.copyWith(
//                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.person,
//                                 size: 16.0,
//                                 color: myColor.primaryColorDark,
//                               ),
//                               const SizedBox(width: 5.0),
//                               Text(
//                                 widget.vendorDetails.followerCount.toString(),
//                                 style: kStyleNormal.copyWith(
//                                   fontSize: 12.0,
//                                   color: myColor.primaryColorDark,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox2(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           RatingBar.builder(
//                             minRating: 5,
//                             itemBuilder: (context, _) {
//                               return const Icon(
//                                 Icons.star,
//                                 color: Color.fromRGBO(255, 193, 7, 1),
//                                 size: 2.0,
//                               );
//                             },
//                             itemCount: 5,
//                             initialRating: rating,
//                             updateOnDrag: true,
//                             itemSize: 20.0,
//                             itemPadding: const EdgeInsets.only(right: 2.0),
//                             onRatingUpdate: (rating) => setState(() {
//                               this.rating = rating;
//                             }),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showModalBottomSheet(
//                                 context: context,
//                                 backgroundColor: backgroundColor,
//                                 isScrollControlled: true,
//                                 shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(20))),
//                                 builder: ((builder) => addReviewBottomSheet()),
//                               );
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.add,
//                                   color: myColor.primaryColorDark,
//                                   size: 16.0,
//                                 ),
//                                 const SizedBox(width: 4.0),
//                                 Text(
//                                   'Add Reviews',
//                                   style: kStyleNormal.copyWith(
//                                     color: myColor.primaryColorDark,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13.0,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox2(),
//             const Divider(),
//             const SizedBox2(),
//             Row(
//               children: [
//                 Expanded(
//                     flex: 1,
//                     child: token == null
//                         ? GestureDetector(
//                             onTap: () {
//                               showLoginPopUp(context);
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 border: Border.all(
//                                     color: myColor.primaryColorDark,
//                                     width: 1.0),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               height: 45,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Follow',
//                                     style: kStyleNormal.copyWith(
//                                       color: myColor.primaryColorDark,
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : followBtnWidget()),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     height: 45,
//                     child: myCustomButton(
//                         context,
//                         myColor.primaryColorDark,
//                         'See all',
//                         kStyleNormal.copyWith(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                           letterSpacing: 1.0,
//                           fontWeight: FontWeight.bold,
//                         ), () {
//                       // goThere(
//                       //   context,
//                       //   AllProductsPage(vendorDetails: widget.vendorDetails),
//                       // );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget writeOrReadFeedbackWidget() {
//     return Row(
//       children: [
//         SizedBox(
//           width: maxWidth(context) / 2 - 15,
//           height: 50.0,
//           child: myWhiteButton(
//             context,
//             Colors.white,
//             'Write Feedback',
//             kStyleNormal.copyWith(
//               color: myColor.primaryColorDark,
//               fontWeight: FontWeight.bold,
//               fontSize: 14.0,
//             ),
//             () {
//               showModalBottomSheet(
//                 context: context,
//                 backgroundColor: backgroundColor,
//                 isScrollControlled: true,
//                 shape: const RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(20))),
//                 builder: ((builder) => addReviewBottomSheet()),
//               );
//             },
//           ),
//         ),
//         const SizedBox(width: 6.0),
//         Expanded(
//           child: SizedBox(
//             height: 50.0,
//             child: myWhiteButton(
//               context,
//               Colors.white,
//               'Read All Feedbacks',
//               kStyleNormal.copyWith(
//                 color: myColor.primaryColorDark,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.0,
//               ),
//               () {},
//             ),
//           ),
//         ),
//         const SizedBox(width: 6.0),
//       ],
//     );
//   }

//   Widget reviewsCard(GetVendorReviewModel getReviewModel) {
//     return Container(
//       width: maxWidth(context),
//       decoration: BoxDecoration(
//         color: myColor.dialogBackgroundColor,
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       margin: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: maxWidth(context),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 myCachedNetworkImage(
//                   50.0,
//                   50.0,
//                   getReviewModel.id.toString(),
//                   const BorderRadius.all(Radius.circular(8.0)),
//                   BoxFit.cover,
//                 ),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         getReviewModel.user!.name.toString(),
//                         style: kStyleNormal.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox8(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               RatingBar.builder(
//                                 minRating: 1,
//                                 itemBuilder: (context, _) {
//                                   return const Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                   );
//                                 },
//                                 itemCount: 1,
//                                 initialRating: rating,
//                                 updateOnDrag: true,
//                                 itemSize: 20.0,
//                                 itemPadding: const EdgeInsets.only(right: 2.0),
//                                 onRatingUpdate: (rating) => setState(() {
//                                   this.rating = rating;
//                                 }),
//                               ),
//                               const SizedBox(
//                                 width: 6.0,
//                               ),
//                               Text(
//                                 getReviewModel.rating.toString(),
//                                 style: kStyleNormal,
//                               ),
//                             ],
//                           ),
//                           Text(
//                             getReviewModel.updatedAt
//                                 .toString()
//                                 .substring(0, 10),
//                             style: kStyleNormal,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: Text(
//               getReviewModel.comment.toString(),
//               style: kStyleNormal.copyWith(
//                 fontSize: 12.0,
//               ),
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.justify,
//             ),
//           ),
//           const SizedBox12(),
//         ],
//       ),
//     );
//   }

//   Widget addReviewBottomSheet() {
//     return StatefulBuilder(builder: (context, setState) {
//       return GestureDetector(
//         onTap: () {
//           myfocusRemover(context);
//         },
//         child: Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const SizedBox12(),
//                   Text(
//                     'Give Ratings',
//                     style: kStyleNormal.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13.0,
//                     ),
//                   ),
//                   Container(
//                     width: maxWidth(context),
//                     padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             RatingBar.builder(
//                                 minRating: 1,
//                                 itemBuilder: (context, _) {
//                                   return const Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                   );
//                                 },
//                                 initialRating: rating,
//                                 updateOnDrag: true,
//                                 itemSize: 30.0,
//                                 itemPadding: const EdgeInsets.only(right: 5),
//                                 onRatingUpdate: (newRatingValue) {
//                                   setState(() {
//                                     rating = newRatingValue;
//                                     rating == 1
//                                         ? ratingsText = 'Satisfactory'
//                                         : rating == 2
//                                             ? ratingsText = 'Good'
//                                             : rating == 3
//                                                 ? ratingsText = 'Average'
//                                                 : rating == 4
//                                                     ? ratingsText = 'Best'
//                                                     : rating == 5
//                                                         ? ratingsText =
//                                                             'Excellent'
//                                                         : 'Excellent';
//                                   });
//                                 }),
//                             const SizedBox(width: 10.0),
//                             Text(
//                               '${rating.toString()}  ( $ratingsText )',
//                               style: kStyleNormal.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13.0,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox12(),
//                   Text(
//                     'Write a Review',
//                     style: kStyleNormal.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13.0,
//                     ),
//                   ),
//                   const SizedBox12(),
//                   Container(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom / 1.4),
//                     width: maxWidth(context),
//                     child: TextField(
//                       controller: _reviewController,
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 10.0, vertical: 8.0),
//                         filled: true,
//                         fillColor: Colors.white,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                           borderSide:
//                               const BorderSide(color: Colors.white, width: 0.0),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                           borderSide: BorderSide(
//                               color: myColor.primaryColorDark, width: 1.5),
//                         ),
//                         hintText:
//                             'Would you like to write anything about this product?',
//                         hintStyle: kStyleNormal.copyWith(
//                             fontSize: 12.0, color: Colors.grey[400]),
//                       ),
//                     ),
//                   ),
//                   const SizedBox32(),
//                   SizedBox(
//                     width: maxWidth(context),
//                     height: 50.0,
//                     child: myCustomButton(
//                       context,
//                       myColor.primaryColorDark,
//                       'Submit Review',
//                       kStyleNormal.copyWith(
//                           color: Colors.white, fontSize: 14.0),
//                       () {
//                         submitReviewBtn();
//                       },
//                     ),
//                   ),
//                   const SizedBox12(),
//                 ])),
//       );
//     });
//   }

//   Widget vendorAdvertisementSlider(
//       BuildContext context, @required List<ImageSliderModel> imageSliderModel) {
//     return CarouselSlider.builder(
//       options: CarouselOptions(
//           height: 130,
//           // enlargeCenterPage: true,
//           autoPlay: true,
//           aspectRatio: 16 / 9,
//           autoPlayCurve: Curves.fastOutSlowIn,
//           enableInfiniteScroll: true,
//           autoPlayAnimationDuration: const Duration(milliseconds: 600),
//           viewportFraction: 1,
//           onPageChanged: (index, reason) {
//             setState(() {
//               activeIndex = index;
//             });
//           }),
//       itemCount: imageSliderModel.length,
//       itemBuilder: (context, index, realIndex) {
//         return Stack(
//           children: [
//             Container(
//               height: 140,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 image: DecorationImage(
//                   image: NetworkImage(
//                       imageSliderModel[index].imagePath.toString()),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 0,
//               child: Container(
//                 width: maxWidth(context) / 2,
//                 height: 130,
//                 decoration: const BoxDecoration(
//                   // color: Colors.red,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     bottomLeft: Radius.circular(20),
//                     topRight: Radius.circular(12),
//                     bottomRight: Radius.circular(12),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }

//   Widget loadingIconWidget(bool isDone) {
//     final color = isDone ? myColor.primaryColorDark : Colors.white;
//     return CircleAvatar(
//       backgroundColor: Colors.white,
//       radius: 10.0,
//       child: isDone
//           ? Icon(
//               Icons.check,
//               size: 20.0,
//               color: myColor.primaryColorDark,
//             )
//           : CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 8.0,
//               child: CircularProgressIndicator(
//                 strokeWidth: 1.0,
//                 color: myColor.primaryColorDark,
//                 backgroundColor: myColor.dialogBackgroundColor,
//               ),
//             ),
//     );
//   }

//   Widget categoryData(
//       VendorWiseCategoryModel vendorWiseCategoryModel, VendorDetails vendor) {
//     return GestureDetector(
//       onTap: () {
//         // goThere(
//         //   context,
//         //   AllProductsPage(
//         //     vendorDetails: vendor,
//         //     categoryID: vendorWiseCategoryModel.id,
//         //   ),
//         // );
//       },
//       child: Container(
//         width: 70.0,
//         margin: const EdgeInsets.only(right: 10.0),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(
//             Radius.circular(8.0),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 2,
//               child: myCachedNetworkImageCircle(
//                 70.0,
//                 70.0,
//                 vendorWiseCategoryModel.imagePath,
//                 BoxFit.cover,
//               ),
//             ),
//             const SizedBox8(),
//             Expanded(
//               flex: 1,
//               child: Text(
//                 vendorWiseCategoryModel.name.toString(),
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: kStyleNormal.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget followBtnWidget() {
//     return StreamBuilder<ApiResponse<dynamic>>(
//       stream: checkFollowBloc!.apiListStream,
//       builder: ((context, snapshot) {
//         if (snapshot.hasData) {
//           switch (snapshot.data!.status) {
//             case Status.LOADING:
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border:
//                       Border.all(color: myColor.primaryColorDark, width: 1.0),
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 height: 45,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Loading',
//                       style: kStyleNormal.copyWith(
//                         color: myColor.primaryColorDark,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               );

//             case Status.COMPLETED:
//               followersCheckModel =
//                   FollowersCheckModel.fromJson(snapshot.data!.data);
//               if (snapshot.data!.data.isEmpty) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border:
//                         Border.all(color: myColor.primaryColorDark, width: 1.0),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   height: 45,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Empty Stream',
//                         style: kStyleNormal.copyWith(
//                           color: myColor.primaryColorDark,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return GestureDetector(
//                 onTap: () async {
//                   followBtn();
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border:
//                         Border.all(color: myColor.primaryColorDark, width: 1.0),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   height: 45,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         followersCheckModel!.isfollowed == 0
//                             ? 'Follow'
//                             : 'Following',
//                         style: kStyleNormal.copyWith(
//                           color: myColor.primaryColorDark,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 5.0),
//                       Container(
//                           margin: const EdgeInsets.only(top: 2.0),
//                           child: followersCheckModel!.isfollowed == 0
//                               ? Icon(
//                                   Icons.add,
//                                   color: myColor.primaryColorDark,
//                                 )
//                               : Icon(
//                                   Icons.check,
//                                   size: 20.0,
//                                   color: myColor.primaryColorDark,
//                                 )),
//                     ],
//                   ),
//                 ),
//               );

//             case Status.ERROR:
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border:
//                       Border.all(color: myColor.primaryColorDark, width: 1.0),
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 height: 45,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Server Error',
//                       style: kStyleNormal.copyWith(
//                         color: myColor.primaryColorDark,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//           }
//         }
//         return SizedBox(
//           width: maxWidth(context),
//         );
//       }),
//     );
//   }
// }
