import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DropDownModel/GetIDName.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:google_fonts/google_fonts.dart';

class ComparePackage extends StatefulWidget {
  final List<PackagesModel> packagesModel;
  final List<PackagesModel> corporatePackagesModel;
  final bool isCorporate;
  const ComparePackage(
      {super.key,
      required this.packagesModel,
      required this.isCorporate,
      required this.corporatePackagesModel});

  @override
  State<ComparePackage> createState() => _ComparePackageState();
}

class _ComparePackageState extends State<ComparePackage>
    with TickerProviderStateMixin {
  List<GetIDNameModel> list = [];
  List<GetIDNameModel> list2 = [];
  List<GetIDNameModel> list3 = [];
  List<GetIDNameModel> list4 = [];
  String? dropdownId1,
      dropdownId2,
      dropdownName1,
      dropdownName2,
      dropdownId3,
      dropdownName3,
      dropdownId4,
      dropdownName4;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        initialIndex: widget.isCorporate == true ? 1 : 0,
        vsync: this);
    dropdownListMethod();
    dropdownListCorMethod();
  }

  dropdownListMethod() {
    list.clear();
    list2.clear();
    for (int i = 0; i < widget.packagesModel.length; i++) {
      list.add(GetIDNameModel(
        id: widget.packagesModel[i].id.toString(),
        name: widget.packagesModel[i].packageType.toString(),
      ));
      list2.add(GetIDNameModel(
        id: widget.packagesModel[i].id.toString(),
        name: widget.packagesModel[i].packageType.toString(),
      ));
    }
    list2.removeWhere((item) => item.name == "Gold Membership");
    list2.sort((a, b) => a.name!.compareTo(b.name!));
    dropdownId1 = list[0].id.toString();
    dropdownName1 = list[0].name.toString();
    dropdownId2 = list2[0].id.toString();
    dropdownName2 = list2[0].name.toString();
    list.removeWhere((item) => item.name == dropdownName2);
    list.sort((a, b) => a.name!.compareTo(b.name!));
  }

  dropdownListCorMethod() {
    list3.clear();
    list4.clear();
    for (int i = 0; i < widget.corporatePackagesModel.length; i++) {
      list3.add(GetIDNameModel(
        id: widget.corporatePackagesModel[i].id.toString(),
        name: widget.corporatePackagesModel[i].packageType.toString(),
      ));
      list4.add(GetIDNameModel(
        id: widget.corporatePackagesModel[i].id.toString(),
        name: widget.corporatePackagesModel[i].packageType.toString(),
      ));
    }
    list4.removeWhere((item) => item.name == "Silver Corporate Membership");
    list4.sort((a, b) => a.name!.compareTo(b.name!));
    dropdownId3 = list3[0].id.toString();
    dropdownName3 = list3[0].name.toString();
    dropdownId4 = list4[0].id.toString();
    dropdownName4 = list4[0].name.toString();
    list3.removeWhere((item) => item.name == dropdownName4);
    list3.sort((a, b) => a.name!.compareTo(b.name!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.colorScheme.background,
      appBar: myCustomAppBar(
        title: 'Compare Package',
        color: backgroundColor,
        borderRadius: 0.0,
      ),
      body: Container(
        width: maxWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        margin: const EdgeInsets.only(top: 20.0),
        decoration: BoxDecoration(
          color: myColor.dialogBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22.0),
            topRight: Radius.circular(22.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: maxWidth(context),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TabBar(
                  labelColor: kWhite,
                  unselectedLabelColor: kBlack,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: myColor.primaryColorDark,
                  ),
                  onTap: (i) {
                    setState(() {
                      _tabController!.index = i;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        'Family',
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Corporate',
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox12(),
                    Text(
                      'Choose your preferable package',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox12(),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: myDropDown2(
                            context,
                            Icons.sort,
                            myColor.primaryColorDark,
                            kBlack,
                            maxWidth(context),
                            _tabController!.index == 0
                                ? dropdownName1
                                : dropdownName3 ?? 'Filter',
                            _tabController!.index == 0 ? list : list3,
                            kWhite.withOpacity(0.4),
                            onValueChanged: (v) {
                              if (_tabController!.index == 0) {
                                list2.addAll(list
                                    .where((item) => item.name == dropdownName1)
                                    .toList());
                                list2 = list2
                                    .where((item) => item.name != v.name)
                                    .toList();
                                dropdownId1 = v.id;
                                dropdownName1 = v.name;
                              } else {
                                list4.addAll(list3
                                    .where((item) => item.name == dropdownName3)
                                    .toList());
                                list4 = list4
                                    .where((item) => item.name != v.name)
                                    .toList();
                                dropdownId3 = v.id;
                                dropdownName3 = v.name;
                              }

                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          flex: 1,
                          child: myDropDown2(
                            context,
                            Icons.sort,
                            myColor.primaryColorDark,
                            kBlack,
                            maxWidth(context),
                            _tabController!.index == 0
                                ? dropdownName2
                                : dropdownName4 ?? 'Filter',
                            _tabController!.index == 0 ? list2 : list4,
                            kWhite.withOpacity(0.4),
                            onValueChanged: (v) {
                              if (_tabController!.index == 0) {
                                list.addAll(list2
                                    .where((item) => item.name == dropdownName2)
                                    .toList());
                                list = list
                                    .where((item) => item.name != v.name)
                                    .toList();
                                dropdownId2 = v.id;
                                dropdownName2 = v.name;
                              } else {
                                list3.addAll(list4
                                    .where((item) => item.name == dropdownName4)
                                    .toList());
                                list3 = list3
                                    .where((item) => item.name != v.name)
                                    .toList();
                                dropdownId4 = v.id;
                                dropdownName4 = v.name;
                              }

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox8(),
                    myPackageDetailsCard(
                      _tabController!.index == 0
                          ? widget.packagesModel
                          : widget.corporatePackagesModel,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myPackageDetailsCard(List<PackagesModel> packagesModel) {
    List<PackagesModel> data = [];
    List<PackagesModel> data2 = [];
    List<PackagesModel> data3 = [];
    List<PackagesModel> data4 = [];
    if (_tabController!.index == 0) {
      data.clear();
      data2.clear();
      if (dropdownId1 != null) {
        data = packagesModel
            .where((element) => int.parse(dropdownId1.toString()) == element.id)
            .toList();
      }
      if (dropdownId2 != null) {
        data2 = packagesModel
            .where((element) => int.parse(dropdownId2.toString()) == element.id)
            .toList();
      }
    } else {
      data3.clear();
      data4.clear();
      if (dropdownId3 != null) {
        data3 = packagesModel
            .where((element) => int.parse(dropdownId3.toString()) == element.id)
            .toList();
      }
      if (dropdownId4 != null) {
        data4 = packagesModel
            .where((element) => int.parse(dropdownId4.toString()) == element.id)
            .toList();
      }
    }

    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
        color: kWhite.withOpacity(0.4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        children: [
          myRow(
              'Number of Home Visit',
              _tabController!.index == 0
                  ? data[0].visits.toString()
                  : data3[0].visits.toString(),
              _tabController!.index == 0
                  ? data2[0].visits.toString()
                  : data4[0].visits.toString()),
          myRow(
              'Online Consultation',
              _tabController!.index == 0
                  ? data[0].onlineConsultation.toString()
                  : data3[0].onlineConsultation.toString(),
              _tabController!.index == 0
                  ? data2[0].onlineConsultation.toString()
                  : data4[0].onlineConsultation.toString()),
          myRow(
              'Registration fee/person',
              _tabController!.index == 0
                  ? 'NPR. ${data[0].registrationFee.toString()}'
                  : 'NPR. ${data3[0].registrationFee.toString()}',
              _tabController!.index == 0
                  ? 'NPR. ${data2[0].registrationFee.toString()}'
                  : 'NPR. ${data4[0].registrationFee.toString()}'),
          myRow(
              'Monthly fee/person',
              _tabController!.index == 0
                  ? 'NPR. ${data[0].monthlyFee.toString()} per Month'
                  : 'NPR. ${data3[0].monthlyFee.toString()} per Month',
              _tabController!.index == 0
                  ? 'NPR. ${data2[0].monthlyFee.toString()} per Month'
                  : 'NPR. ${data4[0].monthlyFee.toString()} per Month'),
          myRow(
              'Pathlogical screening',
              _tabController!.index == 0
                  ? data[0].screening == 0
                      ? false
                      : true
                  : data3[0].screening == 0
                      ? false
                      : true,
              _tabController!.index == 0
                  ? data2[0].screening == 0
                      ? false
                      : true
                  : data4[0].screening == 0
                      ? false
                      : true),
          myRow(
              'Medical checkup',
              _tabController!.index == 0
                  ? data[0].checkup == 0
                      ? false
                      : true
                  : data3[0].checkup == 0
                      ? false
                      : true,
              _tabController!.index == 0
                  ? data2[0].checkup == 0
                      ? false
                      : true
                  : data4[0].checkup == 0
                      ? false
                      : true),
          myRow(
              'Free ambulance service',
              _tabController!.index == 0
                  ? data[0].ambulance == 0
                      ? false
                      : true
                  : data3[0].ambulance == 0
                      ? false
                      : true,
              _tabController!.index == 0
                  ? data2[0].ambulance == 0
                      ? false
                      : true
                  : data4[0].ambulance == 0
                      ? false
                      : true),
          myRow(
            'Insurance service',
            _tabController!.index == 0
                ? data[0].insurance == 0
                    ? false
                    : true
                : data3[0].insurance == 0
                    ? false
                    : true,
            _tabController!.index == 0
                ? data2[0].insurance == 0
                    ? false
                    : true
                : data4[0].insurance == 0
                    ? false
                    : true,
          ),
          myRow(
            'Insurance amount',
            _tabController!.index == 0
                ? 'NPR. ${data[0].insuranceAmount.toString()}'
                : 'NPR. ${data3[0].insuranceAmount.toString()}',
            _tabController!.index == 0
                ? 'NPR. ${data2[0].insuranceAmount.toString()}'
                : 'NPR. ${data4[0].insuranceAmount.toString()}',
          ),
          myRow(
            'Schedule Flexibility',
            _tabController!.index == 0
                ? data[0].scheduleFlexibility == 0
                    ? false
                    : true
                : data3[0].scheduleFlexibility == 0
                    ? false
                    : true,
            _tabController!.index == 0
                ? data2[0].scheduleFlexibility == 0
                    ? false
                    : true
                : data4[0].scheduleFlexibility == 0
                    ? false
                    : true,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget myRow(one, two, three, {showDivider}) {
    RegExp regex = RegExp(r'\d+');

    List<TextSpan> textSpans = [];
    List<TextSpan> textSpans2 = [];
    int currentIndex = 0;
    List<RegExpMatch> listOfString = [];
    List<RegExpMatch> listOfString2 = [];
    if (two != false && two != true) {
      listOfString = regex.allMatches(two).toList();
    }
    if (three != false && three != true) {
      listOfString2 = regex.allMatches(three).toList();
    }
    myTextSpanLoop(value, myTextSpan, matches) {
      for (var match in matches) {
        if (match.start > currentIndex) {
          myTextSpan.add(
            TextSpan(
              text: value.substring(currentIndex, match.start),
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
                //  fontWeight: FontWeight.bold
              ),
            ),
          );
        }
        myTextSpan.add(
          TextSpan(
            text: value.substring(match.start, match.end),
            style: kStyleNormal.copyWith(
                fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
        );
        currentIndex = match.end;
      }
      if (currentIndex < value.length) {
        myTextSpan.add(
          TextSpan(
            text: value.substring(currentIndex),
            style: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
        );
      }
    }

    if (two != false && two != true) {
      myTextSpanLoop(two, textSpans, listOfString);
    }
    if (three != false && three != true) {
      myTextSpanLoop(three, textSpans2, listOfString2);
    }
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: maxWidth(context) / 2.5,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      width: 2.0,
                      color: myColor.dialogBackgroundColor,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    one,
                    style: kStyleNormal.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 2.0,
                          color: myColor.dialogBackgroundColor,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: two == false
                        ? Icon(Icons.cancel_rounded, color: kRed)
                        : two == true
                            ? Icon(Icons.check, color: kGreen)
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: textSpans),
                              ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 2.0,
                          color: kTransparent,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    child: three == false
                        ? Icon(
                            Icons.cancel_rounded,
                            color: kRed,
                          )
                        : three == true
                            ? Icon(
                                Icons.check,
                                color: kGreen,
                              )
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: textSpans2),
                              ),
                  )),
            ],
          ),
        ),
        showDivider == false
            ? Container()
            : Container(
                color: myColor.dialogBackgroundColor,
                height: 2,
                width: maxWidth(context),
              ),
      ],
    );
  }
}
