import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  Future<dynamic> toast(msg) {
    return Fluttertoast.showToast(
      textColor: Colors.white,
      backgroundColor: Colors.black45,
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

final myToast = MyToast();
