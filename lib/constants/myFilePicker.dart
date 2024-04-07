import 'dart:convert';
import 'dart:io';
import 'package:ghargharmadoctor/api/stateBloc.dart';
import 'package:path/path.dart' as path;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabReports/ReportPdfViewer.dart';
import 'package:open_file/open_file.dart';

class myFilePicker extends StatefulWidget {
  final textValue;
  final color;
  final String? stringFile;
  final ValueChanged<MyFileModel>? onValueChanged;
  const myFilePicker(
      {Key? key,
      required this.textValue,
      required this.color,
      this.stringFile,
      this.onValueChanged})
      : super(key: key);

  @override
  State<myFilePicker> createState() => _myFilePickerState();
}

class _myFilePickerState extends State<myFilePicker> {
  FilePickerResult? result;
  PlatformFile? file;
  StateHandlerBloc showImageFromApi = StateHandlerBloc();
  File? myFile;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        initialData: widget.stringFile == null ? 0 : 1,
        stream: showImageFromApi.stateStream,
        builder: (c, s) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: [
                        'jpg',
                        'png',
                        'mp4',
                        'mp3',
                        'pdf',
                        'doc',
                        'docx',
                      ]);
                  print('result:::$result');
                  if (result == null) {
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "No files were selected",
                              style: kStyleNormal.copyWith(fontSize: 15.0),
                            ),
                            actions: [
                              myCustomButton(
                                  context,
                                  myColor.primaryColorDark,
                                  'Ok',
                                  kStyleNormal.copyWith(color: Colors.white),
                                  () {
                                Navigator.of(context).pop();
                              })
                            ],
                          );
                        });
                  }
                  if (result!.files.length == 1) {
                    file = result!.files.first;
                    File saveFile = File(file!.path.toString());
                    List<int> fileBytes = saveFile.readAsBytesSync();
                    String base64File =
                        "data:image/pdf;base64,${base64Encode(fileBytes)}";
                    setState(() {
                      myFile = saveFile;
                    });

                    setState(() {
                      widget.onValueChanged!(
                          MyFileModel(file: myFile!, base64String: base64File));
                    });
                    showImageFromApi.storeData(0);
                  } else {
                    File? saveFile;
                    List<String> listOfBase64Images = [];
                    listOfBase64Images.clear();
                    for (var element in result!.files) {
                      saveFile = File(element.path.toString());
                      List<int> fileBytes = saveFile.readAsBytesSync();
                      String base64File =
                          "data:image/pdf;base64,${base64Encode(fileBytes)}";
                      listOfBase64Images.add(base64File);
                    }
                    setState(() {
                      myFile = saveFile;
                    });

                    setState(() {
                      widget.onValueChanged!(MyFileModel(
                          file: myFile!,
                          listOfBase64Images: listOfBase64Images));
                    });
                    showImageFromApi.storeData(0);
                  }
                },
                child: DottedBorder(
                  dashPattern: const [8, 10],
                  strokeWidth: 1,
                  color: myColor.primaryColor,
                  strokeCap: StrokeCap.round,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(5),
                  child: Container(
                    width: maxWidth(context),
                    decoration: BoxDecoration(
                      color:
                          file != null ? kWhite.withOpacity(0.4) : widget.color,
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
                        Text(file != null ? 'Upload More' : widget.textValue,
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                            )),
                        const SizedBox2(),
                        Text(
                          'Max size: 10 MB',
                          style: kStyleNormal.copyWith(fontSize: 10.0),
                        ),
                        const SizedBox2(),
                        Text(
                          'Browse',
                          style: kStyleNormal.copyWith(
                            color: myColor.primaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox12(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox8(),
              myFile == null && s.data == 0
                  ? Container()
                  : s.data == 1
                      ? stringFileCard()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: result!.files.length,
                          itemBuilder: (ctx, i) {
                            final file = result!.files[i];
                            final kb = file.size / 1000;
                            final mb = kb / 1000;

                            final fileSize = mb >= 1
                                ? mb.toStringAsFixed(2)
                                : kb.toStringAsFixed(2);
                            final extension = file.extension ?? 'none';

                            return GestureDetector(
                              onTap: () {
                                OpenFile.open(file.path);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: myColor.scaffoldBackgroundColor
                                        .withOpacity(0.4),
                                  ),
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Image.asset(
                                          file.extension == "jpg"
                                              ? 'assets/jpgIconSolid.png'
                                              : file.extension == "mp4"
                                                  ? 'assets/mp3IconSolid.png'
                                                  : file.extension == "jpeg"
                                                      ? 'assets/jpgIconSolid.png'
                                                      : file.extension == "mov"
                                                          ? 'assets/mp3IconSolid.png'
                                                          : file.extension ==
                                                                  "pdf"
                                                              ? 'assets/pdfIconsSolid.png'
                                                              : file.extension ==
                                                                      "png"
                                                                  ? 'assets/pngIconsSolid.png'
                                                                  : file.extension ==
                                                                          "doc"
                                                                      ? 'assets/docIcons.png'
                                                                      : file.extension ==
                                                                              "docx"
                                                                          ? 'assets/docIcons.png'
                                                                          : 'assets/logo.png',
                                          width: 35,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            file.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: kStyleNormal,
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                "Size: ",
                                                style: kStyleNormal.copyWith(
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                fileSize.toString(),
                                                style: kStyleNormal.copyWith(
                                                    fontSize: 10),
                                              ),
                                              const SizedBox(width: 3.0),
                                              Text(
                                                file.size <= 1000000
                                                    ? "KB"
                                                    : "MB",
                                                style: kStyleNormal.copyWith(
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              result!.paths.removeAt(i);

                                              //  file.path!.rem
                                              //  setState(() => file.removeAt(index));
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              size: 20.0,
                                            ),
                                            // child: Image.asset(
                                            //   'assets/crossMark.png',
                                            //   width: 20,
                                            //   color: const Color.fromARGB(255, 180, 178, 178),
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              const SizedBox8(),
            ],
          );
        });
  }

  Widget stringFileCard() {
    String url = widget.stringFile!;
    String fileName = path.basename(url);
    String extensionWithDot = path.extension(fileName);
    String extension = extensionWithDot.substring(1, extensionWithDot.length);
    return GestureDetector(
      onTap: () {
        goThere(
            context,
            ReportPdfViewer(
              url: widget.stringFile!.toString(),
              type: 'pdf',
              appBar: 'Your File',
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
          ),
          width: double.infinity,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.asset(
                  extension == "jpg"
                      ? 'assets/jpgIconSolid.png'
                      : extension == "mp4"
                          ? 'assets/mp3IconSolid.png'
                          : extension == "jpeg"
                              ? 'assets/jpgIconSolid.png'
                              : extension == "mov"
                                  ? 'assets/mp3IconSolid.png'
                                  : extension == "pdf"
                                      ? 'assets/pdfIconsSolid.png'
                                      : extension == "png"
                                          ? 'assets/pngIconsSolid.png'
                                          : extension == "doc"
                                              ? 'assets/docIcons.png'
                                              : extension == "docx"
                                                  ? 'assets/docIcons.png'
                                                  : 'assets/logo.png',
                  width: 35,
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                style: kStyleNormal.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
