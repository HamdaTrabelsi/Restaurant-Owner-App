import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  static String tag = '/IntroScreen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hello There !"),
    );
  }
}
