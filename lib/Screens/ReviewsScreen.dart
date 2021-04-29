import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  static String tag = '/ReviewsScreen';

  @override
  _ReviewsScreen createState() => _ReviewsScreen();
}

class _ReviewsScreen extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Reviews")),
    );
  }
}
