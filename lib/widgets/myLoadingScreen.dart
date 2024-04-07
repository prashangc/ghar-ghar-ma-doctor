import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/screens/User/home/Ambulance/GoogleMapAmbulanceUserSide.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/AppointmentList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Appointment%20List/NurseAppointmentList/NurseAppointmentList.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/Family/FamilyPage.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/MyLabs.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/MyOrders.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:ghargharmadoctor/models/Khalti/ConfirmKhaltiOrderModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:permission_handler/permission_handler.dart';

StateHandlerBloc invoiceBtnBloc = StateHandlerBloc();

class MyLoadingScreen extends StatefulWidget {
  final dynamic paymentType;
  final dynamic su;
  final dynamic totalAmount;
  final dynamic model;
  final dynamic invoiceModel;
  final dynamic paymentInterval;
  final dynamic detailsModel;
  final dynamic labType;
  final UserDetailsDatabaseModel? addressModel;

  const MyLoadingScreen({
    Key? key,
    required this.paymentType,
    required this.su,
    required this.totalAmount,
    required this.model,
    this.invoiceModel,
    this.paymentInterval,
    this.detailsModel,
    this.labType,
    this.addressModel,
  }) : super(key: key);

  @override
  State<MyLoadingScreen> createState() => _MyLoadingScreenState();
}

class _MyLoadingScreenState extends State<MyLoadingScreen> {
  StateHandlerBloc? myBloc, btnNavBloc;
  DateTime? currentDate;
  ProfileModel? profileModel;
  String? myPhone, myEmail, myName;
  File? pdfFile;
  @override
  void initState() {
    super.initState();
    myBloc = StateHandlerBloc();
    btnNavBloc = StateHandlerBloc();
    apiCall();
    getDate();
    getProfileInformation();
  }

  getProfileInformation() async {
    var test = await sharedPrefs.getFromDevice("userProfile");
    profileModel = ProfileModel.fromJson(json.decode(test));
    myPhone = profileModel!.member!.phone;
    myEmail = profileModel!.member!.email;
    myName = profileModel!.member!.name;
  }

  void getDate() {
    currentDate = DateTime.now();
  }

  apiCall() {
    if (widget.paymentType == 'isProductOrder') {
      orderProduct(context);
    }
    if (widget.paymentType == 'isNurseBooking') {
      nurseBooking(context);
    }
    if (widget.paymentType == 'isNurseBookingPaymentOnly') {
      nurseBookingPaymentOnly(context);
    }
    if (widget.paymentType == 'isLabBooking') {
      labBooking(context);
    }

    if (widget.paymentType == 'isLabPaymentOnly') {
      labPaymentOnly(context);
    }

    if (widget.paymentType == 'isDoctorBooking') {
      doctorBooking(context);
    }
    if (widget.paymentType == 'isPackageBooking') {
      packageBooking(context);
    }
    if (widget.paymentType == 'isPackagePaymentOnly' ||
        widget.paymentType == 'renewPackage' ||
        widget.paymentType == 'prePayPackage') {
      packagePaymentOnly(context);
    }
    if (widget.paymentType == 'isDoctorBookingPaymentOnly') {
      doctorAppointPaymentOnly(context);
    }
    if (widget.paymentType == 'isAmbulanceBooking') {
      ambulancePayment(context);
    }

    if (widget.paymentType == 'isAmbulanceExtend') {
      ambulancePaymentExtend(context);
    }

    if (widget.paymentType == 'isSubscriptionPaymentForFamilyReqApprove') {
      packagePaymentForFamilyReqApprove(context);
    }
  }

