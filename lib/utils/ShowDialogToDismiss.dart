import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ShowDialogToDismiss extends StatelessWidget {
   String? content;
   String? title;
   String? buttonText;

   ShowDialogToDismiss(
      {this.title, this.buttonText, this.content});

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: Text(
          title!,
        ),
        content: Text(
          content!,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              buttonText!,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title!,
          ),
          content: Text(
            content!,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                buttonText![0].toUpperCase() +
                    buttonText!.substring(1).toLowerCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}