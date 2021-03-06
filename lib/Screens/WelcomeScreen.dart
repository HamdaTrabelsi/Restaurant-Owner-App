import 'package:clippy_flutter/arc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodz_owner/Screens/IntroScreen.dart';
import 'package:foodz_owner/Screens/LoginScreen.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:foodz_owner/Screens/RegisterScreen.dart';
import 'package:foodz_owner/utils/consts/colors.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodColors.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodConstant.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodExtension.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodImages.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodString.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodz_owner/Database/Authentication.dart';

class WelcomeScreen extends StatefulWidget {
  static String tag = '/WelcomeScreen';

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoggedIn;
  final googleSignIn = GoogleSignIn();
  //FacebookLogin _facebookLogin = FacebookLogin();
  final _auth = FirebaseAuth.instance;
  User _user;
  Authentication authentication = Authentication();

  @override
  void initState() {
    //_user.email != null ? isLoggedIn = true : isLoggedIn = false;
    super.initState();
  }

  //final fbLogin = FacebookLogin();

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.transparent);

    var width = MediaQuery.of(context).size.width;
    Widget mOption(var color, var icon, var value, var iconColor, valueColor,
        {Function fn}) {
      return InkWell(
        onTap: fn,
        child: Container(
          width: width,
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.only(bottom: spacing_standard_new),
          decoration: boxDecoration(bgColor: color, radius: 50),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                WidgetSpan(
                    child: Padding(
                        padding: const EdgeInsets.only(right: spacing_standard),
                        child: SvgPicture.asset(icon,
                            color: iconColor, width: 18, height: 18))),
                TextSpan(
                    text: value,
                    style:
                        TextStyle(fontSize: textSizeMedium, color: valueColor)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(food_ic_resto,
              height: width * 0.6, fit: BoxFit.cover, width: width),
          Container(
            margin: EdgeInsets.only(top: width * 0.5),
            child: Stack(
              children: <Widget>[
                Arc(
                  arcType: ArcType.CONVEX,
                  edge: Edge.TOP,
                  height: (MediaQuery.of(context).size.width) / 10,
                  child: new Container(
                      height: (MediaQuery.of(context).size.height),
                      width: MediaQuery.of(context).size.width,
                      color: k_appColor /*kPrimaryColor*/),
                ),
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: Container(
                //     transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle, color: food_white),
                //     width: width * 0.13,
                //     height: width * 0.13,
                //     //child:
                //
                //     //Icon(Icons.arrow_forward, color: food_textColorPrimary),
                //     /*IconButton(
                //             icon: Icon(Icons.arrow_forward),
                //             /*onPressed: () {
                //               //Navigator.pushNamed(context, MainScreen.tag);
                //             },*/
                //             color: food_textColorPrimary),*/
                //   ),
                // ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(spacing_standard_new),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: width * 0.1),
                      text(food_app_name,
                          textColor: food_white,
                          fontFamily: fontBold,
                          fontSize: 30.0),
                      SizedBox(height: width * 0.12),
                      mOption(
                        food_white,
                        food_ic_google_fill,
                        food_lbl_google,
                        food_color_red,
                        food_textColorPrimary,
                        fn: () async {
                          authentication.SignInWithGoogle(context: context);
                          // final user = await googleSignIn.signIn();
                          // if (user == null) {
                          //   return;
                          // } else {
                          //   final googleAuth = await user.authentication;
                          //
                          //   final credential = GoogleAuthProvider.credential(
                          //     accessToken: googleAuth.accessToken,
                          //     idToken: googleAuth.idToken,
                          //   );
                          //
                          //   UserCredential cred = await FirebaseAuth.instance
                          //       .signInWithCredential(credential);
                          //
                          //   if (cred.additionalUserInfo.isNewUser) {
                          //     await authentication.storeUserData(
                          //         id: cred.user.uid,
                          //         name: cred.user.displayName,
                          //         mail: cred.user.email);
                          //   }
                          //   Navigator.pushNamed(context, IntroScreen.tag);
                          // }
                        },
                      ),
                      /*mOption(food_colorPrimary, food_ic_fb, food_lbl_facebook,
                          food_white, food_white, fn: () async {
// Trigger the sign-in flow
                        final AccessToken result =
                            await FacebookAuth.instance.login();

                        // Create a credential from the access token
                        final FacebookAuthCredential facebookAuthCredential =
                            FacebookAuthProvider.credential(result.token);

                        // Once signed in, return the UserCredential
                        await FirebaseAuth.instance
                            .signInWithCredential(facebookAuthCredential);

                        Navigator.pushNamed(context, MainScreen.tag);
                      }),*/
                      SizedBox(height: width * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              height: 0.5,
                              color: food_white,
                              width: width * 0.07,
                              margin: EdgeInsets.only(right: spacing_standard)),
                          text(food_lbl_or_use_your_mobile_email,
                              textColor: food_white,
                              textAllCaps: true,
                              fontSize: textSizeSMedium),
                          Container(
                              height: 0.5,
                              color: food_white,
                              width: width * 0.07,
                              margin: EdgeInsets.only(left: spacing_standard)),
                        ],
                      ),
                      SizedBox(height: width * 0.07),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, LoginScreen.tag);
                        },
                        child: Container(
                          decoration: boxDecoration(
                              bgColor: k_appColor, //t3_colorPrimary
                              radius: 50,
                              color: food_white),
                          width: width,
                          padding: EdgeInsets.all(spacing_middle),
                          child: text("Continue with Email/Password",
                              textColor: food_white, isCentered: true),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
/*
  Future _handleFBLogin() async {
    FacebookLoginResult _result = await _facebookLogin.logIn(['mail']);
    switch (_result.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled By User");
        break;
      case FacebookLoginStatus.error:
        print("OH NO THIS IS AN ERROR");
        break;
      case FacebookLoginStatus.loggedIn:
        await _loginWithFacebook(_result);
        break;
    }
  }

  Future _loginWithFacebook(FacebookLoginResult _result) async {
    FacebookAccessToken _accessToken = _result.accessToken;
    AuthCredential _credential =
        FacebookAuthProvider.credential(_accessToken.token);
    var a = await _auth.signInWithCredential(_credential);
    setState(() {
      //_isLogin = true;
      _user = a.user;
    });
    Navigator.pushNamed(context, HomeScreen.tag);
  }*/
}
