import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SuccessFlush {
  static void showSuccessFlush({BuildContext context, String message}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: "Success",
      message: message,
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(seconds: 3),
    )..show(context).whenComplete(() {
        Navigator.pop(context);
      });
  }
}
