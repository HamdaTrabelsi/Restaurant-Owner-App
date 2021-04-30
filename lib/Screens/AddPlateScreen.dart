import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodz_owner/utils/SnackUtil.dart';
import 'package:image_picker/image_picker.dart';

class AddPlateScreen extends StatefulWidget {
  static String tag = '/AddPlateScreen';

  @override
  _AddPlateScreen createState() => _AddPlateScreen();
}

class _AddPlateScreen extends State<AddPlateScreen> {
  File _image;
  final _picker = ImagePicker();
  String _type;
  String _desc, _name, _sub, _price;
  bool fieldName = false;
  bool fieldSub = false;
  bool fieldPrice = false;
  bool fieldDesc = false;
  bool _isconfirmed = false;
  static const _types = [
    'Appetizer',
    'Dessert',
    'Main Course',
    'Salad',
    'Fast Food',
    'Drink',
  ];

  void checkFields() {
    if (fieldName && fieldSub && fieldPrice && fieldDesc && _type != null) {
      _isconfirmed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              ? AssetImage("images/offline/empty.png")
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
                        if (value != null) {
                          fieldName = true;
                          setState(() {
                            checkFields();
                          });
                        }
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
                              value: _type,
                              items: _types.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (selectedItem) {
                                setState(() {
                                  _type = selectedItem;
                                  checkFields();
                                });
                              }),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(fontSize: 18),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(start: 12),
                          child: Icon(
                            Icons.short_text,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: 'Subtitle',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          fieldSub = true;
                          setState(() {
                            checkFields();
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
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
                        if (value != null) {
                          fieldPrice = true;
                          setState(() {
                            checkFields();
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
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
                        if (value != null) {
                          fieldDesc = true;
                          setState(() {
                            checkFields();
                          });
                        }
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
          label: Text("Add New Dish"),
          onPressed: () async {
            //Navigator.pushNamed(context, AddPlateScreen.tag);
            //SnackUtil.showSnackBar(context, "New Dish added");
            await Future.delayed(Duration(seconds: 2));
            Navigator.pop(context);
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
