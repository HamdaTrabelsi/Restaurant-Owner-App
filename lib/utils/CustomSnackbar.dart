import 'package:flutter/material.dart';

SnackBar customSnackBar({@required String content, @required Color color}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: TextStyle(color: color, letterSpacing: 0.5),
    ),
  );
}
