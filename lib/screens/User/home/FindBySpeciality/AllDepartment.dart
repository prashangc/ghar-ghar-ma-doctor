import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DepartmentModel.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/FilterAllDoctor.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class AllDepartment extends StatefulWidget {
  List<DepartmentModel> departmentModel;

  AllDepartment({Key? key, required this.departmentModel}) : super(key: key);

  @override
  State<AllDepartment> createState() => _AllDepartmentState();
}

class _AllDepartmentState extends State<AllDepartment> {
  ApiHandlerBloc? departmentBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'All Departments',
        color: myColor.dialogBackgroundColor,
        borderRadius: 12.0,
      ),
      body: widget.departmentModel.isEmpty
          ? SizedBox(
              height: maxHeight(context) - 100,
              child: const Center(child: Text('No departments added')))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    const SizedBox12(),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                crossAxisCount: 4,
                                height: 128,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 1),
                        itemCount: widget.departmentModel.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              goThere(
                                  context,
                                  FilterAllDoctors(
                                      context: context,
                                      symptomID:
                                          widget.departmentModel[index].id));
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                      backgroundColor:
                                          myColor.dialogBackgroundColor,
                                      radius: 40.0,
                                      child: myCachedNetworkImageCircle(
                                          25.0,
                                          25.0,
                                          widget
                                              .departmentModel[index].imagePath
                                              .toString(),
                                          BoxFit.contain)),
                                  const SizedBox8(),
                                  SizedBox(
                                    width: maxWidth(context),
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        widget.departmentModel[index].department
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
            ),
    );
  }
}
