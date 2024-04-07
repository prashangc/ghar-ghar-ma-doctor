// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';
// import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
// import 'package:flutter/material.dart';
// import 'package:ghargharmadoctor/constants/buttons.dart';

// class EsewaTestScreen extends StatefulWidget {
//   const EsewaTestScreen({Key? key}) : super(key: key);

//   @override
//   State<EsewaTestScreen> createState() => _EsewaTestScreenState();
// }

// class _EsewaTestScreenState extends State<EsewaTestScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('esewa SDSK'),
//       ),
//       body: myButton(
//         context,
//         Colors.red,
//         'Pay',
//         () async {
//           payBtn('product');
//         },
//       ),
//     );
//   }

//   payBtn(String product) async {
//     print("objectttttttttttttttttttttttttttttttttttttttttttt3");
//     try {
//       EsewaFlutterSdk.initPayment(
//         esewaConfig: EsewaConfig(
//           clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
//           secretId: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
//           environment: Environment.test,
//         ),
//         esewaPayment: EsewaPayment(
//           productId: "1d71jd81",
//           productName: "Product One",
//           productPrice: "1000",
//           callbackUrl: "https://www.test-payment-callback.com",
//         ),
//         onPaymentSuccess: (EsewaPaymentSuccessResult data) {
//           debugPrint(":::SUCCESS::: => $data");
//         },
//         onPaymentFailure: (data) {
//           debugPrint(":::FAILURE::: => $data");
//         },
//         onPaymentCancellation: (data) {
//           debugPrint(":::CANCELLATION::: => $data");
//         },
//       );
//     } on Exception catch (e) {
//       debugPrint("EXCEPTION : ${e.toString()}");
//     }
//   }
// }
