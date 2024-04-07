import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/FilterAllDoctor.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class FilteredDepartmentPage extends StatefulWidget {
  final List<FilteredDepartmentModel> filteredDepartmentModel;
  final List<GetSymptomsModel> getSymptomsModel;

  final List<String> selectedList;

  const FilteredDepartmentPage(
      {Key? key,
      required this.filteredDepartmentModel,
      required this.getSymptomsModel,
      required this.selectedList})
      : super(key: key);

  @override
  State<FilteredDepartmentPage> createState() => _FilteredDepartmentPageState();
}

class _FilteredDepartmentPageState extends State<FilteredDepartmentPage> {
  ApiHandlerBloc? departmentBloc;
  String? mySymptoms;
  @override
  void initState() {
    super.initState();
  }

  idToName(int id) {
    for (int i = 0; i < widget.getSymptomsModel.length; i++) {
      if (widget.getSymptomsModel[i].id == id) {
        return widget.getSymptomsModel[i].name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Departments',
        color: myColor.dialogBackgroundColor,
        borderRadius: 12.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.filteredDepartmentModel.length,
                shrinkWrap: true,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      goThere(
                          context,
                          FilterAllDoctors(
                            context: context,
                            symptomID: widget.filteredDepartmentModel[i].id,
                            symptomValidation: true,
                          ));
                    },
                    child: departmentExpansionCard(
                        widget.filteredDepartmentModel[i]),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget departmentExpansionCard(
      FilteredDepartmentModel filteredDepartmentModel) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      width: maxWidth(context),
      child: Column(
        children: [
          Row(
            children: [
              myCachedNetworkImageCircle(
                60.0,
                60.0,
                filteredDepartmentModel.imagePath.toString(),
                BoxFit.contain,
              ),
              const SizedBox(width: 14.0),
              Text(
                filteredDepartmentModel.department.toString(),
                style: kStyleNormal.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Center(
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 30.0,
                  color: kBlack,
                ),
              )
            ],
          ),
          const SizedBox12(),
          SizedBox(
            height: 30,
            width: maxWidth(context),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: filteredDepartmentModel.symptoms!.length,
                itemBuilder: (ctx, i) {
                  filteredDepartmentModel.symptoms!
                      .contains(widget.selectedList[0]);
                  return Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: widget.selectedList
                              .contains(filteredDepartmentModel.symptoms![i])
                          ? myColor.primaryColorDark
                          : kWhite,
                      border: Border.all(
                          color: myColor.primaryColorDark, width: 1.0),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      idToName(int.parse(filteredDepartmentModel.symptoms![i])),
                      textAlign: TextAlign.center,
                      style: kStyleNormal.copyWith(
                        fontSize: 12.0,
                        color: widget.selectedList
                                .contains(filteredDepartmentModel.symptoms![i])
                            ? kWhite
                            : myColor.primaryColorDark,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
