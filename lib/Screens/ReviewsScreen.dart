import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Review.dart';
import 'package:foodz_owner/Models/Utilisateur.dart';
import 'package:foodz_owner/Widgets/SmoothStarRating.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:foodz_owner/Widgets/TapOpacity.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:foodz_owner/utils/consts/common.dart';

User _loggedInUser;
final _auth = FirebaseAuth.instance;
List<Review> _reviews = [];

class ReviewsScreen extends StatefulWidget {
  static String tag = '/ReviewsScreen';

  @override
  _ReviewsScreen createState() => _ReviewsScreen();
}

class _ReviewsScreen extends State<ReviewsScreen> {
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
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            //SizedBox(height: 10.0),
            Container(
              height: 88,
              //color: Cols.white,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 31,
                    bottom: 31,
                    left: 40,
                    child: Text(
                      "Reviews",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  // Positioned(
                  //   top: 18,
                  //   bottom: 18,
                  //   right: 24,
                  //   // child: FloatingActionButton(
                  //   //   tooltip: "Add a review",
                  //   //   child: Icon(
                  //   //     Icons.rate_review,
                  //   //   ),
                  //   // )
                  //   child: TapOpacity(
                  //       onTap: () {
                  //         openAlertBox();
                  //       },
                  //       child: Container(
                  //         width: 135,
                  //         height: 52,
                  //         decoration: BoxDecoration(
                  //             color: Colors.red[400],
                  //             borderRadius: BorderRadius.circular(8),
                  //             boxShadow: <BoxShadow>[
                  //               BoxShadow(
                  //                   color: Cols.blue.withOpacity(0.2),
                  //                   blurRadius: 24,
                  //                   offset: Offset(0, 8))
                  //             ]).copyWith(),
                  //         child: Center(
                  //             child: Text("Add",
                  //                 style: TextStyles.airbnbCerealMedium.copyWith(
                  //                     fontSize: 16, color: Cols.white))),
                  //       )),
                  // )
                ],
              ),
            ),
            SizedBox(height: 10.0),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('review')
                    .where("restoId", isEqualTo: _loggedInUser.uid)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(child: CircularProgressIndicator()));
                  }
                  if (snapshot.data.docs.isNotEmpty) {
                    _reviews.clear();
                    snapshot.data.docs.forEach((element) {
                      _reviews.add(Review.fromJson(element));
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _reviews == null ? 0 : _reviews.length,
                      itemBuilder: (BuildContext context, int index) {
                        Review rev = _reviews[index];
                        return ReviewCard(rev: rev);
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
                                Text("No reviews !",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Constants.lightAccent,
                                        fontWeight: FontWeight.bold)),
                                Container(height: 10),
                                Text("You don't have any reviews yet !",
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

            SizedBox(height: 10.0),
            // Container(
            //   height: 88,
            //   //color: Cols.white,
            //   child: Stack(
            //     children: <Widget>[
            //       // Positioned(
            //       //   top: 31,
            //       //   bottom: 31,
            //       //   left: 40,
            //       //   child: RichText(
            //       //       text: TextSpan(children: <TextSpan>[
            //       //     TextSpan(
            //       //         text: '\$',
            //       //         style: TextStyles.airbnbCerealMedium.copyWith(
            //       //             fontSize: 12,
            //       //             color: Cols.black.withOpacity(0.75))),
            //       //     TextSpan(
            //       //         //text: price.toStringAsFixed(2),
            //       //         style: TextStyles.airbnbCerealMedium
            //       //             .copyWith(fontSize: 20, color: Cols.black))
            //       //   ])),
            //       // ),
            //       Positioned(
            //         top: 18,
            //         bottom: 18,
            //         right: 24,
            //         // child: FloatingActionButton(
            //         //   tooltip: "Add a review",
            //         //   child: Icon(
            //         //     Icons.rate_review,
            //         //   ),
            //         // )
            //         child: TapOpacity(
            //             onTap: () {},
            //             child: Container(
            //               width: 135,
            //               height: 52,
            //               decoration: BoxDecoration(
            //                   color: Colors.red[400],
            //                   borderRadius: BorderRadius.circular(8),
            //                   boxShadow: <BoxShadow>[
            //                     BoxShadow(
            //                         color: Cols.blue.withOpacity(0.2),
            //                         blurRadius: 24,
            //                         offset: Offset(0, 8))
            //                   ]).copyWith(),
            //               child: Center(
            //                   child: Text("Review",
            //                       style: TextStyles.airbnbCerealMedium.copyWith(
            //                           fontSize: 16, color: Cols.white))),
            //             )),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),

      /*bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: Text(
            "ADD TO CART",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () {},
        ),
      ),*/
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    Key key,
    @required this.rev,
  }) : super(key: key);

  final Review rev;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(rev.userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          } else {
            Utilisateur _user = Utilisateur.fromJson(snapshot.data.data());
            return ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  _user.image,
                ),
              ),
              title: Text(_user.username),
              subtitle: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      StarRating(
                        starCount: 5,
                        color: Constants.ratingBG,
                        allowHalfRating: true,
                        rating: 5.0,
                        size: 12.0,
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        DateFormat.yMMMd().add_jm().format(rev.posted.toDate()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    rev.description,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          }
        });
  }
}
