import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Dish.dart';
import 'package:foodz_owner/Models/Reservation.dart';
import 'package:foodz_owner/Models/Restaurant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';

class ReservationDB {
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservation');

  Reservation reservation;

  final _auth = FirebaseAuth.instance;

  ReservationDB();

  Future<void> editReservationState(
      {@required String id, @required String state}) async {
    DocumentReference documentReference = reservationCollection.doc(id);

    await documentReference.update({"state": state}).catchError((e) {
      throw (e);
    });
  }
}
