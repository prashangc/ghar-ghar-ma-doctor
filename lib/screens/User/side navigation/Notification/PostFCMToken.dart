import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/models/PostFcmTokenModel.dart';

import '../../../../constants/constants_imports.dart';
import '../../../../widgets/widgets_import.dart';

class PostFCMToken extends StatefulWidget {
  const PostFCMToken({Key? key}) : super(key: key);

  @override
  State<PostFCMToken> createState() => _PostFCMTokenState();
}

class _PostFCMTokenState extends State<PostFCMToken> {
  bool isSwitched = false;
  String? fcmToken;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fcmToken = sharedPrefs.getFromDevice('fcm');
    print(fcmToken);
  }

  Future _postFCMToken() async {
    var statusCode;
    print('heelo ths is fcm $fcmToken');
    statusCode = await API().postData(context,
        PostFcmTokenModel(deviceKey: fcmToken), endpoints.postFCMTokenEndpoint);
    if (statusCode == 200) {
      mySnackbar.mySnackBar(context, 'Success: $statusCode', Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Post FCM Token',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: fcmToken!));
                  mySnackbar.mySnackBar(context, 'Token copied to clipboard',
                      Colors.black.withOpacity(0.3));
                },
                child: Text(fcmToken.toString())),
            const SizedBox32(),
            Switch(
              value: isSwitched,
              onChanged: (value) async {
                setState(() {
                  isSwitched = value;
                  print(isSwitched);
                });

                if (isSwitched == true) {
                  _postFCMToken();
                }
              },
              activeTrackColor: Colors.green[200],
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
