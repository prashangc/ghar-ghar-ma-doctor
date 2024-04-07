// import 'package:flutter/material.dart';
// import 'package:ghargharmadoctor/constants/constants_imports.dart';
// import 'package:ghargharmadoctor/screens/User/ForgetPassword/ChangePassword.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<void> initDynamicLinks() async {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  dynamicLinks.onLink.listen((dynamicLinkData) {
    // Navigator.pushNamed(context, dynamicLinkData.link.path);
  }).onError((error) {
    print('onLink error');
    print(error.message);
  });
}
// void initDynamicLinks(BuildContext context) {
//   FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
//     final Uri? deeplink = dynamicLink?.link;
//     if (deeplink != null) {
//       print("deepLink data $deeplink");
//       goThere(context, const ChangePassword());
//     }
//   }, onError: (Exception e) async {
//     print('ERROR - $e');
//   }
//   return _delegate.onLink;
//   );
// }
