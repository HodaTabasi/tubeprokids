import 'dart:io';

import 'package:apptubey/get/favourite_getx_controller.dart';
import 'package:apptubey/screens/Favourite/FavItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FavScreen extends StatefulWidget {
  static String routeName = "/fav_screen";

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  FavouriteGetxController controller = Get.put(FavouriteGetxController());
  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: Platform.isAndroid?'ca-app-pub-6698036413009346/3268497566':'ca-app-pub-6698036413009346/2465432222',
    sizes: [AdSize(width: 350, height: 90)],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdSize adSize = AdSize(width: 300, height: 95);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title:  Text(
          AppLocalizations.of(context)!.favorite,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        // actions: [
        //   Icon(
        //     Icons.search_sharp,
        //     size: 33,
        //     color: Colors.grey.shade400,
        //   ),
        //   const SizedBox(
        //     width: 8,
        //   ),
        // ],
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: AdWidget(ad: myBanner),
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
          ),
          // Image.asset("assets/343_94.png"),
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
              child: Text("00 ${ AppLocalizations.of(context)!.video}",
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
          // MyListWidget()
          MyListWidget()
        ],
      ),
    );
  }
}

class MyListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<FavouriteGetxController>(
      builder: (controller) {
        return controller.loading.isTrue
            ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : controller.videosItems.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),
                      SvgPicture.asset("assets/Group.svg",
                          semanticsLabel: 'Acme Logo'),
                      SizedBox(
                        height: 20.h,
                      ),
                       Text(
                        AppLocalizations.of(context)!.you_have_not_added_any_other_videos_to_your_favourites,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontFamily: 'avater'),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text.rich(
                        TextSpan(
                          text: AppLocalizations.of(context)!.you_can_go_to,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: 'avater'),
                          children: <TextSpan>[
                            TextSpan(
                              onEnter: (PointerEnterEvent) {
                                print("object");
                              },
                              text: AppLocalizations.of(context)!.add_videos_page,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffE20000),
                                  fontSize: 12.sp,
                                  fontFamily: 'avater'),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.and_you_add_videos_here,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontFamily: 'avater'),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : GridView.builder(
                    itemCount: controller.videosItems.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 260 / 300),
                    itemBuilder: (context, index) {
                      return FavItemWidget(
                        video: controller.videosItems[index],
                        index: index,
                      );
                    });
      },
    );
  }
}
