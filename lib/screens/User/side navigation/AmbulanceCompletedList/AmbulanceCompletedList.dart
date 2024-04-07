import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/MyOrdersModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/AmbulanceCompletedList/AmbulanceHistoryDetails.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class AmbulanceCompletedList extends StatefulWidget {
  const AmbulanceCompletedList({super.key});

  @override
  State<AmbulanceCompletedList> createState() => _AmbulanceCompletedListState();
}

class _AmbulanceCompletedListState extends State<AmbulanceCompletedList> {
  ApiHandlerBloc? ambulanceListBloc;
  String? _hospitalName, _doctorName, reportFile64;
  File? reportFile;
  StateHandlerBloc submitBloc = StateHandlerBloc();

  @override
  void initState() {
    super.initState();
    ambulanceListBloc = ApiHandlerBloc();
    ambulanceListBloc!.fetchAPIList(endpoints.getMyOrderEndpoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.colorScheme.background,
      appBar: myCustomAppBar(
          title: 'Ambulance History',
          color: myColor.colorScheme.background,
          borderRadius: 0.0),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: maxWidth(context),
        height: maxHeight(context),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
        child: StreamBuilder<ApiResponse<dynamic>>(
          stream: ambulanceListBloc!.apiListStream,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return SizedBox(
                    width: maxWidth(context),
                    height: maxHeight(context) / 3,
                    child: const Center(
                      child: AnimatedLoading(),
                    ),
                  );
                case Status.COMPLETED:
                  if (snapshot.data!.data.isEmpty) {
                    return Container(
                        height: 140,
                        margin: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Center(child: Text('No any appointments')));
                  }
                  List<MyOrdersModel> myOrdersModel = List<MyOrdersModel>.from(
                      snapshot.data!.data
                          .map((i) => MyOrdersModel.fromJson(i)));
                  return ListView.builder(
                      itemCount: myOrdersModel.length,
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return ordersCard(context, myOrdersModel[i]);
                      });

                case Status.ERROR:
                  return Container(
                    width: maxWidth(context),
                    margin: const EdgeInsets.all(12.0),
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
            return SizedBox(
              width: maxWidth(context),
            );
          }),
        ),
      ),
    );
  }

  Widget ordersCard(BuildContext context, MyOrdersModel orderModel) {
    return GestureDetector(
      onTap: () {
        goThere(
            context,
            AmbulanceHistoryDetails(
              myOrdersModel: orderModel,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: kWhite.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        width: maxWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox8(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip Date',
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
                      'Ambulance No.',
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
            const SizedBox2(),
            const SizedBox2(),
            Divider(
              color: myColor.dialogBackgroundColor,
            ),
            const SizedBox2(),
            const SizedBox2(),
            myLocationCard(
                Icons.perm_identity_outlined, 'Syuchatar, Kalanki, Kathmandu'),
            const SizedBox2(),
            const SizedBox2(),
            myLocationCard(Icons.location_on_outlined, 'Swoyambhu, Kathmandu'),
            const SizedBox2(),
            Divider(color: myColor.dialogBackgroundColor),
            const SizedBox2(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Price:  ',
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
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: backgroundColor,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: ((builder) => refundFormBottomSheet()),
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
                      'Apply for Refund',
                      textAlign: TextAlign.center,
                      style: kStyleNormal.copyWith(
                        fontSize: 10.0,
                        color: myColor.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox12(),
          ],
        ),
      ),
    );
  }

  Widget refundFormBottomSheet() {
    requestBtn() async {
      submitBloc.storeData(true);
      int statusCode;

      statusCode = await API().postData(
          context,
          HospitalizationFormModel(
            doctorName: _doctorName,
            hospitalName: _hospitalName,
            hospitalizationFile: reportFile64,
          ),
          'hospitalization-form/1');

      if (statusCode == 200) {
        submitBloc.storeData(false);
      } else {
        submitBloc.storeData(false);
      }
    }

    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Container(
        height: maxHeight(context) / 1.4,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox16(),
                    infoCard(
                        context,
                        myColor.dialogBackgroundColor,
                        myColor.primaryColorDark,
                        'Refund is only available for hospitalization case.'),
                    const SizedBox12(),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox16(),
                          mytextFormFieldWithPrefixIcon(
                              context,
                              FocusNode(),
                              'Hospital Name',
                              'Enter hospital name',
                              'Enter hospital name',
                              _hospitalName,
                              Icons.local_hospital_outlined,
                              kWhite, onValueChanged: (v) {
                            _hospitalName = v;
                          }),
                          mytextFormFieldWithPrefixIcon(
                              context,
                              FocusNode(),
                              'Doctor Name',
                              'Enter doctor name',
                              'Enter doctor name',
                              _doctorName,
                              Icons.perm_identity_outlined,
                              kWhite, onValueChanged: (v) {
                            _doctorName = v;
                          }),
                          Text(
                            'Hospitalization report',
                            style: kStyleNormal.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox16(),
                          myFilePicker(
                            textValue: 'Upload report',
                            color: kWhite.withOpacity(0.4),
                            onValueChanged: (value) {
                              reportFile64 = value.base64String;
                              reportFile = value.file;
                            },
                          ),
                          const SizedBox16(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: maxWidth(context),
              child: StreamBuilder<dynamic>(
                  initialData: false,
                  stream: submitBloc.stateStream,
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return myBtnLoading(context, 50.0);
                    } else {
                      return SizedBox(
                        height: 50.0,
                        child: myCustomButton(
                          context,
                          myColor.primaryColorDark,
                          'Request',
                          kStyleNormal.copyWith(fontSize: 16.0, color: kWhite),
                          () {
                            requestBtn();
                          },
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget myLocationCard(icon, title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            radius: 12.0,
            backgroundColor: myColor.primaryColorDark,
            child: Icon(icon, color: myColor.dialogBackgroundColor, size: 12.0),
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
