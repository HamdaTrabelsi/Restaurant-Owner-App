import 'package:flutter/material.dart';
import 'package:foodz_owner/Screens/ReservationsAccepted.dart';
import 'package:foodz_owner/Screens/ReservationsPending.dart';
import 'package:foodz_owner/Widgets/ReserveItem.dart';
import 'package:foodz_owner/Widgets/DismissibleWidget.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';

class ReservationsScreen extends StatefulWidget {
  static String tag = '/ReservationsScreen';

  @override
  _ReservationsScreen createState() => _ReservationsScreen();
}

class _ReservationsScreen extends State<ReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // title: Text(
          //   "Restaurant Details",
          // ),
          // titleTextStyle: TextStyle(color: Colors.black54),
          title: TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(
                text: "Accepted",
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.keyboard_backspace,
          //   ),
          //   onPressed: () => Navigator.pop(context),
          // ),
          // centerTitle: true,
          //elevation: 4.0,
          actions: <Widget>[
            // IconButton(
            //   icon: IconBadge(
            //     icon: Icons.notifications,
            //     size: 22.0,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) {
            //           return NotificationScreen();
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
        body: TabBarView(
          children: [
            ReservationsPending(),
            ReservationsAccepted(),
          ],
        ),
      ),
    );
  }
}
