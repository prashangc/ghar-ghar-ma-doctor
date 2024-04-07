import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyOrdersModel.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/orderdProductCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class OrderDetailsScreen extends StatefulWidget {
  final MyOrdersModel myOrdersModel;
  const OrderDetailsScreen({Key? key, required this.myOrdersModel})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Order Details',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Container(
        height: maxHeight(context),
        margin: const EdgeInsets.only(top: 15.0),
        // padding: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox16(),
              orderSummaryCard(),
              const SizedBox16(),
              productListCard(),
              const SizedBox16(),
              shippingAddressCard(),
              const SizedBox16(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: myColor.dialogBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: maxWidth(context),
        height: 85.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox8(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 60.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Price',
                          style: kStyleNormal.copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Rs  ',
                            style: kStyleNormal.copyWith(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                text:
                                    widget.myOrdersModel.totalAmount.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50.0,
                    child: myCustomButton(
                      context,
                      myColor.primaryColorDark,
                      'Get Order',
                      kStyleNormal.copyWith(
                          fontSize: 16.0, color: Colors.white),
                      () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget orderSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Order Summary',
              style: kStyleNormal.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                deliveryAddressCard(Icons.numbers_outlined, 'Order No:',
                    widget.myOrdersModel.orderNumber.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.date_range, 'Placed On:',
                    widget.myOrdersModel.createdAt.toString().substring(0, 10)),
                const SizedBox16(),
                deliveryAddressCard(
                    Icons.directions_bike_outlined,
                    'Delivery Charge',
                    'Rs ${widget.myOrdersModel.totalAmount.toString()}'),
                const SizedBox12(),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on_outlined,
                      size: 15.0,
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Payment Method',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.7),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0))),
                            child: Text(
                              widget.myOrdersModel.paymentMethod.toString() ==
                                      'cod'
                                  ? 'Cash on Delivery'
                                  : widget.myOrdersModel.paymentMethod
                                      .toString()
                                      .capitalize(),
                              textAlign: TextAlign.end,
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                                color: myColor.scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox16(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productListCard() {
    return Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              'Products ',
              style: kStyleNormal.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.myOrdersModel.products!.length,
              itemBuilder: (ctx, i) {
                return orderProductCard(widget.myOrdersModel.products![i]);
              }),
        ],
      ),
    );
  }

  Widget shippingAddressCard() {
    return Container(
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Shipping Address',
              style: kStyleNormal.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox2(),
          const SizedBox2(),
          Divider(
            color: myColor.dialogBackgroundColor,
          ),
          const SizedBox2(),
          const SizedBox2(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                deliveryAddressCard(Icons.location_on, 'Address:',
                    widget.myOrdersModel.address.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.phone, 'Phone:',
                    widget.myOrdersModel.phone.toString()),
                const SizedBox16(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget deliveryAddressCard(myIcon, titleText, text) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              myIcon,
              size: 15.0,
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleText,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.end,
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
