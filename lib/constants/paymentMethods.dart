import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/PaymentMethodModel.dart';

Widget paymentMethod(
    BuildContext context, bool showCashOnDelivery, bool showCircleIcon,
    {required ValueChanged<String>? onValueChanged}) {
  int selectedIndexs = 0;
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        SizedBox(
          // width: maxWidth(context),
          // height: 200.0,
          child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: maxWidth(context) / 300,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              // scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentMethods.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndexs = index;
                    });
                    onValueChanged!(
                        paymentMethods[selectedIndexs].name.toString());
                  },
                  child: Container(
                    // height: 50,
                    // width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: selectedIndexs == index
                            ? Colors.green
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(showCircleIcon == true ? 12.0 : 8.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  paymentMethods[index].imageUrl.toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        showCircleIcon == true
                            ? Container(
                                width: 40,
                                height: maxHeight(context),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Icon(
                                  selectedIndexs == index
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: selectedIndexs == index
                                      ? kGreen
                                      : Colors.grey[200],
                                  size: 15.0,
                                ),
                              )
                            : const SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                );
              }),
        ),
        const SizedBox12(),
        showCashOnDelivery == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndexs = -1;
                  });
                  onValueChanged!('cash on delivery');
                },
                child: Container(
                  height: 100,
                  width: maxWidth(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: selectedIndexs == -1
                          ? Colors.green
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                          ),
                        ),
                        width: 80.0,
                        height: maxHeight(context),
                        child: Image.asset('assets/cash_on_delivery.png'),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cash on Delivery',
                                style: kStyleNormal.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                'Additional Rs 100 will be charged.',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: maxHeight(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Icon(
                          selectedIndexs == -1
                              ? Icons.check_circle
                              : Icons.circle,
                          color: selectedIndexs == -1
                              ? Colors.green
                              : Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  });
}
