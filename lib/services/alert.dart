import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlertPop {
  static void alert(BuildContext context,
      {Text? title,
      @required Text? body,
      VoidCallback? onOkAction,
      String okActionText = "Ok"}) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: title,
            content: body,
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(okActionText),
              ),
            ],
          );
        });
  }
}
