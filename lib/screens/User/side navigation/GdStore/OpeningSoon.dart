import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class OpeningSoon extends StatefulWidget {
  const OpeningSoon({super.key});

  @override
  State<OpeningSoon> createState() => OopeningStateSoon();
}

class OopeningStateSoon extends State<OpeningSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        width: maxWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: maxWidth(context),
              height: maxHeight(context) / 4,
            ),
            const SizedBox8(),
            SizedBox(
              width: maxWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'OPENING',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: myColor.primaryColorDark,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'SOON',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: const Color(0xFF52C8F4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox12(),
            Text(
              'We\'ll be there shortly! We constantly work to provide you with the greatest experience.',
              textAlign: TextAlign.center,
              style: kStyleNormal.copyWith(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
