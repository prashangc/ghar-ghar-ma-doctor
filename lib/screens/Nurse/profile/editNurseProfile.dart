import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/editNurseDetails.dart';

class EditNurseProfileScreen extends StatefulWidget {
  final NurseProfileModel profileModel;
  const EditNurseProfileScreen({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<EditNurseProfileScreen> createState() => EditNurseProfileScreenState();
}

class EditNurseProfileScreenState extends State<EditNurseProfileScreen> {
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
      body: EditNurseProfileDetails(nurseProfileModel: widget.profileModel),
    );
  }
}
