import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/DepartmentModel.dart';
import 'package:ghargharmadoctor/screens/User/home/TopDoctors/FilterAllDoctor.dart';

class FindBySpeciality extends StatefulWidget {
  final List<DepartmentModel> departmentModel;

  const FindBySpeciality({Key? key, required this.departmentModel})
      : super(key: key);

  @override
  State<FindBySpeciality> createState() => _FindBySpecialityState();
}

class _FindBySpecialityState extends State<FindBySpeciality> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 4,
                height: 142.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 6),
        itemCount: widget.departmentModel.length < 8
            ? widget.departmentModel.length
            : 8,
        itemBuilder: (BuildContext ctx, index) {
          return departmentCard(context, () {
            goThere(
                context,
                FilterAllDoctors(
                    context: context,
                    symptomID: widget.departmentModel[index].id));
          }, widget.departmentModel[index].imagePath.toString(),
              widget.departmentModel[index].department.toString());
        });
  }

  Widget departmentCard(BuildContext context, Function myTap, image, text) {
    return GestureDetector(
      onTap: () {
        myTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: kWhite,
              radius: 40.0,
              child: myCachedNetworkImageCircle(
                25.0,
                25.0,
                image,
                BoxFit.contain,
              ),
            ),
            const SizedBox12(),
            SizedBox(
              width: maxWidth(context),
              height: 36.0,
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: kStyleNormal.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox12(),
          ],
        ),
      ),
    );
  }
}
