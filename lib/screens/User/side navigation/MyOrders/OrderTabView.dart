import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyOrdersModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/Loading/loading_imports.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/OrderDetailsScreen.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyOrders/orderdProductCard.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class OrdersTabView extends StatefulWidget {
  List<MyOrdersModel> myOrdersModel;
  bool? showCancelOrderAndTrackStatus;
  OrdersTabView({
    Key? key,
    required this.myOrdersModel,
    this.showCancelOrderAndTrackStatus,
  }) : super(key: key);

  @override
  State<OrdersTabView> createState() => _OrdersTabViewState();
}

class _OrdersTabViewState extends State<OrdersTabView> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _cancelOrderReason;
  int selectedRadioValue = 0;
  List<GetCancelReasonModel> getCancelReasonModel = [];
  bool _isLoading = false;
  ApiHandlerBloc? cancelReasonBloc;
  @override
  void initState() {
    cancelReasonBloc = ApiHandlerBloc();
  }

  void removeOrderBtn() async {
    if (_descriptionController.text.toString().isEmpty) {
      myToast.toast('no desc');
    }

    if (selectedRadioValue == 0) {
      myToast.toast('No reason selected');
    } else {
      if (selectedRadioValue == 0 || _descriptionController.text.isEmpty) {
      } else {
        setState(() {
          _isLoading = true;
        });
        int statusCode;

        FocusManager.instance.primaryFocus?.unfocus();

        statusCode = await API().postData(
            context,
            PostCancelReasonModel(
              cancelReason: selectedRadioValue,
              description: _descriptionController.text.toString(),
            ),
            'admin/order/cancelOrder/1');

        if (statusCode == 200) {
          Navigator.pop(context);
          setState(() {});
          mySnackbar.mySnackBar(context, 'Sucess: $statusCode', Colors.green);
        } else {
          mySnackbar.mySnackBar(context, ' Error: $statusCode', Colors.red);

          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.myOrdersModel.length,
              shrinkWrap: true,
              itemBuilder: (crx, i) {
                return ordersCard(context, widget.myOrdersModel[i]);
              }),
        ],
      ),
    );
  }

  Widget ordersCard(BuildContext context, MyOrdersModel orderModel) {
    return GestureDetector(
      onTap: () {
        goThere(context, OrderDetailsScreen(myOrdersModel: orderModel));
      },
      child: Container(
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        margin: const EdgeInsets.only(bottom: 12.0),
        width: maxWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox8(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Date',
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        orderModel.createdAt.toString().substring(0, 10),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox2(),
                  Row(
                    children: [
                      Text(
                        'Order No.',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        orderModel.orderNumber.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
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
                itemCount: orderModel.products!.length,
                itemBuilder: (ctx, i) {
                  return orderProductCard(orderModel.products![i]);
                }),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Column(
                children: [
                  const SizedBox2(),
                  Divider(color: myColor.dialogBackgroundColor),
                  const SizedBox2(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total:  ',
                            style: kStyleNormal.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs  ${orderModel.totalAmount.toString()}',
                            overflow: TextOverflow.ellipsis,
                            style: kStyleNormal.copyWith(
                              fontSize: 16.0,
                              color: myColor.primaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      widget.showCancelOrderAndTrackStatus!
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: backgroundColor,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: ((builder) =>
                                          trackingOrderBottomSheet(orderModel)),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: myColor.primaryColorDark,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Track Order',
                                      textAlign: TextAlign.center,
                                      style: kStyleNormal.copyWith(
                                        fontSize: 10.0,
                                        color: myColor.scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                orderModel.status == 'pending'
                                    ? GestureDetector(
                                        onTap: () {
                                          cancelReasonBloc!.fetchAPIList(
                                              endpoints
                                                  .getCancelReasonEndpoint);
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: backgroundColor,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20))),
                                            builder: ((builder) =>
                                                removeOrderBottomSheet()),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.9),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Remove Order',
                                            textAlign: TextAlign.center,
                                            style: kStyleNormal.copyWith(
                                              fontSize: 10.0,
                                              color: myColor
                                                  .scaffoldBackgroundColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox12(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget trackingOrderBottomSheet(MyOrdersModel orderModel) {
    ApiHandlerBloc? individualOrderBloc;
    individualOrderBloc = ApiHandlerBloc();
    individualOrderBloc
        .fetchAPIList('admin/order?order_number=${orderModel.orderNumber}');

    return StreamBuilder<ApiResponse<dynamic>>(
      stream: individualOrderBloc.apiListStream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.LOADING:
              return const OrderTrackLoadingShimmer();
            case Status.COMPLETED:
              if (snapshot.data!.data.isEmpty) {
                return Container(
                    height: 140,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('No image added')));
              }
              List<MyOrdersModel> individualOrderModel =
                  List<MyOrdersModel>.from(snapshot.data!.data
                      .map((i) => MyOrdersModel.fromJson(i)));
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: maxWidth(context),
                    height: 100.0,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12.0,
                          right: 11.0,
                          top: 40.0,
                          child: Container(
                            color:
                                myColor.dialogBackgroundColor.withOpacity(0.8),
                            width: maxWidth(context),
                            height: 2.0,
                          ),
                        ),
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: orderTrackingList.length,
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: [
                                  const SizedBox16(),
                                  Container(
                                    width: maxWidth(context) / 5,
                                    height: 50.0,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 205, 226, 247),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      orderTrackingList[i].iconData,
                                      size: 20.0,
                                      color: individualOrderModel[0].status ==
                                              orderTrackingList[i].status
                                          ? myColor.primaryColorDark
                                          : myColor.primaryColorDark
                                              .withOpacity(0.3),
                                    ),
                                  ),
                                  const SizedBox8(),
                                  Text(
                                    orderTrackingList[i].title.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 10.0,
                                      color: individualOrderModel[0].status ==
                                              orderTrackingList[i].status
                                          ? myColor.primaryColorDark
                                          : myColor.primaryColorDark
                                              .withOpacity(0.6),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ],
                    ),
                  )
                ],
              );

            case Status.ERROR:
              return Center(
                child: Text('Server Error',
                    style: kStyleNormal.copyWith(fontSize: 12.0)),
              );
          }
        }
        return SizedBox(
          width: maxWidth(context),
        );
      }),
    );
  }

  Widget removeOrderBottomSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            myfocusRemover(context);
          },
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox12(),
                    SizedBox(
                      width: maxWidth(context),
                      child: ExpansionPanelList.radio(
                        elevation: 0.0,
                        animationDuration: const Duration(milliseconds: 400),
                        children: [
                          ExpansionPanelRadio(
                            value: Null,
                            backgroundColor: Colors.transparent,
                            canTapOnHeader: true,
                            headerBuilder: (context, isExpanded) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    child: Text(
                                      'Select Reason',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: kStyleNormal.copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                            body: StreamBuilder<ApiResponse<dynamic>>(
                              stream: cancelReasonBloc!.apiListStream,
                              builder: ((context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data!.status) {
                                    case Status.LOADING:
                                      return Container(
                                        width: maxWidth(context),
                                        height: 175.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const AnimatedLoading(),
                                      );
                                    case Status.COMPLETED:
                                      if (snapshot.data!.data.isEmpty) {
                                        return Container(
                                            height: 175,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Center(
                                                child: Text(
                                                    'No cancel reasons added')));
                                      }
                                      getCancelReasonModel =
                                          List<GetCancelReasonModel>.from(
                                              snapshot.data!.data.map((i) =>
                                                  GetCancelReasonModel.fromJson(
                                                      i)));
                                      return cancelReasonsDropDownCard(
                                          getCancelReasonModel);
                                    // OurServices(
                                    //   ourServicesModel: ourServicesModel,
                                    // );
                                    case Status.ERROR:
                                      return Container(
                                        width: maxWidth(context),
                                        height: 135.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Text('Server Error'),
                                        ),
                                      );
                                  }
                                }
                                return SizedBox(
                                  width: maxWidth(context),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox12(),
                    Text(
                      'Description',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox12(),
                    Container(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom / 1.4),
                      width: maxWidth(context),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                                color: myColor.primaryColorDark, width: 1.5),
                          ),
                          hintText:
                              'Write short description on cancelling this order?',
                          hintStyle: kStyleNormal.copyWith(
                              fontSize: 12.0, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                    const SizedBox32(),
                    SizedBox(
                      width: maxWidth(context),
                      height: 50.0,
                      child: myCustomButton(
                        context,
                        myColor.primaryColorDark,
                        'Remove Order',
                        kStyleNormal.copyWith(
                            color: Colors.white, fontSize: 14.0),
                        () {
                          removeOrderBtn();
                        },
                      ),
                    ),
                    const SizedBox12(),
                  ])),
        ),
      );
    });
  }

  Widget cancelReasonsDropDownCard(
      List<GetCancelReasonModel> getCancelReasonModel) {
    int myID = -1;
    return StatefulBuilder(builder: (context, setState) {
      return ListView.builder(
          itemCount: getCancelReasonModel.length,
          shrinkWrap: true,
          itemBuilder: (ctx, i) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20.0,
                  child: Radio<int>(
                      activeColor: myColor.primaryColorDark,
                      value: int.parse(getCancelReasonModel[i].id.toString()),
                      groupValue: selectedRadioValue,
                      onChanged: (value) {
                        setState(() {
                          selectedRadioValue =
                              int.parse(getCancelReasonModel[i].id.toString());
                        });
                        print(selectedRadioValue);
                      }),
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  width: maxWidth(context) - 70,
                  child: Text(
                    getCancelReasonModel[i].cancelReason.toString(),
                    style: kStyleNormal.copyWith(),
                    maxLines: 4,
                  ),
                ),
              ],
            );
          });
    });
  }
}
