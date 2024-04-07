import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/UpdateEmail/UpdateEmailScreen.dart';
import 'package:ghargharmadoctor/screens/User/profile/UpdatePhoneNumber/UpdatePhoneNumberScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:open_file/open_file.dart';

enum ButtonState { init, loading, done }

class ProfileDetails extends StatefulWidget {
  ProfileModel profileModel;
  final String? showMessage;

  ProfileDetails({Key? key, required this.profileModel, this.showMessage})
      : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ButtonState state = ButtonState.init;
  int selectedFamilyRadioBtn = 0;
  final _form = GlobalKey<FormState>();
  FilePickerResult? result;
  File? myFile;
  File? fileImage;
  List<PlatformFile>? files;
  StateHandlerBloc? formBloc, readOnlyBloc;
  String? _fullName;
  String? image;
  String? _email;
  String? _phone;
  String? _address;
  String? _country;
  String? _bloodGroup;
  String? _weight;
  String? _height;
  String? _feet, _inch;
  String? _gender, _dateOfBirthEng, _dateOfBirthNep, _profilePicture;
  String? _urlID;
  String? _memberType;
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  String? value;
  List<GetIDNameModel> bloodGroupList = [];
  final bool _formChanged = false;

  @override
  void initState() {
    super.initState();
    formBloc = StateHandlerBloc();
    readOnlyBloc = StateHandlerBloc();
    _urlID = widget.profileModel.id.toString();
    _bloodGroup = widget.profileModel.bloodGroup;
    _profilePicture = widget.profileModel.imagePath;
    covertEnglishDateToNepali();
    _email = widget.profileModel.member!.email;
    _gender = widget.profileModel.gender;
    _address = widget.profileModel.address;
    _country = widget.profileModel.country;
    _fullName = widget.profileModel.member!.name;
    _memberType = widget.profileModel.memberType;
    _phone = widget.profileModel.member!.phone;
    _weight = widget.profileModel.weight;
    _height = widget.profileModel.height;
    // formatHeight(_height);
    _feet = widget.profileModel.heightFeet;
    _inch = widget.profileModel.heightInch;
    bloodGroupList.clear();
    for (int i = 0; i < bloodGroupData.length; i++) {
      bloodGroupList.add(GetIDNameModel(
        id: bloodGroupData[i],
        name: bloodGroupData[i],
      ));
    }
  }

  // formatHeight(meters) {
  //   if (meters != null) {
  //     double totalInches = double.parse(meters.toString()) / 0.0254;
  //     int feet = (totalInches / 12).floor();
  //     double inches = totalInches % 12;

  //     if (inches == 12) {
  //       inches = 0;
  //       feet++;
  //     }
  //     setState(() {
  //       _feet = feet.toString();
  //       _inch = inches.round().toString();
  //     });
  //   }
  // }

  covertEnglishDateToNepali() {
    if (widget.profileModel.dob != null) {
      DateTime date = DateTime.parse(widget.profileModel.dob.toString());
      _dateOfBirthEng = widget.profileModel.dob;
      _dateOfBirthNep = date.toNepaliDateTime().toString().substring(0, 10);
    } else {
      _dateOfBirthNep = widget.profileModel.dob;
      _dateOfBirthEng = widget.profileModel.dob;
    }
  }

  void _refresh() {
    setState(() {
      var test = sharedPrefs.getFromDevice("userProfile");
      widget.profileModel = ProfileModel.fromJson(json.decode(test));
    });
  }

