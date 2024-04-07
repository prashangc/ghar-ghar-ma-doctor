import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/productCardHrz.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/storeLoading.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

StateHandlerBloc? myStateBloc;
StateHandlerBloc? loadingBloc;

Widget allProductListWidget(context, typeID, vendorID) {
  ProductModel? productModel;
  ApiHandlerBloc productBloc;
  productBloc = ApiHandlerBloc();
  List<ProductModelData> testProductData = [];
  myStateBloc = StateHandlerBloc();
  loadingBloc = StateHandlerBloc();
  int page = 1;
  myMethod(myPageNo) async {
    var resp = await API().getData(context,
        'products?vendor_type=$typeID&vendor_id=$vendorID&page=$myPageNo');
    ProductModel productModel = ProductModel.fromJson(resp);
    if (productModel.data!.isNotEmpty) {
      loadingBloc!.storeData(2);
      testProductData.add(ProductModelData(color: 'More Products  '));
      testProductData.addAll(productModel.data!);
    } else {
      loadingBloc!.storeData(0);
    }
  }

  return Column(
    children: [
      StreamBuilder<dynamic>(
          initialData: 'empty',
          stream: myStateBloc!.stateStream,
          builder: ((context, snapshot1) {
            productBloc.fetchAPIList(
                'products?vendor_type=$typeID&vendor_id=$vendorID');
            return StreamBuilder<ApiResponse<dynamic>>(
              stream: productBloc.apiListStream,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      return storeLoading(context);
                    case Status.COMPLETED:
                      productModel = ProductModel.fromJson(snapshot.data!.data);
                      return Column(
                        children: [
                          SizedBox(
                            width: maxWidth(context),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                itemCount: productModel!.data!.length,
                                itemBuilder: (ctx, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: productCardHrz(
                                        productModel!.data![i], true, context),
                                  );
                                }),
                          ),
                        ],
                      );

                    case Status.ERROR:
                      return Container(
                        width: maxWidth(context),
                        height: 210.0,
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('Server Error'),
                        ),
                      );
                  }
                }
                return Container();
              }),
            );
          })),
      StreamBuilder<dynamic>(
          initialData: 90,
          stream: loadingBloc!.stateStream,
          builder: (context, snapshot) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: testProductData.length,
                itemBuilder: (ctx, i) {
                  return testProductData[i].color == 'More Products  '
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'More Products',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child:
                              productCardHrz(testProductData[i], true, context),
                        );
                });
          }),
      const SizedBox8(),
      StreamBuilder<dynamic>(
          initialData: 2,
          stream: loadingBloc!.stateStream,
          builder: (context, snapshot) {
            if (snapshot.data == 1) {
              page = page + 1;
              myMethod(page);
              return const AnimatedLoading();
            } else if (snapshot.data == 0) {
              return Text('No more products',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ));
            } else if (snapshot.data == 2) {
              return Text('Scroll more products',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ));
            } else {
              return Container();
            }
          }),
      const SizedBox12(),
    ],
  );
}
