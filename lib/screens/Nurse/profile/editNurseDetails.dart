import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/NurseModel/NurseProfileModel/NurseProfileModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Nurse/main/mainHomePageNurse.dart';
import 'package:ghargharmadoctor/screens/Nurse/profile/refreshNurseMethod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

enum ButtonState { init, loading, done }

class EditNurseProfileDetails extends StatefulWidget {
  NurseProfileModel nurseProfileModel;

  EditNurseProfileDetails({Key? key, required this.nurseProfileModel})
      : super(key: key);

  @override
  State<EditNurseProfileDetails> createState() =>
      EditNurseProfileDetailsState();
}

class EditNurseProfileDetailsState extends State<EditNurseProfileDetails> {
  ButtonState state = ButtonState.init;
  List<GetIDNameModel> salutationList = [];

  List<GetIDNameModel> departmentDynamicModel = [];
  final _form = GlobalKey<FormState>();
  File? image, fileImage;
  FilePickerResult? result;
  PlatformFile? file;
  List<PlatformFile>? files;
  ApiHandlerBloc? departmentBloc;
  String? _fullName, _gender;
  String? _fee;
  String? _email;
  String? _phone;
  String? _address;
  String? _nncNumber;
  String? _urlID, _profilePicture;
  String? _qualification;
  String? _yearsPractised;
  List<String> departmentStringList = [];
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _qualificationFocusNode = FocusNode();
  final FocusNode _specializationFocusNode = FocusNode();
  String countryValue = "";
  bool _isLoading = false;
  final bool _isBtnActive = false;

  var userID;
  final List selectedIndexs = [];
  String? selectedGender;

  Icon cameraIcon = const Icon(
    Icons.camera_alt,
    size: 25.0,
    color: Colors.white,
  );

  Icon tickIcon = const Icon(
    Icons.check,
    size: 25.0,
    color: Colors.white,
  );

  String? value;

  bool _showOrHideSaveButton = true;

  @override
  void initState() {
    super.initState();
    departmentBloc = ApiHandlerBloc();
    departmentBloc!.fetchAPIList(endpoints.getDepartmentEndpoint);
    _urlID = widget.nurseProfileModel.id.toString();
    _profilePicture = widget.nurseProfileModel.imagePath;
    _email = widget.nurseProfileModel.user!.email;
    _address = widget.nurseProfileModel.address;
    _fullName = widget.nurseProfileModel.user!.name;
    _phone = widget.nurseProfileModel.user!.phone;
    _nncNumber = widget.nurseProfileModel.nncNo;
    _gender = widget.nurseProfileModel.gender;
    _fee = widget.nurseProfileModel.fee.toString();
    _yearsPractised = widget.nurseProfileModel.yearPracticed;
    _qualification = widget.nurseProfileModel.qualification;
    salutationList.clear();
    for (int i = 0; i < saluationData.length; i++) {
      salutationList.add(GetIDNameModel(
        id: saluationData[i],
        name: saluationData[i],
      ));
    }
  }

