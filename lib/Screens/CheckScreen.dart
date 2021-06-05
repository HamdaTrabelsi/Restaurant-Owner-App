import 'package:clippy_flutter/arc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodz_owner/Screens/IntroScreen.dart';
import 'package:foodz_owner/Screens/LoginScreen.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:foodz_owner/Screens/WelcomeScreen.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodz_owner/Database/Authentication.dart';

class CheckScreen extends StatefulWidget {
  static String tag = '/WelcomeScreen';

  @override
  CheckScreenState createState() => CheckScreenState();
}

class CheckScreenState extends State<CheckScreen> {
  bool isLoggedIn;
  final googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  User _user;
  Authentication authentication = Authentication();

  @override
  void initState() {
    _auth.currentUser.email.isNotEmpty ? isLoggedIn = true : isLoggedIn = false;
    super.initState();
  }

  //final fbLogin = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    return isLoggedIn == true ? MainScreen() : WelcomeScreen();
  }
}
