import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Database/ReservationDB.dart';
import 'package:foodz_owner/Models/Reservation.dart';
import 'package:foodz_owner/Models/Restaurant.dart';
import 'package:foodz_owner/Models/Utilisateur.dart';
import 'package:foodz_owner/Widgets/ActivityWidget.dart';
import 'package:foodz_owner/Widgets/ReserveItem.dart';
import 'package:foodz_owner/Widgets/DismissibleWidget.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:intl/intl.dart';
import 'package:sweetsheet/sweetsheet.dart';

final SweetSheet _sweetSheet = SweetSheet();
final ReservationDB resDB = ReservationDB();
DateFormat _formatter = DateFormat('yyyy-MM-dd');
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
                      dismissAction(direction, rev.uid);
                    },
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(rev.clientId)
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
                            return ActivityWidget(
                              type: client.username,
                              rating: 5,
                              name: client.username,
                              people: rev.people,
                              times: [
                                _formatter.format(rev.reservationDay),
                                rev.reservationTime
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

/*
  bool dismissConf(int index, DismissDirection direction, String id) {
    switch (direction) {
      case DismissDirection.startToEnd:
        /*Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          //title: "Hey Ninja",
          message: "This Reservation has been approved",
          duration: Duration(seconds: 1),
        )..show(context);*/
        //return swipeGreenAction(context, id);
        break;
      case DismissDirection.endToStart:
        return swipeRedAction(context, id);
        break;
    }
  }
}

bool swipeRedAction(BuildContext context, String id) {
  _sweetSheet.show(
    context: context,
    title: Text("Decline ?"),
    description: Text('Are you sure you want to decline this reservation ?'),
    color: SweetSheetColor.DANGER,
    icon: Icons.delete,
    positive: SweetSheetAction( 
      onPressed: () async {
        //await resDB.declineReservation(id: id);
        print(true);
        return true;
        //Navigator.pop(context);
      },
      title: 'Confirm',
      //icon: Icons.open_in_new,
    ),
    negative: SweetSheetAction(
      onPressed: () {
        //Navigator.of(context).pop();
        return false;
      },
      title: 'Cancel',
    ),
  );
}

bool swipeGreenAction(BuildContext context, String id) {
  _sweetSheet.show(
    context: context,
    title: Text("Accept"),
    description: Text('Do you want to accept this reservation'),
    color: SweetSheetColor.SUCCESS,
    icon: Icons.check,
    positive: SweetSheetAction(
      onPressed: () async {
        //await resDB.acceptReservation(id: id);
        return true;
      },
      title: 'Confirm',
      //icon: Icons.open_in_new,
    ),
    negative: SweetSheetAction(
      onPressed: () {
        return false;
        //Navigator.of(context).pop();
      },
      title: 'Cancel',
    ),
  );
}
*/
  void dismissAction(DismissDirection direction, String id) {
    switch (direction) {
      case DismissDirection.startToEnd:
        /*Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          //title: "Hey Ninja",
          message: "This Reservation has been approved",
          duration: Duration(seconds: 1),
        )..show(context);*/
        resDB.editReservationState(state: "Accepted", id: id);
        break;
      case DismissDirection.endToStart:
        resDB.editReservationState(state: "Declined", id: id);
        break;
    }
  }
}
