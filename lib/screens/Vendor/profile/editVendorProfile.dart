import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Vendor/profile/editVendorDetails.dart';

class EditVendorProfileScreen extends StatefulWidget {
  final VendorProfileModel profileModel;
  const EditVendorProfileScreen({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<EditVendorProfileScreen> createState() =>
      EditVendorProfileScreenState();
}

class EditVendorProfileScreenState extends State<EditVendorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: Text(
            'Profile',
            style: kStyleTitle2.copyWith(
                color: myColor.primaryColorDark, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: myColor.dialogBackgroundColor,
      body: EditVendorProfileDetails(vendorProfileModel: widget.profileModel),
    );
  }
}
