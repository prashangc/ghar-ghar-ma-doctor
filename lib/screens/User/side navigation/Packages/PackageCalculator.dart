import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class PackageCalculator extends StatefulWidget {
  final PackagesModel packagesModel;
  const PackageCalculator({super.key, required this.packagesModel});

  @override
  State<PackageCalculator> createState() => _PackageCalculatorState();
}

class _PackageCalculatorState extends State<PackageCalculator> {
  int isMemberTypeRadioBtnSelected = 0;
  bool isSelectFamilySizeDropDownOpened = false;
  bool isPaymentIntervalDropDownOpened = false;
  String? paymentIntervalValue, _existingMemberYear, memberType;
  int? familySize;
  double? discount,
      totalPayableAmount,
      totalMonthlyFee,
      totalDiscount,
      totalQuaterlyFee,
      totalPayableAmountAfterDiscount;
  int? month;
  double? oneRegistrationFee, oneMonthlyFee;
  GetPackageFamilySize? getPackageFamilySize;
  List<dynamic> familySizeList = [];
  String? _memberType;

  @override
  void initState() {
    super.initState();
    isMemberTypeRadioBtnSelected = packageMemberTypeList[0].id;
    _memberType = packageMemberTypeList[0].name.toString();
    familySize = widget.packagesModel.fees![0].familySize;
    paymentIntervalValue = packagepaymentIntervalList[0].name;
    month = packagepaymentIntervalList[0].month;
    discount = packagepaymentIntervalList[0].discount;
    getAllFamilySize();
    calculateBtn();
  }

  getAllFamilySize() {
    setState(() {});
    familySizeList.clear();
    for (int i = 0; i < widget.packagesModel.fees!.length; i++) {
      familySizeList.add(widget.packagesModel.fees![i].familySize);
    }
  }

  calculateBtn() {
    for (int i = 0; i < widget.packagesModel.fees!.length; i++) {
      if (widget.packagesModel.fees![i].familySize == familySize) {
        if (isMemberTypeRadioBtnSelected == 1) {
          oneRegistrationFee = double.parse(
              widget.packagesModel.fees![i].oneRegistrationFee.toString());
          oneMonthlyFee = double.parse(
              widget.packagesModel.fees![i].oneMonthlyFee.toString());
        } else {
          if (_existingMemberYear == 'Year 2') {
            oneRegistrationFee = double.parse(
                widget.packagesModel.fees![i].twoContinuationFee.toString());
            oneMonthlyFee = double.parse(
                widget.packagesModel.fees![i].twoMonthlyFee.toString());
          } else {
            oneRegistrationFee = double.parse(
                widget.packagesModel.fees![i].threeContinuationFee.toString());
            oneMonthlyFee = double.parse(
                widget.packagesModel.fees![i].threeMonthlyFee.toString());
          }
        }
      }
    }
    formulaMethod();
    setState(() {});
  }

