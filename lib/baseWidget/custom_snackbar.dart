import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomSnackBar(String message, {bool isError = true}) {


  if(message.isNotEmpty) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  }


}
