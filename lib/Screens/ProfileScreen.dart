import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Database/UserDB.dart';
import 'package:foodz_owner/Provider/app_provider.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:foodz_owner/Database/Authentication.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final googleSignIn = GoogleSignIn();
final _auth = FirebaseAuth.instance;
Authentication authentication = Authentication();
UserDB _userDB = UserDB();

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  File _image;
  final _picker = ImagePicker();

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => imageBottomSheet()),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: Offset(0, 10))
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: _image == null
                                            ? snapshot.data["image"] == ""
                                                ? AssetImage(
                                                    "images/offline/empty.png")
                                                : NetworkImage(
                                                    snapshot.data["image"])
                                            : FileImage(File(_image.path)),
                                        // _image == null
                                        //     ? AssetImage("images/offline/empty.png")
                                        //     : FileImage(File(_image.path)),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2)),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: Colors.green,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    /*"Jane Doe"*/ snapshot.data["username"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FlatButton(
                                    child: Icon(Icons.save),
                                    onPressed: () async {
                                      if (_image != null) {
                                        String res =
                                            await _userDB.storeUserImage(
                                                upImage: _image,
                                                context: context,
                                                id: snapshot.data["uid"]);
                                        await _userDB.savePicUrl(
                                            id: snapshot.data["uid"],
                                            url: res,
                                            context: context);
                                      }
                                    },
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    minWidth: 20,
                                  ),

                                  // Text(
                                  //   snapshot.data["email"],
                                  //   style: TextStyle(
                                  //     fontSize: 14.0,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // InkWell(
                                  //   onTap: () async {
                                  //     await authentication.signOut(
                                  //         context: context);
                                  //     // Navigator.pushNamed(context, WelcomeScreen.tag);
                                  //   },
                                  //   child: Text(
                                  //     "Logout",
                                  //     style: TextStyle(
                                  //       fontSize: 13.0,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: Theme.of(context).accentColor,
                                  //     ),
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          flex: 3,
                        ),
                      ],
                    ),
                    Divider(),
                    Container(height: 15.0),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Account Information".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        //"jane@doefamily.com",
                        //loggedInUser.email,
                        snapshot.data["email"],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data["username"],
                        //loggedInUser.displayName,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Name",
                                fieldType: "text",
                                onPress: () {})),
                          );
                        },
                        tooltip: "Edit",
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Phone",
                                fieldType: "text",
                                onPress: () {})),
                          );
                        },
                        tooltip: "Edit",
                      ),
                      subtitle: Text(
                        snapshot.data["phone"] != ""
                            ? snapshot.data["phone"]
                            : "No phone Number yet",
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Address",
                                fieldType: "text",
                                onPress: () {})),
                          );
                        },
                        tooltip: "Edit",
                      ),
                      subtitle: Text(
                        snapshot.data["address"] != ""
                            ? snapshot.data["address"]
                            : "No address yet",
                      ),
                    ),
                    // ListTile(
                    //   title: Text(
                    //     "Gender",
                    //     style: TextStyle(
                    //       fontSize: 17,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    //   trailing: IconButton(
                    //     icon: Icon(
                    //       Icons.edit,
                    //       size: 20.0,
                    //     ),
                    //     onPressed: () {
                    //       showModalBottomSheet(
                    //         isScrollControlled: true,
                    //         context: context,
                    //         builder: ((builder) => textBottomSheet(
                    //             text: "Edit Gender",
                    //             fieldType: "text",
                    //             onPress: () {})),
                    //       );
                    //     },
                    //     tooltip: "Edit",
                    //   ),
                    //   subtitle: Text(
                    //     snapshot.data["gender"] != ""
                    //         ? snapshot.data["gender"]
                    //         : "Add Gender",
                    //   ),
                    // ),
                    ListTile(
                      title: Text(
                        "Date of Birth",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Birthday",
                                fieldType: "text",
                                onPress: () {})),
                          );
                        },
                        tooltip: "Edit",
                      ),
                      subtitle: Text(
                        snapshot.data["birthDate"] != null
                            ? DateFormat('dd MMMM yyyy')
                                .format(snapshot.data["birthDate"].toDate())
                                .toString()
                            : "No Birth Date",
                      ),
                    ),
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? SizedBox()
                        : ListTile(
                            title: Text(
                              "Dark Theme",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: Switch(
                              value: Provider.of<AppProvider>(context).theme ==
                                      Constants.lightTheme
                                  ? false
                                  : true,
                              onChanged: (v) async {
                                if (v) {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .setTheme(Constants.darkTheme, "dark");
                                } else {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .setTheme(Constants.lightTheme, "light");
                                }
                              },
                              activeColor: Theme.of(context).accentColor,
                            ),
                          ),
                    ListTile(
                      title: Text(
                        "Sign Out",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.red),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await authentication.signOut(context: context);
                        },
                        tooltip: "Logout",
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget imageBottomSheet() {
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

  Widget textBottomSheet(
      {@required String text,
      @required Function onPress,
      @required String fieldType}) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Container(
            padding: EdgeInsets.all(20),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: Icon(Icons.close),
                        onTap: () {
                          Navigator.pop(context);
                        }),
                    Icon(Icons.check),
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Full Name"),
                ),
              ],
            )));
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
