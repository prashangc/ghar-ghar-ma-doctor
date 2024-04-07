import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

Widget htmlText(title) {
  return Html(
    data: title,
    style: {
      "*": Style(
        fontSize: FontSize(12.0),
        fontFamily: GoogleFonts.sourceSansPro().fontFamily,
        textAlign: TextAlign.justify,
      ),
    },
  );
}
