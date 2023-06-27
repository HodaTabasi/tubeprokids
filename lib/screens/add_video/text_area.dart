import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextAreaWidget extends StatelessWidget {
   TextAreaWidget({
    required this.controller,
    Key? key,
  }) : super(key: key);

TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:  BorderSide(
                color: Colors.grey.shade300, width: 0.8.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:  BorderSide(
                color: Colors.grey.shade300, width: 0.8.w),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: "وصف الفيديو",
        hintStyle: TextStyle(
            color: Color(0xffA3A3A3), fontSize: 16, fontFamily: 'avater'),),
    );
  }
}