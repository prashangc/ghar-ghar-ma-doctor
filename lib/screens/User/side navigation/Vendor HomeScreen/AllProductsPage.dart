// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:ghargharmadoctor/api/api_imports.dart';
// import 'package:ghargharmadoctor/constants/constants_imports.dart';
// import 'package:ghargharmadoctor/models/Products%20Model/BrandModel.dart';
// import 'package:ghargharmadoctor/models/Products%20Model/RatingsModel.dart';
// import 'package:ghargharmadoctor/models/models.dart';
// import 'package:ghargharmadoctor/screens/User/Loading/loading_imports.dart';
// import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/productCard.dart';
// import 'package:ghargharmadoctor/widgets/widgets_import.dart';

// class AllProductsPage extends StatefulWidget {
//   final VendorDetails? vendorDetails;
//   final int? categoryID;
//   final bool? isLatest;

//   const AllProductsPage(
//       {Key? key, this.categoryID, this.vendorDetails, this.isLatest})
//       : super(key: key);

//   @override
//   State<AllProductsPage> createState() => _AllProductsPageState();
// }

// class _AllProductsPageState extends State<AllProductsPage> {
//   double rating = 5;
//   RangeValues values = const RangeValues(0, 1000);
//   int turn = 1;
//   String? dropDownValue;
//   String _brandURL = '';
//   String _search = '';
//   final TextEditingController _myController = TextEditingController();
//   String? brandID;
//   int selectedRatingsIndex = 0;
//   int selectedBrandIndex = 0;
//   ApiHandlerBloc? productBloc, brandBloc, categoryBloc;
//   ProductModel? productModel;
//   String _url = '';
//   String? myVendorID;
//   int? myCategoryID;
//   List<VendorWiseCategoryModel> vendorWiseCategoryModel = [];

//   bool isPriceFilterSelected = false;
//   bool overLapDropdown = true;

//   @override
//   void initState() {
//     super.initState();
//     getDataFromAPI();
//   }

//   Future getDataFromAPI() async {
//     productBloc = ApiHandlerBloc();
//     if (widget.vendorDetails == null &&
//         widget.categoryID == null &&
//         widget.isLatest == null) {
//       productBloc!.fetchAPIList('products?keyword=$_search$_url');
//     } else if (widget.categoryID == null && widget.isLatest == null) {
//       myVendorID = widget.vendorDetails!.id.toString();
//       productBloc!
//           .fetchAPIList('products?vendor_id=$myVendorID$_url&keyword=$_search');
//     } else if (widget.isLatest == true && widget.categoryID == null) {
//       myVendorID = widget.vendorDetails!.id.toString();
//       productBloc!.fetchAPIList(
//           'products?vendor_id=$myVendorID$_url&keyword=$_search&latest=desc');
//     } else {
//       myVendorID = widget.vendorDetails!.id.toString();
//       myCategoryID = widget.categoryID;
//       productBloc!.fetchAPIList(
//           'products?vendor_id=$myVendorID$_url&keyword=$_search&category_id=$myCategoryID');
//       categoryBloc = ApiHandlerBloc();
//       categoryBloc!
//           .fetchAPIList('categories/vendortype?vendor_type_id=$myVendorID');
//     }
//   }

