import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CahngePassTextFeildWidget extends StatelessWidget {
  IconData icon;
  String hint;
  TextEditingController controller;

  CahngePassTextFeildWidget(this.icon, this.hint, this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8.w),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r)),
          // borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
              bottomLeft: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r)),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8.w),
        ),
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        hintStyle: TextStyle(
            color: Color(0xffA3A3A3), fontSize: 16.sp, fontFamily: 'avater'),
        prefix: Icon(icon, color: Colors.grey),
      ),
    );
  }
}
