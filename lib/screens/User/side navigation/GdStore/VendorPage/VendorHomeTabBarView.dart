import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/GdStore/StoreUtils/storeImageSlider.dart';

class VendorHomeTabBarView extends StatefulWidget {
  const VendorHomeTabBarView({Key? key}) : super(key: key);

  @override
  State<VendorHomeTabBarView> createState() => _VendorHomeTabBarViewState();
}

class _VendorHomeTabBarViewState extends State<VendorHomeTabBarView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        vendorAdvertisementSlider(context),
      ],
    );
  }
}
