import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/storeLoading.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Vendor%20HomeScreen/productCard.dart';

Widget latestProductWidget(context, vendorTypeID, vendorID, setState) {
  ApiHandlerBloc? productBloc;
  productBloc = ApiHandlerBloc();
  productBloc.fetchAPIList(
      'products?latest=desc&vendor_type=$vendorTypeID&vendor_id=$vendorID');
  ProductModel? productModel;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    width: maxWidth(context),
    child: StreamBuilder<ApiResponse<dynamic>>(
      stream: productBloc.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return storeLoading(context);
            case Status.COMPLETED:
              productModel = ProductModel.fromJson(snapshot.data!.data);
              return productModel!.data!.isEmpty
                  ? Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      width: maxWidth(context),
                      height: maxHeight(context) / 4,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text('No any products added',
                              style: kStyleNormal.copyWith(fontSize: 12.0))))
                  : Column(
                      children: [
                        SizedBox(
                          width: maxWidth(context),
                          height: 220.0,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: productModel!.data!.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: productCard(
                                    context,
                                    productModel!.data![index],
                                    setState,
                                    Colors.white,
                                    0.0,
                                  ),
                                );
                              }),
                        ),
                        // titleCard('Mosted Viewed', 'See All', () {}),
                        // SizedBox(
                        //   width: maxWidth(context),
                        //   height: 220.0,
                        //   child: ListView.builder(
                        //       shrinkWrap: true,
                        //       scrollDirection: Axis.horizontal,
                        //       physics: const BouncingScrollPhysics(),
                        //       padding: EdgeInsets.zero,
                        //       itemCount: productModel!.data!.length,
                        //       itemBuilder: (BuildContext ctx, index) {
                        //         return Padding(
                        //           padding: const EdgeInsets.only(right: 12.0),
                        //           child: productCard(
                        //             context,
                        //             productModel!.data![index],
                        //             setState,
                        //             Colors.white,
                        //             0.0,
                        //           ),
                        //         );
                        //       }),
                        // ),
                      ],
                    );

            case Status.ERROR:
              return Container(
                margin: const EdgeInsets.only(top: 20.0),
                width: maxWidth(context),
                height: 135.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
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
