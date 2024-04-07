import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/constants/graph.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class BloodPressure extends StatefulWidget {
  const BloodPressure({Key? key}) : super(key: key);

  @override
  State<BloodPressure> createState() => _BloodPressureState();
}

class _BloodPressureState extends State<BloodPressure> {
  String? _lowerBp, _upperBp;
  List<GetIDNameModel> filterList = [];

  @override
  void initState() {
    super.initState();
    for (var element in bloodPressureFilterList) {
      filterList.add(GetIDNameModel(
        id: element,
        name: element,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Blood Pressure',
          color: backgroundColor,
          borderRadius: 12.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          height: maxHeight(context),
          width: maxWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox12(),
                      Text(
                        '140/80 mmHg',
                        style: kStyleTitle2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                      const SizedBox8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 15.0,
                            color: Color(0xFFEB5757),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '10% Higher than Last Month',
                            style: kStyleNormal.copyWith(
                              color: kBlack,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox16(),
                      Text(
                        'Blood Pressure Graph',
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox12(),
                      myDropDown2(
                        context,
                        Icons.sort,
                        myColor.primaryColorDark,
                        kBlack,
                        maxWidth(context),
                        'Filter',
                        filterList,
                        kWhite.withOpacity(0.4),
                        onValueChanged: (v) {},
                      ),
                      const SizedBox8(),
                      myGraph(context),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox2(),
                  const SizedBox2(),
                  Divider(color: kWhite.withOpacity(0.4), thickness: 1.0),
                  const SizedBox2(),
                  const SizedBox2(),
                  Row(
                    children: [
                      Expanded(
                        child: myBpTextField(
                            'Upper pressure', 'Enter upper pressure', _upperBp,
                            onValueChanged: (v) {
                          _upperBp = v;
                        }),
                      ),
                      const SizedBox(width: 5.0),
                      Text('-',
                          style: kStyleNormal.copyWith(
                            fontSize: 13.0,
                          )),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: myBpTextField(
                            'Lower pressure', 'Enter lower pressure', _lowerBp,
                            onValueChanged: (v) {
                          _lowerBp = v;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox12(),
                  SizedBox(
                    width: maxWidth(context),
                    height: 50.0,
                    child: myCustomButton(
                      context,
                      myColor.primaryColorDark,
                      'Calculate',
                      kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                      ),
                      () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myBpTextField(labelText, errorMessage, textValue,
      {ValueChanged<String>? onValueChanged}) {
    Color myBorderColor = myColor.primaryColorDark;
    return TextFormField(
      style: kStyleNormal.copyWith(color: Colors.black, fontSize: 13.0),
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        onValueChanged!(value);
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        filled: true,
        fillColor: kWhite.withOpacity(0.4),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: kWhite.withOpacity(0.4), width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: myBorderColor, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        hintText: labelText,
        hintStyle: kStyleNormal.copyWith(color: Colors.black, fontSize: 13.0),
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return '';
        } else if (v.split('.').length > 2) {
          return 'Invalid';
        }
        return null;
      },
      onSaved: (v) {
        textValue = v;
      },
    );
  }
}
