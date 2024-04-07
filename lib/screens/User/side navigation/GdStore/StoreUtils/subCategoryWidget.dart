import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/screens/User/Loading/loading_imports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/AllProductPage.dart';

Widget subCategoryWidget(context, vendorTypeID) {
  ApiHandlerBloc? subCategoryBloc;
  subCategoryBloc = ApiHandlerBloc();
  subCategoryBloc
      .fetchAPIList('categories/vendortype?vendor_type_id=$vendorTypeID');
  List<SubCategory> subCategory = [];
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: StreamBuilder<ApiResponse<dynamic>>(
      stream: subCategoryBloc.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const CategoryLoadingShimmer();
            case Status.COMPLETED:
              subCategory = List<SubCategory>.from(
                  snapshot.data!.data.map((i) => SubCategory.fromJson(i)));
              if (snapshot.data!.data.isEmpty) {
                return const Text('empty');
              }

              return SizedBox(
                width: maxWidth(context),
                height: 25.0,
                child: ListView.builder(
                    itemCount: subCategory.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemBuilder: (ctx, i) {
                      return subCategoryCard(context, subCategory[i]);
                    }),
              );
            case Status.ERROR:
              return const Text('server error');
          }
        }
        return const SizedBox();
      }),
    ),
  );
}

Widget subCategoryCard(context, SubCategory data) {
  return GestureDetector(
    onTap: () {
      goThere(
        context,
        AllProductPage(
          categoryID: data.id,
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: kWhite.withOpacity(0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 0.4,
              color: backgroundColor,
            )
          ]),
      child: Text(
        data.name.toString(),
        style: kStyleNormal.copyWith(fontSize: 12.0),
      ),
    ),
  );
}
