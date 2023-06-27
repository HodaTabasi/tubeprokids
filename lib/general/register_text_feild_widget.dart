import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterTextFeildWidget extends StatelessWidget {
  String hint;
  IconData icon;
  TextEditingController controller;
  bool isScure = false;
  bool enable;
  String errorText;
  final TextFieldType textFieldType;

  RegisterTextFeildWidget(this.hint, this.icon, this.controller,
      {this.isScure = false,
      this.enable = true,
      this.errorText = "",
      required this.textFieldType});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.green),
      child: TextFormField(
        controller: controller,
        
        obscureText: isScure,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        enabled: enable,
        validator: ((value) {
          if ((value ?? "").isEmpty) {
            return notEmpty(context);
          } else if (!isFieldValid(value ?? "")) {
            return lengthError(context);
          }
          // else if(){}
          return null;
        }),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            hintText: hint,
            errorText: errorText,
            
            errorStyle: const TextStyle(fontSize: 13, fontFamily: 'avater'),
            hintStyle: const TextStyle(
                color: Color(0xffA3A3A3), fontSize: 17, fontFamily: 'avater'),
            prefixIcon: Icon(
              icon,
              color: const Color(0xffA3A3A3),
              size: 25,
            ),
            // contentPadding: const EdgeInsets.all(15)
            ),
      ),
    );
  }

  bool isFieldValid(String value) {
    switch (textFieldType) {
      case TextFieldType.email:
        return value.isValidEmail;
      case TextFieldType.password:
        return value.length >= 6;
      case TextFieldType.rePassword:
        return value.length >= 6;
        break;
      case TextFieldType.fullName:
        return value.length > 5;
      case TextFieldType.none:
        return true;
      case TextFieldType.firstName:
        return value.length > 3;
        break;
      case TextFieldType.lastName:
        return value.length > 3;
      case TextFieldType.referCode:
        return value.length != 10;
      case TextFieldType.phoneNumber:
        return true;
      case TextFieldType.noteMessage:
        return true;
      case TextFieldType.buildingNumber:
        return true;
      case TextFieldType.cuntory:
        return true;
    }
  }

  String notEmpty(BuildContext context) {
    final notEmptyStr = AppLocalizations.of(context)!.cannot_be_empty;
    switch (textFieldType) {
      case TextFieldType.email:
        return notEmptyStr;
      case TextFieldType.password:
        return notEmptyStr;
      case TextFieldType.fullName:
        return notEmptyStr;
      case TextFieldType.none:
        return "";
      case TextFieldType.firstName:
        return notEmptyStr;
      case TextFieldType.lastName:
        return notEmptyStr;
      case TextFieldType.rePassword:
        return notEmptyStr;
      case TextFieldType.referCode:
        return notEmptyStr;
      case TextFieldType.phoneNumber:
        return notEmptyStr;
      case TextFieldType.buildingNumber:
        return notEmptyStr;
      case TextFieldType.noteMessage:
        return "";
      case TextFieldType.cuntory:
        return notEmptyStr;
    }
  }

  String lengthError(BuildContext context) {
    switch (textFieldType) {
      case TextFieldType.email:
        return AppLocalizations.of(context)!.enter_valid_email;
      case TextFieldType.password:
        return AppLocalizations.of(context)!.enter_storng_password;
      case TextFieldType.fullName:
        return AppLocalizations.of(context)!.enter_valid_name;
      case TextFieldType.none:
        return "";
      case TextFieldType.firstName:
        return AppLocalizations.of(context)!.enter_valid_first_name;
      case TextFieldType.lastName:
        return AppLocalizations.of(context)!.enter_valid_last_name;
      case TextFieldType.rePassword:
        return AppLocalizations.of(context)!.enter_storng_password;
      case TextFieldType.referCode:
        return "invalid_refer_code".tr;
      case TextFieldType.phoneNumber:
        return "";
      case TextFieldType.noteMessage:
        return "";
      case TextFieldType.buildingNumber:
        return "";
      case TextFieldType.cuntory:
        return AppLocalizations.of(context)!.enter_country;
    }
  }
}

enum TextFieldType {
  email,
  fullName,
  password,
  rePassword,
  firstName,
  lastName,
  referCode,
  phoneNumber,
  noteMessage,
  buildingNumber,
  cuntory,
  none,
}

extension _ on RegisterTextFeildWidget {
  String get hintText {
    switch (textFieldType) {
      case TextFieldType.email:
        return "Enter your email address..";
      case TextFieldType.password:
        return "Enter your password";
      case TextFieldType.fullName:
        return "Enter your full name";
      case TextFieldType.none:
        return "";
      case TextFieldType.firstName:
        return "enter_your_first_name";
      case TextFieldType.lastName:
        return "enter_your_last_name";
      case TextFieldType.rePassword:
        return "confirm_password";
      case TextFieldType.referCode:
        return "Enter refer code";
      case TextFieldType.phoneNumber:
        return "+972597449680";
      case TextFieldType.noteMessage:
        return "Enter note...";
      case TextFieldType.cuntory:
        return "Enter country...";
      case TextFieldType.buildingNumber:
        return "Ex. 50-55";
    }
  }

  String get textTitle {
    switch (textFieldType) {
      case TextFieldType.email:
        return "email";
      case TextFieldType.password:
        return "password";
      case TextFieldType.fullName:
        return "Full name";
      case TextFieldType.none:
        return "";
      case TextFieldType.firstName:
        return "first_name";
        break;
      case TextFieldType.lastName:
        return "last_name";
        break;
      case TextFieldType.rePassword:
        return "confirm_password";
        break;
      case TextFieldType.referCode:
        return "refer code";
        break;
      case TextFieldType.phoneNumber:
        return "phone";
        break;
      case TextFieldType.noteMessage:
        return "";
      case TextFieldType.buildingNumber:
        return "building_number";
      case TextFieldType.cuntory:
        return "cuntory";
    }
  }

  String  validEmail(BuildContext context) {
    switch (textFieldType) {
      case TextFieldType.email:
        return "invalid email";
      case TextFieldType.password:
        return "invalid password";
      case TextFieldType.fullName:
        return "invalid fullName";
      case TextFieldType.none:
        return "";
      case TextFieldType.firstName:
        return "invalid first name";
      case TextFieldType.lastName:
        return "invalid last name";
      case TextFieldType.rePassword:
        return "invalid password";
      case TextFieldType.referCode:
        return 'invalid_refer_code'.tr;
      case TextFieldType.phoneNumber:
        return "";
      case TextFieldType.noteMessage:
        return "";
      case TextFieldType.buildingNumber:
        return "";
      case TextFieldType.cuntory:
        return 'invalid_country'.tr;
    }
  }
}

extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp =
        RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }
}
