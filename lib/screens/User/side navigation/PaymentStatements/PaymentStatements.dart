import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timelines/timelines.dart';

class PaymentStatements extends StatefulWidget {
  const PaymentStatements({
    super.key,
  });

  @override
  State<PaymentStatements> createState() => _PaymentStatementsState();
}

class _PaymentStatementsState extends State<PaymentStatements> {
  StateHandlerBloc invoiceLoadingBloc = StateHandlerBloc();
  DateTime? currentDate;
  ApiHandlerBloc? statementBloc;
  List<PaymentStatementModel> paymentStatementModel = [];
  String? myPhone, myEmail, myName;
  File? pdfFile;

  @override
  void initState() {
    super.initState();
    statementBloc = ApiHandlerBloc();
    statementBloc!.fetchAPIList(endpoints.getPaymentStatementEndpoint);
    getDate();
    getProfileInformation();
  }

  void getDate() {
    currentDate = DateTime.now();
  }

  getProfileInformation() async {
    var test = await sharedPrefs.getFromDevice("userProfile");
    ProfileModel profileModel = ProfileModel.fromJson(json.decode(test));
    myPhone = profileModel.member!.phone;
    myEmail = profileModel.member!.email;
    myName = profileModel.member!.name;
  }

  invoiceCreation(index) async {
    invoiceLoadingBloc.storeData(2);
    if (await checkStoragePermission(Permission.storage)) {
      List<InvoiceDetails> productList = [];
      productList.clear();
      productList.add(
        InvoiceDetails(
          itemName: 'productName',
          vat: '200',
          quantity: '1',
          totalPrice: '${paymentStatementModel[index].amount}',
          deliveryCharge: '20',
          discount: '220',
        ),
      );
      // productList.add(
      //   InvoiceDetails(
      //     consultantName: 'Product Name',
      //     appointmentDate:
      //         '${getMonth(currentDate.toString())} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)} [${currentDate.toString().substring(11, 16)}]',
      //     consultationFee: 'Rs ${paymentStatementModel[index].amount}',
      //     vat: '20',
      //     totalPrice: '${paymentStatementModel[index].amount}',
      //     quantity: '1',
      //   ),
      // );
      InvoiceModel invoiceModel = InvoiceModel(
          fileName: paymentStatementModel[index].serviceName.toString(),
          date:
              '${paymentStatementModel[index].date!.substring(8, 10)} ${getMonth(paymentStatementModel[index].date!.substring(0, 10))} ${paymentStatementModel[index].date!.substring(0, 4)}, ${paymentStatementModel[index].date!.substring(11, 16)}',
          address: paymentStatementModel[index].address.toString(),
          name: paymentStatementModel[index].name.toString(),
          phone: myPhone.toString(),
          email: myEmail.toString(),
          invoiceType: paymentStatementModel[index].serviceName == 'Product'
              ? 'Order'
              : paymentStatementModel[index].serviceName ==
                          'isLabPaymentOnly' ||
                      paymentStatementModel[index].serviceName == 'isLabBooking'
                  ? 'Lab'
                  : paymentStatementModel[index].serviceName ==
                              'isPackageBooking' ||
                          paymentStatementModel[index].serviceName ==
                              'isPackagePaymentOnly'
                      ? 'Package'
                      : 'Appointment',
          items: productList);

      pdfFile = await PdfReceipt.generatePDF(invoiceModel);

      invoiceLoadingBloc.storeData(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Payment Statements',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Container(
        width: maxWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        margin: const EdgeInsets.only(top: 12.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: StreamBuilder<ApiResponse<dynamic>>(
          stream: statementBloc!.apiListStream,
          builder: ((c, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return SizedBox(
                    width: maxWidth(context),
                    height: maxHeight(context),
                    child: const AnimatedLoading(),
                  );
                case Status.COMPLETED:
                  if (snapshot.data!.data.isEmpty) {
                    return emptyPage(
                      context,
                      'No any payment',
                      'No any payments has been done',
                      'Go Back',
                      () {
                        Navigator.pop(context);
                      },
                    );
                  }
                  paymentStatementModel = List<PaymentStatementModel>.from(
                      snapshot.data!.data
                          .map((i) => PaymentStatementModel.fromJson(i)));
                  return Column(children: [
                    FixedTimeline.tileBuilder(
                      theme: TimelineThemeData(
                        nodePosition: 0.0,
                        indicatorPosition: 0.0,
                        color: kWhite.withOpacity(0.4),
                        indicatorTheme: IndicatorThemeData(
                          color: myColor.primaryColorDark,
                        ),
                        direction: Axis.vertical,
                        connectorTheme: ConnectorThemeData(
                          color: kWhite.withOpacity(0.4),
                          indent: 4.0,
                          space: 30.0,
                          thickness: 2.0,
                        ),
                      ),
                      builder: TimelineTileBuilder.connectedFromStyle(
                        contentsAlign: ContentsAlign.basic,
                        contentsBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              paymentStatementModel[index]
                                  .date
                                  .toString()
                                  .substring(0, 10),
                              style: kStyleNormal.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: maxWidth(context),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                color: kWhite.withOpacity(0.4),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      myRow('Amount',
                                          'Rs ${paymentStatementModel[index].amount}'),
                                      myRow(
                                          'Service Type',
                                          paymentStatementModel[index]
                                              .serviceName),
                                      myRow(
                                        'Payment Method',
                                        paymentStatementModel[index]
                                            .paymentMethod,
                                        showDivider: false,
                                        image: paymentStatementModel[index]
                                                    .paymentMethod ==
                                                'Esewa'
                                            ? 'assets/esewa.png'
                                            : paymentStatementModel[index]
                                                        .paymentMethod ==
                                                    'Khalti'
                                                ? 'assets/khalti.png'
                                                : 'assets/esewa.png',
                                      ),
                                    ],
                                  ),
                                  const SizedBox2(),
                                  Divider(color: myColor.dialogBackgroundColor),
                                  const SizedBox2(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.clock,
                                            size: 15.0,
                                            color: myColor.primaryColorDark,
                                          ),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            '${paymentStatementModel[index].date!.substring(8, 10)} ${getMonth(paymentStatementModel[index].date!.substring(0, 10))} ${paymentStatementModel[index].date!.substring(0, 4)}, ${paymentStatementModel[index].date!.substring(11, 16)}',
                                            overflow: TextOverflow.ellipsis,
                                            style: kStyleNormal.copyWith(
                                              fontSize: 16.0,
                                              color: myColor.primaryColorDark,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      StreamBuilder<dynamic>(
                                          stream:
                                              invoiceLoadingBloc.stateStream,
                                          initialData: 0,
                                          builder: (c, s) {
                                            if (s.data == 0) {
                                              return GestureDetector(
                                                onTap: () {
                                                  invoiceCreation(index);
                                                },
                                                child: Icon(
                                                  Icons.download,
                                                  size: 18.0,
                                                  color:
                                                      myColor.primaryColorDark,
                                                ),
                                              );
                                            } else if (s.data == 1) {
                                              return GestureDetector(
                                                onTap: () {
                                                  FileApi.openFile(pdfFile!);
                                                },
                                                child: Icon(
                                                  Icons.picture_as_pdf_outlined,
                                                  size: 20.0,
                                                  color:
                                                      myColor.primaryColorDark,
                                                ),
                                              );
                                            } else {
                                              return SizedBox(
                                                  width: 20.0,
                                                  height: 20.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: myColor
                                                        .primaryColorDark,
                                                    backgroundColor: myColor
                                                        .dialogBackgroundColor,
                                                    strokeWidth: 1.0,
                                                  ));
                                            }
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        connectorStyleBuilder: (context, index) =>
                            ConnectorStyle.solidLine,
                        indicatorStyleBuilder: (context, index) =>
                            IndicatorStyle.outlined,
                        itemCount: paymentStatementModel.length,
                      ),
                    ),
                  ]);
                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 135.0,
                    decoration: BoxDecoration(
                      color: kWhite,
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
    );
  }

  Widget myRow(title, text, {color, showDivider, image}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                  )),
              const SizedBox(width: 4.0),
              image != null
                  ? Image.asset('assets/esewa.png', width: 50.0, height: 30.0)
                  : Text(text,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.clip,
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: color ?? kBlack,
                      )),
            ],
          ),
          showDivider == false
              ? Container(height: 6.0)
              : Divider(color: myColor.dialogBackgroundColor),
        ],
      ),
    );
  }
}
