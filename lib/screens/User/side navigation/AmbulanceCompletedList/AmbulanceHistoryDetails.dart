import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyOrdersModel.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class AmbulanceHistoryDetails extends StatefulWidget {
  final MyOrdersModel myOrdersModel;
  const AmbulanceHistoryDetails({super.key, required this.myOrdersModel});

  @override
  State<AmbulanceHistoryDetails> createState() =>
      _AmbulanceHistoryDetailsState();
}

class _AmbulanceHistoryDetailsState extends State<AmbulanceHistoryDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Ride History',
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
              rideSummaryCard(),
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
                                text: '1200',
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
                      'Add Review',
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

  Widget rideSummaryCard() {
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
              'Ambulance Details',
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
                deliveryAddressCard(Icons.numbers_outlined, 'Ambulance No',
                    widget.myOrdersModel.orderNumber.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.phone, 'Phone',
                    widget.myOrdersModel.phone.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.directions_bike_outlined,
                    'Distance Travelled', '8 km'),
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
                              'Ride Status',
                              style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: kGreen.withOpacity(0.7),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0))),
                            child: Text(
                              'Completed',
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
              'Payment Details',
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
                deliveryAddressCard(Icons.monetization_on_outlined, 'Booking',
                    'Rs ${widget.myOrdersModel.subTotal.toString()}'),
                const SizedBox16(),
                deliveryAddressCard(
                    Icons.monetization_on_outlined,
                    'Destination Switched:',
                    'Rs ${widget.myOrdersModel.subTotal.toString()}'),
                const SizedBox16(),
              ],
            ),
          ),
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
              'Location Details',
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
                deliveryAddressCard(Icons.location_on_outlined, 'Ambulance',
                    widget.myOrdersModel.address.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.location_on_outlined, 'Pickup',
                    widget.myOrdersModel.address.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.location_on_outlined, 'Hospital',
                    widget.myOrdersModel.address.toString()),
                const SizedBox16(),
                deliveryAddressCard(Icons.location_on_outlined, 'Next Hospital',
                    widget.myOrdersModel.address.toString()),
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
