import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/api/stateBloc.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:image_picker/image_picker.dart';

class myImagePicker extends StatefulWidget {
  String? textValue;
  Color? bgColor;
  String? stringImage;
  ValueChanged<MyImageModel>? onValueChanged;

  myImagePicker(
      {Key? key,
      this.textValue,
      this.bgColor,
      this.onValueChanged,
      this.stringImage})
      : super(key: key);

  @override
  State<myImagePicker> createState() => _myImagePickerState();
}

class _myImagePickerState extends State<myImagePicker> {
  File? image;
  StateHandlerBloc showImageFromApi = StateHandlerBloc();
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
        image = saveFile;
        widget.onValueChanged!(
            MyImageModel(file: image!, base64String: base64Image));
      });
      showImageFromApi.storeData(0);
    } on PlatformException catch (e) {
      print("failed $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        initialData: widget.stringImage == null ? 0 : 1,
        stream: showImageFromApi.stateStream,
        builder: (c, s) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: image == null && s.data == 0
                ? DottedBorder(
                    dashPattern: const [8, 10],
                    strokeWidth: 1,
                    color: myColor.primaryColor,
                    strokeCap: StrokeCap.round,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(5),
                    child: Container(
                      width: maxWidth(context),
                      decoration: BoxDecoration(
                        color: widget.bgColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox8(),
                          Icon(
                            Icons.file_upload,
                            size: 35,
                            color: myColor.primaryColorDark,
                          ),
                          const SizedBox(height: 3),
                          Text(widget.textValue!,
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              )),
                          Text(
                            'Browse',
                            style: kStyleNormal.copyWith(
                              color: myColor.primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox16(),
                        ],
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        height: 100,
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          child: s.data == 1
                              ? myCachedNetworkImage(
                                  maxWidth(context),
                                  100.0,
                                  widget.stringImage,
                                  const BorderRadius.all(Radius.circular(5.0)),
                                  BoxFit.cover,
                                )
                              : Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 5.0),
                              const Icon(
                                Icons.file_upload,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                'Re-upload',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          );
        });
  }

  // Widget imageFilledContainer(context, fileImage, snap) {
  //   return
  // }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      color: Colors.white,
      width: maxWidth(context),
      child: Row(
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
    );
  }
}
