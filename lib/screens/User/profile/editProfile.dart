import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/profile/profileDetails.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel profileModel;
  final String? showMessage;
  const EditProfile({Key? key, required this.profileModel, this.showMessage})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
      body: ProfileDetails(
          profileModel: widget.profileModel, showMessage: widget.showMessage),
    );
  }
}
