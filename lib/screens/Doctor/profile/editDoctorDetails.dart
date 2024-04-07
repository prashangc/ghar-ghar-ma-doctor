import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/Doctor/main/mainHomePageDoctor.dart';
import 'package:ghargharmadoctor/screens/Doctor/profile/refreshDoctorProfile.dart';
import 'package:ghargharmadoctor/screens/User/profile/UpdatePhoneNumber/UpdatePhoneNumberScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

enum ButtonState { init, loading, done }

class EditDoctorProfileDetails extends StatefulWidget {
  DoctorProfileModel? doctorProfileModel;

  EditDoctorProfileDetails({Key? key, this.doctorProfileModel})
      : super(key: key);

  @override
  State<EditDoctorProfileDetails> createState() =>
      EditDoctorProfileDetailsState();
}

class EditDoctorProfileDetailsState extends State<EditDoctorProfileDetails> {
  ButtonState state = ButtonState.init;
  List<GetIDNameModel> salutationList = [];
  List<GetIDNameModel> departmentDynamicModel = [];
  final _form = GlobalKey<FormState>();
  File? fileImage;
  FilePickerResult? result;
  PlatformFile? file;
  List<PlatformFile>? files;
  ApiHandlerBloc? departmentBloc, hospitalBloc;
  String? _fullName, _gender, _fee, image;
  String? _email;
  String? _phone;
  String? _address;
  String? _country;
  String? _weight;
  String? _height;
  String? _nmcNumber;
  int? _departmentID;
  String? _department;
  String? _urlID, _profilePicture;
  String? _salutation;
  String? _qualification;
  String? _yearsPractised;
  String? _specialization;
  List<String> departmentStringList = [];
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _qualificationFocusNode = FocusNode();
  final FocusNode _specializationFocusNode = FocusNode();
  String countryValue = "";
  List<bool> boolList = [];
  var userID;
  final List selectedIndexs = [];
  List<AllHospitalModel> hospitalList = [];
  List<String> selectedHospitals = [];
  StateHandlerBloc saveBtnBloc = StateHandlerBloc();
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
    boolList.clear();
    getData();
  }

  getData() {
    if (widget.doctorProfileModel != null) {
      for (int i = 0; i < widget.doctorProfileModel!.hospital!.length; i++) {
        selectedHospitals.add(widget.doctorProfileModel!.hospital![i]);
      }
      _urlID = widget.doctorProfileModel!.id.toString();
      _profilePicture = widget.doctorProfileModel!.imagePath;
      _email = widget.doctorProfileModel!.user!.email;
      _address = widget.doctorProfileModel!.address;
      _fullName = widget.doctorProfileModel!.user!.name;
      _phone = widget.doctorProfileModel!.user!.phone;
      _nmcNumber = widget.doctorProfileModel!.nmcNo;
      _salutation = widget.doctorProfileModel!.salutation;
      _gender = widget.doctorProfileModel!.gender;
      _fee = widget.doctorProfileModel!.fee.toString();
      _yearsPractised = widget.doctorProfileModel!.yearPracticed;
      _qualification = widget.doctorProfileModel!.qualification;
      _specialization = widget.doctorProfileModel!.specialization;
      // _departmentID = widget.doctorProfileModel!.department;
      // _department = widget.doctorProfileModel!.departments!.department;
      salutationList.clear();
      for (int i = 0; i < saluationData.length; i++) {
        salutationList.add(GetIDNameModel(
          id: saluationData[i],
          name: saluationData[i],
        ));
      }
    }
  }

  void _refresh() {
    print('photo uploaded');
    setState(() {
      var test = sharedPrefs.getFromDevice("doctorProfile");
      widget.doctorProfileModel =
          DoctorProfileModel.fromJson(json.decode(test));
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
            const MainHomePageDoctor(
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
                                      _profilePicture.toString(),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Salutation',
                                  style: kStyleNormal.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox16(),
                                myDropDown2(
                                  context,
                                  Icons.medical_services_outlined,
                                  Colors.black,
                                  Colors.black,
                                  maxWidth(context),
                                  _salutation ?? 'Dr.',
                                  salutationList,
                                  myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  onValueChanged: (value) {
                                    setState(() {
                                      _salutation = value.name;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: myNumberTextFormField(
                              'NMC Number',
                              _nmcNumber ?? 'Enter your nmc no',
                              'Enter your NMC number',
                              _nmcNumber,
                              Icons.numbers,
                              kWhite.withOpacity(0.4),
                              onValueChanged: (value) {
                                _nmcNumber = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Phone Number',
                        style: kStyleNormal.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox16(),
                      GestureDetector(
                        onTap: () {
                          if (validationForm()) {
                            goThere(context, const UpdatePhoneNumberScreen());
                          }
                        },
                        child: myCountryCodePicker(
                          hintText: _phone ?? 'Enter your phone',
                          bgColor: Colors.white.withOpacity(0.4),
                          isEditable: false,
                          onValueChanged: (value) {
                            _phone = value;
                          },
                        ),
                      ),
                      myEmailTextFormFieldWithPrefixIcon(
                        context,
                        'Email',
                        _email ?? 'Enter your email',
                        _email,
                        Icons.email_outlined,
                        kWhite.withOpacity(0.4),
                        onValueChanged: (value) {
                          _email = value;
                        },
                        isReadOnly: true,
                      ),
                      mytextFormFieldWithPrefixIcon(
                        context,
                        _addressFocusNode,
                        'Address',
                        _address ?? 'Enter your address',
                        'Enter your address',
                        _address,
                        Icons.location_city,
                        kWhite.withOpacity(0.4),
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
                      const SizedBox24(),
                      Text(
                        'Hospital',
                        style: kStyleNormal.copyWith(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox16(),
                      GestureDetector(
                        onTap: () {
                          hospitalBloc = ApiHandlerBloc();
                          hospitalBloc!
                              .fetchAPIList(endpoints.getAllHospitalsEndpoint);
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: myColor.dialogBackgroundColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: ((builder) =>
                                showHospitalsBottomModelSheet(
                                  context,
                                  setState,
                                )),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withOpacity(0.4),
                          ),
                          width: maxWidth(context),
                          height: 50.0,
                          child: Row(
                            children: [
                              const SizedBox(width: 16.0),
                              const Icon(
                                Icons.location_city,
                                size: 16,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedHospitals.isEmpty
                                          ? 'Select Hospital'
                                          : '${selectedHospitals.length} selected',
                                      style:
                                          kStyleNormal.copyWith(fontSize: 12.0),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12.0),
                            ],
                          ),
                        ),
                      ),
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
                                _height = value;
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
                      mytextFormFieldWithPrefixIcon(
                        context,
                        _specializationFocusNode,
                        'Specialization',
                        _specialization ?? 'Enter your specialization',
                        'Enter your _specialization',
                        _specialization,
                        Icons.key,
                        Colors.white.withOpacity(0.4),
                        onValueChanged: (value) {
                          _specialization = value;
                        },
                      ),
                      StreamBuilder<ApiResponse<dynamic>>(
                        stream: departmentBloc!.apiListStream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.LOADING:
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Department',
                                      style: kStyleNormal.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox16(),
                                    myDropDown2(
                                      context,
                                      Icons.room_outlined,
                                      Colors.black,
                                      Colors.black,
                                      maxWidth(context),
                                      'Select Department',
                                      departmentDynamicModel,
                                      myColor.scaffoldBackgroundColor
                                          .withOpacity(0.4),
                                      onValueChanged: (value) {},
                                    ),
                                  ],
                                );
                              case Status.COMPLETED:
                                if (snapshot.data!.data.isEmpty) {
                                  return Container();
                                }
                                List<DepartmentModel> departmentModel =
                                    List<DepartmentModel>.from(
                                        snapshot.data!.data.map((i) =>
                                            DepartmentModel.fromJson(i)));
                                departmentDynamicModel.clear();
                                for (int i = 0;
                                    i < departmentModel.length;
                                    i++) {
                                  departmentDynamicModel.add(
                                    GetIDNameModel(
                                      id: departmentModel[i].id.toString(),
                                      name: departmentModel[i]
                                          .department
                                          .toString(),
                                    ),
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Department',
                                      style: kStyleNormal.copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox16(),
                                    myDropDown2(
                                      context,
                                      Icons.room_outlined,
                                      Colors.black,
                                      Colors.black,
                                      maxWidth(context),
                                      _department ?? 'Select Department',
                                      departmentDynamicModel,
                                      myColor.scaffoldBackgroundColor
                                          .withOpacity(0.4),
                                      onValueChanged: (value) {
                                        setState(() {
                                          _departmentID =
                                              int.parse(value.id.toString());
                                          _department = value.name.toString();
                                        });
                                      },
                                    ),
                                  ],
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
      ),
    );
  }

  void saveBtn(context) async {
    if (validationForm()) {
      saveBtnBloc.storeData(true);
      int statusCode;
      statusCode = await API().postData(
          context,
          PatchDoctorProfileModel(
            name: _fullName,
            address: _address,
            email: _email,
            phone: _phone,
            nmcNo: _nmcNumber,
            salutation: _salutation,
            gender: _gender,
            yearPracticed: _yearsPractised,
            specialization: _specialization,
            department: _departmentID.toString(),
            fee: _fee,
            hospital: ["$selectedHospitals"],
            qualification: _qualification,
          ),
          'admin/doctor-profile/update/${widget.doctorProfileModel!.id}');

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
  }

  validationForm() {
    if (_gender == null) {
      myToast.toast('Please update gender');
      return false;
    } else if (_department == null) {
      myToast.toast('Please select department');
      return false;
    } else {
      return true;
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
        PatchDoctorProfileModel(
          name: _fullName,
          address: _address,
          email: _email,
          phone: _phone,
          nmcNo: _nmcNumber,
          salutation: _salutation,
          gender: _gender,
          yearPracticed: _yearsPractised,
          specialization: _specialization,
          department: _departmentID.toString(),
          image: image!,
        ),
        'admin/doctor-profile/update/${widget.doctorProfileModel!.id}');
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

  Widget showHospitalsBottomModelSheet(context, myState) {
    return StatefulBuilder(builder: (builder, setState) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10.0),
                StreamBuilder<ApiResponse<dynamic>>(
                  stream: hospitalBloc!.apiListStream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          return const Center(child: AnimatedLoading());
                        case Status.COMPLETED:
                          if (snapshot.data!.data.isEmpty) {
                            return Container(
                                height: 50.0,
                                margin: const EdgeInsets.only(bottom: 12.0),
                                decoration: BoxDecoration(
                                  color: myColor.scaffoldBackgroundColor
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                    child: Text('No hospitals added')));
                          }

                          hospitalList = List<AllHospitalModel>.from(snapshot
                              .data!.data
                              .map((i) => AllHospitalModel.fromJson(i)));

                          return Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                        crossAxisCount: 2,
                                        height: 40.0,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                itemCount: hospitalList.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  boolList.add(false);
                                  selectedHospitals.contains(
                                          hospitalList[index].id.toString())
                                      ? boolList[index] = true
                                      : boolList.add(false);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        boolList[index] = !boolList[index];
                                      });
                                      // if (boolList[index] &&
                                      //     !selectedHospitals.contains(
                                      //         hospitalList[index].id!)) {
                                      //   selectedHospitals
                                      //       .add(hospitalList[index].id!);
                                      // }
                                      // print(selectedHospitals);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: boolList[index]
                                            ? myColor.primaryColorDark
                                            : myColor.scaffoldBackgroundColor
                                                .withOpacity(0.4),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          // widget.doctorProfileModel
                                          //     .hospital![index],
                                          hospitalList[index].name.toString(),
                                          style: kStyleNormal.copyWith(
                                            fontSize: 12.0,
                                            color: boolList[index]
                                                ? myColor
                                                    .scaffoldBackgroundColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox12(),
                            ],
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
                      height: 200,
                    );
                  }),
                ),
                const SizedBox8(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
