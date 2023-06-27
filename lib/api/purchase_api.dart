import 'dart:io';

import 'package:apptubey/baseWidget/custom_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const String _GOOGLE_API_KEY = "goog_PlGSSJRQsMMjatdWDafbDbfvIcS";
  static const String _APPLE_API_KEY = "appl_sqwUDfAuqPZLIoDqwVCOblvhsgb";

  // static const String _GOOGLE_API_KEY = "goog_PlGSSJRdsgadgQsMMjatdWDafbDbfvIcS";

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_GOOGLE_API_KEY);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_APPLE_API_KEY);
    } else {
      configuration = PurchasesConfiguration(_GOOGLE_API_KEY);
    }
    await Purchases.configure(configuration);
  }

  static Future<List<Package>> fetchOffering() async {
    try {
      // LogInResult result = await Purchases.logIn("23");
      // final offering = await Purchases.getOfferings();

      Offerings offering = await Purchases.getOfferings();

      // LogInResult result = await Purchases.logIn("my_app_user_id");
      // print(offering.current!.availablePackages);

      if (offering.current != null) {
        final current = offering.current;
        return current == null ? [] : current.availablePackages;
      } else {
        return [];
      }
    } on PlatformException catch (e) {
      showCustomSnackBar(e.toString());
      return [];
    }
  }

 static Future<bool> checkCustomerStatus() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    if (customerInfo.entitlements.active.isNotEmpty) {
      return true;
    }else{
      return false;
      // showCustomSnackBar("false");
    }
  }

  // Future<void> checkCustomerStastus() async {


  //   try {
  //     final purchaserInfo = await Purchases.purchasePackage(package);
  //     if (purchaserInfo.entitlements.all["my_entitlement_identifier"].isActive) {
  //       // Unlock that great "pro" content
  //     }
  //   } on PlatformException catch (e) {
  //     /* No purchase */
  //   }
  // }

}
