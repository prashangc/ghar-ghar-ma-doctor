import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/reviewsCard.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/titleRow.dart';

class VendorProfileTabBarView extends StatefulWidget {
  const VendorProfileTabBarView({Key? key}) : super(key: key);

  @override
  State<VendorProfileTabBarView> createState() =>
      _VendorProfileTabBarViewState();
}

class _VendorProfileTabBarViewState extends State<VendorProfileTabBarView> {
  double rating = 5;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          titleCard('Reviews', 'See All', () {}),
          reviewsStreamCard(context),
        ],
      ),
    );
  }

  void _refreshVendorReviews() {
    // vendorReviewsBloc!.fetchAPIList('vendor-review?vendor_id=1');
  }
}
