import 'package:flutter/material.dart';
import 'package:foodz_owner/Widgets/SmoothStarRating.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodColors.dart';

class RestaurantScreen extends StatefulWidget {
  static String tag = '/RestaurantScreen';

  @override
  _RestaurantScreen createState() => _RestaurantScreen();
}

class _RestaurantScreen extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    //borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "images/offline/egg.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: -10.0,
                  top: 3.0,
                  child: RawMaterialButton(
                    onPressed: () {},
                    fillColor: Colors.red,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                /*Positioned(
                    right: -10.0,
                    bottom: 3.0,
                    child: RawMaterialButton(
                      onPressed: () {},
                      fillColor: Colors.white,
                      shape: CircleBorder(),
                      elevation: 4.0,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 17,
                        ),
                      ),
                    ),
                  ),*/
              ],
            ),
            //SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              transform: Matrix4.translationValues(0.0, -50.0, 0.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                elevation: 2,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "La Veranda",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                        child: Row(
                          children: <Widget>[
                            StarRating(
                              starCount: 5,
                              color: Constants.ratingBG,
                              allowHalfRating: true,
                              rating: 5.0,
                              size: 10.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "5.0 (23 Reviews)",
                              style: TextStyle(
                                fontSize: 11.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                      //   child: Row(
                      //     children: <Widget>[
                      //       Text(
                      //         "20 Pieces",
                      //         style: TextStyle(
                      //           fontSize: 11.0,
                      //           fontWeight: FontWeight.w300,
                      //         ),
                      //       ),
                      //       SizedBox(width: 10.0),
                      //       Text(
                      //         r"$90",
                      //         style: TextStyle(
                      //           fontSize: 14.0,
                      //           fontWeight: FontWeight.w900,
                      //           color: Theme.of(context).accentColor,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 20.0),
                      Text(
                        "Restaurant Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Nulla quis lorem ut libero malesuada feugiat. Lorem ipsum dolor "
                        "sit amet, consectetur adipiscing elit. Curabitur aliquet quam "
                        "id dui posuere blandit. Pellentesque in ipsum id orci porta "
                        "dapibus. Vestibulum ante ipsum primis in faucibus orci luctus "
                        "et ultrices posuere cubilia Curae; Donec velit neque, auctor "
                        "sit amet aliquam vel, ullamcorper sit amet ligula. Donec"
                        " rutrum congue leo eget malesuada. Vivamus magna justo,"
                        " lacinia eget consectetur sed, convallis at tellus."
                        " Vivamus suscipit tortor eget felis porttitor volutpat."
                        " Donec rutrum congue leo eget malesuada."
                        " Pellentesque in ipsum id orci porta dapibus.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ExpansionTile(
                        leading: Icon(
                          Icons.location_pin,
                          color: /*Colors.green*/ k_appColor,
                        ),
                        title: Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w800),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Raoued, Ariana",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.create,
                                size: 18.0,
                                color: /*Colors.green*/ k_appColor,
                              ),
                              onTap: () {},
                            ),
                          )
                        ],
                      ),
                      ExpansionTile(
                        leading: Icon(
                          Icons.phone,
                          color: /*Colors.green*/ k_appColor,
                        ),
                        title: Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w800),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "55 211 183",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.create,
                                size: 18.0,
                                color: /*Colors.green*/ k_appColor,
                              ),
                              onTap: () {},
                            ),
                          )
                        ],
                      ),
                      ExpansionTile(
                        leading: Icon(
                          Icons.local_restaurant,
                          color: /*Colors.green*/ k_appColor,
                        ),
                        title: Text(
                          "Cuisine",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w800),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "Italian",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.delete,
                                size: 18.0,
                              ),
                              onTap: () {},
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Tunisian",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.delete,
                                size: 18.0,
                              ),
                              onTap: () {},
                            ),
                          ),
                          ListTile(
                            title: Text(
                              "Add another type",
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            trailing: InkWell(
                              child: Icon(
                                Icons.add,
                                size: 18.0,
                              ),
                              onTap: () {},
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /*ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments == null ? 0 : comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map comment = comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: AssetImage(
                            "${comment['img']}",
                          ),
                        ),
                        title: Text("${comment['name']}"),
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
                                  "February 14, 2020",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7.0),
                            Text(
                              "${comment["comment"]}",
                            ),
                          ],
                        ),
                      );
                    },
                  ),*/
                    ],
                  ),
                ),
              ),
            )
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
