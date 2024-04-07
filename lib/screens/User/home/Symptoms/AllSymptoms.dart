import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/Symptoms/FilteredDepartmentPage.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class AllSymptomsScreen extends StatefulWidget {
  final List<GetSymptomsModel> getSymptomsModel;
  final int? selectedIndex;
  const AllSymptomsScreen(
      {Key? key, required this.getSymptomsModel, this.selectedIndex})
      : super(key: key);

  @override
  State<AllSymptomsScreen> createState() => _AllSymptomsScreenState();
}

class _AllSymptomsScreenState extends State<AllSymptomsScreen> {
  final List<GetSymptomsModel> mySelectedList = [];
  List<String> testList = [];
  final TextEditingController _myController = TextEditingController();
  String _search = '';
  List<bool> boolList = [];
  bool test = false;
  Map<String, String> Z = {};
  @override
  void initState() {
    super.initState();
    boolList.clear();
  }

  void btnProceed(context) async {
    testList.clear();
    for (int i = 0; i < widget.getSymptomsModel.length; i++) {
      if (boolList[i]) {
        testList.add(widget.getSymptomsModel[i].id.toString());
      }
    }
    var resp = await API().getPostResponseData(
        context,
        PostSearchBySymptomsModel(symptoms: ['$testList']),
        endpoints.postSearchBySymptomsEndpoint);
    List<FilteredDepartmentModel> test = List<FilteredDepartmentModel>.from(
        resp.map((e) => FilteredDepartmentModel.fromJson(e)));
    goThere(
        context,
        FilteredDepartmentPage(
          filteredDepartmentModel: test,
          selectedList: testList,
          getSymptomsModel: widget.getSymptomsModel,
        ));
    // if (statusCode == 200) {
    //   setState(() {});
    // } else {
    //   mySnackbar.mySnackBar(context, 'Server Error', Colors.red);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Search Doctor',
        color: myColor.dialogBackgroundColor,
        borderRadius: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: maxWidth(context),
              decoration: BoxDecoration(
                color: myColor.dialogBackgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                child: myFilterSearchTextField(
                  context,
                  _myController,
                  'Search all symptoms',
                  _search,
                  Icons.search,
                  Icons.sort,
                  () async {
                    // brandBloc = ApiHandlerBloc();
                    // brandBloc!.fetchAPIList(endpoints.getBrandEndpoint);
                    // showModalBottomSheet(
                    //     backgroundColor: backgroundColor,
                    //     isScrollControlled: true,
                    //     context: context,
                    //     shape: const RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.vertical(
                    //             top: Radius.circular(20))),
                    //     builder: (context) => filterProductsSheet());
                  },
                  () {
                    _myController.clear();
                    setState(() {
                      _search = '';
                      // getDataFromAPI();
                    });
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _search = value;
                      // getDataFromAPI();
                    });
                  },
                ),
              ),
            ),
            // const SizedBox16(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox16(),
                  Row(
                    children: [
                      Text(
                        'Symptoms',
                        style: kStyleNormal.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '( You can select multiple symptoms )',
                        style: kStyleNormal.copyWith(
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox2(),
                  Text(
                      '* This is machine generated response. Please refer actual doctor for precise advice.',
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        color: kRed,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox16(),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 1),
                      itemCount: widget.getSymptomsModel.length,
                      itemBuilder: (BuildContext ctx, index) {
                        boolList.add(false);
                        !test &&
                                widget.selectedIndex != null &&
                                widget.selectedIndex == index
                            ? boolList[widget.selectedIndex!] = true
                            : boolList.add(false);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (widget.selectedIndex == index) {
                                boolList[widget.selectedIndex!] =
                                    !boolList[widget.selectedIndex!];
                                test =
                                    !test; // boolList[widget.selectedIndex!] =
                                //     !boolList[widget.selectedIndex!];
                              } else {
                                boolList[index] = !boolList[index];
                              }
                            });
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                            myColor.dialogBackgroundColor,
                                        radius: 40.0,
                                        child: myCachedNetworkImageCircle(
                                            25.0,
                                            25.0,
                                            widget.getSymptomsModel[index]
                                                .imagePath
                                                .toString(),
                                            BoxFit.contain)),
                                    Positioned(
                                      top: 10.0,
                                      right: 5.0,
                                      child: Icon(
                                        boolList[index]
                                            ? Icons.check_circle
                                            : null,
                                        color: myColor.primaryColorDark,
                                        size: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox8(),
                                SizedBox(
                                  width: maxWidth(context),
                                  height: 18,
                                  child: Center(
                                    child: Text(
                                      widget.getSymptomsModel[index].name
                                          .toString(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: kStyleNormal.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12.0),
        height: 50.0,
        child: myCustomButton(
          context,
          myColor.primaryColorDark,
          'Proceed',
          kStyleNormal.copyWith(
            fontSize: 16.0,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
          () {
            btnProceed(context);
          },
        ),
      ),
    );
  }
}
