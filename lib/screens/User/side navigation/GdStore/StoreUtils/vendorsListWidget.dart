import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/storeLoading.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorProfilePage.dart/ExclusiveVendorHomePage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/VendorProfilePage.dart/NormalVendorHomePage.dart';

Widget vendorListWidget(context, vendorId) {
  ApiHandlerBloc? vendorListBloc;
  vendorListBloc = ApiHandlerBloc();
  vendorListBloc.fetchAPIList('vendor-details?vendor_type=$vendorId');

  List<AllVendorsModel> allVendorsModel = [];
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    width: maxWidth(context),
    child: StreamBuilder<ApiResponse<dynamic>>(
      stream: vendorListBloc.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return storeLoading(context);
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: 160.0,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Text('No any vendors found',
                            style: kStyleNormal.copyWith(fontSize: 12.0))));
              }
              allVendorsModel = List<AllVendorsModel>.from(
                  snapshot.data!.data.map((i) => AllVendorsModel.fromJson(i)));
              return SizedBox(
                width: maxWidth(context),
                height: 220.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: allVendorsModel.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return vendorCard(allVendorsModel[index], context);
                    }),
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

Widget vendorCard(data, context) {
  double rating = 5;
  return GestureDetector(
    onTap: () {
      if (data.isExculsive == 2) {
        goThere(
          context,
          ExclusiveVendorHomePage(
            data: data,
          ),
        );
      } else {
        goThere(
          context,
          NormalVendorHomePage(
            data: data,
          ),
        );
      }
    },
    child: Container(
      margin: const EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: 130.0,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              width: maxWidth(context),
              child: myCachedNetworkImage(
                maxWidth(context),
                maxWidth(context),
                data.imagePath ?? ',',
                const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            width: maxWidth(context),
            child: Column(
              children: [
                SizedBox(
                  width: maxWidth(context),
                  child: Text(
                    data.storeName.toString(),
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 2.0),
                SizedBox(
                  width: maxWidth(context),
                  child: Text(
                    '3.5km away',
                    style: kStyleNormal.copyWith(fontSize: 13.0),
                  ),
                ),
                const SizedBox(height: 2.0),
                SizedBox(
                  width: maxWidth(context),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                        child: RatingBar.builder(
                          minRating: 1,
                          itemBuilder: (context, _) {
                            return const Icon(
                              Icons.star,
                              size: 5.0,
                              color: Colors.amber,
                            );
                          },
                          itemCount: 1,
                          initialRating: rating,
                          updateOnDrag: true,
                          itemSize: 16.0,
                          itemPadding: const EdgeInsets.only(right: 2.0),
                          onRatingUpdate: (rating) => () {},
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                        child: Text(
                          '4.5',
                          style: kStyleNormal.copyWith(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 70.0,
                        child: Text(
                          '(17 Reviews)',
                          overflow: TextOverflow.ellipsis,
                          style: kStyleNormal.copyWith(fontSize: 11.0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
