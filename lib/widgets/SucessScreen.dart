import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class SucessScreen extends StatefulWidget {
  final String title;
  final String subTitle;
  final String btnText;
  final dynamic screen;
  final dynamic model;
  final UserDetailsDatabaseModel? addressModel;
  final List<MyCartDatabaseModel>? productModel;
  final OrderResponseModel? orderResponseModel;
  const SucessScreen({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.btnText,
    required this.screen,
    required this.model,
    this.addressModel,
    this.productModel,
    this.orderResponseModel,
  }) : super(key: key);

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  DateTime? currentDate;
  ProfileModel? profileModel;
  StateHandlerBloc? invoiceBtnBloc;
  PermissionStatus? _permissionStatus;
  String? myEmail;
  @override
  void initState() {
    super.initState();
    invoiceBtnBloc = StateHandlerBloc();
    getDate();
    getProfileInformation();
  }

  getProfileInformation() async {
    var test = await sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    myEmail = profileModel!.member!.email;
  }

  void getDate() {
    currentDate = DateTime.now();
  }

  Future<void> requestPermission() async {
    Permission? permission;
    final status = await permission!.request();

    // setState(() {
    //   print(status);
    //   _permissionStatus = status;
    // });
  }

  void invoiceCreation() async {
    if (await checkStoragePermission(Permission.storage)) {
      invoiceBtnBloc!.storeData(true);
      List<InvoiceDetails> productList = [];
      for (var e in widget.productModel!) {
        productList.add(InvoiceDetails(
          itemName: e.productName,
          vat: '200',
          quantity: e.productQuantity,
          totalPrice: e.productTotalAmount,
          deliveryCharge: e.totalSellingPriceAfterDiscount,
          discount: e.discount,
        ));
      }
      InvoiceModel invoiceModel = InvoiceModel(
          fileName: 'Order_invoice#${widget.orderResponseModel!.orderNumber}',
          date:
              '${getMonth(currentDate.toString())}  ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)}',
          address: widget.addressModel!.address.toString(),
          name: widget.addressModel!.fullName.toString(),
          phone: widget.model.phone.toString(),
          email: myEmail.toString(),
          items: productList);
      final pdfFile = await PdfInvoiceApi.generate(invoiceModel);
      invoiceBtnBloc!.storeData(false);
      // FileApi.openFile(pdfFile);
    } else {
      MySnackBar()
          .mySnackBar(context, 'Permission Denied', kBlack.withOpacity(0.8));
    }
    // Permission? permission;
    // Permission.storage.request();
    // Permission.storage;
    //  var permission = await checkPermissionStatus(PermissionGroup.storage);

    //   if (permission != PermissionStatus.granted) {
    //     await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    //     permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    //   }

    //   return permission == PermissionStatus.granted;

//     var status = await Permission.storage.status;
//     if (status.isDenied) {
//       MySnackBar()
//           .mySnackBar(context, 'Permission Denied', kBlack.withOpacity(0.8));
//     } else {
//       print('hello');
//     }

// // You can can also directly ask the permission about its status.
//     if (await Permission.location.isRestricted) {
//       // The OS restricts access, for example because of parental controls.
//     }
    // requestPermission(); // Permission? permission;
    // requestPermission(permission!);
    // PermissionStatus? permissionStatus;
    // final status = permissionStatus!.isGranted;

    // if (status == PermissionStatus.denied) {
    //   permissionGranted = await location.requestPermission();
    //   if (permissionGranted != PermissionStatus.granted) {
    //     print('my location is $permissionGranted');
    //     return;
    //   }
    // }
    // // var status = await Permission.storage.status;
    // if (true) {
    // } else if (await Permission.location.isRestricted) {
    //   MySnackBar().mySnackBar(context, 'Storage Restricted on your device',
    //       kBlack.withOpacity(0.8));
    // } else {

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          automaticallyImplyLeading: false,
          backgroundColor: widget.title != 'Order Success'
              ? backgroundColor
              : myColor.dialogBackgroundColor,
          elevation: 0.0,
        ),
        backgroundColor: backgroundColor,
        body: widget.title != 'Order Success'
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: maxWidth(context),
                      height: maxHeight(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: maxHeight(context) / 2.4,
                            child: Image.asset(
                              'assets/empty_basket.png',
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox12(),
                                Text(
                                  widget.title,
                                  style: kStyleNormal.copyWith(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox8(),
                                Text(
                                  widget.subTitle,
                                  style: kStyleNormal.copyWith(
                                    color: Colors.grey[400],
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox16(),
                                GestureDetector(
                                  onTap: () {
                                    goThere(context, widget.screen);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      border: Border.all(
                                          color: myColor.primaryColorDark,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    margin: const EdgeInsets.fromLTRB(
                                        12.0, 0.0, 12.0, 18.0),
                                    width: maxWidth(context) / 3,
                                    height: 45,
                                    child: Center(
                                      child: Text(
                                        widget.btnText,
                                        style: kStyleNormal.copyWith(
                                          color: myColor.primaryColorDark,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                width: maxWidth(context),
                height: maxHeight(context),
                child: Column(
                  children: [
                    Container(
                      height: 140.0,
                      width: maxWidth(context),
                      color: myColor.dialogBackgroundColor,
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: kGreen,
                            size: 65.0,
                          ),
                          const SizedBox12(),
                          Text(
                            widget.title,
                            style: kStyleNormal.copyWith(
                              color: kGreen,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox24(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: maxWidth(context),
                            height: maxHeight(context),
                            color: backgroundColor,
                          ),
                          Positioned(
                            child: Container(
                              width: maxWidth(context),
                              height: 40,
                              color: myColor.dialogBackgroundColor,
                            ),
                          ),
                          Positioned(
                            left: 12.0,
                            right: 12.0,
                            child: Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      statementCard(),
                                      const SizedBox12(),
                                      productCard(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainHomePage(
                        tabIndex: 0,
                        index: widget.title == 'Order Success' ? 0 : 1)),
                (route) => false);
          },
          child: Container(
            width: maxWidth(context),
            height: 60.0,
            color: myColor.primaryColorDark,
            child: Center(
              child: Text(
                'Return Home',
                style: kStyleNormal.copyWith(
                  color: myColor.scaffoldBackgroundColor,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
        ));
  }

  Widget statementCard() {
    return Container(
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox16(),
            myRow('Date/Time',
                '${getMonth(currentDate.toString())}  ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)} [${currentDate.toString().substring(11, 16)}]'),
            myRow(
                'Payment Type',
                widget.model.paymentMethod.toString() == 'cod'
                    ? 'Cash On Delivery'
                    : widget.model.paymentMethod.toString()),
            myRow('Ordered By', widget.addressModel!.fullName.toString()),
            myRow('Phone', widget.model.phone.toString()),
            myRow('Delivery Address', widget.model.address.toString()),
            myRow(
              'Total Amount',
              'Rs ${widget.model.totalAmount.toString()}',
              color: myColor.primaryColorDark,
            ),
            Text(
              widget.subTitle,
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
            ),
            const SizedBox16(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        invoiceCreation();
                      },
                      child: StreamBuilder<dynamic>(
                          initialData: false,
                          stream: invoiceBtnBloc!.stateStream,
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: myColor.primaryColorDark,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 10.0,
                                        height: 10.0,
                                        child: CircularProgressIndicator(
                                          color: myColor.primaryColorDark,
                                          backgroundColor:
                                              myColor.dialogBackgroundColor,
                                        )),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'Invoice',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: myColor.primaryColorDark,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      size: 20.0,
                                      color: myColor.primaryColorDark,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'Invoice',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                  ],
                                ),
                              );
                            }
                          }),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50.0,
                      child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          widget.btnText,
                          kStyleNormal.copyWith(
                              fontSize: 16.0,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.bold), () {
                        Navigator.pop(context);
                        goThere(context, widget.screen);
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox16(),
          ],
        ));
  }

  Widget productCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          SizedBox(
            width: maxWidth(context),
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50.0,
                  child: Text(
                    'S.N.',
                    textAlign: TextAlign.center,
                    style: kStyleNormal,
                  ),
                ),
                SizedBox(
                  width: 50.0,
                  child: Text(
                    'Image',
                    style: kStyleNormal,
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      'Product',
                      textAlign: TextAlign.center,
                      style: kStyleNormal,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Qtn',
                    textAlign: TextAlign.center,
                    style: kStyleNormal,
                  ),
                ),
                SizedBox(
                  width: 70.0,
                  child: Text(
                    'Price',
                    textAlign: TextAlign.center,
                    style: kStyleNormal,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.productModel!.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                var data = widget.productModel![i];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 50.0,
                          child: Text(
                            '${(i + 1).toString()}.',
                            style: kStyleNormal,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50.0,
                          child: myCachedNetworkImage(
                              20.0,
                              20.0,
                              data.productImage.toString(),
                              const BorderRadius.all(Radius.circular(0.0)),
                              BoxFit.contain),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data.productName.toString(),
                            textAlign: TextAlign.center,
                            style: kStyleNormal,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            data.productQuantity.toString(),
                            textAlign: TextAlign.center,
                            style: kStyleNormal,
                          ),
                        ),
                        SizedBox(
                          width: 70.0,
                          child: Text(
                            'Rs ${data.productTotalAmount.toString()}',
                            style: kStyleNormal,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    i == widget.productModel!.length - 1
                        ? Container()
                        : const Divider(),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget myRow(title, text, {color}) {
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
              Text(text,
                  style: kStyleNormal.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: color ?? kBlack,
                  )),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
