import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextFeildWidget extends StatelessWidget {
  IconData icon;
  String hint;
  TextEditingController controller;
  bool isScure= false;

  LoginTextFeildWidget(this.icon, this.hint, this.controller,{this.isScure= false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isScure,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: TextStyle(
              color: Color(0xffA3A3A3), fontSize: 16, fontFamily: 'avater'),
          prefixIcon: Icon(
            icon,
            color: Color(0xffA3A3A3),
            size: 20,
          )),
    );
  }
}
