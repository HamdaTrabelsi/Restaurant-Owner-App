import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Models/Dish.dart';
import 'package:foodz_owner/Screens/AddPlateScreen.dart';
import 'package:foodz_owner/Screens/PlateDetailsScreen.dart';
import 'package:foodz_owner/utils/ErrorFlushBar.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';
import 'package:foodz_owner/utils/SuccessFlushBar.dart';
import 'package:image_picker/image_picker.dart';

class EditPlateScreen extends StatefulWidget {
  static String tag = '/EditPlateScreen';

  @override
  _EditPlateScreen createState() => _EditPlateScreen();
}

class _EditPlateScreen extends State<EditPlateScreen> {
  File _image;
  String imageUrl;
  final _picker = ImagePicker();
  String _newCat;
  String _newCuisine;
  //String newDesc;
  bool _isconfirmed = true;

  TextEditingController _NameController = new TextEditingController();
  TextEditingController _DescController = new TextEditingController();
  TextEditingController _PriceController = new TextEditingController();
  TextEditingController _cuisinController = new TextEditingController();
  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _imageController = new TextEditingController();

  static const _types = [
    'Appetizer',
    'Dessert',
    'Main Course',
    'Salad',
    'Fast Food',
    'Drink',
  ];

  List _cuisines = [
    "Tunisian",
    "Italian",
    "Chinese",
    "Japanese",
    "Egyptian",
    "Fast Food",
    "Indian"
  ];

  void checkFields() {
    if (_NameController.text != "" &&
        _DescController.text != "" &&
        _PriceController.text != "" &&
        _categoryController.text != "" &&
        _cuisinController.text != "") {
      _isconfirmed = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Dish dish = ModalRoute.of(context).settings.arguments;
    _NameController.text = dish.name;
    _DescController.text = dish.description;
    _PriceController.text = dish.price;
    _categoryController.text = dish.category;
    _cuisinController.text = dish.cuisine;
    _imageController.text = dish.image;

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: ListView(
            children: [
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
              Center(
                child: Stack(children: [
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
                          image: /*AssetImage("images/offline/food1.jpeg")*/ _image ==
                                  null
                              ? NetworkImage(_imageController.text)
                              : FileImage(File(_image.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
                        color: Colors.green,
                        size: 28,
                      ),
                    ),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Column(
                  children: [
                    TextField(
                      controller: _NameController,
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
                        hintText: 'Plate Name',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (value) {
                        // if (value != null) {
                        //   fieldName = true;
                        //   setState(() {
                        //     checkFields();
                        //   });
                        // }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              .copyWith(color: Colors.black),
                          border: const OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              isExpanded: true,
                              isDense:
                                  true, // Reduces the dropdowns height by +/- 50%
                              icon: Icon(Icons.keyboard_arrow_down),
                              value: _categoryController.text,
                              items: _types.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (selectedItem) {
                                _categoryController.text = selectedItem;

                                // setState(() {
                                //   _type = selectedItem;
                                //   checkFields();
                                // });
                              }),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Cuisine',
                          labelStyle: Theme.of(context)
                              .primaryTextTheme
                              .caption
                              .copyWith(color: Colors.black),
                          border: const OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              isExpanded: true,
                              isDense:
                                  true, // Reduces the dropdowns height by +/- 50%
                              icon: Icon(Icons.keyboard_arrow_down),
                              value: _cuisinController.text,
                              items: _cuisines.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (selectedItem) {
                                _cuisinController.text = selectedItem;
                                // setState(() {
                                //   checkFields();
                                // });
                              }),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _PriceController,
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(start: 12),
                          child: Icon(
                            Icons.monetization_on,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: 'Price (in Dt)',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (value) {
                        // if (value != null) {
                        //   setState(() {
                        //     checkFields();
                        //   });
                        // }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _DescController,
                      style: TextStyle(fontSize: 18),
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(start: 12),
                          child: Icon(
                            Icons.subject,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: 'Description',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (value) {
                        // if (value != null) {
                        //   setState(() {
                        //     checkFields();
                        //   });
                        // }
                      },
                    ),
                    SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: _isconfirmed ? Colors.green : Colors.grey,
          heroTag: "BtnSubmitAdd",
          icon: Icon(_isconfirmed ? Icons.check : Icons.error),
          label: Text("Modify Dish"),
          onPressed: () async {
            if (_image != null) {
              imageUrl = await dishDB.storeDishImage(upImage: _image);
            } else {
              imageUrl = _imageController.text;
            }
            await dishDB
                .editDish(
                    id: dish.uid,
                    name: _NameController.text,
                    category: _categoryController.text,
                    cuisine: _cuisinController.text,
                    description: _DescController.text,
                    price: _PriceController.text,
                    image: imageUrl)
                .catchError((e) {
              ErrorFlush.showErrorFlush(
                  message: e.toString(), context: context);
            }).whenComplete(() {
              SuccessFlush.showSuccessFlush(
                  context: context, message: "Dish edited successfully !");
            });
            // Navigator.pushNamed(context, FoodDetailsScreen.tag,
            //     arguments: dish.uid);
          },
        ));
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
