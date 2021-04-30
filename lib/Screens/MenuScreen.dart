import 'package:flutter/material.dart';
import 'package:foodz_owner/Widgets/Rounded_Category_Title.dart';
import 'package:foodz_owner/Widgets/Grid_Product.dart';
import 'package:foodz_owner/utils/consts/colors.dart';
import 'package:foodz_owner/Screens/AddPlateScreen.dart';

class MenuScreen extends StatefulWidget {
  static String tag = '/MenuScreen';

  @override
  _MenuScreen createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  List<Map> foods = [
    {"img": "images/offline/food1.jpeg", "name": "Fruit Salad"},
    {"img": "images/offline/food2.jpeg", "name": "Fruit Salad"},
    {"img": "images/offline/food3.jpeg", "name": "Hamburger"},
    {"img": "images/offline/food4.jpeg", "name": "Fruit Salad"},
    {"img": "images/offline/food5.jpeg", "name": "Hamburger"},
    {"img": "images/offline/food6.jpeg", "name": "Steak"},
    {"img": "images/offline/food7.jpeg", "name": "Pizza"},
    {"img": "images/offline/food8.jpeg", "name": "Asparagus"},
    {"img": "images/offline/food9.jpeg", "name": "Salad"},
    {"img": "images/offline/food10.jpeg", "name": "Pizza"},
    {"img": "images/offline/food11.jpeg", "name": "Pizza"},
    {"img": "images/offline/food12.jpg", "name": "Salad"},
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                "Menu",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 20.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    CategoryTitle(title: "All", active: true),
                    CategoryTitle(title: "Dessert"),
                    CategoryTitle(title: "Main Course"),
                    CategoryTitle(title: "Fast Food"),
                    CategoryTitle(title: "Appetizer"),
                    CategoryTitle(title: "Drinks"),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GridView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.25),
                ),
                itemCount: foods == null ? 0 : foods.length,
                itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                  Map res = foods[index];
//                print(foods);
//                print(foods.length);
                  return GridProduct(
                    img: res['img'],
                    isFav: true,
                    name: res['name'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),

        // Floating button
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "AddFBtn",
          icon: Icon(Icons.add),
          label: Text("Add"),
          onPressed: () {
            Navigator.pushNamed(context, AddPlateScreen.tag);
          },
        )
        // Container(
        //   height: 80,
        //   width: 80,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: //kPrimaryColor.withOpacity(.26),
        //         Colors.green.withOpacity(.26),
        //   ),
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: <Widget>[
        //       Container(
        //         padding: EdgeInsets.all(15),
        //         height: 60,
        //         width: 60,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: //kPrimaryColor,
        //               Colors.green,
        //         ),
        //         child: Icon(
        //           Icons.add,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );

    //Container(
    //   child: Padding(
    //     padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
    //     child: ListView(
    //       children: <Widget>[
    //         SizedBox(height: 10.0),
    //         Text(
    //           "Menu",
    //           style: TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.w800,
    //           ),
    //           maxLines: 2,
    //         ),
    //         SizedBox(height: 20.0),
    //         SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             children: <Widget>[
    //               CategoryTitle(title: "All", active: true),
    //               CategoryTitle(title: "Italian"),
    //               CategoryTitle(title: "Asian"),
    //               CategoryTitle(title: "Chinese"),
    //               CategoryTitle(title: "Burgers"),
    //             ],
    //           ),
    //         ),
    //         SizedBox(height: 10.0),
    //         // Container(
    //         //     child: GridView.count(
    //         //   shrinkWrap: true,
    //         //   physics: ClampingScrollPhysics(),
    //         //   crossAxisCount: 2,
    //         //   childAspectRatio: ((size.width / 2) / 230),
    //         //   children: this.favoriteFoods.map((product) {
    //         //     return Container(
    //         //       margin: const EdgeInsets.only(top: 10.0),
    //         //       child: FoodCard(
    //         //         img: product['image'],
    //         //         isFav: false,
    //         //         name: product['name'],
    //         //         rating: 5.0,
    //         //         raters: 23,
    //         //       ),
    //         //     );
    //         //   }).toList(),
    //         // ))
    //       ],
    //     ),
    //   ),
    //   /*bottomNavigationBar: Container(
    //     height: 50.0,
    //     child: RaisedButton(
    //       child: Text(
    //         "ADD TO CART",
    //         style: TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       color: Theme.of(context).accentColor,
    //       onPressed: () {},
    //     ),
    //   ),*/
    // );
  }
}
