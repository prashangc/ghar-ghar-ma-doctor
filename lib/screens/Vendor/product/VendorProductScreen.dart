import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/productCardHrz.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class VendorProductScreen extends StatefulWidget {
  const VendorProductScreen({super.key});

  @override
  State<VendorProductScreen> createState() => _VendorProductScreenState();
}

class _VendorProductScreenState extends State<VendorProductScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductModel? productModel;
  ApiHandlerBloc? productBloc;
  VendorProfileModel? vendorProfileModel;
  @override
  void initState() {
    super.initState();

    var test = sharedPrefs.getFromDevice("vendorProfile");
    vendorProfileModel = VendorProfileModel.fromJson(json.decode(test));
    productBloc = ApiHandlerBloc();
    productBloc!.fetchAPIList('products?vendor_id=${vendorProfileModel!.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(''),
        toolbarHeight: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: myColor.dialogBackgroundColor,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: maxWidth(context),
          height: maxHeight(context),
          child: Column(
            children: [
              myAppBarCard(),
              const SizedBox12(),
              Expanded(
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: productStreamBuilder())),
            ],
          ),
        ),
      ),
    );
  }

  Widget myAppBarCard() {
    return Column(
      children: [
        Container(
          width: maxWidth(context),
          color: myColor.dialogBackgroundColor,
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/gd_logo_banner.png',
                width: maxWidth(context) / 2,
                height: 70.0,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 45,
                height: 45,
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: myColor.primaryColorDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.menu,
                      color: myColor.scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          width: maxWidth(context),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Container(
              width: maxWidth(context),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 45.0,
              child: Row(
                children: [
                  const SizedBox(width: 10.0),
                  Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      'Search your products',
                      style: kStyleNormal.copyWith(
                          fontSize: 14.0, color: Colors.grey[400]),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget productStreamBuilder() {
    return StreamBuilder<ApiResponse<dynamic>>(
      stream: productBloc!.apiListStream,
      builder: ((c, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const Center(child: AnimatedLoading());
            case Status.COMPLETED:
              productModel = ProductModel.fromJson(snapshot.data!.data);
              return Column(
                children: [
                  SizedBox(
                    width: maxWidth(context),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        itemCount: productModel!.data!.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
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
  }
}
