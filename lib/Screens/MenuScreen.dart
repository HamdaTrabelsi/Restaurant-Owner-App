import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  static String tag = '/MenuScreen';

  @override
  _MenuScreen createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Reviews")),
    );
  }
}
