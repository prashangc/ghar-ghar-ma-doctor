import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/local_database/CartDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/UserDetailsDatabaseModel.dart';
import 'package:ghargharmadoctor/local_database/myDB.dart';
import 'package:ghargharmadoctor/models/PaymentMethodModel.dart';
import 'package:ghargharmadoctor/models/PostOrderModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/AddShippingDetails.dart';
import 'package:ghargharmadoctor/screens/User/Checkout/ListOfAddressScreen.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/MyOrders.dart';
import 'package:ghargharmadoctor/widgets/SucessScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class CheckoutScreen extends StatefulWidget {
  List<MyCartDatabaseModel> cartDatabaseModel;
  final int totalAmount;
  CheckoutScreen({
    Key? key,
    required this.cartDatabaseModel,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedIndexForAddress = 0;
  int currentStep = 0;
  int totalIndividualPrice = 0;
  String? myPhone, myAddress;
  List<UserDetailsDatabaseModel> userDetailsDatabaseModel = [];
  List<UserDetailsDatabaseModel> temp_userDetailsDatabaseModel = [];
  List<Orders> individualProductList = [];
  String? isDefaultAddress;
  String _paymentMethod = "esewa";
  PostOrderModel? postOrderModel;
  ApiHandlerBloc? shippingDetailsBloc;
  StateHandlerBloc? placeOrderBtnBloc;
  int? deliveryCharge, myTotal, _shippingID;
  @override
  void initState() {
    getDataFromLocalDatabase();
    shippingDetailsBloc = ApiHandlerBloc();
    shippingDetailsBloc!.fetchAPIList(endpoints.getShippingDetailsEndpoint);
    placeOrderBtnBloc = StateHandlerBloc();
    super.initState();
  }

  Future getDataFromLocalDatabase() async {
    int userID = int.parse(sharedPrefs.getUserID('userID'));
    userDetailsDatabaseModel =
        await MyDatabase.instance.fetchDataFromUserDetails(userID);
    setState(() {
      isDefaultAddress = sharedPrefs.getFromDevice('isDefaultAddressID');
      temp_userDetailsDatabaseModel.clear();
      for (var element in userDetailsDatabaseModel) {
        myPhone = element.phoneNumber.toString();
        myAddress = element.address.toString();

        if (isDefaultAddress == element.id.toString()) {
          temp_userDetailsDatabaseModel.add(element);
        }
      }
    });
  }

  void _placeOrderbtn(context) async {
    individualProductList.clear();
    for (var element in widget.cartDatabaseModel) {
      individualProductList.add(
        Orders(
          id: element.productID,
          quantity: int.parse(
            element.productQuantity.toString(),
          ),
          vendorId: element.vendorID,
        ),
      );
    }
    if (_paymentMethod != "cash on delivery") {
      print('subTotal ${widget.totalAmount}');
      print('totalAmount ${widget.totalAmount}');
      print('phone $myPhone');
      print('shippingID $_shippingID');
      print('paymentMethod $_paymentMethod');
      print('address ${temp_userDetailsDatabaseModel[0].phoneNumber}');
      postOrderModel = PostOrderModel(
        subTotal: widget
            .totalAmount, // amount deducted after discount coupon or others
        totalAmount: widget.totalAmount,
        phone: myPhone ?? temp_userDetailsDatabaseModel[0].phoneNumber,
        shippingID: _shippingID,
        paymentMethod: _paymentMethod,
        // selectedIndexs == 0
        //     ? "esewa"
        //     : selectedIndexs == 1
        //         ? "khalti"
        //         : selectedIndexs == 2
        //             ? "khalti"
        //             : selectedIndexs == 3
        //                 ? "khalti"
        //                 : selectedIndexs == 4
        //                     ? "khalti"
        //                     : selectedIndexs == 5
        //                         ? "khalti"
        //                         : "cod",
        address: myAddress ?? temp_userDetailsDatabaseModel[0].address,
        orders: individualProductList,
      );
      switch (_paymentMethod) {
        case 'esewa':
          // myEsewa(context, widget.totalAmount.toString());
          break;

        case 'khalti':
          myKhalti(
            context,
            widget.totalAmount,
            'isProductOrder',
            postOrderModel,
            detailsModel: widget.cartDatabaseModel,
            addressModel: temp_userDetailsDatabaseModel[0],
          );
          break;

        default:
      }
    } else {
      var resp;
      placeOrderBtnBloc!.storeData('loading');
      postOrderModel = PostOrderModel(
        subTotal: widget
            .totalAmount, // amount deducted after discount coupon or others
        totalAmount: widget.totalAmount,
        phone: myPhone,
        shippingID: _shippingID,
        paymentMethod: "cod",
        address: myAddress,
        orders: individualProductList,
      );
      resp = await API().getPostResponseData(
        context,
        postOrderModel,
        endpoints.postOrderEndpoint,
      );
      if (resp != null) {
        placeOrderBtnBloc!.storeData('Next');
        OrderResponseModel orderResponseModel =
            OrderResponseModel.fromJson(resp);
        goThere(
            context,
            SucessScreen(
              btnText: 'View Orders',
              screen: const MyOrders(),
              subTitle: 'Tap View Orders Button to track your order.',
              title: 'Order Success',
              model: postOrderModel!,
              orderResponseModel: orderResponseModel,
              addressModel: temp_userDetailsDatabaseModel[0],
              productModel: widget.cartDatabaseModel,
            ));
      } else {
        placeOrderBtnBloc!.storeData('Next');
      }
    }
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Payment'),
          content: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: maxWidth(context),
                      child: Text(
                        'Choose the address where you want the product to be delivered',
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox16(),
                    temp_userDetailsDatabaseModel.isEmpty
                        ? Text(
                            'Select Delivery Address',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          )
                        : Text(
                            'Selected Delivery Address',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                    const SizedBox16(),
                    temp_userDetailsDatabaseModel.isEmpty
                        ? GestureDetector(
                            onTap: () async {
                              var myPoppedData = await goThere(
                                  context, AddShippingDetailsScreen());
                              if (myPoppedData != null) {
                                setState(() {
                                  temp_userDetailsDatabaseModel = myPoppedData;
                                });
                              }
                            },
                            child: SizedBox(
                              width: maxWidth(context),
                              height: 55.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: myColor.primaryColorDark,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width: maxWidth(context) / 2 - 20,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 9.0,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 8.0,
                                        backgroundColor:
                                            myColor.dialogBackgroundColor,
                                        child: const Icon(
                                          Icons.add,
                                          size: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      child: Text(
                                        'Add New Address',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : StatefulBuilder(builder: (context, setState) {
                            return ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: temp_userDetailsDatabaseModel.length,
                                itemBuilder: (ctx, i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      var myPoppedData = await goThere(
                                          context, const ListOfAddressScreen());
                                      setState(() {
                                        temp_userDetailsDatabaseModel =
                                            myPoppedData;
                                        // myPhone =
                                        //     myPoppedData.phoneNumber.toString();
                                        // myAddress =
                                        //     myPoppedData.address.toString();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // border: Border.all(
                                        //     color: myColor.primaryColorDark,
                                        //     width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 6.0),
                                          SizedBox(
                                            width: 20.0,
                                            height: 20.0,
                                            child: temp_userDetailsDatabaseModel[
                                                            i]
                                                        .addressType ==
                                                    'Home'
                                                ? Icon(
                                                    Icons.home,
                                                    size: 20.0,
                                                    color: myColor
                                                        .primaryColorDark,
                                                  )
                                                : temp_userDetailsDatabaseModel[
                                                                i]
                                                            .addressType ==
                                                        'Office'
                                                    ? Icon(
                                                        Icons.work,
                                                        size: 17.0,
                                                        color: myColor
                                                            .primaryColorDark,
                                                      )
                                                    : Icon(
                                                        Icons.location_on,
                                                        size: 20.0,
                                                        color: myColor
                                                            .primaryColorDark,
                                                      ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    temp_userDetailsDatabaseModel[
                                                            i]
                                                        .address
                                                        .toString(),
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox8(),
                                                  Text(
                                                    temp_userDetailsDatabaseModel[
                                                            i]
                                                        .fullName
                                                        .toString(),
                                                    style: kStyleNormal,
                                                  ),
                                                  const SizedBox2(),
                                                  Text(
                                                    temp_userDetailsDatabaseModel[
                                                            i]
                                                        .phoneNumber
                                                        .toString(),
                                                    style:
                                                        kStyleNormal.copyWith(
                                                      fontSize: 13,
                                                      color: Colors.grey[400],
                                                    ),
                                                  ),
                                                  const SizedBox2(),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            0.0, 5.0, 0.0, 0.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          5.0),
                                                                ),
                                                                border: Border.all(
                                                                    color: myColor
                                                                        .primaryColorDark)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        child: Row(
                                                          children: [
                                                            // Icon(
                                                            //   addressTypeList[i]
                                                            //       .iconData,
                                                            //   size: 14.0,
                                                            //   color: myColor
                                                            //       .primaryColorDark,
                                                            // ),
                                                            // const SizedBox(
                                                            //     width: 5.0),
                                                            Text(
                                                              temp_userDetailsDatabaseModel[
                                                                      i]
                                                                  .addressType
                                                                  .toString(),
                                                              style: kStyleNormal
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: myColor
                                                                          .primaryColorDark),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30.0,
                                            height: 30.0,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              size: 30.0,
                                              color: myColor.primaryColorDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      // : Container()
                                      ;
                                });
                          }),
                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     reverse: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: userDetailsDatabaseModel.length,
                    //     itemBuilder: (context, i) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           setState(() {
                    //             selectedIndexForAddress = i;
                    //           });
                    //         },
                    //         child: Container(
                    //           margin: const EdgeInsets.only(bottom: 16.0),
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             border: selectedIndexForAddress == i
                    //                 ? Border.all(
                    //                     color: Colors.green,
                    //                     width: 1.5,
                    //                   )
                    //                 : Border.all(
                    //                     width: 1.5,
                    //                     color: Colors.transparent,
                    //                   ),
                    //             borderRadius: BorderRadius.circular(12.0),
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               Container(
                    //                 width: maxWidth(context) - 83,
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 15.0, vertical: 10.0),
                    //                 decoration: const BoxDecoration(
                    //                   borderRadius: BorderRadius.only(
                    //                     bottomLeft: Radius.circular(12),
                    //                     topLeft: Radius.circular(12),
                    //                   ),
                    //                 ),
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Row(
                    //                       children: [
                    //                         const Icon(
                    //                           Icons.person,
                    //                         ),
                    //                         const SizedBox(width: 10.0),
                    //                         userDetailsDatabaseModel[i]
                    //                                 .area!
                    //                                 .isEmpty
                    //                             ? Text(
                    //                                 userDetailsDatabaseModel[
                    //                                         i]
                    //                                     .address
                    //                                     .toString(),
                    //                                 style: kStyleNormal
                    //                                     .copyWith(
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                               )
                    //                             : Text(
                    //                                 '${userDetailsDatabaseModel[i].area.toString()} , ${userDetailsDatabaseModel[i].district.toString()}',
                    //                                 style: kStyleNormal
                    //                                     .copyWith(
                    //                                         fontWeight:
                    //                                             FontWeight
                    //                                                 .bold),
                    //                               ),
                    //                       ],
                    //                     ),
                    //                     Text(
                    //                       userDetailsDatabaseModel[i]
                    //                           .fullName
                    //                           .toString(),
                    //                       style: kStyleNormal,
                    //                     ),
                    //                     Text(
                    //                       userDetailsDatabaseModel[i]
                    //                           .phoneNumber
                    //                           .toString(),
                    //                       style: kStyleNormal,
                    //                     ),
                    //                     const SizedBox(height: 10.0),
                    //                     userDetailsDatabaseModel[i]
                    //                             .street!
                    //                             .isEmpty
                    //                         ? Container()
                    //                         : Row(
                    //                             children: [
                    //                               Text(
                    //                                 '${userDetailsDatabaseModel[i].street.toString()}, ${userDetailsDatabaseModel[i].area.toString()}',
                    //                                 style: kStyleNormal
                    //                                     .copyWith(
                    //                                   color: myColor
                    //                                       .primaryColorDark,
                    //                                   fontWeight:
                    //                                       FontWeight.bold,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                     userDetailsDatabaseModel[i]
                    //                             .area!
                    //                             .isEmpty
                    //                         ? Text(
                    //                             userDetailsDatabaseModel[
                    //                                     i]
                    //                                 .address
                    //                                 .toString(),
                    //                             style:
                    //                                 kStyleNormal.copyWith(
                    //                                     fontWeight:
                    //                                         FontWeight
                    //                                             .bold),
                    //                           )
                    //                         : Text(
                    //                             '${userDetailsDatabaseModel[i].area.toString()} , ${userDetailsDatabaseModel[i].district.toString()}',
                    //                             style:
                    //                                 kStyleNormal.copyWith(
                    //                                     fontWeight:
                    //                                         FontWeight
                    //                                             .bold),
                    //                           ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               Container(
                    //                 decoration: const BoxDecoration(
                    //                   borderRadius: BorderRadius.only(
                    //                     topRight: Radius.circular(12),
                    //                     bottomRight: Radius.circular(12),
                    //                   ),
                    //                 ),
                    //                 width: 40.0,
                    //                 child: Icon(
                    //                   selectedIndexForAddress == i
                    //                       ? Icons.check_circle
                    //                       : Icons.circle,
                    //                   color: selectedIndexForAddress == i
                    //                       ? Colors.green
                    //                       : Colors.grey[200],
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     }),
                    const SizedBox16(),
                    Text(
                      'Select Payment Method',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox16(),

                    paymentMethod(context, true, true, onValueChanged: (v) {
                      _paymentMethod = v;
                    }),
                    const SizedBox16(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text('Review'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: kTransparent,
                  width: maxWidth(context),
                  child: Text(
                    'Please confirm and submit your order',
                    style: kStyleNormal.copyWith(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox16(),
                Text(
                  'Order Summary',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox16(),
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
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
                              child: Container(
                                child: Text(
                                  'Qtn',
                                  textAlign: TextAlign.center,
                                  style: kStyleNormal,
                                ),
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
                          itemCount: widget.cartDatabaseModel.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, i) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          widget
                                              .cartDatabaseModel[i].productImage
                                              .toString(),
                                          const BorderRadius.all(
                                              Radius.circular(0.0)),
                                          BoxFit.contain),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        widget.cartDatabaseModel[i].productName
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: kStyleNormal,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        widget.cartDatabaseModel[i]
                                            .productQuantity
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: kStyleNormal,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70.0,
                                      child: Text(
                                        'Rs ${widget.cartDatabaseModel[i].productTotalAmount.toString()}',
                                        style: kStyleNormal,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            );
                          }),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 12.0,
                        ),
                        width: maxWidth(context),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charge',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                StreamBuilder<ApiResponse<dynamic>>(
                                  stream: shippingDetailsBloc!.apiListStream,
                                  builder: ((context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data!.status) {
                                        case Status.LOADING:
                                          return Container();
                                        case Status.COMPLETED:
                                          List<GetShippingDetailsModel>
                                              getShippingDetailsModel =
                                              List<GetShippingDetailsModel>.from(
                                                  snapshot.data!.data.map((i) =>
                                                      GetShippingDetailsModel
                                                          .fromJson(i)));
                                          if (getShippingDetailsModel
                                              .isNotEmpty) {
                                            for (var e
                                                in getShippingDetailsModel) {
                                              if (widget.totalAmount >=
                                                      e.minimum! &&
                                                  widget.totalAmount <=
                                                      e.maximum!) {
                                                deliveryCharge = double.parse(
                                                        e.price.toString())
                                                    .round();
                                              }
                                              _shippingID = e.id;
                                            }
                                            myTotal = widget.totalAmount +
                                                deliveryCharge!;
                                          } else {
                                            deliveryCharge = 0;
                                            myTotal = widget.totalAmount;
                                          }
                                          if (_shippingID == null) {
                                            placeOrderBtnBloc!
                                                .storeData('shippingIdNull');
                                          }
                                          return Text(
                                            'Rs. $deliveryCharge',
                                            style: kStyleNormal.copyWith(
                                              color: myColor.primaryColorDark,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        case Status.ERROR:
                                          return Container();
                                      }
                                    }
                                    return const SizedBox();
                                  }),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  'Rs. $myTotal',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Delivery Address',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox16(),
                ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: temp_userDetailsDatabaseModel.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            deliveryAddressCard(
                                Icons.location_on,
                                temp_userDetailsDatabaseModel[i]
                                    .address
                                    .toString()),
                            const SizedBox12(),
                            deliveryAddressCard(
                                Icons.phone,
                                temp_userDetailsDatabaseModel[i]
                                    .phoneNumber
                                    .toString()),
                            const SizedBox2(),
                            const Divider(),
                            const SizedBox2(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery to: ',
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  temp_userDetailsDatabaseModel[i]
                                      .fullName
                                      .toString(),
                                  style: kStyleNormal.copyWith(
                                    color: myColor.primaryColorDark,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                const SizedBox12(),
                Text(
                  'Payment method',
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox12(),
                Container(
                  height: 70,
                  width: maxWidth(context),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                          ),
                          width: 80.0,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: maxHeight(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _paymentMethod == "cash on delivery"
                                  ? Row(
                                      children: [
                                        Image.asset(
                                            'assets/cash_on_delivery.png'),
                                        const SizedBox(width: 12.0),
                                        Text('Cash on Delivery',
                                            style: kStyleNormal.copyWith(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    )
                                  : Image.asset(paymentMethods[
                                          paymentMethods.indexWhere(
                                              (e) => e.name == _paymentMethod)]
                                      .imageUrl
                                      .toString()),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: myCustomButton(
                            context,
                            myColor.primaryColorDark,
                            'Change',
                            kStyleNormal.copyWith(color: Colors.white), () {
                          setState(() {
                            currentStep -= 1;
                          });
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox16(),
              ],
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColor.colorScheme.background,
        appBar: myCustomAppBar(
          title: 'Checkout',
          color: myColor.colorScheme.background,
          borderRadius: 12.0,
        ),
        body: WillPopScope(
          onWillPop: () async {
            currentStep == 0
                ? Navigator.pop(context)
                : setState(() {
                    currentStep -= 1;
                  });
            return false;
          },
          child: Container(
            height: maxHeight(context),
            margin: const EdgeInsets.only(top: 15.0),
            // padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: maxWidth(context),
            decoration: BoxDecoration(
              color: myColor.dialogBackgroundColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            child: Theme(
              data: ThemeData(
                canvasColor: Colors.transparent,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: myColor.primaryColorDark,
                    ),
              ),
              child: Stepper(
                physics: const BouncingScrollPhysics(),
                elevation: 0,
                type: StepperType.horizontal,
                // onStepTapped: (step) => setState(() {
                //   currentStep = step;
                //   if (currentStep != step) {
                //     currentStep = currentStep;
                //   }
                // }),
                onStepTapped: (int index) {
                  if (currentStep != index) {
                    currentStep = currentStep;
                  }
                },
                steps: getSteps(),
                currentStep: currentStep,
                onStepContinue: () {},
                controlsBuilder: (context, details) {
                  final isLastStep = currentStep == getSteps().length - 1;
                  return Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    color: myColor.dialogBackgroundColor,
                    child: Column(
                      children: [
                        StreamBuilder<dynamic>(
                            initialData: 'Next',
                            stream: placeOrderBtnBloc!.stateStream,
                            builder: (context, snapshot) {
                              if (snapshot.data == 'shippingIdNull') {
                                return SizedBox(
                                  height: 50,
                                  child: infoCard(
                                      context,
                                      kRed.withOpacity(0.4),
                                      kRed,
                                      'Service not available right now.'),
                                );
                              } else if (snapshot.data == 'Next') {
                                return SizedBox(
                                    width: maxWidth(context),
                                    height: 50,
                                    child: myButton(
                                      context,
                                      myColor.primaryColorDark,
                                      !isLastStep ? 'Next' : "Place Order",
                                      () {
                                        if (!isLastStep) {
                                          if (temp_userDetailsDatabaseModel
                                              .isEmpty) {
                                            myToast.toast('Add an Address');
                                          } else {
                                            setState(() {
                                              currentStep += 1;
                                            });
                                          }
                                        } else {
                                          _placeOrderbtn(context);
                                        }
                                      },
                                    ));
                              } else {
                                return myBtnLoading(context, 50.0);
                              }
                            }),
                        const SizedBox12(),
                        GestureDetector(
                          onTap: () {
                            currentStep == 0
                                ? Navigator.pop(context)
                                : setState(() {
                                    currentStep -= 1;
                                  });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: myColor.primaryColorDark, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: maxWidth(context),
                            height: 50,
                            child: Center(
                              child: Text(
                                !isLastStep ? 'Cancel' : "Back",
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox16(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }

  Widget deliveryAddressCard(myIcon, text) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              myIcon,
              size: 17.0,
              color: myColor.primaryColorDark,
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Text(
                text,
                // textAlign: TextAlign.center,
                style: kStyleNormal.copyWith(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
