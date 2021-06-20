import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Restaurant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';

class RestaurantDB {
  final CollectionReference restoCollection =
      FirebaseFirestore.instance.collection('restaurant');

  User myUser;

  final _auth = FirebaseAuth.instance;

  RestaurantDB();

  Future<void> addNewRestaurant(
      {BuildContext context,
      File image,
      String title,
      String type,
      List<String> cuisines,
      String description,
      String phone,
      String website = ""}) async {
    //DocumentReference documentReference = userCollection.doc(id);
    myUser = _auth.currentUser;
    DocumentReference documentReferencer = restoCollection.doc(myUser.uid);

    //GeoPoint g1 = GeoPoint(lat, long);

    String imgName = await storeRestImage(upImage: image, context: context);

    //List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    //print(placemarks);

    /*String adresse = placemarks[0].country +
        " " +
        placemarks[0].locality +
        " " +
        placemarks[0].subLocality +
        " " +
        placemarks[0].street;*/

    Restaurant resto = new Restaurant(
      uid: myUser.uid,
      title: title,
      phone: phone,
      description: description,
      image: imgName,
      type: type,
      cuisine: cuisines,
      website: website,
      //address: adresse,
    );
    var data = resto.toJson();
    //
    await documentReferencer
        .set(data)
        .whenComplete(() => print("resto added"))
        .catchError((e) => print(e));
  }

  Future storeRestImage(
      {@required File upImage, @required BuildContext context}) async {
    final ref = FirebaseStorage.instance.ref(
        "restaurant/${basename(upImage.path)}" + DateTime.now().toString());

    final res = await ref.putFile(upImage);

    return res.ref.getDownloadURL();
  }

  Future<bool> hasRestaurant({@required String id}) async {
    // bool hasresto = false;
    // try {
    //   await restoCollection.doc(id).get().then((value) {
    //     if (value.exists) {
    //       hasresto = true;
    //     } else {
    //       hasresto = false;
    //     }
    //   });
    //   return hasresto;
    // } catch (e) {
    //   return false;
    // }
    try {
      var doc = await restoCollection.doc(id).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Stream<DocumentSnapshot> getRestaurant({@required String id}) {
    try {
      return restoCollection.doc(id).snapshots();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updatePicUrl(
      {@required String url, @required BuildContext context}) async {
    myUser = _auth.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("restaurant").doc(myUser.uid);

    documentReference.update({"image": url}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "It's done !",
        backgroundColor: Theme.of(context).accentColor,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      throw (e);
    });
  }

  Future<void> editTextField(
      {@required String id,
      @required String field,
      @required String newValue,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("restaurant").doc(id);

    documentReference.update({field: newValue}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "Saved !",
        backgroundColor: Theme.of(context).accentColor,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      throw (e);
    });
  }

  Future<void> editAddressField(
      {@required String id,
      @required double newLat,
      @required double newLong,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("restaurant").doc(id);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(newLat, newLong);

    print(placemarks);

    String adresse = placemarks[0].country +
        " " +
        placemarks[0].locality +
        " " +
        placemarks[0].subLocality +
        " " +
        placemarks[0].street;

    GeoPoint g1 = new GeoPoint(newLat, newLong);
    documentReference
        .update({"location": g1, "address": adresse}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "Saved !",
        backgroundColor: Theme.of(context).accentColor,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      throw (e);
    });
  }

  Future<void> editCuisineField(
      {@required String id,
      @required List<dynamic> newValue,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("restaurant").doc(id);

    documentReference.update({"cuisine": newValue}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "Saved !",
        backgroundColor: Theme.of(context).accentColor,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      throw (e);
    });
  }
}
