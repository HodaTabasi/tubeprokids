import 'dart:io';

import 'package:apptubey/get/user_getx_controller.dart';
import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../firebase/fb_firestore.dart';
import '../../general/video_item.dart';
import '../../models/video_model.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoGetxController videoGetxController = Get.put(VideoGetxController());
  UserGetxController userGetxController = Get.put(UserGetxController());

  List myVideos = [];

  @override
  void initState() {
    super.initState();
    myBanner.load();
  }

  int get width => Get.width.toInt();

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-6698036413009346/3903471125'
        : 'ca-app-pub-6698036413009346/6501714304',
    sizes: [AdSize(width: Get.width.toInt(), height: 70)],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  @override
  Widget build(BuildContext context) {
    final AdSize adSize = AdSize(width: Get.width.toInt(), height: 70);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffF2F2F2),
          title: Text(
            AppLocalizations.of(context)!.home,
            style: TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'avater'),
          ),
          elevation: 0,
          centerTitle: true,

        ),
        bottomNavigationBar: SharedPrefController().getValueFor(key: PrefKeys.sub.name) == true ? SizedBox() :
                      Container(
                        width: adSize.width.toDouble(),
                        height: adSize.height.toDouble(),
                        child: AdWidget(ad: myBanner),
                      ),
        body: GetX<VideoGetxController>(
          builder: (controller) {
            return controller.isLoading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                : ListView(children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                          AppLocalizations.of(context)!.videos_selected_for_you,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontFamily: 'avater',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FbFirestoreController().readStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            var documents = fromDocToList(snapshot.data!.docs);
                            videoGetxController.updateVideosViews(documents);
                            return SizedBox(
                                height: 250,
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>const SizedBox(width: 10,),
                                    itemCount: documents.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(16.r),
                                    itemBuilder: (context, index) {
                                      return VideoItem(
                                        video: documents[index],
                                        isUser: false,
                                        index: index,
                                        width: MediaQuery.of(context).size.width * 0.8,
                                      );
                                    }));
                          } else {
                            return Center(
                              child: SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.warning,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.no_video,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        }),

                    // controller.videos.isEmpty
                    //     ? Center(
                    //         child: Text(AppLocalizations.of(context)!.no_video),
                    //       )
                    //     : SizedBox(
                    //         height: 200,
                    //         child: ListView.builder(
                    //             itemCount: controller.videos.length,
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //             padding: EdgeInsets.all(16.r),
                    //             itemBuilder: (context, index) {
                    //               return VideoItem(
                    //                 video: controller.videos[index],
                    //                 isUser: false,
                    //                 index: index,
                    //               );
                    //             })),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)!.my_video,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontFamily: 'avater',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    controller.userVideos.isEmpty
                        ? Column(
                            children: [
                              SvgPicture.asset("assets/noVideos.svg",
                                  semanticsLabel: 'Acme Logo'),
                              SizedBox(
                                height: 10.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80.w),
                                child: Text.rich(
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .you_can_go_to,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontFamily: 'avater',
                                    ),
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
                                ),
                              )
                            ],
                          )
                        : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: SizedBox(
                              height: 220,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>const SizedBox(width: 10,),
                                itemCount: controller.userVideos.length,
                                scrollDirection: Axis.horizontal,
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return VideoItem(
                                    video: controller.userVideos[index],
                                    isUser: true,
                                    index: index,
                                    width: Get.width - 120,
                                  );
                                },
                              )),
                        )
                  ]);
          },
        ));
  }

  List<Video> fromDocToList(docs) {
    List<Video> videos = [];
    for (int i = 0; i < docs.length; i++) {
      videos.add(Video.fromMap(docs[i].data()));
    }
    return videos;
  }
}