//   void applyBtn() {
//     _url =
//         '&min_price=${values.start.round().toString()}&max_price=${values.end.round().toString()}';
//     Navigator.pop(context);
//     setState(() {
//       getDataFromAPI();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         myfocusRemover(context);
//       },
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: myCustomAppBar(
//           title: 'All Products',
//           color: myColor.dialogBackgroundColor,
//           borderRadius: 0.0,
//         ),
//         body: Column(
//           children: [
//             Container(
//               width: maxWidth(context),
//               decoration: BoxDecoration(
//                 color: myColor.dialogBackgroundColor,
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(0),
//                   bottomLeft: Radius.circular(0),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     myFilterSearchTextField(
//                       context,
//                       _myController,
//                       'Search all products',
//                       _search,
//                       Icons.search,
//                       Icons.sort,
//                       () async {
//                         brandBloc = ApiHandlerBloc();
//                         brandBloc!.fetchAPIList(endpoints.getBrandEndpoint);
//                         showModalBottomSheet(
//                             backgroundColor: backgroundColor,
//                             isScrollControlled: true,
//                             context: context,
//                             shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.vertical(
//                                     top: Radius.circular(20))),
//                             builder: (context) => filterProductsSheet());
//                       },
//                       () {
//                         _myController.clear();
//                         myfocusRemover(context);
//                         setState(() {
//                           _search = '';
//                           getDataFromAPI();
//                         });
//                       },
//                       onValueChanged: (value) {
//                         setState(() {
//                           _search = value;
//                           getDataFromAPI();
//                         });
//                       },
//                     ),
//                     widget.categoryID == null
//                         ? Container()
//                         : StreamBuilder<ApiResponse<dynamic>>(
//                             stream: categoryBloc!.apiListStream,
//                             builder: ((context, snapshot) {
//                               if (snapshot.hasData) {
//                                 switch (snapshot.data!.status) {
//                                   case Status.LOADING:
//                                     return const Expanded(
//                                         child: CategoryLoadingShimmer());
//                                   case Status.COMPLETED:
//                                     vendorWiseCategoryModel =
//                                         List<VendorWiseCategoryModel>.from(
//                                             snapshot.data!.data.map((i) =>
//                                                 VendorWiseCategoryModel
//                                                     .fromJson(i)));
//                                     return SizedBox(
//                                       height: 35.0,
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount:
//                                             vendorWiseCategoryModel.length,
//                                         scrollDirection: Axis.horizontal,
//                                         itemBuilder: (context, index) {
//                                           return GestureDetector(
//                                             onTap: () {
//                                               // setState(() {
//                                               //   _url = '';
//                                               //   _search = '';
//                                               //   // myVendorID = widget
//                                               //   //     .vendorDetails!.id
//                                               //   //     .toString();
//                                               //   // myCategoryID =
//                                               //   //     vendorWiseCategoryModel[
//                                               //   //             index]
//                                               //   //         .id;
//                                               //   // print('hello $myCategoryID');
//                                               //   //   productBloc!.fetchAPIList(
//                                               //   //       'products?vendor_id=$myVendorID$_url&keyword=$_search&category_id=$myCategoryID');
//                                               // });
//                                             },
//                                             child: Container(
//                                               margin: const EdgeInsets.only(
//                                                   right: 10.0),
//                                               decoration: BoxDecoration(
//                                                 color: int.parse(myCategoryID
//                                                                 .toString()) -
//                                                             1 ==
//                                                         index
//                                                     ? myColor.primaryColorDark
//                                                     : Colors.white,
//                                                 border: Border.all(
//                                                     color: myColor
//                                                         .primaryColorDark,
//                                                     width: 1.0),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8.0),
//                                               ),
//                                               width: 100,
//                                               child: Center(
//                                                 child: Text(
//                                                     vendorWiseCategoryModel[
//                                                             index]
//                                                         .name
//                                                         .toString(),
//                                                     textAlign: TextAlign.center,
//                                                     overflow: TextOverflow.clip,
//                                                     style: kStyleNormal.copyWith(
//                                                         color: int.parse(myCategoryID
//                                                                         .toString()) -
//                                                                     1 ==
//                                                                 index
//                                                             ? Colors.white
//                                                             : myColor
//                                                                 .primaryColorDark)),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   case Status.ERROR:
//                                     return Expanded(
//                                       child: Container(
//                                         // width: maxWidth(context) / 2,
//                                         height: 24.0,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                         ),
//                                         child: Center(
//                                           child: Text('Server Error',
//                                               style: kStyleNormal),
//                                         ),
//                                       ),
//                                     );
//                                 }
//                               }
//                               return SizedBox(
//                                 width: maxWidth(context),
//                               );
//                             }),
//                           ),
//                     widget.categoryID == null ? Container() : const SizedBox8(),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: maxWidth(context),
//               height: 35.0,
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton2(
//                     isExpanded: true,
//                     hint: Expanded(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.list,
//                             color: myColor.primaryColorDark,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 4.0),
//                           Text(
//                             'Best Match',
//                             style: kStyleNormal.copyWith(
//                                 fontSize: 14.0,
//                                 color: myColor.primaryColorDark),
//                           ),
//                         ],
//                       ),
//                     ),
//                     items: priceFilter
//                         .map((item) => DropdownMenuItem<String>(
//                               value: item,
//                               child: Text(
//                                 item,
//                                 style: kStyleNormal.copyWith(
//                                     fontSize: 14.0,
//                                     color: myColor.primaryColorDark),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ))
//                         .toList(),
//                     value: dropDownValue,
//                     onChanged: (value) {
//                       setState(() {
//                         dropDownValue = value as String;
//                         print('my value $dropDownValue');
//                         if (dropDownValue == 'Price high to low') {
//                           _url = '&sort=desc';
//                           getDataFromAPI();
//                         } else {
//                           _url = '&sort=asc';
//                           getDataFromAPI();
//                         }
//                         isPriceFilterSelected = !isPriceFilterSelected;
//                       });
//                     },

//                     icon: isPriceFilterSelected
//                         ? GestureDetector(
//                             onTap: () {
//                               print('closed');
//                               print(overLapDropdown);
//                               setState(() {
//                                 _url = '';
//                                 overLapDropdown = !overLapDropdown;
//                               });
//                               print(overLapDropdown);
//                             },
//                             child: const Icon(
//                               Icons.close,
//                             ),
//                           )
//                         : const Icon(
//                             Icons.keyboard_arrow_down_outlined,
//                           ),
//                     dropdownOverButton: overLapDropdown,
//                     iconSize: 20,
//                     iconEnabledColor: myColor.primaryColorDark,
//                     iconDisabledColor: Colors.grey,
//                     buttonHeight: 50,

//                     buttonWidth: 130,
//                     buttonElevation: 0,
//                     dropdownElevation: 0,
//                     buttonPadding: const EdgeInsets.only(left: 14, right: 14),
//                     buttonDecoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(20.0),
//                           bottomRight: Radius.circular(20.0)),
//                       // border: Border.all(
//                       //   color: Colors.black26,
//                       // ),
//                       color: Colors.white,
//                     ),
//                     itemHeight: 35,
//                     itemPadding: const EdgeInsets.only(left: 14, right: 14),
//                     // dropdownMaxHeight: 150,
//                     dropdownWidth: maxWidth(context),
//                     dropdownPadding: null,
//                     dropdownDecoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.white,
//                     ),
//                     scrollbarRadius: const Radius.circular(40),
//                     scrollbarThickness: 3,

//                     scrollbarAlwaysShow: false,
//                     offset: const Offset(0, 0),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: _productsWidget(context),
//                 ),
//               ),
//             ),
//             const SizedBox16(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _productsWidget(BuildContext context) {
//     getDataFromAPI();
//     return StreamBuilder<ApiResponse<dynamic>>(
//       stream: productBloc!.apiListStream,
//       builder: ((context, snapshot) {
//         if (snapshot.hasData) {
//           switch (snapshot.data!.status) {
//             case Status.LOADING:
//               return Container(
//                 width: maxWidth(context),
//                 height: maxHeight(context) / 2,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const AnimatedLoading(),
//               );
//             case Status.COMPLETED:
//               if (snapshot.data!.data.isEmpty) {
//                 return Container(
//                     width: maxWidth(context),
//                     height: maxHeight(context) / 2,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Center(child: Text('No any products added')));
//               }

//               productModel = ProductModel.fromJson(snapshot.data!.data);
//               return productModel!.data!.isEmpty
//                   ? const Padding(
//                       padding: EdgeInsets.only(top: 20.0),
//                       child: Text('No products found'),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(top: 15.0),
//                       child: GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   childAspectRatio: 2 / 2.7,
//                                   crossAxisSpacing: 10,
//                                   mainAxisSpacing: 10),
//                           itemCount: productModel!.data!.length,
//                           itemBuilder: (BuildContext ctx, index) {
//                             return productCard(
//                               context,
//                               productModel!.data![index],
//                               setState,
//                               Colors.white,
//                               0.0,
//                             );
//                           }),
//                     );

//             case Status.ERROR:
//               return Container(
//                 margin: const EdgeInsets.only(top: 20.0),
//                 width: maxWidth(context),
//                 height: 135.0,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.0)),
//                 child: const Center(
//                   child: Text('Server Error'),
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

//   Widget filterProductsSheet() {
//     return SingleChildScrollView(
//       child: StatefulBuilder(builder: (context, setState) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 5.0),
//               Center(
//                 child: Text(
//                   "Filters",
//                   style: kStyleNormal.copyWith(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18.0,
//                   ),
//                 ),
//               ),
//               const SizedBox12(),
//               Text(
//                 "Brand",
//                 style: kStyleNormal.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15.0,
//                 ),
//               ),
//               const SizedBox12(),
//               StreamBuilder<ApiResponse<dynamic>>(
//                 stream: brandBloc!.apiListStream,
//                 builder: ((context, snapshot) {
//                   if (snapshot.hasData) {
//                     switch (snapshot.data!.status) {
//                       case Status.LOADING:
//                         return const BrandLoadingShimmer();
//                       case Status.COMPLETED:
//                         if (snapshot.data!.data.isEmpty) {
//                           return Container(
//                               width: maxWidth(context),
//                               height: 60.0,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child:
//                                   const Center(child: Text('No brands found')));
//                         }
//                         List<BrandModel> brandModel = List<BrandModel>.from(
//                             snapshot.data!.data
//                                 .map((i) => BrandModel.fromJson(i)));

//                         return SizedBox(
//                           width: maxWidth(context),
//                           height: 60.0,
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: brandModel.length,
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, index) {
//                               print('hello hi index: $brandID');
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedBrandIndex = index;
//                                     brandID = brandModel[selectedBrandIndex]
//                                         .id
//                                         .toString();

//                                     _brandURL = '&brand=$brandID';
//                                     print('my url $_brandURL');

//                                     print('hello index: $brandID');
//                                   });
//                                 },
//                                 child: Container(
//                                   margin: const EdgeInsets.only(right: 10.0),
//                                   decoration: BoxDecoration(
//                                     color: selectedBrandIndex == index
//                                         ? myColor.primaryColorDark
//                                         : Colors.transparent,
//                                     border: Border.all(
//                                         color: myColor.primaryColorDark,
//                                         width: 1.0),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   width: 100,
//                                   child: Center(
//                                     child: Text(
//                                         brandModel[index].brandName.toString(),
//                                         textAlign: TextAlign.center,
//                                         overflow: TextOverflow.clip,
//                                         style: kStyleNormal.copyWith(
//                                             color: selectedBrandIndex == index
//                                                 ? Colors.white
//                                                 : myColor.primaryColorDark)),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );

//                       case Status.ERROR:
//                         return Container(
//                           width: maxWidth(context),
//                           height: 135.0,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Center(
//                             child: Text('Server Error'),
//                           ),
//                         );
//                     }
//                   }
//                   return SizedBox(
//                     width: maxWidth(context),
//                     height: 200,
//                   );
//                 }),
//               ),
//               const SizedBox12(),
//               Text(
//                 "Price",
//                 style: kStyleNormal.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15.0,
//                 ),
//               ),
//               const SizedBox(height: 4.0),
//               Row(
//                 children: [
//                   StatefulBuilder(builder: (builder, setStateAsParameter) {
//                     return Text(
//                       values.start.round().toString(),
//                       style: kStyleNormal.copyWith(fontSize: 12.0),
//                     );
//                   }),
//                   Expanded(
//                     child: SliderTheme(
//                       data: SliderThemeData(
//                         trackShape: CustomTrackShape(),
//                         valueIndicatorColor: myColor.primaryColorDark,
//                         thumbColor: Colors.white,
//                         activeTickMarkColor: Colors.transparent,
//                         inactiveTickMarkColor: Colors.transparent,
//                         activeTrackColor: myColor.primaryColorDark,
//                         inactiveTrackColor: myColor.dialogBackgroundColor,
//                       ),
//                       child: StatefulBuilder(
//                         builder: (context, setState) => SizedBox(
//                           width: maxWidth(context),
//                           child: RangeSlider(
//                             values: values,
//                             min: 0,
//                             max: 5000,
//                             divisions: 100,
//                             labels: RangeLabels(
//                               values.start.round().toString(),
//                               values.end.round().toString(),
//                             ),
//                             onChanged: (value) {
//                               values = value;
//                               setState(() {
//                                 values = RangeValues(
//                                     double.parse(
//                                         values.start.round().toString()),
//                                     double.parse(
//                                         values.end.round().toString()));
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     values.end.round().toString(),
//                     style: kStyleNormal.copyWith(fontSize: 12.0),
//                   ),
//                 ],
//               ),
//               const SizedBox16(),
//               Text(
//                 "Ratings",
//                 style: kStyleNormal.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15.0,
//                 ),
//               ),
//               const SizedBox16(),
//               SizedBox(
//                 width: maxWidth(context),
//                 height: 60.0,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: ratingsList.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedRatingsIndex = index;
//                         });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(right: 10.0),
//                         decoration: BoxDecoration(
//                           color: selectedRatingsIndex == index
//                               ? myColor.primaryColorDark
//                               : Colors.transparent,
//                           border: Border.all(
//                               color: myColor.primaryColorDark, width: 1.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         width: 100,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(ratingsList[index].ratingValue.toString(),
//                                 textAlign: TextAlign.center,
//                                 overflow: TextOverflow.clip,
//                                 style: kStyleNormal.copyWith(
//                                     color: selectedRatingsIndex == index
//                                         ? Colors.white
//                                         : myColor.primaryColorDark)),
//                             const SizedBox12(),
//                             RatingBar.builder(
//                                 unratedColor: selectedRatingsIndex == index
//                                     ? Colors.white
//                                     : null,
//                                 itemBuilder: (context, _) {
//                                   return const Icon(
//                                     Icons.star,
//                                     color: Colors.amber,
//                                   );
//                                 },
//                                 updateOnDrag: false,
//                                 initialRating: double.parse(
//                                   ratingsList[index].starCount.toString(),
//                                 ),
//                                 itemSize: 12.0,
//                                 itemPadding: const EdgeInsets.only(right: 5),
//                                 onRatingUpdate: (newRatingValue) {}),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox16(),
//               Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       border: Border.all(
//                           color: myColor.primaryColorDark, width: 1.0),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     width: 120,
//                     height: 50,
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 18.0),
//                         Container(
//                           margin: const EdgeInsets.only(top: 2.0),
//                           child: Icon(
//                             Icons.close,
//                             color: myColor.primaryColorDark,
//                           ),
//                         ),
//                         const SizedBox(width: 8.0),
//                         Text(
//                           'Clear',
//                           style: kStyleNormal.copyWith(
//                             color: myColor.primaryColorDark,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 12,
//                   ),
//                   Expanded(
//                     child: SizedBox(
//                       height: 50,
//                       child: myCustomButton(
//                         context,
//                         myColor.primaryColorDark,
//                         'Apply',
//                         kStyleNormal.copyWith(
//                           color: Colors.white,
//                           fontSize: 18.0,
//                           letterSpacing: 1.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         () {
//                           applyBtn();
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox12(),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
