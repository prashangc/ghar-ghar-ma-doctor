import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/myLoadingScreen.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

myKhalti(context, totalAmount, paymentReason, model,
    {paymentInterval, detailsModel, addressModel, labType}) {
  KhaltiScope.of(context).pay(
      config: PaymentConfig(
        // amount: totalAmount * 100,
        amount: 1000,
        productIdentity: 'dells-sssssg5-g5510-2021',
        productName: 'widget.productName',
      ),
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.eBanking,
        PaymentPreference.sct,
        PaymentPreference.mobileBanking,
        PaymentPreference.connectIPS,
      ],
      onSuccess: (su) async {
        Navigator.pop(context);
        Navigator.pop(context);
        goThere(
          context,
          MyLoadingScreen(
            model: model,
            totalAmount: totalAmount,
            su: su,
            paymentType: paymentReason,
            paymentInterval: paymentInterval,
            detailsModel: detailsModel,
            addressModel: addressModel,
            labType: labType,
          ),
        );
      },
      onFailure: (fa) {
        const failedsnackBar = SnackBar(
          content: Text('Payment Failed'),
        );
        ScaffoldMessenger.of(context).showSnackBar(failedsnackBar);
      },
      onCancel: () {
        const cancelsnackBar = SnackBar(
          content: Text('Payment Cancelled'),
        );
        ScaffoldMessenger.of(context).showSnackBar(cancelsnackBar);
      });
}
