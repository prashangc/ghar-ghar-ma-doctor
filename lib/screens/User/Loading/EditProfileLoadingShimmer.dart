import 'package:flutter/material.dart';
import '../../../constants/constants_imports.dart';
import '../../../widgets/LoadingShimmer.dart';

class EditProfileLoadingShimmer extends StatelessWidget {
  const EditProfileLoadingShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: LoadingCircleShimmer(
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox16(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (ctx, i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LoadingShimmer(
                            width: 50,
                            height: 15,
                          ),
                          const SizedBox8(),
                          LoadingShimmer(
                            width: maxWidth(context),
                            height: 60,
                          ),
                          const SizedBox8(),
                        ],
                      );
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    LoadingShimmer(
                      width: 50,
                      height: 15,
                    ),
                    LoadingShimmer(
                      width: 50,
                      height: 15,
                    ),
                  ],
                ),
                const SizedBox8(),
                Row(
                  children: [
                    LoadingShimmer(
                      width: maxWidth(context) / 1.8,
                      height: 60,
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: LoadingShimmer(
                        height: 60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
