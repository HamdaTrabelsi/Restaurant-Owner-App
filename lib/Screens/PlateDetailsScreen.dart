import 'package:flutter/material.dart';
import 'package:foodz_owner/Screens/EditPlateScreen.dart';
import 'package:foodz_owner/utils/consts/colors.dart';

class FoodDetailsScreen extends StatefulWidget {
  static String tag = '/FoodDetailsScreen';

  @override
  _FoodDetailsScreen createState() => _FoodDetailsScreen();
}

class _FoodDetailsScreen extends State<FoodDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)
                    /*SvgPicture.asset(
                    "assets/icons/backward.svg",
                    height: 11,
                  ),*/
                    ),
                //Icon(Icons.menu),
                /*SvgPicture.asset(
                  "assets/icons/menu.svg",
                  height: 11,
                ),*/
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              padding: EdgeInsets.all(6),
              height: 305,
              width: 305,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[200],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("images/offline/food1.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Vegan salad bowl\n",
                        style: Theme.of(context).textTheme.title,
                      ),
                      TextSpan(
                        text: "With red tomato",
                        style: TextStyle(
                          color: kTextColor.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\20 Dt",
                  style: Theme.of(context)
                      .textTheme
                      .headline
                      .copyWith(color: kPrimaryColor),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.",
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    borderRadius: BorderRadius.circular(27),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(.19),
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Edit",
                            style: Theme.of(context).textTheme.button,
                          ),
                          SizedBox(width: 15),
                          // SvgPicture.asset(
                          //   "assets/icons/forward.svg",
                          //   height: 11,
                          // ),
                          Icon(Icons.edit_outlined)
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 80,
                  //   width: 80,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: kPrimaryColor.withOpacity(.26),
                  //   ),
                  // child: Stack(
                  //   alignment: Alignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       padding: EdgeInsets.all(15),
                  //       height: 60,
                  //       width: 60,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: kPrimaryColor,
                  //       ),
                  //       //child: SvgPicture.asset("assets/icons/bag.svg"),
                  //     ),
                  // Positioned(
                  //   right: 15,
                  //   bottom: 10,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     height: 28,
                  //     width: 28,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: kWhiteColor,
                  //     ),
                  //     child: Text(
                  //       "0",
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .button
                  //           .copyWith(color: kPrimaryColor, fontSize: 16),
                  //     ),
                  //   ),
                  // )
                  //],
                  //),
                  //),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose an Action",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                onPressed: () {
                  //takePhoto(ImageSource.camera);
                  Navigator.pushNamed(context, EditPlateScreen.tag);
                },
                icon: Icon(Icons.edit),
                label: Text("Edit"),
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.delete_rounded),
                label: Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
