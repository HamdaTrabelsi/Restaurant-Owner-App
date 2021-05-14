import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Database/RestaurantDB.dart';
import 'package:foodz_owner/Models/Restaurant.dart';
import 'package:foodz_owner/Screens/ProfileScreen.dart';
import 'package:foodz_owner/Widgets/SmoothStarRating.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:foodz_owner/utils/welcomeScreen/FoodColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

RestaurantDB restDB = RestaurantDB();
User loggedInUser;
final _auth = FirebaseAuth.instance;
List<String> _selectedCuisines = [];
List _cuisines = [
  "Tunisian",
  "Italian",
  "Chinese",
  "Japanese",
  "Egyptian",
  "Fast Food",
  "Indian"
];

class RestaurantScreen extends StatefulWidget {
  static String tag = '/RestaurantScreen';
  @override
  _RestaurantScreen createState() => _RestaurantScreen();
}

class _RestaurantScreen extends State<RestaurantScreen> {
  final _picker = ImagePicker();
  File _newimg;
  bool hasRest;
  bool _isLoading = false;
  bool _isDisabled = false;

  var titleCont = TextEditingController();
  var descCont = TextEditingController();
  var longCont = TextEditingController();
  var latCont = TextEditingController();
  var phoneCont = TextEditingController();
  var websiteCont = TextEditingController();

  final _multiSelectKey = GlobalKey<FormFieldState>();

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
    Map<String, dynamic> userDocumentt;

