// import 'package:esewa_pnp/esewa.dart';
// import 'package:esewa_pnp/esewa_pnp.dart';
// import 'package:flutter/material.dart';

// myEsewaFlutter(BuildContext context, double totalAmount) async {
//   ESewaConfiguration configuration = ESewaConfiguration(
//       clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
//       secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
//       environment: ESewaConfiguration.ENVIRONMENT_TEST);

//   ESewaPnp esewaPnp = ESewaPnp(configuration: configuration);

//   ESewaPayment payment = ESewaPayment(
//       amount: totalAmount,
//       productName: "hello",
//       productID: "1",
//       callBackURL: "http:example.com");
//   try {
//     final res = await esewaPnp.initPayment(payment: payment);
//     // Handle success
//   } on ESewaPaymentException {
//     // Handle error
//   }
// }
