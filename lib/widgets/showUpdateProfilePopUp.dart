import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Packages/IndividuaPackagePage.dart';

showUpdateProfilePopUp(BuildContext context, List<String> testList, type) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: ((builder) => updateProfileBottomSheet(context, testList, type)),
  );
}

Widget updateProfileBottomSheet(context, List<String> testList, type) {
  StateHandlerBloc continueBtnBloc = StateHandlerBloc();
  var test = sharedPrefs.getFromDevice("userProfile");
  ProfileModel profileModel = ProfileModel.fromJson(json.decode(test));
  String? gender, dateOfBirthNep, dateOfBirthEng;
  formValidation() {
    if (testList.contains('dobNull')) {
      if (dateOfBirthNep == null) {
        myToast.toast('Please select date of birth');
        return false;
      } else if (gender == null) {
        myToast.toast('Please select gender');
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  continueBtn(setState, type) async {
    if (formValidation()) {
      continueBtnBloc.storeData(true);

      if (!testList.contains('dobNull')) {
        gender = profileModel.gender;
        dateOfBirthNep = profileModel.dob;
      }
      myfocusRemover(context);

      int statusCode;

      statusCode = await API().postData(
          context,
          PatchProfileModel(
            name: profileModel.member!.name.toString(),
            email: profileModel.member!.email.toString(),
            phone: profileModel.member!.phone.toString(),
            gender: gender,
            dob: dateOfBirthEng,
          ),
          'admin/user-profile/update/${profileModel.id}');

      if (statusCode == 200) {
        continueBtnBloc.storeData(false);
        Navigator.pop(context);
        pop_upHelper.popUpNavigatorPop(
            context, 1, CoolAlertType.success, 'Profile Updated');
        if (type == 'isPackageBooking') {
          isPackageBookingBloc.storeData(true);
        } else if (type == 'isAddFamily') {
          isAddFamilyProfileUpdateBloc.storeData(true);
        }
      } else {
        continueBtnBloc.storeData(false);
      }
    }
  }

  return StatefulBuilder(builder: (context, setState) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox12(),
              Container(
                color: backgroundColor,
                width: maxWidth(context),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: backgroundColor,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              const SizedBox12(),
              testList.contains('dobNull')
                  ? Text(
                      'Update profile to continue',
                      style: kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    )
                  : Text(
                      'Add Family to continue',
                      style: kStyleNormal.copyWith(
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
              const SizedBox32(),
              testList.contains('dobNull')
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date of birth',
                          style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold, color: kBlack),
                        ),
                        const SizedBox16(),
                        widgetDatePicker(
                            context,
                            kStyleNormal,
                            dateOfBirthNep ?? 'YYYY-MM-DD',
                            dateOfBirthNep,
                            Icons.cake_outlined,
                            kWhite, onValueChanged: (value) {
                          setState(() {
                            dateOfBirthNep = value.nepaliDate;
                            dateOfBirthEng = value.englishDate;
                          });
                        }),
                        const SizedBox12(),
                        myGender(
                            context,
                            kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold, color: kBlack),
                            kWhite,
                            gender, onValueChanged: (value) {
                          gender = value;
                        }),
                        const SizedBox24(),
                      ],
                    )
                  : Container(),
              StreamBuilder<dynamic>(
                  initialData: false,
                  stream: continueBtnBloc.stateStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return myBtnLoading(context, 50.0);
                    } else {
                      return SizedBox(
                        width: maxWidth(context),
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Continue',
                          kStyleNormal.copyWith(
                              color: Colors.white, fontSize: 16.0),
                          () {
                            continueBtn(setState, type);
                          },
                        ),
                      );
                    }
                  }),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  });
}
