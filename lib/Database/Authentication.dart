import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Utilisateur.dart';
import 'package:foodz_owner/Screens/IntroScreen.dart';
import 'package:foodz_owner/Screens/WelcomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodz_owner/utils/CustomSnackbar.dart';

class Authentication {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Authentication();

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

  Future<DocumentSnapshot> getUserData() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot fireUser = await userCollection.doc(uid).get();
    return fireUser;
  }

  Stream<QuerySnapshot> retrieveUsers() {}

  Future<void> signOut({@required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();

    try {
      if (googleSignIn.currentUser != null) {
        //await googleSignIn.signOut();
        await googleSignIn.disconnect();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, WelcomeScreen.tag);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> SignInWithGoogle({@required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();

    final user = await googleSignIn.signIn();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(content: 'Problem: ', color: Colors.redAccent));
    } else {
      final googleAuth = await user.authentication;

      try {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential cred =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (cred.additionalUserInfo.isNewUser) {
          await storeUserData(
              id: cred.user.uid,
              name: cred.user.displayName,
              mail: cred.user.email);
        }
      } catch (e) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          title: "Error",
          message: e.toString(),
          duration: Duration(seconds: 3),
        )..show(context);
      }
      Navigator.pushNamed(context, IntroScreen.tag);
      Navigator.pop(context);
    }
  }

  Future<void> classicSignUp(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    final _auth = FirebaseAuth.instance;

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        await storeUserData(
            id: _auth.currentUser.uid, name: "", mail: _auth.currentUser.email);

        Navigator.pushNamed(context, IntroScreen.tag);
        Navigator.pop(context);
      }
    } catch (e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> classicSignIn(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    final _auth = FirebaseAuth.instance;

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.pushNamed(context, IntroScreen.tag);
        Navigator.pop(context);
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
      //     content: 'Error: ' + e.toString(), color: Colors.redAccent));
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
