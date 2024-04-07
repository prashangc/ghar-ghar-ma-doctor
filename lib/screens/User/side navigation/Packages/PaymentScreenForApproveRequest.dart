import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class PaymentScreenForApproveRequest extends StatefulWidget {
  final List<int> familyId;
  const PaymentScreenForApproveRequest({super.key, required this.familyId});

  @override
  State<PaymentScreenForApproveRequest> createState() =>
      _PaymentScreenForApproveRequestState();
}

class _PaymentScreenForApproveRequestState
    extends State<PaymentScreenForApproveRequest> {
  ApiHandlerBloc? subscriptionBloc;
  String? paymentType;
  StateHandlerBloc? bottomNavBloc;
  PaymentDetailsOfPackageWhileReqApprove? model;
  @override
  void initState() {
    super.initState();
    bottomNavBloc = StateHandlerBloc();
    subscriptionBloc = ApiHandlerBloc();
    subscriptionBloc!.fetchAPIList(
        '${endpoints.getPaymentDetailsOfPackageWhileReqApproveEndpoints}?family_count=${widget.familyId.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: myColor.colorScheme.background,
      appBar: myCustomAppBar(
          title: 'Subscription Payment',
          color: myColor.colorScheme.background,
          borderRadius: 0.0),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: maxWidth(context),
        height: maxHeight(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: StreamBuilder<ApiResponse<dynamic>>(
          stream: subscriptionBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return SizedBox(
                    width: maxWidth(context),
                    height: maxHeight(context),
                    child: const Center(
                      child: AnimatedLoading(),
                    ),
                  );
                case Status.COMPLETED:
                  model = PaymentDetailsOfPackageWhileReqApprove.fromJson(
                      snapshot.data!.data);
                  bottomNavBloc!.storeData('show');
                  if (snapshot.data!.data.isEmpty) {
                    return Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('No packages added'),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      infoCard(
                          context,
                          const Color.fromARGB(255, 255, 205, 202),
                          kRed,
                          'Payment required for ongoing package'),
                      const SizedBox12(),
                      Container(
                        width: maxWidth(context),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: kWhite.withOpacity(0.4),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox12(),
                              Text(
                                'Details',
                                style: kStyleNormal.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox2(),
                              const SizedBox2(),
                              const Divider(),
                              const SizedBox2(),
                              const SizedBox2(),
                              myRow('Total Additional Family Member',
                                  widget.familyId.length.toString()),
                              myRow('Enrollment fee',
                                  'Rs ${model!.enrollmentFee.toString()}'),
                              myRow('Daily fee',
                                  'Rs ${model!.dailyFee.toString()}'),
                              myRow('Remaining Payment Days',
                                  '${model!.paymentDays.toString()} days'),
                              const SizedBox16(),
                            ]),
                      ),
                      const SizedBox12(),
                      Container(
                        width: maxWidth(context),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: kWhite.withOpacity(0.4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox12(),
                            Text(
                              'Payment Method',
                              style: kStyleNormal.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox12(),
                            paymentMethod(context, false, true,
                                onValueChanged: (v) {
                              paymentType = v;
                            })
                          ],
                        ),
                      ),
                    ],
                  );
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    height: 135.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Server Error'),
                    ),
                  );
              }
            }
            return const SizedBox();
          }),
        ),
      ),
      bottomNavigationBar: Container(
        color: myColor.dialogBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        width: maxWidth(context),
        height: 85.0,
        child: StreamBuilder<dynamic>(
          initialData: 'empty',
          stream: bottomNavBloc!.stateStream,
          builder: ((context, snapshot) {
            if (snapshot.data == 'empty') {
              return Container();
            } else {
              return Row(
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
                                  text: model!.totalPayment.toString(),
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
                        'Pay',
                        kStyleNormal.copyWith(
                            fontSize: 16.0, color: Colors.white),
                        () {
                          payBtn('isSubscriptionPaymentForFamilyReqApprove');
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  payBtn(type) {
    switch (paymentType) {
      case 'esewa':
        // myEsewa(context, widget.totalAmount.toString());
        break;

      case 'khalti':
        myKhalti(context, model!.totalPayment!, type, model,
            paymentInterval: widget.familyId);
        break;

      case '2':
        // myEsewaFlutter(context, double.parse(widget.totalAmount.toString()));
        break;

      case '3':
        // myKhalti(context, widget.totalAmount, 'isProductOrder');
        break;

      case '4':
        // goThere(context, const EsewaTestScreen());
        break;

      case '5':
        // myKhalti(context, widget.totalAmount, 'isProductOrder');
        break;

      default:
    }
  }

  myRow(title, value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: kStyleNormal.copyWith(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        const SizedBox12(),
      ],
    );
  }
}
