import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
// import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

class CropImage extends StatefulWidget {
  File image;
  String imagePath;
  CropImage({super.key, required this.image, required this.imagePath});

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  // final cropKey = GlobalKey<CropState>();
  File? _sample, _lastCropped;
  StateHandlerBloc? imagePickerBloc;
  @override
  void initState() {
    super.initState();
    imagePickerBloc = StateHandlerBloc();
  }

  Future<void> pickImage(context, ImageSource source) async {
    Navigator.pop(context);
    try {
      final picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(source: source);
      if (imageFile == null) return;
      final File saveFile = File(imageFile.path);
      imagePickerBloc!.storeData('tick');
      setState(() {
        widget.image = saveFile;
        widget.imagePath = imageFile.path;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed $e");
      }
    }
  }

  Widget pickImageOrCameraBottomSheet(context) {
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
            "Choose QR",
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
                      pickImage(context, ImageSource.camera);
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
                      pickImage(context, ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Stack(
          children: [
            // AnimatedPositioned(
            //   duration: const Duration(milliseconds: 200),
            //   curve: Curves.fastOutSlowIn,
            //   top: 0,
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: InteractiveViewer(
            //     panEnabled: true,
            //     minScale: 0.5,
            //     maxScale: 4,
            //     child: Center(
            //       child:
            //           Crop(key: cropKey, image: Image.file(widget.image).image),
            //     ),
            //   ),
            // ),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(12.0, 50.0, 0.0, 0.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.3), shape: BoxShape.circle),
                child: Icon(Icons.keyboard_arrow_left_rounded,
                    color: kWhite, size: 18.0),
              ),
            ),
            Positioned(
              right: 12,
              child: StreamBuilder<dynamic>(
                  initialData: 'tick',
                  stream: imagePickerBloc!.stateStream,
                  builder: (context, mySnap) {
                    return GestureDetector(
                      onTap: () {
                        if (mySnap.data == 'tick') {
                          _cropImage(context);
                        } else {
                          showModalBottomSheet(
                            context: context,
                            builder: ((builder) => pickImageOrCameraBottomSheet(
                                  context,
                                )),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(12.0, 50.0, 0.0, 0.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.3),
                            shape: BoxShape.circle),
                        child: mySnap.data == 'loading'
                            ? SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  color: kWhite,
                                  strokeWidth: 1.0,
                                ))
                            : Icon(
                                mySnap.data == 'tick'
                                    ? Icons.check
                                    : Icons.image,
                                color: kWhite,
                                size: 18.0),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _sample?.delete();
    _lastCropped?.delete();
  }

  Future<void> _cropImage(context) async {
    imagePickerBloc!.storeData('loading');
    // final scale = cropKey.currentState!.scale;
    // final area = cropKey.currentState!.area;
    // if (area == null) {
    //   if (kDebugMode) {
    //     print("cannot crop, widget is not setup");
    //   }
    //   return;
    // }
    // final sample = await ImageCrop.sampleImage(
    //   file: widget.image,
    //   preferredSize: (2000 / scale).round(),
    // );

    // final file = await ImageCrop.cropImage(
    //   file: sample,
    //   area: area,
    // );
    // _lastCropped = file;
    // _scanQRCode(context, _lastCropped!);
  }

  _scanQRCode(context, File img) async {
    try {
      final qrContent = await FlutterQrReader.imgScan(widget.imagePath);
      if (qrContent.isEmpty) {
        imagePickerBloc!.storeData('image');
        mySnackbar.mySnackBar(context, 'Not a valid QR', kRed);
      } else {
        imagePickerBloc!.storeData('tick');
        Navigator.pop(context, GetIDNameModel(file: img, name: qrContent));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception = $e');
      }
    }
  }
}
