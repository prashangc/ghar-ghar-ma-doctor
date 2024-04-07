import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/login/LoginScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:ghargharmadoctor/widgets/CropImage.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:torch_controller/torch_controller.dart';
// import 'package:torch_light/torch_light.dart';

class QR extends StatefulWidget {
  const QR({Key? key}) : super(key: key);

  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> with SingleTickerProviderStateMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  AnimationController? _controller;
  Animation<double>? _animation;
  String? key;
  bool _qrCodeDetected = false;
  StateHandlerBloc? flashBloc, draggableSheetBloc, croppedImageBloc;
  MobileScannerController? scanController;
  final torchController = TorchController();
  File? croppedImage;
  ProfileModel? profileModel;
  @override
  void initState() {
    super.initState();
    var test = sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    draggableSheetBloc = StateHandlerBloc();
    flashBloc = StateHandlerBloc();
    croppedImageBloc = StateHandlerBloc();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 200).animate(_controller!);
    scanController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      torchEnabled: false,
      returnImage: true,
    );
  }

  Future<void> pickImage(context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? imageFile = await picker.pickImage(source: source);
      if (imageFile == null) return;
      final File saveFile = File(imageFile.path);
      Navigator.pop(context);
      GetIDNameModel getIDNameModel = await goThere(
          context,
          CropImage(
            image: saveFile,
            imagePath: imageFile.path,
          ));
      if (getIDNameModel.file != null) {
        setState(() {
          croppedImage = null;
          croppedImage = getIDNameModel.file;
        });
        croppedImageBloc!.storeData('a');
        List<int> encryptedBytes = getIDNameModel.name!.codeUnits;
        String key = 'ufxhqsy7ytiiibye';
        List<int> keyBytes = key.codeUnits;
        List<int> decryptedBytes = [];
        for (int i = 0; i < encryptedBytes.length; i++) {
          decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
        }
        String decryptedData = String.fromCharCodes(decryptedBytes);
        GetQrKeyModel getQrKeyModel =
            GetQrKeyModel.fromJson(jsonDecode(decryptedData));
        if (getQrKeyModel.type == "family") {
          print('the qr is of family');
          if (profileModel!.memberType == null &&
              getQrKeyModel.familyType == "None") {
            print('the qr should connect pusher');

            connectSocketIO(context, getQrKeyModel.id);
          } else {
            print('the qr should add family');

            addFamilyBtn(context, getQrKeyModel.key);
          }
        } else if (getQrKeyModel.type == "login") {
          loginMethod(context, getQrKeyModel);
        }
        setState(() {
          _qrCodeDetected = true;
        });
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed $e");
      }
    }
  }

  connectSocketIO(ctx, id) async {
    print('the qr is now connect socket io $id');
    var test = sharedPrefs.getFromDevice("userProfile");
    ProfileModel profileModel = ProfileModel.fromJson(json.decode(test));
    PusherClient? pusher;
    Channel? channel;
    pusher = PusherClient(
      'cd3ed25c9be7e1f981d8',
      PusherOptions(
        cluster: 'ap2',
      ),
    );
    await pusher.connect();
    channel = pusher.subscribe('my-family-channel.$id');
    int statusCode = await API().postData(
        context,
        PostPhoneQrModel(id: id, phone: profileModel.member!.phone),
        endpoints.postQRPhoneEndpoint);
    if (statusCode == 200) {
      // addFamilyBtn(context, getQrKeyModel.key);
      Navigator.pop(context);
      goThere(
          context,
          const FamilyPage(
            tabIndex: 1,
          ));
      mySnackbar.mySnackBar(context, 'success $statusCode', kGreen);
    } else {
      mySnackbar.mySnackBar(context, 'erroes $statusCode', kRed);
    }

    channel.bind('my-family-event.$id', (event) {
      print('--------------> event normal ${event!.data}');
    });
    print('--------------> event test');
  }

  @override
  Widget build(BuildContext context) {
    Color color = myColor.primaryColorDark.withOpacity(0.6);
    return Scaffold(
      backgroundColor: myColor.dialogBackgroundColor.withOpacity(0.4),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: myColor.primaryColorDark,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: myColor.dialogBackgroundColor,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: ((builder) => myExpandedSheetCard()));
        },
        icon: Icon(
          Icons.qr_code,
          color: kWhite,
          size: 25.0,
        ),
        label: Text(
          'Learn about QR',
          style: kStyleNormal.copyWith(
            color: kWhite,
            fontSize: 12,
          ),
        ),
      ),
      body: SizedBox(
        width: maxWidth(context),
        height: maxHeight(context),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  MobileScanner(
                    fit: BoxFit.cover,
                    controller: scanController,
                    placeholderBuilder: (context, c) => const Center(
                      child: AnimatedLoading(),
                    ),
                    onDetect: (capture) {
                      if (!_qrCodeDetected) {
                        final List<Barcode> barcodes = capture.barcodes;
                        List<int> encryptedBytes =
                            barcodes[0].rawValue!.codeUnits;
                        String key = 'ufxhqsy7ytiiibye';
                        List<int> keyBytes = key.codeUnits;
                        List<int> decryptedBytes = [];
                        for (int i = 0; i < encryptedBytes.length; i++) {
                          decryptedBytes.add(encryptedBytes[i] ^
                              keyBytes[i % keyBytes.length]);
                        }
                        String decryptedData =
                            String.fromCharCodes(decryptedBytes);
                        GetQrKeyModel getQrKeyModel =
                            GetQrKeyModel.fromJson(jsonDecode(decryptedData));
                        if (getQrKeyModel.type == "family") {
                          print('the qr is of family');
                          if (profileModel!.memberType == null &&
                              getQrKeyModel.familyType == "None") {
                            print('the qr should connect pusher');

                            connectSocketIO(context, getQrKeyModel.id);
                          } else {
                            print('the qr should add family');

                            addFamilyBtn(context, getQrKeyModel.key);
                          }
                        } else if (getQrKeyModel.type == "login") {
                          loginMethod(context, getQrKeyModel);
                        }
                        setState(() {
                          _qrCodeDetected = true;
                        });
                      }
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: maxWidth(context),
                      height: maxHeight(context),
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 20.0),
                            color: color,
                            width: maxWidth(context),
                            child: Image.asset(
                              'assets/logo_white.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            color: color,
                            width: maxWidth(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Scan',
                                  textAlign: TextAlign.center,
                                  style: kStyleNormal.copyWith(
                                    color: kWhite,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                GestureDetector(
                                  onTap: () {
                                    draggableSheetBloc!.storeData(true);
                                  },
                                  child: Icon(
                                    Icons.error_outline_outlined,
                                    size: 16.0,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            color: color,
                            width: maxWidth(context),
                            child: Text(
                              'Keep the qr on the center of the frame',
                              textAlign: TextAlign.center,
                              style: kStyleNormal.copyWith(
                                color: kWhite,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: maxWidth(context),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: color,
                                        height: 200.0,
                                      ),
                                    ),
                                    Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        color: kTransparent,
                                        border: Border.all(
                                          color: kWhite,
                                          width: 2,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            child: croppedImage == null
                                                ? Container()
                                                : Expanded(
                                                    child: Container(
                                                      height:
                                                          maxHeight(context),
                                                      width: maxWidth(context),
                                                      color: kWhite,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Image.file(
                                                          croppedImage!),
                                                    ),
                                                  ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: AnimatedBuilder(
                                              animation: _animation!,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(
                                                      0, _animation!.value),
                                                  child: Container(
                                                    height: 2,
                                                    width: 2,
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                begin: Alignment
                                                                    .bottomLeft,
                                                                end: Alignment
                                                                    .topCenter,
                                                                colors: <Color>[
                                                          myColor
                                                              .primaryColorDark,
                                                          myColor
                                                              .dialogBackgroundColor,
                                                        ])),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: color,
                                        height: 200.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FutureBuilder<bool?>(
                                                future: torchController
                                                    .isTorchActive,
                                                builder: (_, snapshot) {
                                                  final snapshotData =
                                                      snapshot.data ?? false;

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return StreamBuilder<
                                                            dynamic>(
                                                        initialData: false,
                                                        stream: flashBloc!
                                                            .stateStream,
                                                        builder: (context,
                                                            flashSnap) {
                                                          return GestureDetector(
                                                            onTap: () async {
                                                              flashBloc!
                                                                  .storeData(
                                                                      !flashSnap
                                                                          .data);
                                                              torchController
                                                                  .toggle();
                                                            },
                                                            child: Icon(
                                                              flashSnap.data ==
                                                                      false
                                                                  ? Icons
                                                                      .flash_off
                                                                  : Icons
                                                                      .flash_on,
                                                              color: kWhite,
                                                            ),
                                                          );
                                                        });
                                                  }

                                                  return Container();
                                                }),
                                            GestureDetector(
                                                onTap: () {
                                                  pickImage(context,
                                                      ImageSource.gallery);
                                                },
                                                child: Icon(
                                                  Icons.image,
                                                  color: kWhite,
                                                )),
                                            Icon(
                                              // flashSnap.data == false
                                              //   ? Icons.flash_off
                                              // :
                                              Icons.flash_on, color: kWhite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: color,
                              width: maxWidth(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(12.0, 50.0, 0.0, 0.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: kWhite.withOpacity(0.3),
                            shape: BoxShape.circle),
                        child: Icon(Icons.keyboard_arrow_left_rounded,
                            color: kWhite, size: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  addFamilyBtn(context, phone) async {
    int statusCode;

    statusCode = await API().postData(
        context, SendRequestModel(phone: phone), endpoints.sendFriendRequest);

    if (statusCode == 200) {
      Navigator.pop(context);
      mySnackbar.mySnackBar(context, 'Request sent successfully.', kGreen);
      goThere(context, const FamilyPage(tabIndex: 1));
    }
  }

  Future<void> loginMethod(context, GetQrKeyModel getQrKeyModel) async {
    print('checking token key ${getQrKeyModel.key}');
    int statusCode = await API().postData(
        context,
        ScanAndPostQrKeyModel(
          token: getQrKeyModel.key,
        ),
        endpoints.postQrKeyEndpoint);
    print('checking status code $statusCode');

    if (statusCode == 200) {
      if (getQrKeyModel.platform != 'web') {
        String tokenID = sharedPrefs.getFromDevice('tokenId');
        int myStatusCode = await API().deleteData(endpoints.qrLogoutEndpoint,
            model: QRLogoutModel(tokenId: tokenID));
        if (myStatusCode == 200) {
          pop_upHelper.clearLocalStorage();
          print('checkkkkkkkkkk');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (c) => const LoginScreen(logout: 'qrLogout')),
              (route) => false);
        }
      } else {
        pop_upHelper.popUpNavigatorPop(
            context, 2, CoolAlertType.success, 'Logged in successfully in web');
      }
    }
  }

  Widget myExpandedSheetCard() {
    return Container(
      decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )),
      width: maxWidth(context),
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox16(),
            Container(
              width: 40,
              height: 6,
              decoration: BoxDecoration(
                color: myColor.primaryColorDark,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox16(),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: kWhite.withOpacity(0.4),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code,
                        color: myColor.primaryColorDark,
                        size: 25.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'Know more about ',
                            style: kStyleNormal.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'QR',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' scanning.',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox16(),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: qrDescriptionList.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 10.0,
                          backgroundColor: kWhite.withOpacity(0.4),
                          child: Text(
                            (i + 1).toString(),
                            style: kStyleNormal.copyWith(fontSize: 10.0),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Text(
                            qrDescriptionList[i].desc.toString(),
                            style: kStyleNormal.copyWith(fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox12(),
          ],
        ),
      ),
    );
  }
}
