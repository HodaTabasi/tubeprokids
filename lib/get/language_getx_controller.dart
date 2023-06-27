import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../preferences/shared_pref_controller.dart';

class LanguageGetxController extends GetxController {

  static String defaultLocale = Platform.localeName; // Returns locale string in the form 'en_US'

  static LanguageGetxController get to => Get.find<LanguageGetxController>();
  String? lang = SharedPrefController().getValueFor<String>(key: PrefKeys.lang.name);

  Rx<String> language = SharedPrefController().getValueFor<String>(key: PrefKeys.lang.name) == null
      ?  (defaultLocale == 'ar_US' || defaultLocale == 'ar' )? 'ar'.obs : 'en'.obs 
      // Intl.getCurrentLocale() == 'ar' ? 'ar'.obs : 'en'.obs 
      : SharedPrefController().getValueFor<String>(key: PrefKeys.lang.name)!.obs;

  void changeLanguage(int langValue) {
    // SharedPrefController().removeValueFor(key:  PrefKeys.lang.name);
   String fd =  Intl.getCurrentLocale();
    // language = language == 'ar'.obs ? 'en'.obs : 'ar'.obs;
    language.value = langValue == 0 ? 'ar' : 'en';
    SharedPrefController().changeLanguage(language: language.value);
    var locale = Locale(language.value);
    Get.updateLocale(locale);
    // language.refresh();
    print(language);

        // SharedPrefController().removeValueFor(key:  PrefKeys.lang.name);

  }
}
