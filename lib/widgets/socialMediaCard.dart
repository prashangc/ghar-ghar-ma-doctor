import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

Widget socialMediaCard(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    decoration: BoxDecoration(
        // color: kTransparent,
        color: kWhite.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(10.0))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox12(),
        Text(
          'Connect with us',
          style: kStyleNormal.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox16(),
        SizedBox(
          width: maxWidth(context),
          height: 25.0,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: socialMediaList.length,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () async {
                    await closeInAppWebView();
                    if (await canLaunchUrl(
                        Uri.parse(socialMediaList[i].appType))) {
                      await launchUrl(Uri.parse(socialMediaList[i].appType));
                    } else {
                      if (socialMediaList[i].alternateAppType != null) {
                        await launchUrl(
                            Uri.parse(socialMediaList[i].alternateAppType!));
                        myToast
                            .toast("Messenger is not installed in your device");
                      } else {
                        await launchUrl(
                            Uri.parse(socialMediaList[i].ifNotSupported),
                            mode: LaunchMode.externalApplication);
                      }
                    }
                  },
                  child: SizedBox(
                    width: (maxWidth(context) / 4) - 12,
                    child: Image.asset(
                      socialMediaList[i].image.toString(),
                    ),
                  ),
                );
              }),
        ),
        const SizedBox12(),
      ],
    ),
  );
}
