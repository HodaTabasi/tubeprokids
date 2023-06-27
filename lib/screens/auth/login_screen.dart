import 'dart:io';

import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:apptubey/firebase/fb_auth_controller.dart';
import 'package:apptubey/general/btn_layout.dart';
import 'package:apptubey/general/login_text_feild_widget.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/screens/change_password/change_pass.dart';
import 'package:apptubey/utils/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bottom_navigations.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> with Helpers{
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // _emailController.text = "alsfeh852123@gmail.com";
    // _passwordController.text = "123456";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, 0),
                    blurRadius: 4)
              ]),
          child: Column(
            children: [
              LoginTextFeildWidget(
                Icons.email,
                AppLocalizations.of(context)!.email,
                _emailController,
              ),
              Divider(
                height: 0,
                color: Colors.grey.shade300,
                thickness: 0.8.h,
              ),
              LoginTextFeildWidget(
                Icons.password,
                AppLocalizations.of(context)!.password,
                _passwordController,
                isScure: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.r, vertical: 8.r),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, ChangePass.routeName);
            },
            child: Text(
              AppLocalizations.of(context)!.forget_pass_hl,
              style: TextStyle(
                  fontFamily: 'avater',
                  fontSize: 16.sp,
                  color: const Color(0xffFF0000)),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        BtnLayout(AppLocalizations.of(context)!.login, () {
          _performLogin();
        }),
        SizedBox(
          height: 20,
        ),
        Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: Colors.grey.shade500,
            height: 1,
            thickness: 1,
            endIndent: 20,
            indent: 20,
          )),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text("${AppLocalizations.of(context)!.login_with}",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13.sp,
                  fontFamily: 'avater',
                  fontWeight: FontWeight.normal,
                )),
          ),
          Expanded(
              child: Divider(
            color: Colors.grey.shade500,
            height: 1,
            thickness: 1,
            endIndent: 20,
            indent: 20,
          )),
        ]),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: Platform.isIOS,
                  // visable:Platform.isAndroid
                  child: InkWell(
                    onTap: () {
                      AuthSocial().signInWithApple(context);
                    },
                    child: Image.asset(
                      "assets/apple.png",
                      width: 50,
                      height: 50,
                    ),
                  )),
              Visibility(
                visible: Platform.isIOS,
                child: SizedBox(
                  width: 50.w,
                ),
              ),
              // InkWell(
              //     onTap: () {
              //       // AuthSocial().signInWithFacebook(context);
              //     },
              //     child: Image.asset(
              //       "assets/facebook.png",
              //       width: 50,
              //       height: 50,
              //     )),
              // SizedBox(
              //   width: 50.w,
              // ),
              InkWell(
                  onTap: () {
                    AuthSocial().signInWithGoogle(context);
                  },
                  child: Image.asset(
                    "assets/google.png",
                    width: 50,
                    height: 50,
                  )),
            ],
          ),
        )
        // RichText(
        //   text: TextSpan(
        //     text: 'Hello ',
        //     style: DefaultTextStyle.of(context).style,
        //     children: const <TextSpan>[
        //       TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
        //       TextSpan(text: ' world!'),
        //     ],
        //   ),
        // )
      ],
    );
  }

  Future<void> _performLogin() async {
    if (_checkData()) {
      await _login();
    }
  }

  bool _checkData() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _login() async {
    showLoaderDialog(context);
    FbResponse fbResponse = await FbAuthController().signIn(
        _emailController.text.toString().trim(), _passwordController.text);
    Navigator.pop(context);
    if (fbResponse.success) {
      Navigator.pushReplacementNamed(context, BottomNavigation.routeName);
    }else {
      context.showSnackBar(
          message: fbResponse.message, error: !fbResponse.success);
    }

  }
}
