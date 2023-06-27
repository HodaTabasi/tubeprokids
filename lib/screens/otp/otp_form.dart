import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helper/SizeConfig.dart';
import '../../../helper/constant.dart';
import '../../get/copon_getx_controller.dart';

class OtpForm extends StatefulWidget {
  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  FocusNode? pin4FocusNode;
  late List<String> numbers;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  void _getClipboardText() async {
    
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    numbers = clipboardText!.split("");
    if (numbers.length == 6) {
      CoponGextController.to.num1Controller.text = numbers[0];
      CoponGextController.to.num2Controller.text = numbers[1];
      CoponGextController.to.num3Controller.text = numbers[2];
      CoponGextController.to.num4Controller.text = numbers[3];
      CoponGextController.to.num5Controller.text = numbers[4];
      CoponGextController.to.num6Controller.text = numbers[5];
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Form(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(45.w),
                child: TextFormField(
                  controller: CoponGextController.to.num1Controller,
                  autofocus: true,
                  obscureText: false,
                  style: TextStyle(fontSize: 16.sp),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  maxLength: 1,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode!);
                    _getClipboardText();
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(46.w),
                child: TextFormField(
                  controller: CoponGextController.to.num2Controller,
                  focusNode: pin2FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 16.sp),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin3FocusNode!);
                    _getClipboardText();
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(45.w),
                child: TextFormField(
                    controller: CoponGextController.to.num3Controller,
                    focusNode: pin3FocusNode,
                    obscureText: false,
                    style: TextStyle(fontSize: 16.sp),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      nextField(value, pin5FocusNode!);
                      _getClipboardText();
                    }),
              ),
              SizedBox(
                width: getProportionateScreenWidth(45.w),
                child: TextFormField(
                  controller: CoponGextController.to.num4Controller,
                  focusNode: pin5FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 16.sp),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin6FocusNode!);
                    _getClipboardText();
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(45.w),
                child: TextFormField(
                  controller: CoponGextController.to.num5Controller,
                  focusNode: pin6FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 16.sp),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    // nextField(value, pin4FocusNode!);
                    _getClipboardText();
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(45.w),
                child: TextFormField(
                  controller: CoponGextController.to.num6Controller,
                  focusNode: pin4FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 16.sp),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      // pin4FocusNode!.unfocus();
                      _getClipboardText();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
