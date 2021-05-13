import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final _picker = ImagePicker();

Widget imageBottomSheet(BuildContext context) {
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

Future<File> takePhoto(ImageSource source) async {
  final pickedImage = await _picker.getImage(
    source: source,
  );
  return File(pickedImage.path);
}