    return StreamBuilder(
        stream: /*restDB.getRestaurant(id: loggedInUser.uid)*/ FirebaseFirestore
            .instance
            .collection('restaurant')
            .doc(loggedInUser.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
          if (snapshot.data.exists) {
            //print(snapshot.data.data());
            //userDocumentt = Map.from(snapshot.data);
            Map<String, dynamic> data = snapshot.data.data();
            Restaurant myRes = Restaurant();
            myRes = Restaurant.fromJson(data);
            print(myRes.cuisine);
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
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: _newimg == null
                                    ? myRes.image == ""
                                        ? AssetImage("images/offline/empty.png")
                                        : NetworkImage(snapshot.data["image"])
                                    : FileImage(File(_newimg.path)),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10.0,
                          top: 3.0,
                          child: RawMaterialButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => imageBottomSheet()),
                              );
                            },
                            fillColor: Colors.green,
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        _newimg != null
                            ? Positioned(
                                right: -10.0,
                                bottom: 50,
                                child: RawMaterialButton(
                                  onPressed: _isDisabled == true
                                      ? null
                                      : () async {
                                          if (_newimg != null) {
                                            setState(() {
                                              _isDisabled = true;
                                              _isLoading = true;
                                            });

                                            String res =
                                                await restDB.storeRestImage(
                                              upImage: _newimg,
                                              context: context,
                                            );
                                            await restDB.updatePicUrl(
                                                url: res, context: context);

                                            setState(() {
                                              _isLoading = false;
                                              _isDisabled = false;
                                            });
                                          }
                                        },
                                  fillColor: Colors.green,
                                  shape: CircleBorder(),
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: _isLoading == true
                                        ? Container(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          )
                                        : Icon(
                                            Icons.save,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 1,
                              ),
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
                              Row(
                                children: [
                                  Text(
                                    myRes.title,
                                    //"La Veranda",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    child:
                                        Icon(Icons.create, color: Colors.green),
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ((builder) => textBottomSheet(
                                            text: "Edit Title",
                                            kbtype: TextInputType.name,
                                            //newValue: newName,
                                            field: "title",
                                            contex: builder,
                                            cont: titleCont,
                                            uid: myRes.uid)),
                                      );
                                    },
                                  )
                                ],
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
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Restaurant Description",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 2,
                                  ),
                                  InkWell(
                                    child:
                                        Icon(Icons.create, color: Colors.green),
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ((builder) => textBottomSheet(
                                            text: "Edit Description",
                                            kbtype: TextInputType.name,
                                            //newValue: newName,
                                            minL: 4,
                                            maxL: 5,
                                            field: "description",
                                            contex: builder,
                                            cont: descCont,
                                            uid: myRes.uid)),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                myRes.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.4),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    MultiSelectBottomSheetField(
                                      initialValue: myRes.cuisine,
                                      key: _multiSelectKey,
                                      initialChildSize: 0.4,
                                      listType: MultiSelectListType.CHIP,
                                      buttonText: Text("Select"),
                                      selectedColor: Colors.green,
                                      selectedItemsTextStyle:
                                          TextStyle(color: Colors.white),
                                      title: Text("Cuisines"),
                                      items: _cuisines
                                          .map((e) => MultiSelectItem(e, e))
                                          .toList(),
                                      onConfirm: (values) async {
                                        _multiSelectKey.currentState.validate();
                                        await restDB.editCuisineField(
                                            id: loggedInUser.uid,
                                            newValue: values,
                                            context: context);
                                      },
                                      validator: (values) {
                                        if (values == null) {
                                          return "Please choose at least one type of cuisine";
                                        } else if (values.length == 0) {
                                          return "Please choose at least one type of cuisine";
                                        }
                                        return null;
                                      },
                                      chipDisplay: MultiSelectChipDisplay(
                                        onTap: (value) {
                                          setState(() {
                                            _selectedCuisines.remove(value);
                                          });
                                          _multiSelectKey.currentState
                                              .validate();
                                        },
                                      ),
                                    ),
                                    _selectedCuisines == null ||
                                            _selectedCuisines.isEmpty
                                        ? Container(
                                            padding: EdgeInsets.all(10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "You should select at least one cuisine",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ))
                                        : Container(),
                                  ],
                                ),
                              ),
                              // MultiSelectDialogField(
                              //   decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.grey),
                              //   ),
                              //   validator: (values) {
                              //     if (values == null) {
                              //       return "Please choose at least one type of cuisine";
                              //     } else if (values.length == 0) {
                              //       return "Please choose at least one type of cuisine";
                              //     }
                              //     return null;
                              //   },
                              //   initialValue: myRes.cuisine,
                              //   items: _cuisines
                              //       .map((e) => MultiSelectItem(e, e))
                              //       .toList(),
                              //   listType: MultiSelectListType.CHIP,
                              //   onConfirm: (values) {
                              //     setState(() {
                              //       _selectedCuisines = values.cast<String>();
                              //       print(" cuisines list : " +
                              //           _selectedCuisines.toString());
                              //     });
                              //   },
                              //   //checkColor: Colors.green,
                              //   buttonText: Text("Edit cuisines"),
                              //   buttonIcon: Icon(
                              //     Icons.restaurant_menu,
                              //     color: Colors.green,
                              //   ),
                              //   selectedColor: Colors.green,
                              //   selectedItemsTextStyle:
                              //       TextStyle(color: Colors.white),
                              // ),
                              SizedBox(height: 20.0),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.location_pin,
                                  color: /*Colors.green*/ k_appColor,
                                ),
                                title: Text(
                                  "Address",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      myRes.address == null
                                          ? ""
                                          : myRes.address,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: InkWell(
                                      child: Icon(
                                        Icons.create,
                                        size: 18.0,
                                        color: /*Colors.green*/ k_appColor,
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: ((builder) =>
                                              locationBottomSheet(
                                                  //newValue: newName,
                                                  contex: builder,
                                                  latcont: latCont,
                                                  longcont: longCont,
                                                  uid: myRes.uid)),
                                        );
                                      },
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
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      myRes.phone,
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
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: ((builder) =>
                                              textBottomSheet(
                                                  text: "Edit Phone Number",
                                                  kbtype: TextInputType.phone,
                                                  //newValue: newName,
                                                  field: "phone",
                                                  contex: builder,
                                                  cont: phoneCont,
                                                  uid: myRes.uid)),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                              myRes.website != ""
                                  ? ExpansionTile(
                                      leading: Icon(
                                        Icons.contact_support_rounded,
                                        color: /*Colors.green*/ k_appColor,
                                      ),
                                      title: Text(
                                        "Website",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            myRes.website,
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
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: ((builder) =>
                                                    textBottomSheet(
                                                        text:
                                                            "Edit Website Info",
                                                        kbtype:
                                                            TextInputType.url,
                                                        //newValue: newName,
                                                        field: "website",
                                                        contex: builder,
                                                        cont: websiteCont,
                                                        uid: myRes.uid)),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : SizedBox(
                                      height: 2,
                                    ),
                              // ExpansionTile(
                              //   leading: Icon(
                              //     Icons.local_restaurant,
                              //     color: /*Colors.green*/ k_appColor,
                              //   ),
                              //   title: Text(
                              //     "Website",
                              //     style: TextStyle(
                              //         fontSize: 16.0,
                              //         fontWeight: FontWeight.w800),
                              //   ),
                              //   children: <Widget>[
                              //     ListTile(
                              //       title: Text(
                              //         "Italian",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w500),
                              //       ),
                              //       trailing: InkWell(
                              //         child: Icon(
                              //           Icons.delete,
                              //           size: 18.0,
                              //         ),
                              //         onTap: () {},
                              //       ),
                              //     ),
                              //     ListTile(
                              //       title: Text(
                              //         "Tunisian",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w500),
                              //       ),
                              //       trailing: InkWell(
                              //         child: Icon(
                              //           Icons.delete,
                              //           size: 18.0,
                              //         ),
                              //         onTap: () {},
                              //       ),
                              //     ),
                              //     ListTile(
                              //       title: Text(
                              //         "Add another type",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w300),
                              //       ),
                              //       trailing: InkWell(
                              //         child: Icon(
                              //           Icons.add,
                              //           size: 18.0,
                              //         ),
                              //         onTap: () {},
                              //       ),
                              //     )
                              //   ],
                              // ),
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
          } else {
            return Center(child: Container(child: Text("No restaurant")));
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
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
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
      _newimg = File(pickedImage.path);
    });
  }

  Widget textBottomSheet(
      {
      //@required String newValue,
      @required String field,
      @required String text,
      //@required Function onPress,
      @required TextInputType kbtype,
      @required String uid,
      BuildContext contex,
      int minL = 1,
      int maxL = 1,
      TextEditingController cont}) {
    return StatefulBuilder(
        builder: (contex, StateSetter setModalState /*You can rename this!*/) {
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
                      GestureDetector(
                        child: Icon(Icons.check),
                        onTap: cont.text.trim() != ""
                            ? () async {
                                await restDB.editTextField(
                                    id: uid,
                                    field: field,
                                    newValue: cont.text,
                                    context: context);
                                Navigator.pop(context);
                              }
                            : null,
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      /*text*/ /*newValue*/ text,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    minLines: minL,
                    maxLines: maxL,
                    controller: cont,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    keyboardType: kbtype,
                    autofocus: true,
                    //decoration: InputDecoration(labelText: "Full Name"),
                  ),
                ],
              )));
    });
  }

  Widget locationBottomSheet({
    @required String uid,
    BuildContext contex,
    @required TextEditingController latcont,
    @required TextEditingController longcont,
  }) {
    return StatefulBuilder(
        builder: (contex, StateSetter setModalState /*You can rename this!*/) {
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
                      GestureDetector(
                        child: Icon(Icons.check),
                        onTap: latCont.text.trim() != "" &&
                                longCont.text.trim() != ""
                            ? () async {
                                await restDB.editAddressField(
                                    id: uid,
                                    newLat: double.parse(latCont.text),
                                    newLong: double.parse(longCont.text),
                                    context: context);
                                Navigator.pop(context);
                              }
                            : null,
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      /*text*/ /*newValue*/ "Edit Address",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: latCont,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Latitude"),
                  ),
                  TextField(
                    controller: longCont,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    //autofocus: true,
                    decoration: InputDecoration(labelText: "Longitude"),
                  ),
                ],
              )));
    });
  }
}
