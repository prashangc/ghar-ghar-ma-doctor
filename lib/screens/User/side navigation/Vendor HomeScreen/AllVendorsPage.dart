// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:ghargharmadoctor/api/api_imports.dart';
// import 'package:ghargharmadoctor/constants/constants_imports.dart';
// import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/My%20Cart/MyCart.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/AllProductsPage.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/IndividualVendorDetails.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor/Gym/IndividualGymDetails.dart';
// import 'package:ghargharmadoctor/widgets/widgets_import.dart';

// class AllVendorsPage extends StatefulWidget {
//   const AllVendorsPage({Key? key}) : super(key: key);

//   @override
//   State<AllVendorsPage> createState() => _AllVendorsPageState();
// }

// class _AllVendorsPageState extends State<AllVendorsPage> {
//   String? _searchWord;
//   ApiHandlerBloc? vendorBloc;
//   List<AllListOfVendorsModel> allListOfVendorsModel = [];
//   final TextEditingController _myController = TextEditingController();
//   double rating = 5;

//   @override
//   void initState() {
//     super.initState();
//     vendorBloc = ApiHandlerBloc();
//     vendorBloc!.fetchAPIList(endpoints.getAllVendorsEndpoint);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         titleSpacing: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: myColor.dialogBackgroundColor,
//         elevation: 0.0,
//         toolbarHeight: 70.0,
//         title: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(
//               'GD Store',
//               style: kStyleNormal.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17.0,
//                 overflow: TextOverflow.ellipsis,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           pop_upHelper.popUpLogout(context);
//           myfocusRemover(context);
//         },
//         child: Column(
//           children: [
//             Container(
//               width: maxWidth(context),
//               decoration: BoxDecoration(
//                 color: myColor.dialogBackgroundColor,
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                 ),
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   goThere(
//                     context,
//                     const AllProductsPage(),
//                   );
//                 },
//                 child: Container(
//                     margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
//                     width: maxWidth(context),
//                     decoration: BoxDecoration(
//                       color: myColor.scaffoldBackgroundColor,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     height: 55.0,
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 10.0),
//                         Icon(
//                           Icons.search,
//                           size: 18,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(width: 12.0),
//                         Expanded(
//                           child: Text(
//                             'Search in Store',
//                             style: kStyleNormal.copyWith(
//                                 fontSize: 14.0, color: Colors.grey[400]),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             goThere(context, const MyCart());
//                           },
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: myColor.primaryColorDark,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Icon(
//                               Icons.shopping_cart,
//                               color: myColor.scaffoldBackgroundColor,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10.0),
//                       ],
//                     )),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12.0, vertical: 10.0),
//                   child: Column(children: [
//                     const SizedBox8(),
//                     StreamBuilder<ApiResponse<dynamic>>(
//                       stream: vendorBloc!.apiListStream,
//                       builder: ((context, snapshot) {
//                         if (snapshot.hasData) {
//                           switch (snapshot.data!.status) {
//                             case Status.LOADING:
//                               return Container(
//                                 width: maxWidth(context),
//                                 height: maxHeight(context) - 280,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const AnimatedLoading(),
//                               );
//                             case Status.COMPLETED:
//                               if (snapshot.data!.data.isEmpty) {
//                                 return Container(
//                                     height: 160.0,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Center(
//                                         child: Text('No any vendors found')));
//                               }
//                               allListOfVendorsModel =
//                                   List<AllListOfVendorsModel>.from(
//                                       snapshot.data!.data.map((i) =>
//                                           AllListOfVendorsModel.fromJson(i)));
//                               return ListView.builder(
//                                 itemCount: allListOfVendorsModel.length,
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 // scrollDirection: Axis.horizontal,
//                                 itemBuilder: (ctx, i) {
//                                   return allListOfVendorsModel[i]
//                                           .vendorDetails!
//                                           .isEmpty
//                                       ? Container()
//                                       : allVendor(allListOfVendorsModel[i]);
//                                 },
//                               );

//                             case Status.ERROR:
//                               return Container(
//                                 width: maxWidth(context),
//                                 height: 160.0,
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
//                   ]),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget allVendor(AllListOfVendorsModel allListOfVendor) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               allListOfVendor.vendorType.toString(),
//               style: kStyleNormal.copyWith(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16.0,
//               ),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: Text(
//                 'See all',
//                 style: kStyleNormal.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15.0,
//                     color: myColor.primaryColorDark),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox16(),
//         SizedBox(
//           width: maxWidth(context),
//           height: 200.0,
//           child: ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               // physics: const NeverScrollableScrollPhysics(),
//               itemCount: allListOfVendor.vendorDetails!.length,
//               itemBuilder: (ctx, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     var vendorTypeId =
//                         allListOfVendor.vendorDetails![index].vendorType;
//                     switch (vendorTypeId) {
//                       case 1:
//                         goThere(
//                           context,
//                           IndividualVendorDetails(
//                             vendorDetails:
//                                 allListOfVendor.vendorDetails![index],
//                           ),
//                         );
//                         break;
//                       case 2:
//                         goThere(
//                           context,
//                           IndividualVendorDetails(
//                             vendorDetails:
//                                 allListOfVendor.vendorDetails![index],
//                           ),
//                         );
//                         break;
//                       case 3:
//                         goThere(
//                             context,
//                             IndividualGymDetails(
//                               vendorDetails:
//                                   allListOfVendor.vendorDetails![index],
//                             ));
//                         break;
//                       default:
//                     }
//                   },
//                   child: vendorCard(
//                     allListOfVendor.vendorDetails![index].imagePath.toString(),
//                     allListOfVendor.vendorDetails![index].user!.name.toString(),
//                   ),
//                 );
//               }),
//         ),
//         const SizedBox16(),
//       ],
//     );
//   }

//   Widget vendorCard(
//     image,
//     name,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(right: 15.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       width: 130.0,
//       child: Column(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(12),
//                   topLeft: Radius.circular(12),
//                 ),
//               ),
//               width: maxWidth(context),
//               child: myCachedNetworkImage(
//                 maxWidth(context),
//                 maxWidth(context),
//                 image,
//                 const BorderRadius.only(
//                   topLeft: Radius.circular(12.0),
//                   topRight: Radius.circular(12.0),
//                 ),
//                 BoxFit.contain,
//               ),
//             ),
//           ),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//             ),
//             width: maxWidth(context),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: maxWidth(context),
//                   child: Text(
//                     name,
//                     style: kStyleNormal.copyWith(
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 2.0),
//                 SizedBox(
//                   width: maxWidth(context),
//                   child: Text(
//                     '3.5km away',
//                     style: kStyleNormal.copyWith(fontSize: 13.0),
//                   ),
//                 ),
//                 const SizedBox(height: 2.0),
//                 SizedBox(
//                   width: maxWidth(context),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 20.0,
//                         child: RatingBar.builder(
//                           minRating: 1,
//                           itemBuilder: (context, _) {
//                             return const Icon(
//                               Icons.star,
//                               size: 5.0,
//                               color: Colors.amber,
//                             );
//                           },
//                           itemCount: 1,
//                           initialRating: rating,
//                           updateOnDrag: true,
//                           itemSize: 16.0,
//                           itemPadding: const EdgeInsets.only(right: 2.0),
//                           onRatingUpdate: (rating) => setState(() {
//                             this.rating = rating;
//                           }),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20.0,
//                         child: Text(
//                           '4.5',
//                           style: kStyleNormal.copyWith(
//                             fontSize: 13.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 70.0,
//                         child: Text(
//                           '(17 Reviews)',
//                           overflow: TextOverflow.ellipsis,
//                           style: kStyleNormal.copyWith(fontSize: 11.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