  invoiceCreation() async {
    invoiceBtnBloc.storeData(1);
    if (await checkStoragePermission(Permission.storage)) {
      List<InvoiceDetails> productList = [];
      productList.clear();
      if (widget.paymentType == 'isNurseBooking' ||
          widget.paymentType == 'isNurseBookingPaymentOnly' ||
          widget.paymentType == 'isDoctorBooking' ||
          widget.paymentType == 'isDoctorBookingPaymentOnly') {
        productList.add(
          InvoiceDetails(
            consultantName: widget.paymentType == 'isNurseBookingPaymentOnly'
                ? widget.detailsModel.shift.nurse.user.name.toString()
                : widget.paymentType == 'isDoctorBookingPaymentOnly'
                    ? widget.detailsModel.slot.bookings.doctor.user.name
                        .toString()
                    : widget.detailsModel.user.name.toString(),
            appointmentDate: widget.paymentType == 'isDoctorBooking' ||
                    widget.paymentType == 'isNurseBooking'
                ? '${getMonth(currentDate.toString())} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)} [${currentDate.toString().substring(11, 16)}]'
                : widget.paymentType == 'isNurseBookingPaymentOnly'
                    ? '${getMonth(widget.detailsModel.shift.date)} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)}'
                    : '${getMonth(widget.detailsModel.slot.bookings.date)} ${widget.detailsModel.slot.bookings.date.substring(5, 7)}, ${widget.detailsModel.slot.bookings.date.substring(0, 4)}',
            consultationFee: widget.paymentType == 'isNurseBookingPaymentOnly'
                ? widget.detailsModel.shift.nurse.fee.toString()
                : widget.paymentType == 'isDoctorBookingPaymentOnly'
                    ? widget.detailsModel.slot.bookings.doctor.user.name
                        .toString()
                    : widget.detailsModel.fee.toString(),
            vat: '20',
            totalPrice: widget.paymentType == 'isNurseBookingPaymentOnly'
                ? widget.detailsModel.shift.nurse.fee.toString()
                : widget.paymentType == 'isDoctorBookingPaymentOnly'
                    ? widget.detailsModel.slot.bookings.doctor.user.name
                        .toString()
                    : widget.detailsModel.fee.toString(),
          ),
        );
      } else if (widget.paymentType == 'isProductOrder') {
        for (var e in widget.detailsModel) {
          productList.add(
            InvoiceDetails(
              itemName: e.productName,
              vat: '200',
              quantity: e.productQuantity,
              totalPrice: e.productTotalAmount,
              deliveryCharge: e.totalSellingPriceAfterDiscount,
              discount: e.discount,
            ),
          );
        }
      } else if (widget.paymentType == 'isLabPaymentOnly') {
        productList.add(
          InvoiceDetails(
            consultantName: widget.detailsModel.labprofile != null
                ? widget.detailsModel.labprofile.profileName.toString()
                : widget.detailsModel.labtest.tests.toString(),
            consultationFee: widget.detailsModel.labprofile != null
                ? 'Rs ${widget.detailsModel.labprofile.price}'
                : 'Rs ${widget.detailsModel.labtest.price}',
            vat: '20',
            totalPrice: widget.detailsModel.labprofile != null
                ? 'Rs ${widget.detailsModel.labprofile.price}'
                : 'Rs ${widget.detailsModel.labtest.price}',
          ),
        );
      } else if (widget.paymentType == 'isLabBooking') {
        productList.add(
          InvoiceDetails(
            consultantName: widget.labType == 'labProfile'
                ? widget.detailsModel.profileName.toString()
                : widget.detailsModel.tests.toString(),
            consultationFee: 'Rs ${widget.detailsModel.price.toString()}',
            vat: '20',
            totalPrice: 'Rs ${widget.detailsModel.price.toString()}',
          ),
        );
      } else if (widget.paymentType == 'isPackageBooking' ||
          widget.paymentType == 'isPackagePaymentOnly') {
        productList.add(
          InvoiceDetails(
            consultantName: widget.detailsModel.packageType,
            appointmentDate:
                '${getMonth(currentDate.toString())} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)} [${currentDate.toString().substring(11, 16)}]',
            consultationFee: 'Rs ${widget.detailsModel.monthlyFee}',
            vat: '20',
            totalPrice: 'Rs ${widget.totalAmount}',
          ),
        );
      }
      InvoiceModel invoiceModel = InvoiceModel(
          fileName: widget.paymentType == 'isProductOrder'
              ? 'Order_Invoice${widget.detailsModel[0].slug}'
              : widget.paymentType == 'isLabPaymentOnly' ||
                      widget.paymentType == 'isLabBooking'
                  ? 'Lab_Invoice'
                  : widget.paymentType == 'isPackageBooking' ||
                          widget.paymentType == 'isPackagePaymentOnly'
                      ? 'Package_Invoice${widget.detailsModel.slug}'
                      : 'Appointment_Invoice${widget.detailsModel.slug}',
          date:
              '${getMonth(currentDate.toString())} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)}',
          address: widget.paymentType == 'isProductOrder'
              ? widget.addressModel!.address.toString()
              : '',
          name: myName.toString(),
          phone: myPhone.toString(),
          email: myEmail.toString(),
          invoiceType: widget.paymentType == 'isProductOrder'
              ? 'Order'
              : widget.paymentType == 'isLabPaymentOnly' ||
                      widget.paymentType == 'isLabBooking'
                  ? 'Lab'
                  : widget.paymentType == 'isPackageBooking' ||
                          widget.paymentType == 'isPackagePaymentOnly'
                      ? 'Package'
                      : 'Appointment',
          items: productList);
      pdfFile = await PdfInvoiceApi.generate(invoiceModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColor.dialogBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: StreamBuilder<dynamic>(
              initialData: 0,
              stream: myBloc!.stateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data) {
                    case 0:
                      return SizedBox(
                        width: maxWidth(context),
                        height: maxHeight(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AnimatedLoading(),
                            const SizedBox24(),
                            Text(
                              'Verifying your payment',
                              style: kStyleNormal.copyWith(
                                letterSpacing: 0.5,
                              ),
                            )
                          ],
                        ),
                      );
                    case 1:
                      btnNavBloc!.storeData(1);
                      return myBody();
                  }
                }
                return Container();
              }),
        ),
        bottomNavigationBar: SizedBox(
          width: maxWidth(context),
          height: 60.0,
          child: StreamBuilder<dynamic>(
              initialData: 0,
              stream: btnNavBloc!.stateStream,
              builder: (context, snapshot) {
                if (snapshot.data == 0) {
                  return Container();
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainHomePage(
                                  tabIndex: 0,
                                  index: widget.paymentType == 'isProductOrder'
                                      ? 1
                                      : 0)),
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
                  );
                }
              }),
        ));
  }

  Widget myBody() {
    return SizedBox(
      width: maxWidth(context),
      height: maxHeight(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: maxWidth(context),
            height: 60.0,
            color: myColor.dialogBackgroundColor,
          ),
          Container(
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
                  widget.paymentType == 'isNurseBooking' ||
                          widget.paymentType == 'isNurseBookingPaymentOnly'
                      ? 'Appointment Booked'
                      : widget.paymentType == 'isAmbulanceBooking' ||
                              widget.paymentType == 'isAmbulanceExtend' ||
                              widget.paymentType == 'isLabPaymentOnly'
                          ? 'Payment Successful'
                          : widget.paymentType == 'isLabBooking'
                              ? 'Lab Booked'
                              : widget.paymentType == 'isDoctorBooking' ||
                                      widget.paymentType ==
                                          'isDoctorBookingPaymentOnly'
                                  ? 'Appointment Booked'
                                  : widget.paymentType == 'isPackageBooking' ||
                                          widget.paymentType ==
                                              'isPackagePaymentOnly'
                                      ? 'Package Booked'
                                      : widget.paymentType == 'renewPackage'
                                          ? 'Re-New Success'
                                          : widget.paymentType ==
                                                      'prePayPackage' ||
                                                  widget.paymentType ==
                                                      'isSubscriptionPaymentForFamilyReqApprove'
                                              ? 'Payment Success'
                                              : 'Order Success',
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: maxWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    statementCard(),
                    const SizedBox16(),
                    widget.paymentType == 'isNurseBooking' ||
                            widget.paymentType == 'isDoctorBooking' ||
                            widget.paymentType ==
                                'isDoctorBookingPaymentOnly' ||
                            widget.paymentType == 'isNurseBookingPaymentOnly'
                        ? nurseDetailsCard()
                        : widget.paymentType == 'isAmbulanceBooking' ||
                                widget.paymentType == 'isAmbulanceExtend'
                            ? productDetailsCard()
                            : widget.paymentType == 'isLabPaymentOnly' ||
                                    widget.paymentType == 'isLabBooking'
                                ? labDetailsCard()
                                : widget.paymentType == 'isPackageBooking' ||
                                        widget.paymentType ==
                                            'isPackagePaymentOnly' ||
                                        widget.paymentType ==
                                            'isPackagePaymentOnly'
                                    ? packageDetailsCard()
                                    : widget.paymentType ==
                                            'isSubscriptionPaymentForFamilyReqApprove'
                                        ? Container()
                                        : productDetailsCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget packageDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Text(
            widget.detailsModel.packageType.toString(),
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  60.0,
                  60.0,
                  'widget.detailsModel.imagePath.toString()',
                  const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  BoxFit.contain,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myRow(
                        'Monthly Fee',
                        'Rs ${widget.detailsModel.monthlyFee}',
                      ),
                      myRow(
                        'Amount',
                        'Rs ${widget.totalAmount}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: maxWidth(context),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.clock,
                  size: 15.0,
                  color: myColor.primaryColorDark,
                ),
                const SizedBox(width: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${getMonth(currentDate.toString())}  ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)}',
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' ${[currentDate.toString().substring(11, 16)]}',
                      overflow: TextOverflow.ellipsis,
                      style: kStyleNormal.copyWith(
                        fontSize: 16.0,
                        color: myColor.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget labDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reporting Date',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
              Text(
                widget.paymentType == 'isLabPaymentOnly'
                    ? '${getMonth(widget.detailsModel.date)} ${widget.detailsModel.date.substring(5, 7)}, ${widget.detailsModel.date.substring(0, 4)}'
                    : widget.labType == 'labProfile'
                        ? '${getMonth(widget.detailsModel.updatedAt.substring(0, 10))} ${widget.detailsModel.date.substring(5, 7)}, ${widget.detailsModel.date.substring(0, 4)}'
                        : '${getMonth(widget.detailsModel.labprofile.updatedAt.substring(0, 10))} ${widget.detailsModel.labprofile.updatedAt.substring(5, 7)}, ${widget.detailsModel.labprofile.updatedAt.substring(0, 4)}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: kStyleNormal.copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox16(),
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  60.0,
                  60.0,
                  'widget.detailsModel.imagePath.toString()',
                  const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  BoxFit.contain,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myRow(
                        widget.paymentType == 'isLabPaymentOnly'
                            ? (widget.detailsModel.labprofile != null
                                ? 'Lab Profile'
                                : 'Lab Test')
                            : widget.labType == 'labProfile'
                                ? 'Lab Profile'
                                : 'Lab Test',
                        widget.paymentType == 'isLabPaymentOnly'
                            ? (widget.detailsModel.labprofile != null
                                ? widget.detailsModel.labprofile.profileName
                                    .toString()
                                : widget.detailsModel.labtest.tests.toString())
                            : widget.labType == 'labProfile'
                                ? widget.detailsModel.profileName.toString()
                                : widget.detailsModel.tests.toString(),
                      ),
                      myRow(
                        'Amount',
                        widget.paymentType == 'isLabPaymentOnly'
                            ? (widget.detailsModel.labprofile != null
                                ? 'Rs ${widget.detailsModel.labprofile.price}'
                                : 'Rs ${widget.detailsModel.labtest.price}')
                            : widget.detailsModel.price.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    widget.paymentType == 'isLabPaymentOnly'
                        ? widget.detailsModel.time.toString()
                        : widget.detailsModel.updatedAt
                            .toString()
                            .substring(12, 16),
                    overflow: TextOverflow.ellipsis,
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      color: myColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget nurseDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: myColor.scaffoldBackgroundColor.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointment Date',
                style: kStyleNormal.copyWith(
                  fontSize: 12.0,
                ),
              ),
              Text(
                widget.paymentType == 'isDoctorBooking' ||
                        widget.paymentType == 'isNurseBooking'
                    ? '${getMonth(currentDate.toString())} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)} [${currentDate.toString().substring(11, 16)}]'
                    : widget.paymentType == 'isNurseBookingPaymentOnly'
                        ? '${getMonth(widget.detailsModel.shift.date)} ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)}'
                        : '${getMonth(widget.detailsModel.slot.bookings.date)} ${widget.detailsModel.slot.bookings.date.substring(5, 7)}, ${widget.detailsModel.slot.bookings.date.substring(0, 4)}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: kStyleNormal.copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox16(),
          Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  60.0,
                  60.0,
                  widget.paymentType == 'isNurseBookingPaymentOnly'
                      ? widget.detailsModel.shift.nurse.imagePath.toString()
                      : widget.paymentType == 'isDoctorBookingPaymentOnly'
                          ? widget.detailsModel.slot.bookings.doctor.imagePath
                              .toString()
                          : widget.detailsModel.imagePath.toString(),
                  const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  BoxFit.contain,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      myRow(
                        widget.paymentType == 'isDoctorBooking' ||
                                widget.paymentType ==
                                    'isDoctorBookingPaymentOnly'
                            ? 'Doctor'
                            : 'Nurse',
                        widget.paymentType == 'isNurseBookingPaymentOnly'
                            ? widget.detailsModel.shift.nurse.user.name
                                .toString()
                            : widget.paymentType == 'isDoctorBookingPaymentOnly'
                                ? widget
                                    .detailsModel.slot.bookings.doctor.user.name
                                    .toString()
                                : widget.detailsModel.user.name.toString(),
                      ),
                      myRow(
                        'Phone',
                        widget.paymentType == 'isNurseBookingPaymentOnly'
                            ? widget.detailsModel.shift.nurse.user.phone
                                .toString()
                            : widget.paymentType == 'isDoctorBookingPaymentOnly'
                                ? widget.detailsModel.slot.bookings.doctor.user
                                    .phone
                                    .toString()
                                : widget.detailsModel.user.phone.toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    widget.paymentType == 'isDoctorBooking' ||
                            widget.paymentType == 'isNurseBooking'
                        ? 'static'
                        : widget.paymentType == 'isNurseBookingPaymentOnly'
                            ? widget.detailsModel.shift.shift
                            : widget.detailsModel.slot.bookings.startTime,
                    overflow: TextOverflow.ellipsis,
                    style: kStyleNormal.copyWith(
                      fontSize: 16.0,
                      color: kRed,
                      // color: myColor.primaryColorDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget productDetailsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8.0),
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
                  child: Text(
                    'Product',
                    textAlign: TextAlign.center,
                    style: kStyleNormal,
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
          const SizedBox2(),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.detailsModel!.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, i) {
                var data = widget.detailsModel![i];

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
                    i == widget.detailsModel!.length - 1
                        ? Container()
                        : const Divider(),
                  ],
                );
              }),
          const SizedBox2(),
        ],
      ),
    );
  }

  Widget statementCard() {
    return Container(
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.6),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox16(),
            widget.paymentType == 'isPackageBooking' ||
                    widget.paymentType == 'isPackagePaymentOnly'
                ? Container()
                : myRow('Date/Time',
                    '${getMonth(currentDate.toString())}  ${currentDate.toString().substring(5, 7)}, ${currentDate.toString().substring(0, 4)} [${currentDate.toString().substring(11, 16)}]'),
            myRow('Name', myName),
            myRow('Email', myEmail),
            myRow('Phone', myPhone),
            widget.paymentType == 'isProductOrder'
                ? myRow('Delivered To', widget.addressModel!.address.toString())
                : Container(),
            myRow('Payment Type', 'Khalti'),
            myRow('Total Amount', 'Rs ${widget.totalAmount}',
                color: myColor.primaryColorDark),
            Text(
              widget.paymentType == 'isNurseBooking' ||
                      widget.paymentType == 'isNurseBookingPaymentOnly'
                  ? 'Tap View Appointment Button to find more details.'
                  : widget.paymentType == 'isAmbulanceBooking' ||
                          widget.paymentType == 'isAmbulanceExtend'
                      ? 'Tap Track My Ambulance Button to view live tracking.'
                      : widget.paymentType == 'isLabBooking' ||
                              widget.paymentType == 'isLabPaymentOnly'
                          ? 'Tap View Labs Button to find more details.'
                          : widget.paymentType == 'isDoctorBooking' ||
                                  widget.paymentType ==
                                      'isDoctorBookingPaymentOnly'
                              ? 'Tap View Appointment Button to find more details.'
                              : widget.paymentType == 'isPackageBooking' ||
                                      widget.paymentType ==
                                          'isPackagePaymentOnly' ||
                                      widget.paymentType == 'renewPackage'
                                  ? 'Tap View Packages Button to view package details.'
                                  : widget.paymentType ==
                                          'isSubscriptionPaymentForFamilyReqApprove'
                                      ? 'Tap View Family Button to view member details.'
                                      : 'Tap My Orders Button to track your order.',
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
            ),
            const SizedBox12(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: StreamBuilder<dynamic>(
                        initialData: 0,
                        stream: invoiceBtnBloc.stateStream,
                        builder: (context, snapshot) {
                          if (snapshot.data == 0) {
                            return GestureDetector(
                              onTap: () {
                                invoiceCreation();
                              },
                              child: Container(
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
                                      ' Invoice',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.data == 2) {
                            return GestureDetector(
                              onTap: () {
                                FileApi.openFile(pdfFile!);
                              },
                              child: Container(
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
                                      Icons.picture_as_pdf_outlined,
                                      size: 20.0,
                                      color: myColor.primaryColorDark,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'View File',
                                      style: kStyleNormal.copyWith(
                                        color: myColor.primaryColorDark,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                invoiceBtnBloc.storeData(0);
                              },
                              child: Container(
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
                                        width: 20.0,
                                        height: 20.0,
                                        child: CircularProgressIndicator(
                                          color: myColor.primaryColorDark,
                                          backgroundColor:
                                              myColor.dialogBackgroundColor,
                                          strokeWidth: 1.0,
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
                              ),
                            );
                          }
                        }),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50.0,
                      child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          widget.paymentType == 'isNurseBooking' ||
                                  widget.paymentType ==
                                      'isNurseBookingPaymentOnly'
                              ? 'View Appointment'
                              : widget.paymentType == 'isAmbulanceBooking' ||
                                      widget.paymentType == 'isAmbulanceExtend'
                                  ? 'Track My Ambulance'
                                  : widget.paymentType == 'isLabBooking' ||
                                          widget.paymentType ==
                                              'isLabPaymentOnly'
                                      ? 'View Labs'
                                      : widget.paymentType ==
                                                  'isDoctorBooking' ||
                                              widget
                                                      .paymentType ==
                                                  'isDoctorBookingPaymentOnly'
                                          ? 'View Appointment'
                                          : widget
                                                      .paymentType ==
                                                  'isSubscriptionPaymentForFamilyReqApprove'
                                              ? 'View Family'
                                              : widget
                                                              .paymentType ==
                                                          'isPackageBooking' ||
                                                      widget
                                                              .paymentType ==
                                                          'isPackagePaymentOnly' ||
                                                      widget.paymentType ==
                                                          'renewPackage' ||
                                                      widget.paymentType ==
                                                          'prePayPackage'
                                                  ? 'View Package'
                                                  : 'View Orders',
                          kStyleNormal.copyWith(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold), () {
                        Navigator.pop(context);
                        widget.paymentType == 'isNurseBooking' ||
                                widget.paymentType ==
                                    'isNurseBookingPaymentOnly'
                            ? goThere(context, const NurseAppointmentList())
                            : widget.paymentType == 'isLabBooking' ||
                                    widget.paymentType == 'isLabPaymentOnly'
                                ? goThere(context, const MyLabs())
                                : widget.paymentType == 'isAmbulanceBooking' ||
                                        widget.paymentType ==
                                            'isAmbulanceExtend'
                                    ? goThere(context,
                                        const GoogleMapAmbulanceUserSide())
                                    : widget.paymentType == 'isDoctorBooking' ||
                                            widget.paymentType ==
                                                'isDoctorBookingPaymentOnly'
                                        ? widget.paymentType ==
                                            goThere(
                                                context,
                                                const AppointmentList(
                                                    tabIndex: 0))
                                        : widget.paymentType ==
                                                'isSubscriptionPaymentForFamilyReqApprove'
                                            ? goThere(
                                                context, const FamilyPage())
                                            : widget.paymentType ==
                                                        'isPackageBooking' ||
                                                    widget.paymentType ==
                                                        'isPackagePaymentOnly' ||
                                                    widget.paymentType ==
                                                        'renewPackage' ||
                                                    widget.paymentType ==
                                                        'prePayPackage'
                                                ?
                                                // widget.paymentType ==
                                                goThere(
                                                    context,
                                                    const MainHomePage(
                                                      index: 2,
                                                      tabIndex: 0,
                                                    ))
                                                : goThere(
                                                    context, const MyOrders());
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

  doctorBooking(context) async {
    // goThere(context, const MyLoadingScreen());
    var resp = await API().getPostResponseData(
        context, widget.model, endpoints.postBookingReview);
    DoctorBookingResponseModel test =
        DoctorBookingResponseModel.fromJson(resp[0]);

    if (resp != null) {
      int statusCode;
      statusCode = await API().postData(
        context,
        ConfirmKhaltiLabBookingModel(
          // lab and doc same model
          amount: 1000,
          id: test.id,
          token: widget.su.token.toString(),
        ),
        endpoints.confirmDoctorPaymentEndpoint,
      );
      if (statusCode == 200) {
        myBloc!.storeData(1);

        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // goThere(
        //     context,
        //     const SucessScreen(
        //       btnText: 'View Appointment',
        //       screen: AppointmentList(tabIndex: 0),
        //       subTitle: 'Tap View Appointment Button to find more details.',
        //       title: 'Appointment Booked',
        //     ));
      } else {
        myBloc!.storeData(1);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // goThere(
        //     context,
        //     const SucessScreen(
        //       btnText: 'View Appointment',
        //       screen: AppointmentList(tabIndex: 0),
        //       subTitle: 'Tap View Appointment Button to find more details.',
        //       title: 'Payment failed',
        //     ));
      }
    }
  }

  nurseBooking(context) async {
    // goThere(context, const MyLoadingScreen());
    var resp = await API().getPostResponseData(
        context, widget.model, endpoints.postNurseBookingEndpoint);
    print('resp $resp');
    if (resp != null) {
      NurseBookingResponseModel test =
          NurseBookingResponseModel.fromJson(resp[0]);
      int statusCode;
      statusCode = await API().postData(
        context,
        ConfirmKhaltiNurseBookingModel(
          amount: 1000,
          id: test.id,
          token: widget.su.token.toString(),
        ),
        endpoints.postNursePaymentEndpoint,
      );
      if (statusCode == 200) {
        // Navigator.pop(context);
        myBloc!.storeData(1);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // goThere(
        //     context,
        //     const SucessScreen(
        //       btnText: 'View Appointment',
        //       screen: AppointmentList(tabIndex: 0),
        //       subTitle: 'Tap View Appointment Button to find more details.',
        //       title: 'Appointment Booked',
        //     ));
      } else {
        myBloc!.storeData(1);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
      }
    }
  }

  orderProduct(context) async {
    // goThere(context, const MyLoadingScreen());
    var resp = await API().getPostResponseData(
        context, widget.model, endpoints.postOrderEndpoint);

    if (resp != null) {
      OrderResponseModel test = OrderResponseModel.fromJson(resp);
      int statusCode;
      statusCode = await API().postData(
        context,
        ConfirmKhaltiOrderModel(
          amount: 1000,
          id: test.id,
          token: widget.su.token.toString(),
        ),
        endpoints.confirmPaymentEndpoint,
      );
      if (statusCode == 200) {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // goThere(
        //     context,
        //     const SucessScreen(
        //       btnText: 'View Orders',
        //       screen: MyOrders(),
        //       subTitle: 'Tap My Orders Button to track your order.',
        //       title: 'Order Success',
        //     ));
        myBloc!.storeData(1);
      } else {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
      }
    }
  }

  labBooking(context) async {
    var resp = await API().getPostResponseData(
        context, widget.model, endpoints.postLabBookingEndpoint);

    if (resp != null) {
      LabBookingResponseModel labBookingResponseModel =
          LabBookingResponseModel.fromJson(resp);
      int statusCode;
      statusCode = await API().postData(
        context,
        ConfirmKhaltiLabBookingModel(
          amount: 1000,
          id: labBookingResponseModel.id,
          token: widget.su.token.toString(),
        ),
        endpoints.confirmPaymentLabEndpoint,
      );
      if (statusCode == 200) {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // goThere(
        //     context,
        //     const SucessScreen(
        //       btnText: 'View Labs',
        //       screen: MyOrders(),
        //       subTitle: 'Tap My View Button to find more details.',
        //       title: 'Lab Booked',
        //     ));
        myBloc!.storeData(1);
      } else {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
      }
    }
  }

  labPaymentOnly(context) async {
    int statusCode;

    statusCode = await API().postData(
      context,
      ConfirmKhaltiLabBookingModel(
        amount: 1000,
        id: widget.model,
        token: widget.su.token.toString(),
      ),
      endpoints.confirmPaymentLabEndpoint,
    );
    if (statusCode == 200) {
      myBloc!.storeData(1);
    } else {}
  }

  packageBooking(context) async {
    var resp = await API().getPostResponseData(
        context, widget.model, endpoints.postBookPackageEndpoint);
    if (resp != null) {
      PackageResponseForBookingModel packageResponseForBookingModel =
          PackageResponseForBookingModel.fromJson(resp);
      int statusCode;
      statusCode = await API().postData(
        context,
        ConfirmKhaltiPackageBookingModel(
          paymentInterval: widget.paymentInterval,
          amount: 1000,
          id: packageResponseForBookingModel.id,
          token: widget.su.token.toString(),
        ),
        endpoints.confirmPaymentPackageEndpoint,
      );
      if (statusCode == 200) {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        // goThere(
        //     context,
        //     const SucessScreen(
        //       btnText: 'View Labs',
        //       screen: MyOrders(),
        //       subTitle: 'Tap My View Button to find more details.',
        //       title: 'Lab Booked',
        //     ));
        myBloc!.storeData(1);
      } else {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
      }
    }
  }

  packagePaymentOnly(context) async {
    int statusCode;
    statusCode = await API().postData(
      context,
      ConfirmKhaltiPackageBookingModel(
        paymentInterval: widget.paymentInterval,
        // amount: widget.totalAmount,
        amount: 1000,
        id: widget.model,
        prePayStatus: widget.paymentType == 'prePayPackage' ? 1 : 0,
        token: widget.su.token.toString(),
      ),
      endpoints.confirmPaymentPackageEndpoint,
    );
    if (statusCode == 200) {
      myBloc!.storeData(1);
    } else {}
  }

  packagePaymentForFamilyReqApprove(context) async {
    int statusCode;
    statusCode = await API().postData(
      context,
      PaymentModelForFamilyReqApprove(
        // amount: widget.totalAmount,
        amount: 1000,
        token: widget.su.token.toString(),
        familyId: widget.paymentInterval,
        paymentDays: widget.model.paymentDays,
        userpackageId: widget.model.userpackage.id,
      ),
      endpoints.postPaymentForFamilyApproveReq,
    );
    if (statusCode == 200) {
      myBloc!.storeData(1);
    } else {}
  }

  nurseBookingPaymentOnly(context) async {
    int statusCode;
    statusCode = await API().postData(
      context,
      ConfirmKhaltiNurseBookingModel(
        amount: 1000,
        id: widget.model,
        token: widget.su.token.toString(),
      ),
      endpoints.postNursePaymentEndpoint,
    );
    if (statusCode == 200) {
      myBloc!.storeData(1);
    } else {}
  }

  doctorAppointPaymentOnly(context) async {
    int statusCode;
    statusCode = await API().postData(
      context,
      ConfirmKhaltiLabBookingModel(
        // lab and doc same model
        amount: 1000,
        id: widget.model,
        token: widget.su.token.toString(),
      ),
      endpoints.confirmDoctorPaymentEndpoint,
    );
    if (statusCode == 200) {
      myBloc!.storeData(1);
    } else {}
  }

  ambulancePayment(context) async {
    int statusCode;
    statusCode = await API().postData(
      context,
      PostAmbulanceBookingForm(
        id: widget.model.id,
        destinationLatitude: widget.model.destinationLatitude,
        destinationLongitude: widget.model.destinationLongitude,
        medicalSupport: widget.model.medicalSupport,
        patientName: widget.model.patientName.toString(),
        patientNumber: widget.model.patientNumber.toString(),
        paymentAmount: widget.model.paymentAmount,
        paymentMethod: widget.model.paymentMethod.toString(),
        token: widget.su.token.toString(),
      ),
      endpoints.postAmbulanceBooking,
    );
    if (statusCode == 200) {
      sharedPrefs.storeToDevice('isAmbulanceTracking', 'showTrackingScreen');
      myBloc!.storeData(1);
    } else {
      print('error');
      // myBloc!.storeData(1);
    }
  }

  ambulancePaymentExtend(context) async {
    int statusCode;
    statusCode = await API().postData(
      context,
      widget.model,
      // PostAmbulanceExtendForm(
      // id: widget.model.id,
      // destinationLatitude: widget.model.destinationLatitude,
      // destinationLongitude: widget.model.destinationLongitude,
      // medicalSupport: widget.model.medicalSupport,
      // patientName: widget.model.patientName.toString(),
      // patientNumber: widget.model.patientNumber.toString(),
      // paymentAmount: widget.model.paymentAmount,
      // paymentMethod: widget.model.paymentMethod.toString(),
      // token: widget.su.token.toString(),
      // ),
      'extends-trip/${widget.model.id}',
    );
    if (statusCode == 200) {
      sharedPrefs.storeToDevice('isAmbulanceTracking', 'showTrackingScreen');
      myBloc!.storeData(1);
    } else {
      print('error');
      // myBloc!.storeData(1);
    }
  }
}
