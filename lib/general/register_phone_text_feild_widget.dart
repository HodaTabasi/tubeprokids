import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../get/copon_getx_controller.dart';

class RegisterPhoneTextFeildWidget extends StatelessWidget {
  String hint;
  IconData icon;
  TextEditingController controller;
  var controllers;
Function()? onTap;

  RegisterPhoneTextFeildWidget(this.hint, this.icon, this.controller,this.controllers,{this.onTap });

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      obscureText: false,
      enabled: true,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              )),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          prefixIcon: GestureDetector(
            onTap: onTap ,
            child: Padding(
              padding:  EdgeInsetsDirectional.only(top: 15.0.h,start: 12,bottom: 15.0.h,end: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(controllers.sufixPhone.value,style: TextStyle(
                      fontFamily: 'avater',
                      color: Colors.grey,
                      fontSize: 15.r,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.center,),
                  const SizedBox(width: 4,),
                  const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.grey,)
                ],
              ),
            ),
          ),
          hintStyle: TextStyle(
              color: Color(0xffA3A3A3), fontSize: 17, fontFamily: 'avater'),
          // prefixIcon: Icon(
          //   icon,
          //   color: Color(0xffA3A3A3),
          //   size: 25,
          // ),
          contentPadding: EdgeInsets.all(15)),
    );
  }
}
