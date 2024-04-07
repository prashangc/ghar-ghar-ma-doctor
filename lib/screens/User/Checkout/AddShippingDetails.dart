import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/MyGoogleMap.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

import 'package:geocoding/geocoding.dart';

class AddShippingDetailsScreen extends StatefulWidget {
  UserDetailsDatabaseModel? editData;

  AddShippingDetailsScreen({Key? key, this.editData}) : super(key: key);

  @override
  State<AddShippingDetailsScreen> createState() =>
      _AddShippingDetailsScreenState();
}

class _AddShippingDetailsScreenState extends State<AddShippingDetailsScreen> {
  final _form = GlobalKey<FormState>();
  String? _fullName, _phone, _address, _addressName;
  double? myLat, myLng;
  List<Predictions> placeSuggestion = [];
  GoogleMapModel? testPopModal;
  String emptyString = '';
  TextEditingController addressController = TextEditingController();
  ApiHandlerBloc? mapBloc;
  bool isSwitched = false;
  bool _isVisible = false;
  int selectedAddressType = -1;
  List<UserDetailsDatabaseModel> userDetailsDatabaseModel = [];
  final List<String> _addressTypeAlreadyInDB = [];
  String? isDefaultAddress;
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _nmcNumberFocusNode = FocusNode();
  List<String> testList = [];

  @override
  void initState() {
    super.initState();
    isDefaultAddress = sharedPrefs.getFromDevice('isDefaultAddressID');
    if (widget.editData == null) {
      _fullName = '';
      _phone = '';
      _addressName = '';
      testPopModal = GoogleMapModel(address: '');
    } else {
      _fullName = widget.editData!.fullName.toString();
      _phone = widget.editData!.phoneNumber.toString();
      _addressName = widget.editData!.addressType.toString();
      testPopModal =
          GoogleMapModel(address: widget.editData!.address.toString());
    }
    mapBloc = ApiHandlerBloc();
    mapBloc!.fetchGoogleMapAPIAutoComplete(emptyString);
    getUserDetailsFromLocalDB();
  }

  getUserDetailsFromLocalDB() async {
    int userID = int.parse(sharedPrefs.getUserID('userID'));
    userDetailsDatabaseModel =
        await MyDatabase.instance.fetchDataFromUserDetails(userID);

    setState(() {
      testList.clear();
      for (var element in userDetailsDatabaseModel) {
        testList.add(element.addressType!);
      }

      print('testList = $testList');
      if (userDetailsDatabaseModel.isEmpty) {
        isSwitched = !isSwitched;
      } else {
        if (widget.editData != null &&
            isDefaultAddress == widget.editData!.id.toString()) {
          isSwitched = true;
        } else {
          isSwitched = false;
        }
      }
    });
    setState(() {
      if (testList.contains('Home') && testList.contains('Office')) {
        _isVisible = true;
        selectedAddressType = 2;
      }
    });
  }

  void myAutoCompleteLocationTap(myIndex) async {
    FocusManager.instance.primaryFocus?.unfocus();
    mapBloc!.fetchGoogleMapAPIAutoComplete('');

    List<Location> locations = await locationFromAddress(
        placeSuggestion[myIndex].description.toString());
    String place = placeSuggestion[myIndex].description.toString();
    setState(() {
      addressController.clear();
      testPopModal = GoogleMapModel(
        address: place,
        lat: locations.last.latitude,
        lng: locations.last.longitude,
      );
      myLat = locations.last.latitude;
      myLng = locations.last.longitude;
    });
  }

  _getLatLng(Function mySetState) async {}

