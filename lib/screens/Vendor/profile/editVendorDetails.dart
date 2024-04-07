import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/refreshDoctorProfile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

enum ButtonState { init, loading, done }

class EditVendorProfileDetails extends StatefulWidget {
  VendorProfileModel? vendorProfileModel;

  EditVendorProfileDetails({Key? key, this.vendorProfileModel})
      : super(key: key);

  @override
  State<EditVendorProfileDetails> createState() =>
      EditVendorProfileDetailsState();
}

class EditVendorProfileDetailsState extends State<EditVendorProfileDetails> {
  ButtonState state = ButtonState.init;
  final _form = GlobalKey<FormState>();
  File? fileImage;
  FilePickerResult? result;
  PlatformFile? file;
  List<PlatformFile>? files;

  String? storeName, address, image;
  StateHandlerBloc saveBtnBloc = StateHandlerBloc();
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
    getData();
  }

  getData() {
    if (widget.vendorProfileModel != null) {
      storeName = widget.vendorProfileModel!.storeName;
      address = widget.vendorProfileModel!.address;
    }
  }

  void _refresh() {
    setState(() {
      var test = sharedPrefs.getFromDevice("vendorProfile");
      widget.vendorProfileModel =
          VendorProfileModel.fromJson(json.decode(test));
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isStretched = state == ButtonState.init;
    final isDone = state == ButtonState.done;

    return GestureDetector(
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
                                    widget.vendorProfileModel!.imagePath
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
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Store Name',
                      storeName ?? 'Enter your store name',
                      'Enter your store name',
                      storeName,
                      Icons.person,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        storeName = value;
                      },
                    ),
                    Text(
                      'Phone Number',
                      style: kStyleNormal.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox16(),
                    myCountryCodePicker(
                      hintText:
                          widget.vendorProfileModel!.user!.phone.toString(),
                      bgColor: kWhite.withOpacity(0.4),
                      isEditable: false,
                      onValueChanged: (value) {},
                    ),
                    myEmailTextFormFieldWithPrefixIcon(
                      context,
                      'Email',
                      widget.vendorProfileModel!.user!.email.toString(),
                      '',
                      Icons.email_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {},
                      isReadOnly: true,
                    ),
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Address',
                      address ?? 'Enter store location',
                      'Enter store location',
                      address,
                      Icons.location_city,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        address = value;
                      },
                    ),
                    const SizedBox24(),
                    StreamBuilder<dynamic>(
                        initialData: false,
                        stream: saveBtnBloc.stateStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == false) {
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
                          } else {
                            return myBtnLoading(context, 55.0);
                          }
                        }),
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
    );
  }

  void saveBtn(context) async {
    saveBtnBloc.storeData(true);
    int statusCode;
    statusCode = await API().postData(
        context,
        PatchVendorProfileModel(
          address: address,
          email: widget.vendorProfileModel!.user!.email.toString(),
          phone: widget.vendorProfileModel!.user!.phone.toString(),
          name: storeName,
          image: image!,
        ),
        'vendor-profile/update/${widget.vendorProfileModel!.slug}');

    FocusManager.instance.primaryFocus?.unfocus();

    if (statusCode == 200) {
      await refreshDoctorProfile(context);
      Navigator.pop(context);
      pop_upHelper.customAlert(context, 'SUCCESS', 'Profile Updated');
      saveBtnBloc.storeData(false);
      setState(() {
        _showOrHideSaveButton = true;
        myfocusRemover(context);
      });
    } else {
      saveBtnBloc.storeData(false);
    }
  }

  void cancelBtn() {
    setState(() {
      _showOrHideSaveButton = true;
      myfocusRemover(context);
    });
    Navigator.pop(context);
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
      print("failed $e");
    }
  }

  void uploadPhoto() async {
    setState(() => state = ButtonState.loading);
    int statusCode;
    statusCode = await API().postData(
        context,
        PatchVendorProfileModel(
          address: address,
          email: widget.vendorProfileModel!.user!.email.toString(),
          phone: widget.vendorProfileModel!.user!.phone.toString(),
          name: storeName,
        ),
        'vendor-profile/update/${widget.vendorProfileModel!.slug}');
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
    }
  }

  Widget _getEditIcon() {
    return Container(
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
            "Choose Store Logo",
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
}
