import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/editDoctorDetails.dart';

class EditDoctorProfileScreen extends StatefulWidget {
  final DoctorProfileModel profileModel;
  const EditDoctorProfileScreen({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<EditDoctorProfileScreen> createState() =>
      EditDoctorProfileScreenState();
}

class EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
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
      body: EditDoctorProfileDetails(doctorProfileModel: widget.profileModel),
    );
  }
}
