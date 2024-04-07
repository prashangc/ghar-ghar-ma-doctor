import 'package:flutter/material.dart';

import '../../../widgets/widgets_import.dart';

class ProfilePictureLoadingShimmer extends StatelessWidget {
  const ProfilePictureLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: const LoadingCircleShimmer(
        height: 120,
        width: 120,
      ),
    );
  }
}
