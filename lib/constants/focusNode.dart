import 'package:flutter/material.dart';

void myfocusRemover(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
