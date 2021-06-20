import 'dart:io';

import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:foodz_owner/Database/RestaurantDB.dart';
import 'package:foodz_owner/Screens/AddAdressScreen.dart';
import 'package:foodz_owner/Screens/MainScreen.dart';
import 'package:foodz_owner/Screens/TestMap.dart';
import 'package:foodz_owner/Screens/mapboxScreen.dart';
import 'package:foodz_owner/utils/consts/const.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class IntroScreen extends StatefulWidget {
  static String tag = '/IntroScreen';
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List _types = ["Cafe", "Restaurant"];
  List _cuisines = [
    "Tunisian",
    "Italian",
    "Chinese",
    "Japanese",
    "Egyptian",
    "Fast Food",
    "Mexican"
  ];

  File _image;
  //String _chosenType;
  List<String> _selectedCuisines;

  RestaurantDB restDB = RestaurantDB();
  final _picker = ImagePicker();

  final _form1Key = GlobalKey<FormState>();
  final _form2Key = GlobalKey<FormState>();
  String selectedType = 'Restaurant';
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _longCtrl = TextEditingController();
  final TextEditingController _latCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _websiteCtrl = TextEditingController();
  final TextEditingController _imageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final steps = [
      CoolStep(
        title: 'General Information',
        subtitle: 'These are the basic information about your restaurant ',
        content: Form(
          key: _form1Key,
          child: Column(
            children: [
              imageProfile(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet()),
                    );
                  },
                  decoration: InputDecoration(
                    labelText: "Choose an image",
                    enabledBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'You need to choose an image';
                    }
                    return null;
                  },
                  controller: _imageCtrl,
                ),
              ),
              _buildTextField(
                kbtype: TextInputType.text,
                labelText: 'Title',
                icon: Icon(Icons.title),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                controller: _titleCtrl,
              ),
              /*_buildTextField(
                kbtype: TextInputType.number,
                labelText: 'Longitude',
                icon: Icon(Icons.location_pin),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Longitude address is required';
                  } else if (double.parse(value) > 180 ||
                      double.parse(value) < -180) {
                    return 'Longitude should be between -180 and 180';
                  }
                  return null;
                },
                controller: _longCtrl,
              ),
              _buildTextField(
                labelText: 'Latitude',
                icon: Icon(Icons.location_pin),
                kbtype: TextInputType.number,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Latitude is required';
                  } else if (double.parse(value) > 90 ||
                      double.parse(value) < -90) {
                    return 'Latitude should be between -90 and 90';
                  }
                  return null;
                },
                controller: _latCtrl,
              ),*/
              _buildTextField(
                kbtype: TextInputType.multiline,
                labelText: 'Description',
                minLine: 6,
                icon: Icon(Icons.short_text_rounded),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
                controller: _descriptionCtrl,
              ),
            ],
          ),
        ),
        validation: () {
          if (!_form1Key.currentState.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      CoolStep(
        title: 'Additional Information',
        subtitle:
            'These will allow users to know more about your restaurant and be able to contact you',
        content: Form(
          key: _form2Key,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 20.0),
              //   child: DropdownButtonFormField(
              //     decoration: InputDecoration(
              //       enabledBorder: OutlineInputBorder(
              //           //borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.grey)),
              //       focusedBorder: OutlineInputBorder(
              //           //borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.green)),
              //       errorBorder: OutlineInputBorder(
              //           //borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.red)),
              //       focusedErrorBorder: OutlineInputBorder(
              //           //borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide(color: Colors.red)),
              //     ),
              //     value: _chosenType,
              //     dropdownColor: Colors.white,
              //     isExpanded: true,
              //     onChanged: (val) {
              //       setState(() {
              //         _chosenType = val;
              //       });
              //     },
              //     validator: (value) => value == null ? 'field required' : null,
              //     hint: Text("Select Type"),
              //     items: _types.map((valueItem) {
              //       return DropdownMenuItem(
              //           value: valueItem, child: Text(valueItem));
              //     }).toList(),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    _buildSelector(
                      context: context,
                      name: 'Restaurant',
                    ),
                    SizedBox(width: 5.0),
                    _buildSelector(
                      context: context,
                      name: 'Cafe',
                    ),
                  ],
                ),
              ),
              selectedType == "Cafe"
                  ? SizedBox(
                      height: 5,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: MultiSelectDialogField(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        validator: (values) {
                          if (values == null) {
                            return "Please choose at least one type of cuisine";
                          } else if (values.length == 0) {
                            return "Please choose at least one type of cuisine";
                          }
                          return null;
                        },
                        initialValue: _selectedCuisines,
                        items: _cuisines
                            .map((e) => MultiSelectItem(e, e))
                            .toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          setState(() {
                            _selectedCuisines = values.cast<String>();
                            print(" cuisines list : " +
                                _selectedCuisines.toString());
                          });
                        },
                        //checkColor: Colors.green,
                        buttonText: Text("Select cuisines"),
                        buttonIcon: Icon(Icons.restaurant_menu),
                        selectedColor: Colors.green,
                        selectedItemsTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),

              _buildTextField(
                kbtype: TextInputType.phone,
                labelText: 'Phone',
                icon: Icon(Icons.phone),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Phone Number is required';
                  }
                  return null;
                },
                controller: _phoneCtrl,
              ),
              _buildTextField(
                icon: Icon(Icons.contact_support),
                labelText: 'Website or Social Media (Optional)',
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Name is required';
                //   }
                //   return null;
                // },
                controller: _websiteCtrl,
              ),
            ],
          ),
        ),
        validation: () {
          if (!_form2Key.currentState.validate()) {
            return 'Fill form correctly';
          }
          return null;
        },
      ),
      /*CoolStep(
        isHeaderEnabled: false,
        content: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(top: 120),
            alignment: Alignment.center,
            width: 280,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("images/offline/check-mark.png",
                        width: 250, height: 200),
                    SizedBox(
                      height: 20,
                    ),
                    Text("You're Done!",
                        style: TextStyle(
                            fontSize: 30,
                            color: Constants.lightAccent,
                            fontWeight: FontWeight.bold)),
                    Container(height: 10),
                    Text("Make sure to check all your info before proceeding",
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
        ),
        validation: () {
          return null;
        },
      ),
      */

      // CoolStep(
      //   title: 'Select your role',
      //   subtitle: 'Choose a role that better defines you',
      //   content: Container(
      //     child: Row(
      //       children: <Widget>[
      //         _buildSelector(
      //           context: context,
      //           name: 'Writer',
      //         ),
      //         SizedBox(width: 5.0),
      //         _buildSelector(
      //           context: context,
      //           name: 'Editor',
      //         ),
      //       ],
      //     ),
      //   ),
      //   validation: () {
      //     return null;
      //   },
      // ),
    ];

    final stepper = CoolStepper(
      showErrorSnackbar: false,
      onCompleted: () async {
        context.loaderOverlay.show();
        await restDB.addNewRestaurant(
            context: context,
            image: _image,
            title: _titleCtrl.text,
            type: selectedType,
            cuisines: _selectedCuisines,
            description: _descriptionCtrl.text,
            phone: _phoneCtrl.text,
            website: _websiteCtrl.text.isNotEmpty ? _websiteCtrl.text : "");
        context.loaderOverlay.hide();

        Position _pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        Navigator.pop(context);
        Navigator.pushNamed(context, AddAddressScreen.tag, arguments: _pos);

        print('Steps completed!');
      },
      steps: steps,
      config: CoolStepperConfig(
        backText: 'PREV',
      ),
    );

    return GestureDetector(
      onTap: () {
        //here
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: LoaderOverlay(
        overlayWidget: CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).accentColor,
            title: Text("Your First Restaurant"),
            titleTextStyle: TextStyle(color: Colors.white),
          ),
          body: Container(
            child: stepper,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {String labelText,
      FormFieldValidator<String> validator,
      TextEditingController controller,
      TextInputType kbtype,
      int minLine = 1,
      Icon icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: kbtype,
        maxLines: null,
        minLines: minLine,
        onChanged: (value) {
          print(controller.text);
        },
        decoration: InputDecoration(
          suffixIcon: icon,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green)),
          errorBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red)),
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Widget _buildSelector({
    BuildContext context,
    String name,
  }) {
    final isActive = name == selectedType;

    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? Colors.green : null,
          border: Border.all(
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: RadioListTile(
          value: name,
          activeColor: Colors.white,
          groupValue: selectedType,
          onChanged: (String v) {
            setState(() {
              selectedType = v;
            });
          },
          title: Text(
            name,
            style: TextStyle(
              color: isActive ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }

  // return Scaffold(
  //     body: ListView(
  //   children: <Widget>[
  //     Container(
  //       //height: 590,
  //       decoration: BoxDecoration(
  //           boxShadow: [
  //             new BoxShadow(
  //               color: Colors.black26,
  //               offset: new Offset(0.0, 2.0),
  //               blurRadius: 25.0,
  //             )
  //           ],
  //           color: Theme.of(context).primaryColor,
  //           borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(32),
  //               bottomRight: Radius.circular(32))),
  //       alignment: Alignment.topCenter,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               // Container(
  //               //   margin: EdgeInsets.all(16),
  //               //   child: FlatButton(
  //               //     onPressed: () {},
  //               //     child: Text(
  //               //       'Sign In',
  //               //       style: TextStyle(
  //               //         fontSize: 20,
  //               //         color: Colors.grey,
  //               //       ),
  //               //     ),
  //               //   ),
  //               // ),
  //               SizedBox(
  //                 height: 20,
  //               )
  //               // Container(
  //               //   margin: EdgeInsets.all(16),
  //               //   child: FlatButton(
  //               //     onPressed: () {},
  //               //     child: Text(
  //               //       'Welcome',
  //               //       style: TextStyle(
  //               //         fontSize: 20,
  //               //         color: Colors.green,
  //               //       ),
  //               //     ),
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(left: 16, top: 8),
  //             child: Text(
  //               'Create your restaurant\'s profile',
  //               style: TextStyle(
  //                   fontSize: 26,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.green),
  //             ),
  //           ),
  //           Container(
  //             margin: EdgeInsets.only(left: 16, top: 8),
  //             child: Text(
  //               'Let\'s get started',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
  //             ),
  //           ),
  //           imageProfile(),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           Padding(
  //             padding:
  //                 EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 8),
  //             child: TextField(
  //               style: TextStyle(fontSize: 18),
  //               keyboardType: TextInputType.text,
  //               textCapitalization: TextCapitalization.words,
  //               decoration: InputDecoration(
  //                 prefixIcon: Padding(
  //                   padding: EdgeInsetsDirectional.only(start: 12),
  //                   child: Icon(
  //                     Icons.local_restaurant,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //                 hintText: 'Restaurant Name',
  //                 enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding:
  //                 EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
  //             child: TextField(
  //               keyboardType: TextInputType.multiline,
  //               maxLines: null,
  //               style: TextStyle(fontSize: 18),
  //               decoration: InputDecoration(
  //                 prefixIcon: Padding(
  //                   padding: EdgeInsetsDirectional.only(start: 12),
  //                   child: Icon(
  //                     Icons.short_text,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //                 hintText: 'Write a small description',
  //                 enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding:
  //                 EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
  //             child: TextField(
  //               keyboardType: TextInputType.phone,
  //               maxLines: null,
  //               style: TextStyle(fontSize: 18),
  //               decoration: InputDecoration(
  //                 prefixIcon: Padding(
  //                   padding: EdgeInsetsDirectional.only(start: 12),
  //                   child: Icon(
  //                     Icons.phone,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //                 hintText: 'Phone Number',
  //                 enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //                 focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                     borderSide: BorderSide(color: Colors.grey)),
  //               ),
  //             ),
  //           ),
  //           FlatButton(
  //               onPressed: () async {
  //                 await restDB.addNewRestaurant();
  //               },
  //               child: Text("add")),
  //           Align(
  //               alignment: Alignment.centerRight,
  //               child: Container(
  //                 margin: EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                     color: Colors.green, shape: BoxShape.circle),
  //                 child: IconButton(
  //                   color: Colors.white,
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     Navigator.pushNamed(context, MainScreen.tag);
  //                   },
  //                   icon: Icon(Icons.arrow_forward),
  //                 ),
  //               )),
  //         ],
  //       ),
  //     ),
  //   ],
  // ));

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4.2,
            width: MediaQuery.of(context).size.width / 1.2,
            margin: EdgeInsets.only(bottom: 20),
            //radius: 80,
            /*backgroundImage: _image == null
                ? AssetImage("images/offline/empty.png")
                : FileImage(File(_image.path)),*/
            decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: _image == null
                      ? AssetImage("images/offline/choose-image.png")
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
      _imageCtrl.text = pickedImage.path;
    });
  }
}
