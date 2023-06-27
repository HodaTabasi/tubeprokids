import 'dart:io';

import 'package:apptubey/baseWidget/custom_snackbar.dart';
import 'package:apptubey/general/paka_item.dart';
import 'package:apptubey/helper/constant.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:apptubey/utilities/keys.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../api/purchase_api.dart';
import '../../firebase/fb_auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../general/btn_layout.dart';
import '../../get/copon_getx_controller.dart';
import '../../models/fb_response.dart';
import '../../models/paka.dart';
import '../bottom_navigations.dart';
import '../setting/web_view_screen.dart';

class showOffering extends StatefulWidget {
  @override
  State<showOffering> createState() => _showOfferingState();
}

class _showOfferingState extends State<showOffering> with Helpers {
  bool isLoading = false;
  late List<Package> aa;
  final _controller = TextEditingController();
  CoponGextController controller =
      Get.put<CoponGextController>(CoponGextController());
  Package? package;
  int selectIndex = -1;
  bool flag = false;

  CoponGextController coponGextController =
      Get.put<CoponGextController>(CoponGextController());


  var value = "";

  late bool bb ;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    aa = await PurchaseApi.fetchOffering();
   bb =  await CoponGextController.to.getFlag();

  
    // if(aa != null && aa.isNotEmpty) {

    // aa.sort((e , a) {
    //   print("sdf ${e}");
    //   print("fdgdg ${a}");
    //   return a.storeProduct.price.compareTo(e.storeProduct.price);});
    // }

