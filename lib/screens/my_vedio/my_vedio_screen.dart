import 'dart:io';

import 'package:apptubey/get/user_getx_controller.dart';
import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/screens/my_vedio/lib_video_item_widget.dart';
import 'package:apptubey/screens/my_vedio/show_offerring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../api/purchase_api.dart';
import '../../models/pakage_offering.dart';
import '../../preferences/shared_pref_controller.dart';
import '../../utils/ShowDialogToDismiss.dart';
import '../constant.dart';

class MyVideoScreens extends StatefulWidget {
  static String routeName = "/my_video";

  @override
  State<MyVideoScreens> createState() => _MyVideoScreensState();
}

class _MyVideoScreensState extends State<MyVideoScreens> {
  UserGetxController userGetxController = UserGetxController.to;
  VideoGetxController videoGetxController = VideoGetxController.to;

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-6698036413009346/3903471125'
        : 'ca-app-pub-6698036413009346/6501714304',
    sizes: [AdSize(width: Get.width.toInt(), height: 70)],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userGetxController.getCurrentUser();
    });
    myBanner.load();
  }

  bool _isLoading = false;

  /*
    We should check if we can magically change the weather
    (subscription active) and if not, display the paywall.
  */
  // void perfomMagic() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //
  //   if (customerInfo.entitlements.all["premium"] != null &&
  //       customerInfo.entitlements.all["premium"]!.isActive == true) {
  //
  //   } else {
  //     Offerings? offerings;
  //     try {
  //       offerings = await Purchases.getOfferings();
  //     } on PlatformException catch (e) {
  //       await showDialog(
  //           context: context,
  //           builder: (BuildContext context) => ShowDialogToDismiss(
  //               title: "Error", content: e.message, buttonText: 'OK'));
  //     }
  //
  //     setState(() {
  //       _isLoading = false;
  //     });
  //
  //     if (offerings == null || offerings.current == null) {
  //       // offerings are empty, show a message to your user
  //     } else {
  //       // current offering is available, show paywall
  //       await showModalBottomSheet(
  //         useRootNavigator: true,
  //         isDismissible: true,
  //         isScrollControlled: true,
  //         backgroundColor: Colors.black,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //         ),
  //         context: context,
  //         builder: (BuildContext context) {
  //           return StatefulBuilder(
  //               builder: (BuildContext context, StateSetter setModalState) {
  //                 return Center(
  //                   child: Text("offerings.current"),
  //                 );
  //                 // return Paywall(
  //                 //   offering: offerings.current,
  //                 // );
  //               });
  //         },
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final AdSize adSize = AdSize(width: 300, height: 70);
    return Scaffold(
      // backgroundColor: Color(0xffF5F5F5),
        bottomNavigationBar: SharedPrefController().getValueFor(key: PrefKeys.sub.name) == true ? SizedBox() :
                      Container(
                        width: adSize.width.toDouble(),
                        height: adSize.height.toDouble(),
                        child: AdWidget(ad: myBanner),
                      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title: Text(
          AppLocalizations.of(context)!.my_video,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        // actions: [
        //   Icon(
        //     Icons.search_sharp,
        //     size: 33.r,
        //     color: Colors.grey.shade400,
        //   ),
        //   SizedBox(
        //     width: 8.w,
        //   ),
        // ],
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        return userGetxController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : ListView(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                
                  // Image.asset("assets/343_94.png"),
                  Card(
                      margin: EdgeInsets.only(
                          left: 16.r, right: 16.r, bottom: 16.r, top: 16.r),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.r),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              userGetxController.currentUser.value.image),
                          backgroundColor: Colors.transparent,
                        ),
                        trailing: SharedPrefController()
                                .getValueFor(key: PrefKeys.sub.name)
                            ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  "assets/crown.png",
                                  width: 25.w,
                                  height: 25.h,
                                ),
                            )
                            : SizedBox(
                                height: 40.h,
                                width: 100.w,
                                child: InkWell(
                                    onTap: () async {
                                      _displayAlertDialog(context);

                                      // List<Offering> aa = await PurchaseApi.fetchOffering();

                                      // print(aa[0]);
                                      // perfomMagic();
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffE20000),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .subscription,
                                          style: TextStyle(
                                              fontFamily: "avater",
                                              color: Colors.white,
                                              fontSize: 12.r),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                              ),
                        title: Text(
                          userGetxController.currentUser.value.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontFamily: 'avater',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text.rich(
                          TextSpan(
                            text: SharedPrefController()
                                    .getValueFor(key: PrefKeys.sub.name)
                                ? "${SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar' ? 'غير محدود' : 'Unlimited'}"
                                : "${videoGetxController.userVideos.length}/${AppConstant.VIDEO_LIMIT_LENTH.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontFamily: 'avater'),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    " ${AppLocalizations.of(context)!.video} |  ${SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar' ? userGetxController.currentUser.value.accountTypeAR : userGetxController.currentUser.value.accountTypeEN} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 13.sp,
                                    fontFamily: 'avater'),
                              ),
                            ],
                          ),
                        ),
                      )),
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
                      padding: EdgeInsets.all(3.0.r),
                      child: Text(
                          "${videoGetxController.userVideos.length} ${AppLocalizations.of(context)!.video}",
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

                  videoGetxController.isLoading.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        )
                      : videoGetxController.userVideos.isEmpty
                          ? Column(
                              children: [
                                SvgPicture.asset("assets/Frame.svg",
                                    semanticsLabel: 'Acme Logo'),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .you_can_go_to,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: 'avater'),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .add_videos_page,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xffE20000),
                                            fontSize: 12.sp,
                                            fontFamily: 'avater'),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : ListView.separated(
                            separatorBuilder: (context, index) =>  const SizedBox(height: 10,),
                              itemCount: videoGetxController.userVideos.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(16.r),
                              itemBuilder: (context, index) {
                                return LibVideoItemWidget(
                                  video: videoGetxController.userVideos[index],
                                  index: index,
                                );
                              }),
                ],
              );
      }),
    );
  }

  Future<void> _displayAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text(AppLocalizations.of(context)!.titlew),
            content: Text(AppLocalizations.of(context)!.mssage1),
            actions: <Widget>[
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.yes,
                  style: TextStyle(color: Colors.red),
                ),

                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              showOffering()));
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>showOffering()));
                },
              ),
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.no1 ,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

}
