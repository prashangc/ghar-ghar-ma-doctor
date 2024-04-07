// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:ghargharmadoctor/api/api_imports.dart';
// import 'package:ghargharmadoctor/constants/constants_imports.dart';
// import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
// import 'package:ghargharmadoctor/models/GetReviewModel.dart';
// import 'package:ghargharmadoctor/widgets/widgets_import.dart';
// import 'package:url_launcher/url_launcher.dart';

// class IndividualGymDetails extends StatefulWidget {
//   final VendorDetails vendorDetails;

//   const IndividualGymDetails({Key? key, required this.vendorDetails})
//       : super(key: key);

//   @override
//   State<IndividualGymDetails> createState() => _IndividualGymDetailsState();
// }

// class _IndividualGymDetailsState extends State<IndividualGymDetails> {
//   int initialLength = 3;
//   double rating = 5;
//   bool isReadMore = false;
//   List<GetReviewModel> getReviewModel = [];
//   final TextEditingController _reviewController = TextEditingController();
//   String ratingsText = 'Excellent';
//   ApiHandlerBloc? reviewsBloc;
//   @override
//   void initState() {
//     super.initState();
//     reviewsBloc = ApiHandlerBloc();
//     _refreshReviews();
//   }

//   void _refreshReviews() {
//     reviewsBloc!.fetchAPIList('get_review?product_id=1');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final maxLines = isReadMore ? null : 5;
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: const myCustomAppBar(
//         title: '',
//         color: Colors.transparent,
//         borderRadius: 12.0,
//       ),
//       extendBodyBehindAppBar: true,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 myCachedNetworkImage(
//                   maxWidth(context),
//                   200.0,
//                   widget.vendorDetails.imagePath.toString(),
//                   const BorderRadius.all(Radius.circular(0.0)),
//                   BoxFit.cover,
//                 ),
//                 Positioned(
//                   left: 12.0,
//                   bottom: -60,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 62,
//                     child: CircleAvatar(
//                       backgroundColor: Colors.white,
//                       radius: 54,
//                       child: myCachedNetworkImage(
//                         maxWidth(context),
//                         maxHeight(context),
//                         widget.vendorDetails.imagePath.toString(),
//                         const BorderRadius.all(Radius.circular(54)),
//                         BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     color: Colors.transparent,
//                     width: maxWidth(context),
//                     height: 60.0,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           'Rs 2000',
//                           style: kStyleNormal.copyWith(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20.0,
//                           ),
//                         ),
//                         const SizedBox(height: 4.0),
//                         Text(
//                           'per month',
//                           style: kStyleNormal.copyWith(
//                             fontSize: 12.0,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox8(),
//                   Text(
//                     widget.vendorDetails.user!.name.toString(),
//                     style: kStyleNormal.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: myColor.primaryColorDark,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                   const SizedBox(height: 4.0),
//                   const Divider(),
//                   const SizedBox(height: 4.0),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 2.0),
//                         child: Icon(
//                           Icons.location_on,
//                           size: 20.0,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       const SizedBox(width: 10.0),
//                       Text(
//                         widget.vendorDetails.address.toString(),
//                         style: kStyleNormal.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5.0),
//                   Row(
//                     children: [
//                       RatingBar.builder(
//                         minRating: 1,
//                         itemBuilder: (context, _) {
//                           return const Icon(
//                             Icons.star,
//                             size: 5.0,
//                             color: Colors.amber,
//                           );
//                         },
//                         initialRating: rating,
//                         updateOnDrag: true,
//                         itemSize: 18.0,
//                         itemPadding: const EdgeInsets.only(right: 2.0),
//                         onRatingUpdate: (rating) => setState(() {
//                           this.rating = rating;
//                         }),
//                       ),
//                       const SizedBox(width: 5.0),
//                       Text(
//                         '4.2',
//                         style: kStyleNormal,
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 5.0),
//                   Row(
//                     children: [
//                       Text(
//                         'Phone:',
//                         style: kStyleNormal.copyWith(
//                           color: Colors.grey[500],
//                           fontSize: 15.0,
//                         ),
//                       ),
//                       const SizedBox(width: 10.0),
//                       Text(
//                         widget.vendorDetails.user!.phone.toString(),
//                         // '${widget.vendorDetails.user!.phone.toString().substring(0, 4)} ${widget.vendorDetails.user!.phone.toString().substring(4, 14)}',
//                         style: kStyleNormal.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5.0),
//                   Row(
//                     children: [
//                       Text(
//                         'Opening hours:',
//                         style: kStyleNormal.copyWith(
//                           color: Colors.grey[500],
//                           fontSize: 15.0,
//                         ),
//                       ),
//                       const SizedBox(width: 10.0),
//                       Text(
//                         widget.vendorDetails.createdAt.toString(),
//                         // '${widget.vendorDetails.user!.phone.toString().substring(0, 4)} ${widget.vendorDetails.user!.phone.toString().substring(4, 14)}',
//                         style: kStyleNormal.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox12(),
//                   Row(
//                     children: [
//                       myContainer(
//                         Icons.location_on,
//                         'Show Directions',
//                         () {},
//                       ),
//                       const SizedBox(width: 12.0),
//                       myContainer(
//                         Icons.call,
//                         'Call',
//                         () {
//                           // UrlLaucher
//                           launch(
//                               'tel://${widget.vendorDetails.user!.phone.toString()}');
//                         },
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 5.0),
//                   const Divider(),
//                   const SizedBox(height: 5.0),
//                   Text(
//                     'Description',
//                     style: kStyleNormal.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13.0,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         widget.vendorDetails.address.toString() * 100,
//                         textAlign: TextAlign.justify,
//                         maxLines: maxLines,
//                         overflow: isReadMore
//                             ? TextOverflow.visible
//                             : TextOverflow.ellipsis,
//                         style: kStyleNormal.copyWith(
//                           fontSize: 12.0,
//                         ),
//                       ),
//                       const SizedBox8(),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isReadMore = !isReadMore;
//                           });
//                         },
//                         child: Text(
//                           isReadMore ? 'Read less' : 'Read more',
//                           style: kStyleNormal.copyWith(
//                             fontWeight: FontWeight.bold,
//                             color: myColor.primaryColorDark,
//                             fontSize: 13.0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox12(),
//                   const Divider(),
//                   const SizedBox(
//                     height: 4.0,
//                   ),
//                   StreamBuilder<ApiResponse<dynamic>>(
//                     stream: reviewsBloc!.apiListStream,
//                     builder: ((context, snapshot) {
//                       if (snapshot.hasData) {
//                         switch (snapshot.data!.status) {
//                           case Status.LOADING:
//                             return Container(
//                               width: maxWidth(context),
//                               height: 120.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const AnimatedLoading(),
//                             );
//                           case Status.COMPLETED:
//                             if (snapshot.data!.data.isEmpty) {
//                               return Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       showModalBottomSheet(
//                                         context: context,
//                                         backgroundColor:
//                                             backgroundColor,
//                                         isScrollControlled: true,
//                                         shape: const RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.vertical(
//                                                 top: Radius.circular(20))),
//                                         builder: ((builder) =>
//                                             addReviewBottomSheet()),
//                                       );
//                                     },
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(
//                                           Icons.add,
//                                           color: myColor.primaryColorDark,
//                                           size: 16.0,
//                                         ),
//                                         Text(
//                                           'Add Reviews',
//                                           style: kStyleNormal.copyWith(
//                                             color: myColor.primaryColorDark,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 13.0,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     'No reviews yet',
//                                     style: kStyleNormal.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 11.0,
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }
//                             getReviewModel = List<GetReviewModel>.from(snapshot
//                                 .data!.data
//                                 .map((i) => GetReviewModel.fromJson(i)));
//                             return Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       '${getReviewModel.length} Reviews',
//                                       style: kStyleNormal.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 13.0,
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         showModalBottomSheet(
//                                           context: context,
//                                           backgroundColor:
//                                               backgroundColor,
//                                           isScrollControlled: true,
//                                           shape: const RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.vertical(
//                                                       top:
//                                                           Radius.circular(20))),
//                                           builder: ((builder) =>
//                                               addReviewBottomSheet()),
//                                         );
//                                       },
//                                       child: Text(
//                                         'Add Review',
//                                         style: kStyleNormal.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: myColor.primaryColorDark,
//                                           fontSize: 13.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   color: Colors.red,
//                                   child: ListView.builder(
//                                       itemCount: 1,
//                                       shrinkWrap: true,
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         return reviewsCard(
//                                             getReviewModel[index]);
//                                       }),
//                                 ),
//                                 const SizedBox(
//                                   height: 5.0,
//                                 ),
//                                 getReviewModel.length > initialLength
//                                     ? Center(
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               initialLength =
//                                                   getReviewModel.length;
//                                             });
//                                           },
//                                           child: Text(
//                                             'See more',
//                                             style: kStyleNormal.copyWith(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12.0,
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     : getReviewModel.length == initialLength
//                                         ? GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 initialLength = 3;
//                                               });
//                                             },
//                                             child: Text(
//                                               'See less',
//                                               style: kStyleNormal.copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12.0,
//                                               ),
//                                             ),
//                                           )
//                                         : Container()
//                               ],
//                             );
//                           case Status.ERROR:
//                             return Container(
//                               width: maxWidth(context),
//                               height: 135.0,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Center(
//                                 child: Text('Server Error'),
//                               ),
//                             );
//                         }
//                       }
//                       return SizedBox(
//                         width: maxWidth(context),
//                       );
//                     }),
//                   ),
//                   const SizedBox32()
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget myContainer(icon, text, Function myTap) {
//     return GestureDetector(
//       onTap: () {
//         myTap();
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0),
//         height: 50.0,
//         decoration: BoxDecoration(
//             color: myColor.primaryColorDark,
//             borderRadius: BorderRadius.circular(10.0)),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 20.0,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8.0),
//             Text(
//               text,
//               style: kStyleNormal.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 15.0,
//               ),
//             ),
//           ],
//         ),
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
//                   const SizedBox12(),
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
//                                     // rating = newRatingValue;
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
//                     width: 400.0,
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
//                         () {};
//                       },
//                     ),
//                   ),
//                   const SizedBox12(),
//                 ])),
//       );
//     });
//   }

//   Widget reviewsCard(GetReviewModel getReviewModel) {
//     return Container(
//       width: maxWidth(context),
//       decoration: BoxDecoration(
//         color: Colors.amber,
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
//                 Container(
//                   width: 50,
//                   height: 50.0,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.0),
//                       image: const DecorationImage(
//                         image: AssetImage(
//                           'assets/lab_service.jpg',
//                         ),
//                         fit: BoxFit.contain,
//                       )),
//                 ),
//                 const SizedBox(width: 10.0),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         getReviewModel.member!.user!.name.toString(),
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
// }