    setState(() {
      isLoading = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //           appBar: AppBar(
  //             automaticallyImplyLeading: false,
  //             backgroundColor: Colors.white.withOpacity(0),
  //             actions: [
  //               IconButton(onPressed: (){
  //                 Navigator.pop(context);
  //               }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,))
  //             ],
  //             elevation: 0,
  //             title: const Text("اختر باقتك المميزة",style: TextStyle(color: Colors.black),),
  //           ),
  //           body: isLoading
  //               ? const Center(
  //             child: CircularProgressIndicator(),
  //           )
  //               : Padding(
  //             padding: EdgeInsets.all(16.0.r),
  //             child: ListView(
  //               children: [
  //                 SizedBox(
  //                   height: 5.h,
  //                 ),
  //                 Text(
  //                   "استمتع بتحميلات بلا حدود واكثر بكثير",
  //                   style: TextStyle(
  //                       fontSize: 18.sp,
  //                       fontFamily: 'avater',
  //                       fontWeight: FontWeight.w500),
  //                 ),
  //                 ListTile(
  //                   leading: Icon(
  //                     Icons.circle,
  //                     color: const Color(0xff0E4C8F),
  //                     size: 8.r,
  //                   ),
  //                   title: Text(
  //                     "عمليات رفع غير محدودة للفيديوهات",
  //                     style: TextStyle(
  //                       color: const Color(0xff2D2D2D),
  //                       fontSize: 13.sp,
  //                       fontFamily: 'avater',
  //                       overflow: TextOverflow.fade,
  //                       // height: 2
  //                       // fontWeight: FontWeight.normal,
  //                     ),
  //                     maxLines: 5,
  //                   ),
  //                 ),
  //                 ListTile(
  //                   leading: Icon(
  //                     Icons.circle,
  //                     color: const Color(0xff0E4C8F),
  //                     size: 8.r,
  //                   ),
  //                   title: Text(
  //                     "انشاء لا محدود من قوائم التشغيل",
  //                     style: TextStyle(
  //                       color: const Color(0xff2D2D2D),
  //                       fontSize: 13.sp,
  //                       fontFamily: 'avater',
  //                       overflow: TextOverflow.fade,
  //                       // height: 2
  //                       // fontWeight: FontWeight.normal,
  //                     ),
  //                     maxLines: 5,
  //                   ),
  //                 ),
  //                 ListTile(
  //                   leading: Icon(
  //                     Icons.circle,
  //                     color: const Color(0xff0E4C8F),
  //                     size: 8.r,
  //                   ),
  //                   title: Text(
  //                     "خالي من الاعلانات",
  //                     style: TextStyle(
  //                       color: const Color(0xff2D2D2D),
  //                       fontSize: 13.sp,
  //                       fontFamily: 'avater',
  //                       overflow: TextOverflow.fade,
  //                       // height: 2
  //                       // fontWeight: FontWeight.normal,
  //                     ),
  //                     maxLines: 5,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height:10.h,
  //                 ),
  //                 ListView.builder(
  //                     itemCount: aa.length,
  //                     shrinkWrap: true,
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     itemBuilder: (context, index) {
  //                       return Card(
  //                         elevation: 2,
  //                         borderOnForeground: true,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.end,
  //                           children:[
  //                             RadioListTile(
  //                             title: Text(aa[index].storeProduct.title),
  //                             subtitle: Text(aa[index].storeProduct.description),
  //                             value: aa[index].storeProduct.identifier,
  //                             groupValue: value,
  //                             contentPadding: EdgeInsets.all(8.r),
  //                             onChanged: (String? value)  async {
  //                               package = aa[index];
  //                               // showLoaderDialog(context);
  //                               setState(() {
  //                                 this.value  = value!;
  //                               });
  //
  //                               // print(aa[index]);
  //                               // try{
  //                               //      print(aa[index]);
  //                               //    var customerInfo = await Purchases.purchaseProduct(aa[index].identifier);
  //                               //     print(customerInfo.toJson());
  //                               //    // Purchases.purchasePackage(aa[index]);
  //                               // } catch(e){
  //                               //   print(e);
  //                               // }
  //                               // setState(() {
  //                               //   this.value  = value!;
  //                               // });
  //                               // await Purchases.purchasePackage(aa[index]);
  //                               // Navigator.pop(context);
  //                               // print(dd);
  //
  //                             },
  //                           ),
  //                             Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(vertical: 8.0.r,horizontal: 16.r),
  //                                   child:  Text(aa[index].storeProduct.priceString, style:TextStyle(
  //                                     color: Colors.red.shade800,
  //                                     fontSize: 14.sp,
  //                                     fontFamily: 'avater',
  //                                     overflow: TextOverflow.fade,
  //                                     // height: 2
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                     textAlign: TextAlign.end,),
  //                                 ),
  //                                 TextButton(onPressed: (){
  //                                   if(package != null ){
  //                                     displayTextInputDialog(context,
  //                                         textFieldController: _controller,product: package);
  //                                   }else {
  //                                     showSnackBar(context, message: "select pakage to got payment",error: true);
  //                                   }
  //
  //                                 }, child: Text("Apply Copun"))
  //                               ],
  //                             )
  //                       ]
  //                         ),
  //                       );
  //                     }),
  //               ],
  //             ),
  //           ),
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.grey.shade200,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                ClipPath(
                  // clipper: BottomWaveClipper(),
                  // clipBehavior: Clip.hardEdge,
                  child: Container(
                    // width: 400,
                    // height: 350,
                    // decoration: BoxDecoration(border: Border.all(color: Colors.grey),color: Colors.white,),
                    
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context)!.close,
                                style: TextStyle(
                                    fontSize: 12.r,
                                    fontFamily: 'avater',
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CarouselSlider(
                          items: mM
                              .map((e) => SingleChildScrollView(
                                child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber.shade600,
                                          size: 40.r,
                                        ),
                                        Text(
                                          SharedPrefController().getValueFor(
                                                      key: PrefKeys.lang.name) ==
                                                  'ar'
                                              ? "حساب مدفوع"
                                              : "Go Premium",
                                          style: TextStyle(
                                              fontFamily: 'avater',
                                              fontSize: 10.r,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Text(
                                          SharedPrefController().getValueFor(
                                                      key: PrefKeys.lang.name) ==
                                                  'ar'
                                              ? "استمتع بجميع مميزات"
                                              : "Enjoy all the features",
                                          style: TextStyle(
                                              fontFamily: 'avater',
                                              fontSize: 20.r,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          SharedPrefController().getValueFor(
                                                      key: PrefKeys.lang.name) ==
                                                  'ar'
                                              ? e.nameArabic
                                              : e.nameEnglish,
                                          style: TextStyle(
                                              fontFamily: 'avater',
                                              fontSize: 16.r,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                              ))
                              .toList(),
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),

                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: mM.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => buttonCarouselController.animateToPage(entry.key),
                              child: Container(
                                width: 10.0,
                                height: 10.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black)
                                        .withOpacity(
                                            _current == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
        
                ListView.builder(
                    itemCount: aa.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PakaItem(
                          title: SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?keydesc[index].nameAR:keydesc[index].nameEN,
                          value: aa[index].storeProduct.identifier,
                          groupValue: value,
                          price: aa[index].storeProduct.priceString,
                          data: SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?keydesc[index].desAR:keydesc[index].desEN,
                          onChanged: (value) => setState(() {
                                this.value = value!;
                                package = aa[index];
                                selectIndex = index;
                              }));
                    }),

                     Padding(

                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Visibility(
                  visible: !flag ,
                  child: TextButton(
                            onPressed: () {
                              setState(() {
                                flag = true;
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!.apply_copon,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontSize: 14.sp,
                                fontFamily: 'avater',
                                overflow: TextOverflow.fade,
                                
                                // height: 2
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                ),
                         ],
                       ),
                     ),

                
                Visibility(
                  visible: flag && bb,
                  child: Padding(
                    padding: const EdgeInsets.only( left: 16,right: 16,top: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                                hintText: AppLocalizations.of(context)!.enter_cpon_number,
                                fillColor: Colors.white,
                                filled: true,
                                hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: 'avater',
                                overflow: TextOverflow.fade,
                                
                                // height: 2
                                fontWeight: FontWeight.bold,
                              ),
                                contentPadding: EdgeInsets.symmetric(vertical: 2,horizontal: 12),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                        color: Colors.black))),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                flag = false;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                ),                  
                
                
                Visibility(
                  visible: !flag || !bb ,
                  child: BtnLayout(AppLocalizations.of(context)!.countunie, margin: EdgeInsets.symmetric(horizontal: 16),() async {
                    try {
                      if(Platform.isAndroid) {
                        await Purchases.purchasePackage(package!);
                      }else{
                        await Purchases.purchaseProduct(package!.storeProduct.identifier);
                      }
                      updateUserData(package!.storeProduct.identifier);
                    } catch (e) {
                      showSnackBar(context,
                          message: AppLocalizations.of(context)!.falied, error: true);
                    }
                  }),
                ),
                            SizedBox(
                            height: 10.h,
                          ),

                           Visibility(
                            visible: !SharedPrefController().getValueFor(key: PrefKeys.sub.name),
                            child: SizedBox(
                              height: 40.h,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel_subscribtion,
                                    style: TextStyle(
                                        fontFamily: "avater", color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        
              

                //  Text(AppLocalizations.of(context)!.notee,style: const TextStyle(
                //   color: Colors.grey,
                //   fontFamily: 'avater',
                // ),textAlign: TextAlign.center,),
                Visibility(
                  visible: flag && bb,
                  child: BtnLayout(AppLocalizations.of(context)!.enter_copon, () async {
                    if (_controller.text.isNotEmpty) {
                      if(selectIndex != -1){
                        // print(package!.storeProduct.identifier);
                        bool sttas = await controller.getCopon(_controller.text, pacakesDiscounts[selectIndex].price);
                        if (sttas) {
                          try {
                          await Purchases.purchaseProduct(pacakesDiscounts[selectIndex].price);
                          await updateUserData(package!.storeProduct.identifier);
                          await controller.updateCoponNumber(_controller.text);
                          await controller.addSubscriberUserWithCoupon(FbAuthController().currentUser.uid,_controller.text,pacakesDiscounts[selectIndex].price);
                          } catch (e) {
                            showCustomSnackBar( "لم تتم العمليه بنجاح",isError: true);
                          }
                          // await updateUserData(package!.storeProduct.identifier);
                          // await changeCoponNumber(_controller.text);
  
                        } else {
                         showCustomSnackBar( AppLocalizations.of(context)!.no_avilable_pakage,isError: true);
                 
                        }
                      }else {
                        showCustomSnackBar( AppLocalizations.of(context)!.select_pakage,isError: true);
                      }

                    } else {
                      showSnackBar(context,
                          message: AppLocalizations.of(context)!.enter_cpon_number, error: true);
                    }
                  }),
                ),
                SizedBox(height: 10,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       InkWell(

                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewViewScreen(uri: null,)));
                          // Navigator.pushNamed(context, ViewViewScreen.routeName);

                        },
                        child: Text(AppLocalizations.of(context)!.policy,style:  const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'avater',
                        fontSize: 10
                                      ),textAlign: TextAlign.center,),
                  ),
                  SizedBox(width: 12,),
                  InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewViewScreen(uri: "https://sites.google.com/view/terms-condition23/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9",)));
                          // Navigator.pushNamed(context, ViewViewScreen.routeName);

                        },
                        child: Text(AppLocalizations.of(context)!.terms_use,style:  const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'avater',
                        fontSize: 10
                                      ),textAlign: TextAlign.center,),
                  ),
                     ],
                   ),

                   

              ],
            ),
    );
  }

  Future<void> updateUserData(String identifier) async {
    DateTime? expireData;
    switch (identifier) {
      case "tube_1111_1m":
        expireData = DateTime.now().add(Duration(days: 30));
        break;
      case "tube_3333_3m":
        expireData = DateTime.now().add(Duration(days: 90));
        break;
      case "tube_1111_1y":
        expireData = DateTime.now().add(Duration(days: 365));
        break;
      case "tuby_app_1m":
        expireData = DateTime.now().add(Duration(days: 100000));
        break;
    }
    FbResponse response = await FbAuthController().udateUserData(
        SharedPrefController().getValueFor(key: PrefKeys.id.name), {
      'subscraption': true,
      'subscraption_duration': expireData.toString(),
      'account_type_ar': 'حساب مدفوع',
      'account_type_en': 'Premium'
    });
    if (response.success) {
      SharedPrefController().saveSubE(true, expireData.toString());
      // Navigator.pop(context);
    }
    showSnackBar(context, message: response.message, error: !response.success);

    /*
    tube_3333_3m
    tube_1111_1y
    tuby_app_1m
    tube_1111_1m
     */
  }

  Future<void> displayTextInputDialog(BuildContext context,
      {textFieldController, product}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.apply),
            content: TextField(
              controller: textFieldController,
              decoration: InputDecoration(hintText:  AppLocalizations.of(context)!.enter_copon),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.apply,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    print(product.storeProduct.identifier);
                    bool sttas = await controller.getCopon(
                        textFieldController.text,
                        product.storeProduct.identifier);

                    if (sttas) {
                      updateUserData(product.storeProduct.identifier);

                    } else {
                      try {
                        if(Platform.isAndroid) {
                          await Purchases.purchasePackage(package!);
                        }else {
                          await Purchases.purchaseProduct(package!.storeProduct.identifier);
                        }
                        updateUserData(package!.storeProduct.identifier);
                      } catch (e) {
                        showSnackBar(context,
                            message: AppLocalizations.of(context)!.falied, error: true);
                      }
                    }
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;

  Future<void> changeCoponNumber(String text) async {
    FbResponse response = await controller.updateCoponNumber(text);
    if(response.success){
      Navigator.pushReplacementNamed(context, BottomNavigation.routeName);
    } else {
      print("dcs");
    }
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// class PathPainter extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double w = size.width;
//     double h = size.height;
//
//     final path= Path();
//     path.lineTo(0, h);
//     path.quadraticBezierTo(w*0.5, h+100, w, h);
//     // path.lineTo(w, h);
//     path.lineTo(w, 0);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
