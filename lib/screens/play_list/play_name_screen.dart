import 'dart:io';

import 'package:apptubey/get/play_list_getx_controller.dart';
import 'package:apptubey/screens/play_list/play_list_screen.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../models/fb_response.dart';
import '../../preferences/shared_pref_controller.dart';
import '../../utils/helpers.dart';
import '../constant.dart';
import '../my_vedio/show_offerring.dart';

class PlayNameScreen extends StatefulWidget {
  static String routeName = "/play_name_screen";

  const PlayNameScreen({super.key});

  @override
  State<PlayNameScreen> createState() => _PlayNameScreenState();
}

class _PlayNameScreenState extends State<PlayNameScreen> with ApiHelpers{
  PlayListGetxController playListGetxController =
      Get.put(PlayListGetxController());
  final _controller = TextEditingController();

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-6698036413009346/3903471125'
        : 'ca-app-pub-6698036413009346/6501714304',
    sizes: [AdSize(width: Get.width.toInt(), height: 70)],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );
  
  var index = 10000;

  @override
  void initState() {
    myBanner.load();
    playListGetxController.getPlayListName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdSize adSize =  AdSize(width: Get.width.toInt(), height: 70);
    return Scaffold(
      bottomNavigationBar:   Container(
              alignment: Alignment.center,
              width: adSize.width.toDouble(),
              height: adSize.height.toDouble(),
              child: AdWidget(ad: myBanner),
            ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffF2F2F2),
          title: Text(
            AppLocalizations.of(context)!.play_list ,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'avater'),
          ),
          elevation: 0,
          centerTitle: true,
          // actions: [
          //   IconButton(onPressed: (){
          //     Navigator.pop(context);
          //   }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,))
          // ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            if(!SharedPrefController().getValueFor(key: PrefKeys.sub.name))
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
                child: Text(" ${AppLocalizations.of(context)!.play_list}",
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
            ListTile(
              onTap: () {
                if(!SharedPrefController().getValueFor(key: PrefKeys.sub.name)){
                  if(playListGetxController.playListModel.length < 3){
                    displayTextInputDialog(context,
                        textFieldController: _controller);

                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>showOffering()));
                    // showSnackBar(context, message: AppLocalizations.of(context)!.no_m,error: true);
                  }
                } else {
                  displayTextInputDialog(context,
                      textFieldController: _controller);
                }


              },
              leading: const Icon(Icons.add),
              title: Text(
                AppLocalizations.of(context)!.new_list ,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontFamily: 'avater',
                  fontWeight: FontWeight.normal,
                ),
              ),
              // contentPadding: EdgeInsets.all(0),
            ),
            GetX<PlayListGetxController>(
              builder: (controller) {
                return controller.isLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.playListModel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35.0.w),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayList(
                                        controller.playListModel[index]),
                                  ),
                                );
                              },
                              title: Text(
                                controller.playListModel[index].name!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontFamily: 'avater',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              subtitle: Text(
                                "${controller.playListModel[index].vedios!.length}    ${AppLocalizations.of(context)!.video}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'avater',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              trailing: this.index != index
                                  ? IconButton(
                                      onPressed: () async {
                                        await _displayDialog(
                                            context, index, controller);
                                      },
                                      icon:  Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20.r,
                                      ),
                                    )
                                  :  SizedBox(
                                      width: 15.w,
                                      height: 15.h,
                                      child:  CircularProgressIndicator(
                                        strokeWidth: 2.r,
                                      )),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      );
              },
            ),
          ],
        ));
  }

  Future<void> _displayDialog(BuildContext context, index, controller) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:  Text(AppLocalizations.of(context)!.are_you_sure_delete_playlist),
            actions: <Widget>[
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  setState(() {
                    this.index = index;
                  });
                  FbResponse fbResponse = await controller
                      .deletePlayList(controller.playListModel[index].id);
                  if (fbResponse.success) {
                    context.showSnackBar(
                        message: fbResponse.message,
                        error: !fbResponse.success);
                    Navigator.pop(context);
                  }
                  setState(() {
                    this.index = 10000;
                  });
                },
              ),
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.back,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
