import 'package:flutter/material.dart';

class DeleteDialog {
  static void showAlertDialog(
      {BuildContext context,
      String title = "Warning",
      String message,
      Function onCancel,
      Function onSubmit}) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: onCancel,
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: onSubmit,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
