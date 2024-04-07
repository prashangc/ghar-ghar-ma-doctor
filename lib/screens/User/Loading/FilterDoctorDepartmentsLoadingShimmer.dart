import 'package:flutter/material.dart';

import '../../../constants/constants_imports.dart';
import '../../../widgets/LoadingShimmer.dart';

class FilterDoctorDepartmentsLoadingShimmer extends StatefulWidget {
  const FilterDoctorDepartmentsLoadingShimmer({Key? key}) : super(key: key);

  @override
  State<FilterDoctorDepartmentsLoadingShimmer> createState() =>
      _FilterDoctorDepartmentsLoadingShimmerState();
}

class _FilterDoctorDepartmentsLoadingShimmerState
    extends State<FilterDoctorDepartmentsLoadingShimmer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth(context),
      height: 85.0,
      child: ListView.builder(
          itemCount: 50,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            return Container(
                margin: const EdgeInsets.only(right: 10.0),
                width: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    LoadingCircleShimmer(
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(height: 8.0),
                    Center(
                      child: LoadingShimmer(
                        width: 50,
                        height: 10,
                      ),
                    ),
                  ],
                ));
          })),
    );
  }
}
