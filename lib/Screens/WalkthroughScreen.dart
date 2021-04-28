import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodz_owner/Screens/WelcomeScreen.dart';
//import 'package:foodz_owner/utils/consts/AppConstant.dart';
import 'package:foodz_owner/utils/consts/T3Images.dart';
import 'package:foodz_owner/utils/consts/T3Constant.dart';
import 'package:foodz_owner/utils/consts/colors.dart';
import 'package:foodz_owner/utils/dots_indicator/dots_indicator.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodColors.dart';

class WalkthroughScreen extends StatefulWidget {
  static String tag = '/WalkthroughScreen';
  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {
  int currentIndexPage = 0;
  int pageLength;
  var titles = [
    "Discover",
    "Get Bigger",
    "Manage More",
  ];
  var subTitles = [
    "Welcome to Foodz Owner, here we offer you a lot of features",
    "We help you get more cutomers while simplifying the process of reaching a bigger audience",
    "Here you can manage your restaurant from the smallest details all the way to the Menu and the reservations",
  ];

  @override
  void initState() {
    super.initState();
    currentIndexPage = 0;
    pageLength = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PageView(
              children: <Widget>[
                WalkThrough(
                  textContent: t3_ic_walk1,
                ),
                WalkThrough(
                  textContent: t3_ic_walk2,
                ),
                WalkThrough(
                  textContent: t3_ic_walk3,
                ),
              ],
              onPageChanged: (value) {
                setState(() => currentIndexPage = value);
              },
            ),
          ),
          Container(
            child: Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height * 0.43,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: new DotsIndicator(
                        dotsCount: 3,
                        position: currentIndexPage,
                        decorator: DotsDecorator(
                          color: t3_view_color,
                          activeColor: /*t3_colorPrimary*/ k_appColor,
                        )),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(titles[currentIndexPage],
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: fontMedium,
                                color: k_appColor)),
                        SizedBox(height: 16),
                        Center(
                            child: Text(
                          subTitles[currentIndexPage],
                          style: TextStyle(
                              fontFamily: fontRegular,
                              fontSize: 18,
                              color: t3_textColorSecondary),
                          textAlign: TextAlign.center,
                        )),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 100,
                      child: RaisedButton(
                        textColor: t3_white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(80.0),
                                topLeft: Radius.circular(80.0))),
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: <Color>[
                              // t3_red,
                              k_appColor,
                              //kPrimaryColor,
                              food_colorAccent
                            ]),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(80.0),
                                topLeft: Radius.circular(80.0)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Skip",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, WelcomeScreen.tag);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalkThrough extends StatelessWidget {
  final String textContent;

  WalkThrough({Key key, @required this.textContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
        child:
            /*CachedNetworkImage(
        imageUrl: textContent,
        width: 280,
        height: (MediaQuery.of(context).size.height) / 2.3,
      ),*/
            Image.asset(
          textContent,
          width: 280,
          height: (MediaQuery.of(context).size.height) / 2.3,
        ));
  }
}
