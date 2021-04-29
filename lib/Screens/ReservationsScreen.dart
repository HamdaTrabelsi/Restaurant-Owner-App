import 'package:flutter/material.dart';

class ReservationsScreen extends StatefulWidget {
  static String tag = '/ReservationsScreen';

  @override
  _ReservationsScreen createState() => _ReservationsScreen();
}

class _ReservationsScreen extends State<ReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Reservation")),
    );
  }
}
