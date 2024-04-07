import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/AddShippingDetails.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class ListOfAddressScreen extends StatefulWidget {
  const ListOfAddressScreen({Key? key}) : super(key: key);

  @override
  State<ListOfAddressScreen> createState() => _ListOfAddressScreenState();
}

class _ListOfAddressScreenState extends State<ListOfAddressScreen> {
  List<UserDetailsDatabaseModel> userDetailsDatabaseModel = [];
  List<UserDetailsDatabaseModel> sendDataWithSelectBtn = [];
  int selectedIndex = -1;
  String? isDefaultAddress;

  @override
  void initState() {
    super.initState();
    getFromUserDetailsLocalDB();
  }

  void getFromUserDetailsLocalDB() async {
    int userID = int.parse(sharedPrefs.getUserID('userID'));
    userDetailsDatabaseModel =
        await MyDatabase.instance.fetchDataFromUserDetails(userID);
    setState(() {
      isDefaultAddress = sharedPrefs.getFromDevice('isDefaultAddressID');
    });
  }

  void _selectBtn() {
    Navigator.pop(context, sendDataWithSelectBtn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
          title: 'Select Shipping address',
          color: backgroundColor,
          borderRadius: 12.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  if (userDetailsDatabaseModel.length == 5) {
                    myToast.toast('Can\'t address more than 5 address');
                  } else {
                    var myPoppedData =
                        await swipeTo(context, AddShippingDetailsScreen());
                    setState(() {
                      userDetailsDatabaseModel = myPoppedData;
                      isDefaultAddress =
                          sharedPrefs.getFromDevice('isDefaultAddressID');
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: Icon(
                              Icons.add,
                              size: 18.0,
                              color: myColor.primaryColorDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 8.0),
                            margin: const EdgeInsets.only(bottom: 2.0),
                            child: Text(
                              'Add new address',
                              style: kStyleNormal.copyWith(
                                color: myColor.primaryColorDark,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              userDetailsDatabaseModel.isEmpty
                  ? Container()
                  : ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userDetailsDatabaseModel.length,
                      itemBuilder: (ctx, i) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = i;
                                  sendDataWithSelectBtn.clear();
                                  sendDataWithSelectBtn
                                      .add(UserDetailsDatabaseModel(
                                    address:
                                        userDetailsDatabaseModel[selectedIndex]
                                            .address
                                            .toString(),
                                    addressType:
                                        userDetailsDatabaseModel[selectedIndex]
                                            .addressType
                                            .toString(),
                                    fullName:
                                        userDetailsDatabaseModel[selectedIndex]
                                            .fullName
                                            .toString(),
                                    phoneNumber:
                                        userDetailsDatabaseModel[selectedIndex]
                                            .phoneNumber
                                            .toString(),
                                    isAddressDefault:
                                        userDetailsDatabaseModel[selectedIndex]
                                            .isAddressDefault
                                            .toString(),
                                  ));
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: selectedIndex == i
                                          ? myColor.primaryColorDark
                                          : Colors.transparent,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 6.0),
                                    SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: userDetailsDatabaseModel[i]
                                                  .addressType ==
                                              'Home'
                                          ? Icon(
                                              Icons.home,
                                              size: 20.0,
                                              color: myColor.primaryColorDark,
                                            )
                                          : userDetailsDatabaseModel[i]
                                                      .addressType ==
                                                  'Office'
                                              ? Icon(
                                                  Icons.work,
                                                  size: 17.0,
                                                  color:
                                                      myColor.primaryColorDark,
                                                )
                                              : Icon(
                                                  Icons.location_on,
                                                  size: 20.0,
                                                  color:
                                                      myColor.primaryColorDark,
                                                ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      maxWidth(context) - 145,
                                                  child: Text(
                                                    userDetailsDatabaseModel[i]
                                                        .address
                                                        .toString(),
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox8(),
                                                Text(
                                                  userDetailsDatabaseModel[i]
                                                      .fullName
                                                      .toString(),
                                                  style: kStyleNormal,
                                                ),
                                                const SizedBox2(),
                                                Text(
                                                  userDetailsDatabaseModel[i]
                                                      .phoneNumber
                                                      .toString(),
                                                  style: kStyleNormal.copyWith(
                                                    fontSize: 13,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                                const SizedBox2(),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.5),
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(5.0),
                                                      ),
                                                      border: Border.all(
                                                          color: myColor
                                                              .primaryColorDark)),
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Row(
                                                    children: [
                                                      // Icon(
                                                      //   addressTypeList[i]
                                                      //       .iconData,
                                                      //   size: 14.0,
                                                      //   color: myColor
                                                      //       .primaryColorDark,
                                                      // ),
                                                      const SizedBox(
                                                          width: 5.0),
                                                      Text(
                                                        userDetailsDatabaseModel[
                                                                i]
                                                            .addressType
                                                            .toString(),
                                                        style: kStyleNormal
                                                            .copyWith(
                                                                fontSize: 12.0,
                                                                color: myColor
                                                                    .primaryColorDark),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                isDefaultAddress ==
                                                        userDetailsDatabaseModel[
                                                                i]
                                                            .id
                                                            .toString()
                                                    ? Container(
                                                        margin: const EdgeInsets
                                                            .all(5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: myColor
                                                                    .primaryColorDark,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                                ),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .white)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.location_on,
                                                              size: 14.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            const SizedBox(
                                                                width: 5.0),
                                                            Text(
                                                              'Default',
                                                              style: kStyleNormal
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.0,
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 20.0,
                                        color: selectedIndex == i
                                            ? myColor.primaryColorDark
                                            : Colors.grey[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.0,
                              right: 16.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        selectedIndex = -1;
                                      });
                                      print('i - $i');
                                      print(
                                          'userDetailsDatabaseModel - ${userDetailsDatabaseModel.length}');
                                      print(
                                          'sendDataWithSelectBtn - ${sendDataWithSelectBtn.length}');

                                      print('selectedIndex - $selectedIndex');
                                      var myPoppedData = await goThere(
                                          context,
                                          AddShippingDetailsScreen(
                                              editData:
                                                  userDetailsDatabaseModel[i]));
                                      setState(() {
                                        userDetailsDatabaseModel = myPoppedData;
                                        // sendDataWithSelectBtn.clear();
                                        // sendDataWithSelectBtn = myPoppedData;
                                        isDefaultAddress =
                                            sharedPrefs.getFromDevice(
                                                'isDefaultAddressID');
                                      });
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 17.0,
                                      color: myColor.dialogBackgroundColor,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  GestureDetector(
                                    onTap: () {
                                      if (isDefaultAddress !=
                                          userDetailsDatabaseModel[i]
                                              .id
                                              .toString()) {
                                        popUpHelper().popUpDelete(context, () {
                                          MyDatabase.instance.deleteAddress(
                                              userDetailsDatabaseModel[i]
                                                  .id!
                                                  .toInt());
                                          sharedPrefs.removeFromDevice(
                                              'addressTypeName');
                                          Navigator.pop(context);
                                          getFromUserDetailsLocalDB();
                                        });
                                      } else {
                                        myToast.toast(
                                            'Set another default address first');
                                      }
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 17.0,
                                      color: myColor.dialogBackgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // padding: const EdgeInsets.symmetric(vertical: 14.0),
        margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        height: 50.0,
        child: myCustomButton(
            context,
            myColor.primaryColorDark,
            'Select',
            kStyleNormal.copyWith(
              color: Colors.white,
              fontSize: 16.0,
            ),
            selectedIndex != -1
                ? () {
                    _selectBtn();
                  }
                : () {
                    myToast.toast('Select atleast one address');
                  }),
      ),
    );
  }
}
