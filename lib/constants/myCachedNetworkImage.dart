import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget myCachedNetworkImage(
  myWidth,
  myHeight,
  myImage,
  borderRadius,
  fit,
) {
  return CachedNetworkImage(
      width: myWidth,
      height: myHeight,
      imageUrl: myImage ?? '',
      imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              ),
            ),
          ),
      placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            color: myColor.primaryColorDark,
            strokeWidth: 1.5,
            backgroundColor: myColor.primaryColor,
          )),
      errorWidget: (context, url, error) => Image.asset(
            'assets/logo.png',
          ));
}

Widget myCachedNetworkImageCircle(
  myWidth,
  myHeight,
  myImage,
  fit,
) {
  return CachedNetworkImage(
      width: myWidth,
      height: myHeight,
      imageUrl: myImage ?? '',
      imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
              ),
            ),
          ),
      placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            color: myColor.primaryColorDark,
            strokeWidth: 1.5,
            backgroundColor: myColor.primaryColor,
          )),
      errorWidget: (context, url, error) => Image.asset('assets/logo.png'));
}
