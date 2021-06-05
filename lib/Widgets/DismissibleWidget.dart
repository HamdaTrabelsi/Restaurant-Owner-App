import 'package:flutter/material.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback ondismissed;
  const DismissibleWidget(
      {@required this.item,
      @required this.child,
      @required this.ondismissed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(item),
        background: buildSwipeActionLeft(),
        secondaryBackground: buildSwipeActionRight(),
        child: child,
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                /*content: const Text(
                  "Are you sure you wish to delete this item?",
                  style: TextStyle(color: Colors.white),
                ),*/
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("CONFIRM")),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: ondismissed);
  }

  Widget buildSwipeActionLeft() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.green,
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget buildSwipeActionRight() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: Icon(
        Icons.delete,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
