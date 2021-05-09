import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Utilisateur.dart';
import 'package:foodz_owner/Screens/IntroScreen.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:foodz_owner/Screens/WelcomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodz_owner/utils/CustomSnackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UserDB {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  User myUser;

  final _auth = FirebaseAuth.instance;

  UserDB();

  storeUserData({
    @required String id,
    @required String name,
    @required String mail,
  }) async {
    DocumentReference documentReference = userCollection.doc(id);

    Utilisateur user = Utilisateur(
        uid: id,
        username: name,
        email: mail,
        image: "",
        created: DateTime.now(),
        birthDate: null,
        phone: "",
        gender: "",
        address: "");

    var data = user.toJson();

    await documentReference.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));
  }

  Future storeUserImage(
      {@required File upImage,
      @required BuildContext context,
      @required String id}) async {
    // DocumentReference documentReference =
    //     FirebaseFirestore.instance.collection("users").doc(id);

    final ref = FirebaseStorage.instance
        .ref("profile/${basename(upImage.path)}" + DateTime.now().toString());

    //FirebaseStorage storage = FirebaseStorage.instance;

    // Reference ref = storage.ref().child(
    //     "/profile/${basename(upImage.path)}" + DateTime.now().toString());

    //UploadTask uploadTask = ref.putFile(upImage);

    final res = await ref.putFile(upImage);
    //.then((res) {
    return res.ref.getDownloadURL();
    // documentReference
    //     .update({"image": res.ref.getDownloadURL()}).whenComplete(() {
    //   Flushbar(
    //     flushbarPosition: FlushbarPosition.TOP,
    //     title: "Success",
    //     message: "It's done !",
    //     duration: Duration(seconds: 3),
    //   )..show(context);
    // });

    // }).catchError((error) {
    //   Flushbar(
    //     flushbarPosition: FlushbarPosition.TOP,
    //     title: "Error",
    //     message: error.toString(),
    //     duration: Duration(seconds: 3),
    //   )..show(context);
    // });
  }

  Future<void> savePicUrl(
      {@required String id,
      @required String url,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(id);

    documentReference.update({"image": url}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "It's done !",
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot fireUser = await userCollection.doc(uid).get();
    return fireUser;
  }

  // Stream<QuerySnapshot> retrieveUsers() {}
}
