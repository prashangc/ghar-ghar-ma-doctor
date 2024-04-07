import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/MyOrders.dart';
import 'package:ghargharmadoctor/widgets/myCustomAppBar.dart';

class OrderCompletionScreen extends StatefulWidget {
  const OrderCompletionScreen({Key? key}) : super(key: key);

  @override
  State<OrderCompletionScreen> createState() => _OrderCompletionScreenState();
}

class _OrderCompletionScreenState extends State<OrderCompletionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(
        title: 'Order Completed',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Success'),
            myCustomButton(
              context,
              myColor.primaryColorDark,
              'Change',
              kStyleNormal.copyWith(color: Colors.white),
              () {
                goThere(context, const MyOrders());
              },
            )
          ],
        ),
      ),
    );
  }
}
