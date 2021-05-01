import 'package:flutter/material.dart';
import 'package:foodz_owner/Widgets/ReserveItem.dart';
import 'package:foodz_owner/Widgets/DismissibleWidget.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';

List reservations = [
  {
    "img": "images/offline/cm1.jpeg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "4",
    "time": "14:15",
    "date": "24 / 08 / 2020"
  },
  {
    "img": "images/offline/cm2.jpeg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "9",
    "time": "17:15",
    "date": "24 / 15 / 2021"
  },
  {
    "img": "images/offline/cm4.jpeg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "2",
    "time": "14:15",
    "date": "14 / 09 / 2020"
  },
  {
    "img": "images/offline/cm3.jpeg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "4",
    "time": "14:15",
    "date": "24 / 08 / 2020"
  },
];

class ReservationsPending extends StatefulWidget {
  static String tag = '/ReservationsPending';

  @override
  _ReservationsPending createState() => _ReservationsPending();
}

class _ReservationsPending extends State<ReservationsPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: reservations == null ? 0 : reservations.length,
          itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
            Map rest = reservations[index];
//                print(foods);
//                print(foods.length);
            return DismissibleWidget(
              item: rest,
              ondismissed: (direction) {
                dismissItem(context, index, direction);
              },
              child: ReserveItem(
                img: rest['img'],
                time: rest['time'],
                name: rest['name'],
                date: rest['date'],
                seats: rest['seats'],
              ),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: "Checkout",
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (BuildContext context) {
      //           return CheckoutScreen();
      //           return CheckoutScreen();
      //         },
      //       ),
      //     );
      //   },
      //   child: Icon(
      //     Icons.arrow_forward,
      //   ),
      //   heroTag: Object(),
      // ),
    );
  }

  void dismissItem(
      BuildContext context, int index, DismissDirection direction) {
    setState(() {
      reservations.removeAt(index);
    });
    switch (direction) {
      case DismissDirection.startToEnd:
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          //title: "Hey Ninja",
          message: "This Reservation has been approved",
          duration: Duration(seconds: 1),
        )..show(context);
        break;
      case DismissDirection.endToStart:
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          //title: "Hey Ninja",
          message: "This Reservation has been deleted",
          duration: Duration(seconds: 1),
        )..show(context);
        break;
    }
  }
}
