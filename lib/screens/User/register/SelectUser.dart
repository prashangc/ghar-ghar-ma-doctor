import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/register/BecomePartner.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({Key? key}) : super(key: key);

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  int selectedIndex = -1;
  UserTypeModel? userType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: 30.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: Text(
            '',
            style: kStyleTitle2.copyWith(
                color: myColor.primaryColorDark, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select',
              style: kStyleNormal.copyWith(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'User Type',
              style: kStyleNormal.copyWith(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox32(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.8 / 4,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: userTypeList.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return userCard(userTypeList[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget userCard(UserTypeModel list, index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        goThere(
            context,
            BecomePartnerScreen(
              userTypeModel: list,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor.withOpacity(0.6),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              6.0,
            ),
          ),
          //   border: selectedIndex == index
          //       ? Border.all(color: myColor.primaryColorDark)
          //       : Border.all(color: myColor.dialogBackgroundColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 12.0),
                  width: maxWidth(context),
                  child: CircleAvatar(
                    backgroundColor: backgroundColor,
                    radius: 35.0,
                    child: list.image,
                  ),
                ),
                Positioned(
                  right: 5.0,
                  top: 5.0,
                  child: Icon(
                    selectedIndex == index ? Icons.check_circle : Icons.circle,
                    color: selectedIndex == index
                        ? myColor.primaryColorDark.withOpacity(0.3)
                        : Colors.grey[200],
                    size: 18.0,
                  ),
                ),
              ],
            ),
            Text(
              list.name.toString(),
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