  formulaMethod() {
    setState(() {
      totalQuaterlyFee = double.parse(familySize.toString()) *
          double.parse(oneMonthlyFee.toString()) *
          double.parse(month.toString());
      totalDiscount = totalQuaterlyFee! * double.parse(discount.toString());
      totalPayableAmountAfterDiscount = totalQuaterlyFee! - totalDiscount!;
      totalPayableAmount = oneRegistrationFee! +
          double.parse(totalPayableAmountAfterDiscount.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.colorScheme.background,
      appBar: myCustomAppBar(
          title: 'Package Calculator',
          color: myColor.colorScheme.background,
          borderRadius: 0.0),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0),
        width: maxWidth(context),
        height: maxHeight(context),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: formWidget())),
            resultWidget(),
          ],
        ),
      ),
    );
  }

  Widget formWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox16(),
          Text(
            'GD Member Type',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          Container(
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.4),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 53.0,
            width: maxWidth(context),
            child: ListView.builder(
                itemCount: 1,
                // itemCount: packageMemberTypeList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isMemberTypeRadioBtnSelected =
                            packageMemberTypeList[i].id;
                        _memberType = packageMemberTypeList[i].name.toString();
                      });
                      if (isMemberTypeRadioBtnSelected == 1) {
                        calculateBtn();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kWhite.withOpacity(0.3),
                              border: Border.all(
                                color: _memberType ==
                                        packageMemberTypeList[i].name.toString()
                                    ? myColor.primaryColorDark
                                    : myColor.dialogBackgroundColor,
                                width: 1.7,
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Icon(
                                  Icons.circle,
                                  color: _memberType ==
                                          packageMemberTypeList[i]
                                              .name
                                              .toString()
                                      ? myColor.primaryColorDark
                                      : kWhite.withOpacity(0.3),
                                  size: 13.0,
                                )),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            packageMemberTypeList[0].name.toString(),
                            // packageMemberTypeList[i].name.toString(),
                            style: kStyleNormal.copyWith(
                              color: Colors.black,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox8(),
          isMemberTypeRadioBtnSelected == 2
              ? Container(
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 53.0,
                  width: maxWidth(context),
                  child: ListView.builder(
                      itemCount: packageExistingYearList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _existingMemberYear =
                                  packageExistingYearList[i].name.toString();
                            });
                            calculateBtn();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 60.0),
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kWhite.withOpacity(0.3),
                                    border: Border.all(
                                      color: _existingMemberYear ==
                                              packageExistingYearList[i]
                                                  .name
                                                  .toString()
                                          ? myColor.primaryColorDark
                                          : myColor.dialogBackgroundColor,
                                      width: 1.7,
                                    ),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Icon(
                                        Icons.circle,
                                        color: _existingMemberYear ==
                                                packageExistingYearList[i]
                                                    .name
                                                    .toString()
                                            ? myColor.primaryColorDark
                                            : kWhite.withOpacity(0.3),
                                        size: 13.0,
                                      )),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  packageExistingYearList[i].name.toString(),
                                  style: kStyleNormal.copyWith(
                                    color: kBlack,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container(),
          const SizedBox16(),
          Text(
            'Select Family Size',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          DropdownButtonHideUnderline(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                onMenuStateChange: (v) {
                  setState(() {
                    isSelectFamilySizeDropDownOpened = v;
                  });
                },
                isExpanded: true,
                hint: Row(
                  children: [
                    const Icon(
                      Icons.perm_identity,
                      size: 16,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      familySize.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                items: familySizeList
                    .map((item) => DropdownMenuItem<int>(
                          value: item,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.perm_identity,
                                size: 16,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '${item.toString()} Members',
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                value: familySize,
                onChanged: (value) {
                  setState(() {
                    familySize = value as int;
                    getAllFamilySize();
                    calculateBtn();
                  });
                },
                dropdownOverButton: false,
                iconSize: 20,
                iconEnabledColor: myColor.primaryColorDark,
                iconDisabledColor: Colors.grey,
                buttonElevation: 0,
                buttonHeight: 53.0,
                buttonWidth: maxWidth(context),
                dropdownElevation: 0,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: !isSelectFamilySizeDropDownOpened
                      ? const BorderRadius.all(Radius.circular(12.0))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                  color: kWhite.withOpacity(0.4),
                ),
                itemHeight: 35,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 150,
                dropdownPadding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 14.0, 14.0),
                dropdownDecoration: BoxDecoration(
                  borderRadius: isSelectFamilySizeDropDownOpened
                      ? const BorderRadius.all(Radius.circular(12.0))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                  color: myColor.colorScheme.background,
                ),
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 5,
                scrollbarAlwaysShow: true,
              ),
            ),
          ),
          const SizedBox16(),
          Text(
            'Select Payment Interval',
            style: kStyleNormal.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox16(),
          DropdownButtonHideUnderline(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                onMenuStateChange: (v) {
                  setState(() {
                    isPaymentIntervalDropDownOpened = v;
                  });
                },
                isExpanded: true,
                hint: Row(
                  children: [
                    const Icon(
                      Icons.perm_identity,
                      size: 16,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      paymentIntervalValue.toString(),
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                items: packagepaymentIntervalList
                    .map((item) => DropdownMenuItem<String>(
                          value: item.name,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.perm_identity,
                                size: 16,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                item.name.toString(),
                                style: kStyleNormal.copyWith(
                                  fontSize: 12.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                value: paymentIntervalValue,
                onChanged: (value) {
                  setState(() {
                    paymentIntervalValue = value as String;
                    for (int i = 0;
                        i < packagepaymentIntervalList.length;
                        i++) {
                      if (packagepaymentIntervalList[i].name ==
                          paymentIntervalValue) {
                        month = packagepaymentIntervalList[i].month;
                        discount = packagepaymentIntervalList[i].discount;
                      }
                    }
                    calculateBtn();
                  });
                },
                dropdownOverButton: false,
                iconSize: 20,
                iconEnabledColor: myColor.primaryColorDark,
                iconDisabledColor: Colors.grey,
                buttonElevation: 0,
                buttonHeight: 53.0,
                buttonWidth: maxWidth(context),
                dropdownElevation: 0,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: !isPaymentIntervalDropDownOpened
                      ? const BorderRadius.all(Radius.circular(12.0))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                        ),
                  color: kWhite.withOpacity(0.4),
                ),
                itemHeight: 35,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 150,
                dropdownPadding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 14.0, 14.0),
                dropdownDecoration: BoxDecoration(
                  borderRadius: isPaymentIntervalDropDownOpened
                      ? const BorderRadius.all(Radius.circular(12.0))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                  color: myColor.colorScheme.background,
                ),
              ),
            ),
          ),
          const SizedBox16(),
        ],
      ),
    );
  }

  Widget resultWidget() {
    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22.0),
          topRight: Radius.circular(22.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox12(),
          SizedBox(
            width: maxWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fee Type',
                    overflow: TextOverflow.clip,
                    style: kStyleNormal.copyWith(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Amount',
                      overflow: TextOverflow.clip,
                      style: kStyleNormal.copyWith(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox8(),
          const Divider(),
          calculateAmountRow('Total GD Enrollment Fee',
              'Rs ${formatNumber(oneRegistrationFee!)}'),
          calculateAmountRow('Package Subscription Fee per Person (Monthly)',
              'Rs ${formatNumber(oneMonthlyFee!)}'),
          calculateAmountRow('Total Package Subscription Fee (Yearly)',
              'Rs ${formatNumber(totalQuaterlyFee!)}'),
          calculateAmountRow(
              'Discount on total package subscription fee (Yearly) 5%',
              '- Rs ${formatNumber(totalDiscount!)}',
              color: kRed),
          calculateAmountRow(
            'Total Payable Fee',
            'Rs ${formatNumber(totalPayableAmount!)}',
            showDivider: false,
            size: 16.0,
            color: myColor.primaryColorDark,
          ),
        ],
      ),
    );
  }

  String formatNumber(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  Widget calculateAmountRow(textValue, amount, {showDivider, color, size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: maxWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  textValue,
                  overflow: TextOverflow.clip,
                  style: kStyleNormal.copyWith(fontSize: 12.0),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    amount,
                    overflow: TextOverflow.clip,
                    style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: size ?? 14.0,
                        color: color ?? kBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox8(),
        showDivider == false ? Container(height: 6.0) : const Divider(),
      ],
    );
  }
}
