import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  final bool _offer = false;
  StateHandlerBloc? micBloc, volumeBloc, videoBloc, chatBloc, callEndBloc;
  RTCPeerConnection? _peerConnection;

  ///second person
  final _remoteRenderer = RTCVideoRenderer();

  final sdpController = TextEditingController();

  final Map<String, dynamic> mediaConstraints = {
    'audio': true,
    'video': {
      /// `Provide your own width, height and frame rate here`
      /// if it's larger than your screen , it wount showUP
      'mandatory': {
        'minWidth': '200',
        'minHeight': '200',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    },
  };

  ///`for UX`
  ///after clicking offer button there will a generated offer credintial and
  ///this variable will hold that jsonText
  ///later it will use to paste button but wait we on diff page ,
  /// then make textBOX or just use exits textField and filled with generated sdp Jsontext
  /// instead of depending on consol we gonna print somewhere of debig purpose
  /// later we will pass this data over some media
  /// this is called signaling
  dynamic offerJsonString;

  @override
  void initState() {
    super.initState();
    initRenderers();
    micBloc = StateHandlerBloc();
    volumeBloc = StateHandlerBloc();
    videoBloc = StateHandlerBloc();
    chatBloc = StateHandlerBloc();
    callEndBloc = StateHandlerBloc();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
  }

  _createPeerConnection() async {
    Map<String, dynamic> config = {
      "iceServers": [
        {
          "url":
              "https://ghargharmadoctor.metered.live/ghargharmadoctor-metting"
        },
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(config, offerSdpConstraints);

    pc.addStream(_localStream!);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        print(json.encode({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          // 'sdpMlineIndex': e.sdpMlineIndex,
        }));
      }
    };

    pc.onIceConnectionState = (e) {
      print(e);
    };

    pc.onAddStream = (stream) {
      print("addStream: ${stream.id}");
      _remoteRenderer.srcObject = stream;
    };

    return pc;
  }

  @override
  void dispose() {
    _localStream!.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    sdpController.dispose();
    super.dispose();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  _getUserMedia() async {
    var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    // _localStream = stream;
    _localRenderer.srcObject = stream;
    return stream;
  }

  bool isFrontCamera = true;

  void switchCamera() async {
    if (_localStream != null) {
      bool value = await _localStream!.getVideoTracks()[0].switchCamera();
      while (value == isFrontCamera) {
        value = await _localStream!.getVideoTracks()[0].switchCamera();
      }
      isFrontCamera = value;
    }
  }

  // getUserMedia() async {
  //   var devices = await navigator.mediaDevices.getUserMedia(mediaConstraints);
  //   log("logs" + devices.toString());
  // }
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // _createOFfer();
    // _answer();
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isEndDrawerOpen) {
          _scaffoldKey.currentState!.closeEndDrawer();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: myColor.dialogBackgroundColor,
        endDrawer: sideNavBar(),
        body: Container(
          color: myColor.dialogBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          width: maxWidth(context),
          height: maxHeight(context),
          child: Column(
            children: [
              Expanded(child: Container(color: kBlack, child: doctorView())),
              const SizedBox2(),
              Expanded(
                  child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: kBlack,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        )),
                    child: userView(),
                  ),
                  Positioned(
                    top: 5.0,
                    left: 5.0,
                    child: GestureDetector(
                      onTap: () {
                        switchCamera();
                      },
                      child: CircleAvatar(
                        backgroundColor: kWhite.withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.flip_camera_ios,
                            size: 16.0,
                            color: kBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    iconCard(
                        Icons.mic_rounded, Icons.mic_off_rounded, micBloc!),
                    iconCard(Icons.volume_up, Icons.volume_off, volumeBloc!),
                    iconCard(Icons.videocam, Icons.videocam_off, videoBloc!),
                    iconCard(Icons.message, Icons.message, chatBloc!),
                    iconCard(Icons.call_end, Icons.call_end, callEndBloc!,
                        bgColor: kRed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // body: Center(
    //   child: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         videoRenderers(),
    //         offerAnswerButton(),
    //         autoCompletedButton(),
    //         sdpCandidateTF(),
    //         sdpCandidateButtons(),
    //         myButton(context, kRed, 'Switch Cam', () {
    //           switchCamera();
    //         }),
    //       ],
    //     ),
    //   ),
    // ));
  }

  Widget doctorView() {
    return RTCVideoView(
      _remoteRenderer,
      mirror: true,
      placeholderBuilder: (_) => const Center(
        child: AnimatedLoading(),
      ),
    );
  }

  Widget userView() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child: RTCVideoView(
        _localRenderer,
        mirror: true,
        placeholderBuilder: (_) => const Center(
          child: AnimatedLoading(),
        ),
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
    );
  }

  Widget iconCard(icon, trailingIcon, bloc, {bgColor}) {
    return StreamBuilder<dynamic>(
        initialData: false,
        stream: bloc.stateStream,
        builder: (context, iconSnap) {
          return GestureDetector(
            onTap: () {
              if (bgColor == null) {
                if (bloc == chatBloc!) {
                  _scaffoldKey.currentState!.openEndDrawer();
                } else {
                  bloc.storeData(!iconSnap.data);
                }
              } else {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: backgroundColor,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (builder) {
                      return leaveMeetingBottomSheet(context);
                    });
              }
            },
            child: CircleAvatar(
              backgroundColor: iconSnap.data == false
                  ? bgColor ?? kWhite.withOpacity(0.4)
                  : myColor.primaryColorDark,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  iconSnap.data == false ? icon : trailingIcon,
                  size: 20.0,
                  color: iconSnap.data == false ? kBlack : kWhite,
                ),
              ),
            ),
          );
        });
  }

  Widget sideNavBar() {
    return SizedBox(
      width: maxWidth(context) / 1.3,
      height: maxHeight(context),
      child: StatefulBuilder(builder: (context, s) {
        return Column(
          children: [
            Container(
              color: myColor.dialogBackgroundColor,
              width: maxWidth(context),
              height: 130.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Send\n',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Messages',
                          style: kStyleNormal.copyWith(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: kWhite.withOpacity(0.4),
                    radius: 14.0,
                    child: Icon(Icons.message,
                        size: 15.0, color: myColor.primaryColorDark),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: maxWidth(context),
                height: maxHeight(context),
                color: myColor.dialogBackgroundColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 12.0, top: 12.0, left: 12.0),
                      width: 70,
                      margin: const EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: const Text('chats are here'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                color: myColor.dialogBackgroundColor,
                width: maxWidth(context),
                child: searchCard(context)),
          ],
        );
      }),
    );
  }

  Widget searchCard(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: mytextFormFieldWithPrefixIcon(
            context,
            FocusNode(),
            null,
            'Enter text',
            '',
            '',
            Icons.message,
            kWhite.withOpacity(0.4),
            onValueChanged: (v) {},
          ),
        ),
        const SizedBox(width: 8.0),
        Container(
          decoration: BoxDecoration(
            color: kWhite.withOpacity(0.5),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ),
      ],
    );
  }

  Widget leaveMeetingBottomSheet(context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox12(),
            SizedBox(
              width: maxWidth(context),
              height: 50.0,
              child: myCustomButton(
                context,
                kRed,
                'Leave Call',
                kStyleNormal.copyWith(
                    fontSize: 14.0, color: kWhite, fontWeight: FontWeight.bold),
                () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox12(),
          ],
        ),
      );
    });
  }

  // SizedBox videoRenderers() => SizedBox(
  //       height: 200,
  //       child: Row(
  //         children: [
  //           Flexible(
  //             child: Container(
  //               margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
  //               // width: MediaQuery.of(context).size.width,
  //               // height: 400,
  //               child: RTCVideoView(_localRenderer, mirror: true),
  //               // child: Text("hey"),
  //             ),
  //           ),
  //           Flexible(
  //             child: Container(
  //               margin: const EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
  //               // width: MediaQuery.of(context).size.width,
  //               // height: 400,
  //               child: RTCVideoView(_remoteRenderer, mirror: true),
  //               // child: Text("hey"),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  // Widget offerAnswerButton() => Padding(
  //       padding: const EdgeInsets.all(10.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Row(
  //             children: [
  //               myButton(context, kRed, 'Offer', () {
  //                 _createOFfer();
  //               }),
  //               const SizedBox(
  //                 width: 10,
  //               ),
  //               const Text("1st click here")
  //             ],
  //           ),
  //           myButton(context, kRed, '_answer call', () {
  //             _createOFfer();
  //           }),
  //         ],
  //       ),
  //     );

  // Padding sdpCandidateTF() => Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: TextField(
  //         controller: sdpController,
  //         keyboardType: TextInputType.multiline,
  //         maxLines: 4,
  //         maxLength: TextField.noMaxLength,
  //       ),
  //     );

  // Row sdpCandidateButtons() => Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         myButton(context, kRed, 'set Remote Desc', () {
  //           _setRemodeDescription();
  //         }),
  //         myButton(context, kRed, 'set Candidate', () {
  //           _setCandiate();
  //         }),
  //       ],
  //     );

  // /// `auto copyPaste creditial helper`
  // Widget autoCompletedButton() => Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Row(
  //             children: [
  //               myButton(context, kRed, 'Copy & paste', () {
  //                 _copyPasteSdp();
  //               }),
  //               const SizedBox(
  //                 width: 10,
  //               ),
  //               const Text("2nd click here")
  //             ],
  //           ),
  //           Container(),
  //         ],
  //       ),
  //     );

  // void _copyPasteSdp() {}

  // ///`Offer Text copy and hold on Copy & paste`
  // void _createOFfer() async {
  //   Map<String, dynamic> cfMap = {'offerToReceiveVideo': 1};
  //   RTCSessionDescription description =
  //       await _peerConnection!.createOffer(cfMap);

  //   var session = parse(description.sdp!);
  //   // log("oFFer>> " + json.encode(session));

  //   print('hello ${json.encode(session)}');
  //   _offer = true;
  //   _peerConnection!.setLocalDescription(description);
  // }

  // void _setRemodeDescription() async {
  //   String jsonString = sdpController.text;
  //   dynamic session = await jsonDecode(jsonString);

  //   String sdp = write(session, null);

  //   RTCSessionDescription description =
  //       RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

  //   print(description.toMap());

  //   await _peerConnection!.setRemoteDescription(description);
  // }

  // void _answer() async {
  //   RTCSessionDescription description =
  //       await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

  //   var session = parse(description.sdp!);
  //   print(json.encode(session));
  //   _peerConnection!.setLocalDescription(description);
  // }

  // void _setCandiate() async {
  //   String jsonString = sdpController.text;

  //   dynamic session = await jsonDecode(jsonString);
  //   print(session['candidate']);

  //   dynamic candidate = RTCIceCandidate(
  //       session['candidate'], session['sdpMid'], session['sdpMlineIndex']);

  //   await _peerConnection!.addCandidate(candidate);
  // }
}
