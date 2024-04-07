import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/AllListOfVendorsModel.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/allProductListWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/latestProductWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/subCategoryWidget.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';

class HealthyFoodMainPage extends StatefulWidget {
  final int? vendorTypeID;
  final List<SubCategory>? allCategoryModel;
  const HealthyFoodMainPage(
      {Key? key, this.vendorTypeID, this.allCategoryModel})
      : super(key: key);

  @override
  State<HealthyFoodMainPage> createState() => _HealthyFoodMainPageState();
}

class _HealthyFoodMainPageState extends State<HealthyFoodMainPage> {
  ApiHandlerBloc? productBloc;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    print('widget.vendorTypeID ${widget.vendorTypeID}');
    _scrollController = ScrollController()..addListener(loadMore);
  }

  void loadMore() async {
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      // stateBloc!.storeData(_scrollController!.position.extentAfter);
      loadingBloc!.storeData(1);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder<dynamic>(
          initialData: null,
          stream: scrollingBloc.stateStream,
          builder: (c, s) {
            if (s.data == 1) {
              _scrollController!.animateTo(0,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox12(),
                subCategoryWidget(context, widget.vendorTypeID),
                titleCard('Latest Products', 'See All', () {}),
                latestProductWidget(context, widget.vendorTypeID, '', setState),
                titleCard('All Products', 'See all', () {}),
                allProductListWidget(context, widget.vendorTypeID, ''),
              ],
            );
          }),
    );
  }

  Widget subCategoryCard(SubCategory data) {
    return Container(
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
    );
  }
}