  void _refresh() {
    setState(() {
      var test = sharedPrefs.getFromDevice("nurseProfile");
      widget.nurseProfileModel = NurseProfileModel.fromJson(json.decode(test));
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isStretched = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        Navigator.pop(context);
        goThere(
            context,
            const MainHomePageNurse(
              index: 3,
            ));
        return false;
      },
      child: GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox8(),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: DottedBorder(
                          color: myColor.primaryColor,
                          padding: const EdgeInsets.all(0.0),
                          borderType: BorderType.Circle,
                          dashPattern: const [8, 8],
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: myCachedNetworkImageCircle(
                                      120.0,
                                      120.0,
                                      widget.nurseProfileModel.imagePath
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
                      myNumberTextFormField(
                        'NNC Number',
                        _nncNumber ?? 'Enter your nnc no',
                        'Enter your NNC number',
                        _nncNumber,
                        Icons.key,
                        kWhite.withOpacity(0.4),
                        onValueChanged: (value) {
                          _nncNumber = value;
                        },
                      ),
                      mytextFormFieldWithPrefixIcon(
                        context,
                        _fullNameFocusNode,
                        'Full Name',
                        _fullName ?? 'Enter your fullname',
                        'Enter your fullname',
                        _fullName,
                        Icons.person,
                        Colors.white.withOpacity(0.4),
                        onValueChanged: (value) {
                          _fullName = value;
                        },
                      ),
                      myEmailTextFormFieldWithPrefixIcon(
                        context,
                        'Email',
                        _email ?? 'Enter your email',
                        _email,
                        Icons.email_outlined,
                        Colors.white.withOpacity(0.4),
                        onValueChanged: (value) {
                          _email = value;
                        },
                      ),
                      mytextFormFieldWithPrefixIcon(
                        context,
                        _addressFocusNode,
                        'Address',
                        _address ?? 'Enter your address',
                        'Enter your address',
                        _address,
                        Icons.location_city,
                        Colors.white.withOpacity(0.4),
                        onValueChanged: (value) {
                          _address = value;
                        },
                      ),
                      myNumberTextFormField(
                        'Fee',
                        _fee == "null" ? 'Enter your fee' : _fee,
                        'Enter your fee',
                        _fee == "null" ? '' : _fee,
                        Icons.money,
                        kWhite.withOpacity(0.4),
                        onValueChanged: (value) {
                          _fee = value;
                        },
                      ),
                      myGender(
                          context,
                          kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                          Colors.white.withOpacity(0.4),
                          _gender, onValueChanged: (value) {
                        _gender = value;
                      }),
                      const SizedBox16(),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: myNumberTextFormField(
                              'Year Practised',
                              _yearsPractised ?? '1',
                              'Enter your year practised',
                              _yearsPractised,
                              Icons.height_rounded,
                              kWhite.withOpacity(0.4),
                              onValueChanged: (value) {
                                _yearsPractised = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 2,
                            child: mytextFormFieldWithPrefixIcon(
                              context,
                              _qualificationFocusNode,
                              'Qualification',
                              _qualification ?? 'Enter your qualification',
                              'Enter your qualification',
                              _qualification,
                              Icons.line_weight_rounded,
                              Colors.white.withOpacity(0.4),
                              onValueChanged: (value) {
                                _qualification = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox24(),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: myColor.primaryColor,
                                  backgroundColor: myColor.primaryColorDark),
                            )
                          : SizedBox(
                              width: maxWidth(context),
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.primaryColorDark,
                                  disabledForegroundColor: myColor
                                      .primaryColorDark
                                      .withOpacity(0.38),
                                  disabledBackgroundColor: myColor
                                      .primaryColorDark
                                      .withOpacity(0.12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                onPressed: () {
                                  saveBtn();
                                },
                                //  !_isBtnActive
                                //     ? () {
                                //         saveBtn();
                                //       }
                                //     : null,
                                child: Text(
                                  'Save',
                                  style: kStyleButton,
                                ),
                              ),
                            ),
                      const SizedBox8(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: myColor.primaryColorDark, width: 1.0),
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
                      const SizedBox12(),
                      const SizedBox32(),
                      const SizedBox32(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveBtn() async {
    setState(() {
      _isLoading = true;
    });
    int statusCode;
    statusCode = await API().postData(
        context,
        PatchNurseProfileModel(
          name: _fullName,
          address: _address,
          email: _email,
          phone: _phone,
          nncNo: _nncNumber,
          gender: _gender,
          yearPracticed: _yearsPractised,
          fee: _fee,
          qualification: _qualification,
        ),
        'admin/nurse-profile/update/$_urlID');

    FocusManager.instance.primaryFocus?.unfocus();

    if (statusCode == 200) {
      await refreshNurseProfile(context);
      Navigator.pop(context);

      pop_upHelper.customAlert(context, 'SUCCESS', 'Profile Updated');

      setState(() {
        _isLoading = false;
        _showOrHideSaveButton = true;
        myfocusRemover(context);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void cancelBtn() {
    setState(() {
      _showOrHideSaveButton = true;
      myfocusRemover(context);
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(source: source);
      if (imageFile == null) return;
      final File saveFile = File(imageFile.path);
      setState(() {
        Navigator.pop(context);
        image = saveFile;
        uploadPhoto();
      });
    } on PlatformException catch (e) {
      print("failed $e");
    }
  }

  void uploadPhoto() async {
    setState(() => state = ButtonState.loading);
    String imageName = image!.path.split('/').last;
    print('only image name : $imageName');

    int statusCode;
    statusCode = await API().postNurseImage(
      _fullName.toString(),
      _email.toString(),
      _phone.toString(),
      _nncNumber.toString(),
      _gender.toString(),
      _qualification.toString(),
      _yearsPractised.toString(),
      _address.toString(),
      image!,
      'admin/nurse-profile/update/$_urlID',
    );
    if (statusCode == 200) {
      _refresh();
      Fluttertoast.showToast(
        textColor: Colors.white,
        backgroundColor: Colors.grey,
        msg: "Profile Updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      setState(() => state = ButtonState.done);
      await Future.delayed(const Duration(seconds: 2));
      _showOrHideSaveButton = true;
      setState(() => state = ButtonState.init);
    } else {
      setState(() => state = ButtonState.init);
      pop_upHelper.popUpNavigatorPop(
          context, 1, CoolAlertType.error, 'Please provide valid credentials');
      mySnackbar.mySnackBar(
          context, 'Can\'t Update Profile! Error: $statusCode', Colors.red);
    }
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: myColor.primaryColorDark,
        ),
        margin: const EdgeInsets.only(right: 12.0, top: 15.0, bottom: 2.0),
        width: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Edit',
              style: kStyleNormal.copyWith(color: Colors.white),
            ),
            const Icon(
              Icons.edit,
              color: Colors.white,
              size: 16.0,
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _showOrHideSaveButton = false;
        });
      },
    );
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
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          child: cameraIcon,
        ),
      ),
    );
  }

  Widget loadingIconWidget(bool isDone) {
    final color = isDone ? Colors.green : myColor.primaryColorDark;
    return Positioned(
      top: 90,
      left: 42,
      child: CircleAvatar(
          backgroundColor: color,
          radius: 23.0,
          child: isDone
              ? tickIcon
              : const Padding(
                  padding: EdgeInsets.all(10.0),
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
}
