import 'dart:convert';

import 'package:apptubey/api/api_service.dart';
import 'package:apptubey/get/language_getx_controller.dart';
import 'package:apptubey/get/user_getx_controller.dart';
import 'package:apptubey/models/Country.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../profile/items.dart';

class Setting extends StatefulWidget {
  static String routeName = "/setting";

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  UserGetxController userGetxController = UserGetxController.to;
  List<Country> data = [];

  String? dropdownValue;

  var isExpand = false;

  Country value = Country();
  int  langValue = SharedPrefController().getValueFor<String>(key: PrefKeys.lang.name)=='ar'?0:1;

  var isExpand1 = false;

  @override
  void initState() {
    super.initState();
    getData();
    value.name = SharedPrefController().getValueFor(key: PrefKeys.country.name);
  }

  getData() async {
 
    List my_data = json.decode(await APIService.instance.getJson());
    data = my_data.map((e) => Country.fromJson(e)).toList();
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();


    print("customerInfo = $customerInfo");
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title: Text(
          AppLocalizations.of(context)!.setting,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,))
        ],
        // actions: [
        //   Icon(
        //     Icons.search_sharp,
        //     size: 33.r,
        //     color: Colors.grey.shade400,
        //   ),
        //   const SizedBox(
        //     width: 8,
        //   ),
        // ],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: ListView(
          children: [
            SizedBox(
              height: 20.h,
            ),
            ExpansionPanelList(
              animationDuration: Duration(milliseconds: 100),
              elevation: 2,
              children: [
                ExpansionPanel(
                    isExpanded: isExpand1,
                    body: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.0.r),
                              child: Text(AppLocalizations.of(context)!.ar,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontFamily: 'avater',
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0.r),
                              child: Radio(
                                value: 0,
                                groupValue: langValue,
                                onChanged: (int? value) {
                                  langValue = value!;
                                  LanguageGetxController.to.changeLanguage(langValue);

                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.0.r),
                              child: Text(AppLocalizations.of(context)!.en,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontFamily: 'avater',
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0.r),
                              child: Radio(
                                value: 1,
                                groupValue: langValue,
                                onChanged: (int? value) {
                                  langValue = value!;
                                  LanguageGetxController.to.changeLanguage(langValue);

                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12.0.r),
                            child: Text(AppLocalizations.of(context)!.lang,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily: 'avater',
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text(
                            SharedPrefController().getValueFor<String>(key: PrefKeys.lang.name)=='ar'?"العربية":"English",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.sp,
                                fontFamily: 'avater'),
                          ),
                        ],
                      );
                    }),
              ],
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  isExpand1 = !isExpand1;
                  // visable = !isExpand;
                });
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            // ExpansionPanelList(
            //   animationDuration: const Duration(milliseconds: 100),
            //   elevation: 2,
            //   children: [
            //     ExpansionPanel(
            //         isExpanded: isExpand,
            //         body: ListView.builder(
            //             shrinkWrap: true,
            //             physics: const NeverScrollableScrollPhysics(),
            //             itemCount: data.length,
            //             itemBuilder: (context, index) {
            //               // print(data[index].name!);
            //               return Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Padding(
            //                     padding: EdgeInsets.all(12.0.r),
            //                     child: Text(data[index].name!,
            //                         style: TextStyle(
            //                             color: Colors.black,
            //                             fontSize: 14.sp,
            //                             fontFamily: 'avater',
            //                             fontWeight: FontWeight.bold)),
            //                   ),
            //                   Padding(
            //                     padding: EdgeInsets.all(12.0.r),
            //                     child: Radio<Country>(
            //                       value: data[index],
            //                       groupValue: value,
            //                       activeColor: const Color(0xffE20000),
            //                       onChanged: (value) {
            //                         setState(() {
            //                           this.value = value!;
            //                         });
            //                         _changeCountry();
            //                       },
            //                     ),
            //                   ),
            //                 ],
            //               );
            //             }),
            //         headerBuilder: (BuildContext context, bool isExpanded) {
            //           return Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Padding(
            //                 padding: EdgeInsets.all(12.0.r),
            //                 child: Text(AppLocalizations.of(context)!.cuntory,
            //                     style: TextStyle(
            //                         color: Colors.black,
            //                         fontSize: 14.sp,
            //                         fontFamily: 'avater',
            //                         fontWeight: FontWeight.bold)),
            //               ),
            //               Text(
            //                 value.name!,
            //                 style: TextStyle(
            //                     color: Colors.black,
            //                     fontSize: 11.sp,
            //                     fontFamily: 'avater'),
            //               ),
            //             ],
            //           );
            //         }),
            //   ],
            //   expansionCallback: (panelIndex, isExpanded) {
            //     setState(() {
            //       isExpand = !isExpand;
            //       // visable = !isExpand;
            //     });
            //   },
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            TextItem(AppLocalizations.of(context)!.change_password, () {
              Navigator.pushNamed(context, "/change_password");
            }),
          ],
        ),
      ),
    );
  }

  // _changeCountry() async {
  //   userGetxController.currentUser.value.country = value.name!;
  //
  //   FbResponse fbResponse = await userGetxController.updateUser(
  //       user: userGetxController.currentUser.value);
  //   if (fbResponse.success) {
  //     SharedPrefController().saveCountry(value.name);
  //     Navigator.pop(context);
  //   }
  //   context.showSnackBar(message: fbResponse.message);
  // }
}