  void _onFormChanged() {
    if (!_formChanged) {
      formBloc!.storeData(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isStretched = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return WillPopScope(
      onWillPop: () async {
        if (widget.showMessage != null) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          goThere(
              context,
              const MainHomePage(
                index: 4,
                tabIndex: 0,
              ));
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: RefreshIndicator(
          edgeOffset: 0,
          strokeWidth: 2.0,
          color: Colors.white,
          backgroundColor: myColor.primaryColorDark,
          onRefresh: () async {
            _refresh();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox12(),
                  Form(
                    key: _form,
                    onChanged: _onFormChanged,
                    child: StreamBuilder<dynamic>(
                        initialData: false,
                        stream: readOnlyBloc!.stateStream,
                        builder: (c, readOnlySnap) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: DottedBorder(
                                  color: myColor.primaryColor,
                                  padding: const EdgeInsets.all(0.0),
                                  borderType: BorderType.Circle,
                                  dashPattern: const [8, 8],
                                  strokeWidth: 2,
                                  child: Column(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              shape: BoxShape.circle,
                                            ),
                                            child: myCachedNetworkImageCircle(
                                              120.0,
                                              120.0,
                                              widget.profileModel.imagePath
                                                  .toString(),
                                              BoxFit.cover,
                                            ),
                                          ),
                                          isStretched
                                              ? cameraIconWidget()
                                              : loadingIconWidget(isDone),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox24(),
                              widget.showMessage == 'isBuyingPackage'
                                  ? profileUpdateMsg('buy package.')
                                  : widget.showMessage == 'isAddingFamily'
                                      ? profileUpdateMsg('add family.')
                                      : widget.showMessage == 'confirmReq'
                                          ? profileUpdateMsg('confirm request.')
                                          : widget.showMessage ==
                                                  'isDrinkingWater'
                                              ? profileUpdateMsg(
                                                  'calculate your daily water intake.')
                                              : Container(),
                              mytextFormFieldWithPrefixIcon(
                                context,
                                _fullNameFocusNode,
                                'Full Name',
                                _fullName ?? 'Enter your fullname',
                                'Enter your fullname',
                                _fullName,
                                Icons.perm_identity_outlined,
                                Colors.white.withOpacity(0.4),
                                onValueChanged: (value) {
                                  _fullName = value;
                                },
                                readOnly: readOnlySnap.data,
                              ),
                              Text(
                                'Date of Birth',
                                style: kStyleNormal.copyWith(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox16(),
                              widgetDatePicker(
                                  context,
                                  kStyleNormal.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                  ),
                                  _dateOfBirthNep ?? 'YYYY-MM-DD',
                                  _dateOfBirthNep,
                                  Icons.cake_outlined,
                                  Colors.white.withOpacity(0.4),
                                  onValueChanged: (value) {
                                setState(() {
                                  _dateOfBirthNep = value.nepaliDate;
                                  _dateOfBirthEng = value.englishDate;
                                });
                              }, disableDateType: 'future'),
                              const SizedBox16(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Phone Number',
                                    style: kStyleNormal.copyWith(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  widget.profileModel.member!.phoneVerified == 0
                                      ? Row(
                                          children: [
                                            Text(
                                              '(',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 11.0,
                                                color: kRed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              'Unverified',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 11.0,
                                                color: kRed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 6.0),
                                            Icon(Icons.error_outline_outlined,
                                                color: kRed, size: 14.0),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              ')',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 11.0,
                                                color: kRed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              '(',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 11.0,
                                                color: kGreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              'Verified',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 11.0,
                                                color: kGreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 3.0),
                                            Icon(Icons.check_circle,
                                                color: kGreen, size: 14.0),
                                            const SizedBox(width: 2.0),
                                            Text(
                                              ')',
                                              style: kStyleNormal.copyWith(
                                                fontSize: 11.0,
                                                color: kGreen,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                              const SizedBox16(),
                              GestureDetector(
                                onTap: () async {
                                  if (readOnlySnap.data == false) {
                                    if (validationForm()) {
                                      var myPoppedData = await goThere(
                                          context,
                                          UpdatePhoneNumberScreen(
                                            dob: _dateOfBirthEng,
                                            gender: _gender,
                                          ));

                                      if (myPoppedData != null) {
                                        var test = await sharedPrefs
                                            .getFromDevice("userProfile");
                                        ProfileModel profileModel =
                                            ProfileModel.fromJson(
                                                json.decode(test));
                                        setState(() {
                                          widget.profileModel = profileModel;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: myCountryCodePicker(
                                  hintText: _phone ?? 'Enter phone number',
                                  bgColor: kWhite.withOpacity(0.4),
                                  isEditable: false,
                                  onValueChanged: (value) {
                                    _phone = value;
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('asda');
                                },
                                child: myEmailTextFormFieldWithPrefixIcon(
                                    context,
                                    'Email',
                                    _email ?? 'Enter your fullname',
                                    _email,
                                    Icons.email_outlined,
                                    kWhite.withOpacity(0.4),
                                    onValueChanged: (value) {
                                      _email = value;
                                    },
                                    isReadOnly: true,
                                    emailOnTap: () async {
                                      var myPoppedData = await goThere(
                                          context,
                                          UpdateEmailScreen(
                                            email: widget
                                                .profileModel.member!.email
                                                .toString(),
                                          ));

                                      if (myPoppedData != null) {
                                        var test = await sharedPrefs
                                            .getFromDevice("userProfile");
                                        ProfileModel profileModel =
                                            ProfileModel.fromJson(
                                                json.decode(test));
                                        setState(() {
                                          widget.profileModel = profileModel;
                                        });
                                      }
                                    }),
                              ),
                              mytextFormFieldWithPrefixIcon(
                                context,
                                _addressFocusNode,
                                'Address',
                                _address ?? 'Enter your address',
                                'Enter your address',
                                _address,
                                Icons.location_on_outlined,
                                Colors.white.withOpacity(0.4),
                                onValueChanged: (value) {
                                  _address = value;
                                },
                                readOnly: readOnlySnap.data,
                              ),
                              SizedBox(
                                width: maxWidth(context),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                        height: 85.0,
                                        child: myCountryPicker(
                                          titleText: "Country",
                                          initialCountry: _country,
                                          onValueChanged: (v) {
                                            _country = v;
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Text(
                                            'Blood Group',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox16(),
                                          myDropDown2(
                                            context,
                                            Icons.water_drop_outlined,
                                            Colors.black,
                                            Colors.black,
                                            maxWidth(context),
                                            _bloodGroup ??
                                                bloodGroupList[0].name,
                                            readOnlySnap.data == true
                                                ? []
                                                : bloodGroupList,
                                            myColor.scaffoldBackgroundColor
                                                .withOpacity(0.4),
                                            onValueChanged: (value) {
                                              setState(() {
                                                _bloodGroup = value.name;
                                              });
                                              formBloc!.storeData(true);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox16(),
                              myNumberTextFormField(
                                'Weight',
                                _weight ?? 'In Kg',
                                'Enter your weight',
                                _weight,
                                Icons.line_weight_rounded,
                                kWhite.withOpacity(0.4),
                                onValueChanged: (value) {
                                  _weight = value;
                                },
                                readOnlyStatus: readOnlySnap.data,
                              ),
                              myHeightCard(
                                context,
                                onValueChanged: (v) {
                                  _height = v.toString();
                                  formBloc!.storeData(true);
                                },
                                onValueChangedFt: (v) {
                                  _feet = v.toString();
                                  formBloc!.storeData(true);
                                },
                                onValueChangedIn: (v) {
                                  _inch = v.toString();
                                  formBloc!.storeData(true);
                                },
                                initialFeet: _feet,
                                initialInch: _inch,
                                readOnly: readOnlySnap.data,
                              ),
                              myGender(
                                  context,
                                  kStyleNormal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0),
                                  Colors.white.withOpacity(0.4),
                                  _gender, onValueChanged: (value) {
                                _gender = value;
                                formBloc!.storeData(true);
                              }, readOnly: readOnlySnap.data),
                              const SizedBox24(),
                              _getActionButtons(),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getActionButtons() {
    return Column(
      children: [
        StreamBuilder<dynamic>(
            initialData: _formChanged,
            stream: formBloc!.stateStream,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return SizedBox(
                  width: maxWidth(context),
                  height: 55.0,
                  child: myCustomButton(
                    context,
                    myColor.primaryColorDark.withOpacity(0.12),
                    'Save',
                    kStyleButton,
                    () {},
                  ),
                );
              } else if (snapshot.data == 'loading') {
                return myBtnLoading(context, 55.0);
              } else {
                return SizedBox(
                  width: maxWidth(context),
                  height: 55.0,
                  child: myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Save',
                    kStyleButton,
                    () {
                      saveBtn(context);
                    },
                  ),
                );
              }
            }),
        const SizedBox8(),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: myColor.primaryColorDark, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: maxWidth(context),
          height: 55,
          child: TextButton(
            onPressed: () {
              cancelBtn();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.sourceSansPro(
                fontSize: 18,
                color: myColor.primaryColorDark,
              ),
            ),
          ),
        ),
        const SizedBox16(),
        const SizedBox(height: 55),
      ],
    );
  }

  validationForm() {
    if (_dateOfBirthNep == null) {
      myToast.toast('Please update Date of Birth');
      return false;
    } else if (_gender == null) {
      myToast.toast('Please update gender');
      return false;
    } else {
      return true;
    }
  }

  void saveBtn(context) async {
    readOnlyBloc!.storeData(true);
    if (validationForm()) {
      FocusManager.instance.primaryFocus?.unfocus();
      formBloc!.storeData('loading');
      int statusCode;
      statusCode = await API().postData(
          context,
          PatchProfileModel(
            name: _fullName,
            address: _address,
            country: _country ?? '🇳🇵    Nepal',
            dob: _dateOfBirthEng,
            email: _email,
            phone: _phone,
            height: _height,
            weight: _weight,
            bloodGroup: _bloodGroup ?? bloodGroupList[0].name,
            gender: _gender,
            heightFeet: _feet,
            heightInch: _inch,
          ),
          'admin/user-profile/update/$_urlID');

      if (statusCode == 200) {
        var profileResp =
            await API().getData(context, endpoints.getUserProfileEndpoint);
        ProfileModel profileModel = ProfileModel.fromJson(profileResp);
        sharedPrefs.storeToDevice("userProfile", jsonEncode(profileModel));
        if (profileResp != null) {
          if (widget.showMessage != null) {
            setWaterDetails();
            refreshMainSreenBloc.storeData(profileModel);
            Navigator.pop(context, GetIDNameModel(id: '1'));
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
            goThere(
                context,
                const MainHomePage(
                  index: 4,
                  tabIndex: 0,
                ));
            setWaterDetails();
            pop_upHelper.customAlert(context, 'SUCCESS', 'Profile Updated');
            formBloc!.storeData(false);
            readOnlyBloc!.storeData(false);
            myfocusRemover(context);
          }
        }
      } else {
        readOnlyBloc!.storeData(false);
        formBloc!.storeData(false);
      }
    }
  }

  setWaterDetails() {
    if (_gender != null && _weight != null) {
      double genderConstant = (_gender == 'Male') ? 0.035 : 0.031;
      double waterIntake =
          double.parse(_weight.toString()) * genderConstant * 1000;
      if (waterIntake == waterIntake.toInt()) {
        sharedPrefs.storeToDevice("waterToDrinkDaily", waterIntake.toString());
      } else {
        sharedPrefs.storeToDevice(
            "waterToDrinkDaily", waterIntake.toStringAsFixed(2).toString());
      }
    }
  }

  void cancelBtn() {
    myfocusRemover(context);
    Navigator.pop(context);
    Navigator.pop(context);
    goThere(
        context,
        const MainHomePage(
          index: 4,
          tabIndex: 0,
        ));
  }

  Future pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(source: source);
      if (imageFile == null) return;
      final File saveFile = File(imageFile.path);

      List<int> imageBytes = saveFile.readAsBytesSync();
      String base64Image = "data:image/png;base64,${base64Encode(imageBytes)}";
      setState(() {
        Navigator.pop(context);
        image = base64Image;
        uploadPhoto();
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed $e");
      }
    }
  }

  void uploadPhoto() async {
    setState(() => state = ButtonState.loading);
    // String imageName = image!.path.split('/').last;
    // print('only image name : $imageName');
    int statusCode;
    statusCode = await API().postData(
      context,
      PatchProfileModel(
        name: _fullName,
        email: _email,
        phone: _phone,
        dob: _dateOfBirthEng,
        gender: _gender,
        image: image,
      ),
      'admin/user-profile/update/$_urlID',
    );

    // statusCode = await API().postUserImage(
    //   _fullName.toString(),
    //   _email.toString(),
    //   _phone.toString(),
    //   _dateOfBirth.toString(),
    //   _gender.toString(),
    //   image!,
    //   'admin/user-profile/update/$_urlID',
    // );

    if (statusCode == 200) {
      _refresh();
      Fluttertoast.showToast(
        textColor: Colors.white,
        backgroundColor: Colors.grey,
        msg: "Profile Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      setState(() => state = ButtonState.done);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => state = ButtonState.init);
      setState(() {});
    } else {
      setState(() => state = ButtonState.init);
      // pop_upHelper.popUpNavigatorPop(
      //     context, 1, CoolAlertType.error, 'Please provide valid credentials');
      // mySnackbar.mySnackBar(
      //     context, 'Can\'t Login! Error: $statusCode', Colors.red);
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: maxWidth(context),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          const Text(
            "Choose Profile Picture",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor.primaryColorDark,
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ),
              const SizedBox(width: 25.0),
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColor.primaryColorDark,
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("Gallery")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cameraIconWidget() {
    return Positioned(
      top: 90,
      left: 1,
      right: 1,
      child: CircleAvatar(
        backgroundColor: myColor.primaryColorDark,
        radius: 23.0,
        child: GestureDetector(
          onTap: () async {
            if (validationForm()) {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            }
          },
          child: const Icon(
            Icons.camera_alt,
            size: 25.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget loadingIconWidget(bool isDone) {
    final color = isDone ? Colors.green : myColor.primaryColorDark;
    return Positioned(
      top: 90,
      left: 1,
      right: 1,
      child: CircleAvatar(
          backgroundColor: color,
          radius: 23.0,
          child: isDone
              ? const Icon(
                  Icons.check,
                  size: 25.0,
                  color: Colors.white,
                )
              : const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 45.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.white,
                  ))),
    );
  }

  Widget buildFile(PlatformFile file) {
    final kb = file.size / 1000;
    final mb = kb / 1000;

    final fileSize = mb >= 1 ? mb.toStringAsFixed(2) : kb.toStringAsFixed(2);
    final extension = file.extension ?? 'none';
    // final color = getColor(extension);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(255, 247, 245, 245),
        ),
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            OpenFile.open(file.path);
          },
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    file.extension == "jpg"
                        ? 'assets/jpgIconSolid.png'
                        : file.extension == "mp4"
                            ? 'assets/mp3IconSolid.png'
                            : file.extension == "jpeg"
                                ? 'assets/jpgIconSolid.png'
                                : file.extension == "mov"
                                    ? 'assets/mp3IconSolid.png'
                                    : file.extension == "pdf"
                                        ? 'assets/pdfIconsSolid.png'
                                        : file.extension == "png"
                                            ? 'assets/pngIconsSolid.png'
                                            : file.extension == "doc"
                                                ? 'assets/docIcons.png'
                                                : file.extension == "docx"
                                                    ? 'assets/docIcons.png'
                                                    : 'assets/logo.png',
                    width: 35,
                  )),
              Expanded(
                child: ListTile(
                  title: Text(
                    file.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Row(
                    children: [
                      const Text(
                        "Size: ",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        fileSize.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(width: 3.0),
                      Text(
                        file.size <= 1000000 ? "KB" : "MB",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  trailing: Image.asset(
                    'assets/crossMark.png',
                    width: 20,
                    color: const Color.fromARGB(255, 180, 178, 178),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileUpdateMsg(msg) {
    return Column(
      children: [
        const SizedBox16(),
        infoCard(context, const Color.fromARGB(255, 253, 184, 179), kRed,
            'Please update your profile to $msg'),
        const SizedBox16(),
      ],
    );
  }
}
