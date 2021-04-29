import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:image_picker/image_picker.dart';

class IntroScreen extends StatefulWidget {
  static String tag = '/IntroScreen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  File _image;
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          //height: 590,
          decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(0.0, 2.0),
                  blurRadius: 25.0,
                )
              ],
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32))),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.all(16),
                  //   child: FlatButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       'Sign In',
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  )
                  // Container(
                  //   margin: EdgeInsets.all(16),
                  //   child: FlatButton(
                  //     onPressed: () {},
                  //     child: Text(
                  //       'Welcome',
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         color: Colors.green,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  'Create your restaurant\'s profile',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  'Let\'s get started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              imageProfile(),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(start: 12),
                      child: Icon(
                        Icons.local_restaurant,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Restaurant Name',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(start: 12),
                      child: Icon(
                        Icons.short_text,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Write a small description',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  maxLines: null,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsetsDirectional.only(start: 12),
                      child: Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: 'Phone Number',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, MainScreen.tag);
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  )),
            ],
          ),
        ),
      ],
    ));
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4.2,
            width: MediaQuery.of(context).size.width / 1.2,
            margin: EdgeInsets.all(15),
            //radius: 80,
            /*backgroundImage: _image == null
                ? AssetImage("images/offline/empty.png")
                : FileImage(File(_image.path)),*/
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  image: _image == null
                      ? AssetImage("images/offline/empty.png")
                      : FileImage(File(_image.path)),
                )),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28,
              ),
            ),
          )
        ],
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
            "Choose a Profile Photo",
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
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedImage = await _picker.getImage(
      source: source,
    );
    setState(() {
      _image = File(pickedImage.path);
    });
  }
}
