import 'package:apptubey/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'auth/create_user.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login_create";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize:const Size.fromHeight(230.0),
            child: AppBar(
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/group_1.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 60.h,
                child: TabBar(
                  onTap: (val) {
                    index = val;
                    setState(() {});
                  },
                  indicatorWeight: 2,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  padding:
                      EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 8.r),
                  indicatorColor: const Color(0xffE20000),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontFamily: 'avater',
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontFamily: 'avater',
                    fontWeight: FontWeight.normal,
                  ),
                  labelColor: Colors.black,

                  // controller: controller,
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context)!.login,
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.register,
                    ),
                  ],
                ),
              ),
              IndexedStack(
                index: index,
                children: [
                  LoginScreens(),
                  CreateUser(),
                ],
              ),
              // // second tab bar viiew widget
            ],
          )),
    );
  }
}
