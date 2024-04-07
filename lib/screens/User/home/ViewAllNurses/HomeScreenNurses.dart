import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/AlNurseModel.dart';
import 'package:ghargharmadoctor/screens/User/home/ViewAllNurses/IndividualNursePage.dart';

class HomeScreenNurses extends StatefulWidget {
  List<AllNurseModel> allNurseModel;

  HomeScreenNurses({Key? key, required this.allNurseModel}) : super(key: key);

  @override
  State<HomeScreenNurses> createState() => _HomeScreenNursesState();
}

class _HomeScreenNursesState extends State<HomeScreenNurses> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox16(),
          GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: maxWidth(context) / 400,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: widget.allNurseModel.length < 4
                  ? widget.allNurseModel.length
                  : 4,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    goThere(
                        context,
                        IndividualNursePage(
                            nurseModel: widget.allNurseModel[index]));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: maxWidth(context),
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 238, 238),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: myCachedNetworkImage(
                                maxWidth(context),
                                maxHeight(context),
                                widget.allNurseModel[index].imagePath
                                    .toString(),
                                const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                BoxFit.contain),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.allNurseModel[index].user!.name
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.allNurseModel[index].qualification
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                style: kStyleNormal.copyWith(
                                  color: myColor.primaryColorDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox2(),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 12.0,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.allNurseModel[index].address
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: kStyleNormal.copyWith(
                                        fontSize: 10.0,
                                      ),
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
                );
              }),
          const SizedBox16(),
        ],
      ),
    );
  }
}
