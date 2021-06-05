import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Reservation.dart';
import 'package:foodz_owner/Models/Restaurant.dart';
import 'package:foodz_owner/Widgets/ActivityWidget.dart';
import 'package:foodz_owner/Widgets/ReserveItem.dart';
import 'package:foodz_owner/Widgets/DismissibleWidget.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:foodz_owner/utils/consts/const.dart';

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

final _auth = FirebaseAuth.instance;
User _loggedInUser;

class ReservationsPending extends StatefulWidget {
  static String tag = '/ReservationsPending';

  @override
  _ReservationsPending createState() => _ReservationsPending();
}

class _ReservationsPending extends State<ReservationsPending> {
  List<Reservation> _pending = [];

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reservation')
              .where("restoId", isEqualTo: _loggedInUser.uid)
              .where("state", isEqualTo: "Pending")
              .orderBy("sent")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
            if (snapshot.data.docs.isNotEmpty) {
              _pending.clear();
              snapshot.data.docs.forEach((element) {
                _pending.add(Reservation.fromJson(element));
              });
              return ListView.builder(
                //padding: EdgeInsets.symmetric(vertical: 10),
                //shrinkWrap: true,
                //primary: false,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: _pending == null ? 0 : _pending.length,
                itemBuilder: (BuildContext context, int index) {
                  Reservation rev = _pending[index];
                  return DismissibleWidget(
                    item: rev,
                    ondismissed: (direction) {
                      dismissItem(context, index, direction);
                    },
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('restaurant')
                            .doc(rev.restoId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> restSnapshot) {
                          if (restSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator()));
                          }
                          if (restSnapshot.data.exists) {
                            Restaurant rest =
                                Restaurant.fromJson(restSnapshot.data);
                            return ActivityWidget(
                              type: rest.title,
                              rating: 5,
                              name: rest.title,
                              people: 4,
                              times: ["24/02/2021", rev.reservationTime],
                              imageUrl: rest.image,
                            );
                          } else {
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator()));
                          }
                        }),
                  );
                },
              );
            } else {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: 280,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          // Image.asset("images/offline/serving-dish.png",
                          //     width: 230, height: 120),
                          SizedBox(
                            height: 20,
                          ),
                          Text("You don't have any reservations !",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Constants.lightAccent,
                                  fontWeight: FontWeight.bold)),
                          Container(height: 10),
                          Text("Make some !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Constants.lightAccent,
                              )),
                          Container(height: 25),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
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
