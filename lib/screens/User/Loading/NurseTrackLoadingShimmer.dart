import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class NurseTrackLoadingShimmer extends StatelessWidget {
  const NurseTrackLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: maxWidth(context),
          height: 100.0,
          child: Stack(
            children: [
              Positioned(
                  left: 40.0,
                  right: 40.0,
                  top: 40.0,
                  child: LoadingShimmer(
                    width: maxWidth(context),
                    height: 2.0,
                  )),
              ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: nurseTrackingList.length,
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        const SizedBox16(),
                        LoadingCircleShimmer(
                          width: maxWidth(context) / 3,
                          height: 50.0,
                        ),
                        const SizedBox8(),
                        const LoadingShimmer(
                          height: 8.0,
                          width: 40.0,
                        )
                      ],
                    );
                  }),
            ],
          ),
        )
      ],
    );
  }
}
