import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Database/ReservationDB.dart';
import 'package:foodz_owner/Models/Reservation.dart';
import 'package:foodz_owner/Models/Utilisateur.dart';
import 'package:foodz_owner/Widgets/ActivityWidget.dart';
import 'package:foodz_owner/Widgets/ReserveItem.dart';
import 'package:foodz_owner/Widgets/DismissibleWidget.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:intl/intl.dart';

ReservationDB resDB = ReservationDB();
DateFormat _formatter = DateFormat('yyyy-MM-dd');

final _auth = FirebaseAuth.instance;
User _loggedInUser;

class ReservationsAccepted extends StatefulWidget {
  static String tag = '/ReservationsPending';

  @override
  _ReservationsAccepted createState() => _ReservationsAccepted();
}

class _ReservationsAccepted extends State<ReservationsAccepted> {
  List<Reservation> _accepted = [];

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
                .where("state", isEqualTo: "Accepted")
                .orderBy("sent")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(child: CircularProgressIndicator()));
              }
              if (snapshot.data.docs.isNotEmpty) {
                _accepted.clear();
                snapshot.data.docs.forEach((element) {
                  _accepted.add(Reservation.fromJson(element));
                });
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: _accepted == null ? 0 : _accepted.length,
                  itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                    Reservation rest = _accepted[index];
//                print(foods);
//                print(foods.length);
                    return DismissibleWidget(
                      item: rest,
                      //conf : () {}
                      ondismissed: (direction) {
                        dismissAction(direction, rest.uid);
                      },
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(rest.clientId)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> clientSnapshot) {
                            if (clientSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Container(
                                      child: CircularProgressIndicator()));
                            }
                            if (clientSnapshot.data.exists) {
                              Utilisateur client = Utilisateur.fromJson(
                                  clientSnapshot.data.data());
                              /*return ReserveItem(
                                img: client.image,
                                time: rest.reservationTime,
                                name: client.username,
                                date: "24/02/2021",
                                seats: rest.people,
                              );*/
                              return ActivityWidget(
                                type: client.username,
                                rating: 5,
                                name: client.username,
                                people: rest.people,
                                times: [
                                  _formatter.format(rest.reservationDay),
                                  rest.reservationTime
                                ],
                                imageUrl: client.image,
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
            }),
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

  /*void dismissItem(
      BuildContext context, int index, DismissDirection direction) {
    setState(() {
      reservations.removeAt(index);
    });
    SnackUtil.showSnackBar(context, 'This reservation has been cancelled');
  }*/
}

void dismissAction(DismissDirection direction, String id) {
  switch (direction) {
    case DismissDirection.startToEnd:
      /*Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          //title: "Hey Ninja",
          message: "This Reservation has been approved",
          duration: Duration(seconds: 1),
        )..show(context);*/
      resDB.editReservationState(state: "Done", id: id);
      break;
    case DismissDirection.endToStart:
      resDB.editReservationState(state: "Canceled", id: id);
      break;
  }
}