  void _updateBtn() async {
    if (formValidation()) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (isSwitched == true) {
        sharedPrefs.storeToDevice(
            'isDefaultAddressID', '${widget.editData!.id}');
      }
      MyDatabase.instance.updateAddressTable(_fullName, testPopModal!.address,
          _phone, _addressName, widget.editData!.id);
      int userID = int.parse(sharedPrefs.getUserID('userID'));
      userDetailsDatabaseModel =
          await MyDatabase.instance.fetchDataFromUserDetails(userID);
      Navigator.pop(context, userDetailsDatabaseModel);
    }
  }

  void _addAddressBtn() async {
    if (formValidation()) {
      // var isValid = _form.currentState?.validate();
      // if (!isValid!) {
      //   print('provide valid data');
      //   FocusManager.instance.primaryFocus?.unfocus();
      //   return;
      // }
      FocusManager.instance.primaryFocus?.unfocus();
      int UserID = int.parse(sharedPrefs.getUserID('userID'));
      var myUserDetails = UserDetailsDatabaseModel(
        userID: int.parse(
          UserID.toString(),
        ),
        fullName: _fullName,
        address: testPopModal!.address.toString(),
        phoneNumber: _phone,
        addressType: _addressName ?? 'No address type selected',
        isAddressDefault: isSwitched.toString(),
      );
      var dbHelper = MyDatabase.instance.addUserDetailsToLocalDB(myUserDetails);

      print('my switch $isSwitched');
      List<UserDetailsDatabaseModel> userDetailsDatabaseModel =
          await MyDatabase.instance.fetchDataFromUserDetails(UserID);
      if (isSwitched == true) {
        sharedPrefs.storeToDevice(
            'isDefaultAddressID', '${userDetailsDatabaseModel.last.id}');
      }

      Navigator.pop(context, userDetailsDatabaseModel);
    }
  }

  formValidation() {
    if (_fullName == '') {
      myToast.toast('Name field can\'t be empty');
      return false;
    } else if (addressController.text.isNotEmpty) {
      myToast.toast('Address shouldn\'t be manually written');
      return false;
    } else if (testPopModal!.address == '') {
      myToast.toast('Address field can\'t be empty');
      return false;
    } else if (_phone == '') {
      myToast.toast('Phone field can\'t be empty');
      return false;
    } else if (widget.editData == null &&
        _isVisible == false &&
        selectedAddressType == -1) {
      myToast.toast('Select an address type');
      return false;
    } else if (
        // widget.editData != null &&
        //   (widget.editData!.addressType == 'Home' ||
        //       widget.editData!.addressType == 'Office') &&
        _isVisible == true) {
      print('_isVisible  is true');
      if (_addressName == '') {
        myToast.toast('enter address');
        return false;
      } else {
        widget.editData != null ? myToast.toast('Updated successfully') : null;
        return true;
      }
    } else {
      return true;
    }
  }

  test(String value) {
    if (testList.contains(value)) {
      return true;
    }
    //  else if (testList.contains('Home') &&
    //     testList.contains('Office') &&
    //     selectedAddressType == 2) {
    //   return true;
    // }
    else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: widget.editData != null
              ? 'Edit Shipping Details'
              : 'Add Shipping Details',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 14.0),
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          height: maxHeight(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Details',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox16(),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      mytextFormFieldWithPrefixIcon(
                        context,
                        _fullNameFocusNode,
                        'Full Name',
                        _fullName ?? '',
                        'Enter your name',
                        _fullName,
                        Icons.perm_identity_outlined,
                        kWhite.withOpacity(0.4),
                        onValueChanged: (value) {
                          _fullName = value;
                        },
                      ),
                      mytextFormFieldWithSuffixIcon(
                        context,
                        addressController,
                        'Address',
                        testPopModal!.address == ''
                            ? 'Select Address'
                            : testPopModal!.address.toString(),
                        'Select your address',
                        _address,
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 20,
                        ),
                        kWhite.withOpacity(0.4),
                        () async {
                          setState(() {
                            addressController.clear();
                          });
                          var myPoppedData =
                              await goThere(context, const MyGoogleMap());
                          setState(() {
                            testPopModal = myPoppedData;
                          });
                        },
                        onValueChanged: (value) {
                          setState(() {
                            mapBloc!.fetchGoogleMapAPIAutoComplete(value);
                          });
                        },
                      ),
                      StreamBuilder<ApiResponse<dynamic>>(
                        stream: mapBloc!.apiListStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return Container();
                              case Status.COMPLETED:
                                placeSuggestion = List<Predictions>.from(
                                    snapshot.data!.data
                                        .map((i) => Predictions.fromJson(i)));
                                return Container(
                                  decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12.0),
                                          bottomRight: Radius.circular(12.0))),
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: placeSuggestion.length,
                                      itemBuilder: (ctx, i) {
                                        return ListTile(
                                          onTap: () {
                                            myAutoCompleteLocationTap(i);
                                          },
                                          title: SizedBox(
                                            width: maxWidth(context),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 20,
                                                  color: Colors.grey[400],
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Text(
                                                    placeSuggestion[i]
                                                        .description
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: kStyleNormal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                );

                              case Status.ERROR:
                                return Container(
                                  width: maxWidth(context),
                                  height: 135.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('Server Error'),
                                  ),
                                );
                            }
                          }
                          return SizedBox(
                            width: maxWidth(context),
                          );
                        }),
                      ),
                      const SizedBox8(),
                      myNumberTextFormField(
                        'Phone Number',
                        _phone,
                        'Enter your phone number',
                        _phone,
                        Icons.call_outlined,
                        kWhite.withOpacity(0.4),
                        onValueChanged: (value) {
                          _phone = value;
                        },
                      ),
                      const SizedBox(height: 4.0),
                      widget.editData != null
                          ? Container()
                          : testList.contains('Home') &&
                                  testList.contains('Office') &&
                                  selectedAddressType == 2
                              ? Container()
                              : SizedBox(
                                  width: maxWidth(context),
                                  height: 40.0,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: addressTypeList.length,
                                      itemBuilder: (ctx, i) {
                                        return test(addressTypeList[i]
                                                .title
                                                .toString())
                                            // addressTypeInLocalStorage ==
                                            //         addressTypeList[i].title.toString()
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () {
                                                  myfocusRemover(context);
                                                  setState(() {
                                                    selectedAddressType = i;
                                                    if (addressTypeList[
                                                                selectedAddressType]
                                                            .title
                                                            .toString() ==
                                                        'Others') {
                                                      _isVisible = true;
                                                    } else {
                                                      _addressName =
                                                          addressTypeList[
                                                                  selectedAddressType]
                                                              .title
                                                              .toString();
                                                      _isVisible = false;
                                                      print(
                                                          'add $_addressName');
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(
                                                      color: selectedAddressType ==
                                                              i
                                                          ? myColor
                                                              .primaryColorDark
                                                          : kWhite
                                                              .withOpacity(0.4),
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
                                                      Icon(
                                                        addressTypeList[i]
                                                            .iconData,
                                                        size: 12.0,
                                                        color: selectedAddressType ==
                                                                i
                                                            ? Colors.white
                                                            : myColor
                                                                .primaryColorDark,
                                                      ),
                                                      const SizedBox(
                                                          width: 5.0),
                                                      Text(
                                                        addressTypeList[i]
                                                            .title
                                                            .toString(),
                                                        style: kStyleNormal.copyWith(
                                                            fontSize: 12.0,
                                                            color: selectedAddressType ==
                                                                    i
                                                                ? Colors.white
                                                                : myColor
                                                                    .primaryColorDark),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      }),
                                ),
                      const SizedBox(height: 6.0),
                      widget.editData != null &&
                              (widget.editData!.addressType == 'Home' ||
                                  widget.editData!.addressType == 'Office')
                          ? Container()
                          : Visibility(
                              visible: _isVisible,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mytextFormFieldWithPrefixIcon(
                                    context,
                                    FocusNode(),
                                    'Enter Address Name',
                                    _addressName ?? '',
                                    'Enter your address name',
                                    _addressName,
                                    Icons.perm_identity_outlined,
                                    kWhite.withOpacity(0.4),
                                    onValueChanged: (value) {
                                      _addressName = value;
                                    },
                                  ),
                                  const SizedBox8(),
                                ],
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Set as Default',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) async {
                              if (userDetailsDatabaseModel.isNotEmpty) {
                                if (widget.editData != null &&
                                    isDefaultAddress ==
                                        widget.editData!.id.toString()) {
                                  myToast.toast(
                                      'Set another default address first');
                                } else {
                                  myfocusRemover(context);
                                  setState(() {
                                    isSwitched = value;
                                    print(isSwitched);
                                  });
                                }
                              } else {
                                myfocusRemover(context);
                                myToast.toast(
                                    'Your initial address will be default. You can change later');
                              }
                            },
                            activeTrackColor:
                                myColor.primaryColorDark.withOpacity(0.3),
                            activeColor: myColor.primaryColorDark,
                            inactiveTrackColor: Colors.grey[200],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
          height: 142.0,
          color: myColor.dialogBackgroundColor,
          child: Column(
            children: [
              widget.editData != null
                  ? SizedBox(
                      width: maxWidth(context),
                      height: 55.0,
                      child: myCustomButton(
                          context,
                          (_fullName == widget.editData!.fullName &&
                                  testPopModal!.address ==
                                      widget.editData!.address &&
                                  _phone == widget.editData!.phoneNumber &&
                                  isSwitched == false)
                              // &&
                              // addressController.text.isEmpty &&
                              // testPopModal != null
                              ? Colors.white38
                              : myColor.primaryColorDark,
                          'Update',
                          kStyleNormal.copyWith(
                            color: addressController.text.isEmpty &&
                                    testPopModal != null
                                ? Colors.white
                                : myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                          ),
                          (_fullName == widget.editData!.fullName &&
                                  testPopModal!.address ==
                                      widget.editData!.address &&
                                  _phone == widget.editData!.phoneNumber &&
                                  isSwitched == false)
                              ? () {
                                  print('blank');
                                }
                              : () {
                                  _updateBtn();
                                }),
                    )
                  : SizedBox(
                      width: maxWidth(context),
                      height: 55.0,
                      child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Add Address',
                          kStyleNormal.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            letterSpacing: 0.5,
                          ), () {
                        _addAddressBtn();
                      }),
                    ),
              const SizedBox12(),
              SizedBox(
                width: maxWidth(context),
                height: 55.0,
                child: myWhiteButton(
                  context,
                  Colors.transparent,
                  'Cancel',
                  kStyleNormal.copyWith(
                    color: myColor.primaryColorDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 0.5,
                  ),
                  () {
                    sharedPrefs.removeFromDevice('isDefaultAddressID');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
