import 'package:apptubey/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../api/purchase_api.dart';
import '../preferences/shared_pref_controller.dart';
import 'bottom_navigations.dart';

class FirstScreen extends StatefulWidget {
  static String routeName = "/first";

  
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  
  @override
  void initState() {
    super.initState();
    PurchaseApi.checkCustomerStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
        

    });

  }


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
        if (SharedPrefController().getValueFor(key: PrefKeys.lang.name) == null)
        SharedPrefController().changeLanguage(language: 'ar');
        String route = SharedPrefController()
                    .getValueFor(key: PrefKeys.loggedIn.name) !=
                null
            ? SharedPrefController().getValueFor(key: PrefKeys.loggedIn.name)
                ? BottomNavigation.routeName
                : LoginScreen.routeName
            : LoginScreen.routeName;

        if(SharedPrefController().getValueFor(key: PrefKeys.loggedIn.name) != null){
          if(SharedPrefController().getValueFor(key: PrefKeys.loggedIn.name)){
              PurchaseApi.checkCustomerStatus().then((value) {
                if(value){
                  SharedPrefController().saveSub(true);
                }else{
                  SharedPrefController().saveSub(false);
                }
              });

            // if(SharedPrefController().getValueFor(key: PrefKeys.subExpire.name) == ""){
            //   SharedPrefController().saveSub(false);
            //   print(DateTime.now());
            // }else{
            //   DateTime dd = DateTime.now();
            //   try{
            //     dd = DateTime.parse(SharedPrefController().getValueFor(key: PrefKeys.subExpire.name) ??"" );
            //   }catch(e){
            //     print("errorr = $e");
            //   }
            //   if(DateTime.now().compareTo(dd) == 0){
            //     // print("Both date time are at same moment.");
            //     SharedPrefController().saveSub(true);
            //   }

            //   if(DateTime.now().compareTo(dd) < 0){
            //     // print("DT1 is before DT2");
            //     SharedPrefController().saveSub(true);
            //   }
            //   if(DateTime.now().compareTo(dd) > 0){
            //     // print("DT1 is after DT2");
            //     SharedPrefController().saveSub(false);
            //   }
            // }
          }
        }else{
          print("dsdser");
        }

        Navigator.pushReplacementNamed(context, route);
      },
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo2.jpeg",
              fit: BoxFit.contain,
              // fit: BoxFit.fitHeight,
            ),
          // const Text(" Kids Tube Pro",textAlign: TextAlign.center,style:  TextStyle(
          //             color: Colors.black,
          //             fontSize: 20,
          //             fontFamily: 'avater',
          //             fontWeight: FontWeight.bold,
          //           ),)
          ],
        ),
      ),
    );
  }
}
