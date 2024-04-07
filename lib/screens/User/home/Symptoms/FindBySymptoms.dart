import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/Symptoms/AllSymptoms.dart';

class FindBySymptoms extends StatefulWidget {
  final List<GetSymptomsModel> getSymptomsModel;

  const FindBySymptoms({Key? key, required this.getSymptomsModel})
      : super(key: key);

  @override
  State<FindBySymptoms> createState() => _FindBySymptomsState();
}

class _FindBySymptomsState extends State<FindBySymptoms> {
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
        itemCount: widget.getSymptomsModel.length < 8
            ? widget.getSymptomsModel.length
            : 8,
        itemBuilder: (BuildContext ctx, index) {
          return symptomCard(context, () {
            // widget.getSymptomsModel[index].isSelected = true;

            goThere(
              context,
              AllSymptomsScreen(
                getSymptomsModel: widget.getSymptomsModel,
                selectedIndex: index,
              ),
            );
          }, widget.getSymptomsModel[index].imagePath.toString(),
              widget.getSymptomsModel[index].name.toString());
        });
  }

  Widget symptomCard(BuildContext context, Function myTap, image, text) {
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
              backgroundColor: Colors.white,
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
