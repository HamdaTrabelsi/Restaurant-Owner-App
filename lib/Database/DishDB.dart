import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Dish.dart';
import 'package:foodz_owner/Models/Restaurant.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';

class DishDB {
  final CollectionReference dishCollection =
      FirebaseFirestore.instance.collection('dishes');

  Dish dish;

  final _auth = FirebaseAuth.instance;

  DishDB();

  Future<void> addNewDish(
      {String restoID,
      String description,
      File image,
      String cuisine,
      String name,
      String price,
      String category}) async {
    DocumentReference documentReference = dishCollection.doc();

    String imgName = await storeDishImage(upImage: image);

    Dish dish = new Dish(
        uid: documentReference.id,
        restoID: restoID,
        description: description,
        image: imgName,
        cuisine: cuisine,
        name: name,
        price: price,
        category: category);

    var data = dish.toJson();

    await documentReference.set(data);
  }

  Future storeDishImage({@required File upImage}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref("Dish/${basename(upImage.path)}" + DateTime.now().toString());

      final res = await ref.putFile(upImage);

      return res.ref.getDownloadURL();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deleteDish({@required String id}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dishes").doc(id);
    await documentReference.delete().catchError((e) {
      throw (e);
    });
  }

  Future<void> editDish({
    @required String id,
    @required String name,
    @required String category,
    @required String cuisine,
    @required String description,
    @required String price,
    @required String image,
  }) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("dishes").doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "category": category,
      "cuisine": cuisine,
      "description": description,
      "price": price,
      "image": image,
    };

    await documentReference.update(data).catchError((e) {
      throw (e);
    });
  }
}
