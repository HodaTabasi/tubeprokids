import 'dart:io';

import 'package:apptubey/database/db_controller.dart';
import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/helper/routes.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:apptubey/screens/bottom_navigations.dart';
import 'package:apptubey/screens/first_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import 'api/purchase_api.dart';
import 'get/copon_getx_controller.dart';
import 'get/language_getx_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'get/play_list_getx_controller.dart';
import 'get/user_getx_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPref();
  await DbController().initDatabase();
  PurchaseApi.init();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();

    String defaultLocale = Platform.localeName; // Returns locale string in the form 'en_US'
     if (SharedPrefController().getValueFor<String>(key: PrefKeys.lang.name) == null  ){
          if (defaultLocale == 'ar_US' || defaultLocale == 'ar' || defaultLocale.contains('ar')){
                SharedPrefController().changeLanguage(language: "ar");
          }else{
               SharedPrefController().changeLanguage(language: "en");
    }
  }
     

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final LanguageGetxController languageGetxController =
  Get.put<LanguageGetxController>(LanguageGetxController());
  PlayListGetxController playListGetxController = Get.put(PlayListGetxController());
  VideoGetxController videoGetxController = Get.put(VideoGetxController());
  UserGetxController userGetxController = Get.put(UserGetxController());
  CoponGextController coponGetxController = Get.put(CoponGextController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(392.72727272727275, 781.0909090909091),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Kids tube pro',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            // supportedLocales: AppLocalizations.supportedLocales,
            // locale: Locale(Provider.of<LanguageProvider>(context).language),
            // locale: Locale(context.watch<LanguageProvider>().language),
            locale: Locale(languageGetxController.language.value),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.red,
            ),
            // home: LoginScreen(),
            // home: LoginScreens(),
            initialRoute: FirstScreen.routeName,
            routes: routes,
          );
        });
  }
}
