import 'package:flutter/material.dart';

mixin Helpers {
  showAlertDialog(BuildContext context) {
    Widget continueButton = Center(
      child: TextButton(
          child: Text("لقد تم نسخ الرابط بنجاح",
              style: TextStyle(
                  fontSize: 16, fontFamily: 'Tajawal', color: Colors.green)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          }),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffF2F2F2),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.check_circle,
          size: 60,
          color: Colors.green,
        ),
      ),
      actions: [
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


  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: new Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.shade300.withOpacity(0.3),
          color: Colors.white,
        ),
        // Container(margin: EdgeInsets.only(left: 7),child: Text("...")),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showSnackBar(BuildContext context,
      {required String message, bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

}
