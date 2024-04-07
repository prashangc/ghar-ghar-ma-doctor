import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyLabsModel/MyLabsModel.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';

Widget payNowBottomModel(context, MyLabsModel labModel) {
  String selectedPaymentMethod = 'esewa';
  payBtn(MyLabsModel labModel) {
    switch (selectedPaymentMethod) {
      case 'esewa':
        // myEsewa(context, widget.totalAmount.toString());
        break;

      case 'khalti':
        myKhalti(
          context,
          labModel.price.toString(),
          'isLabPaymentOnly',
          //  labModel.labprofile != null ?
          labModel.id,
          detailsModel: labModel,
        );
        break;

      case '2':
        break;

      case '3':
        break;

      case '4':
        break;

      case '5':
        break;

      default:
    }
  }

  return StatefulBuilder(builder: (context, setState) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox12(),
                paymentMethod(context, false, true, onValueChanged: (v) {
                  selectedPaymentMethod = v;
                  print(v);
                }),
                SizedBox(
                  width: maxWidth(context),
                  height: 56.0,
                  child: myCustomButton(
                    context,
                    myColor.primaryColorDark,
                    'Rs  ${labModel.price.toString()}',
                    kStyleNormal.copyWith(fontSize: 16.0, color: Colors.white),
                    () {
                      payBtn(labModel);
                    },
                  ),
                ),
                const SizedBox12(),
              ])),
    );
  });
}
