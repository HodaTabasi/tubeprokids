import 'package:apptubey/models/play_list_modle.dart';
import 'package:apptubey/screens/play_list/add_video_to_play_list.dart';
import 'package:apptubey/screens/play_list/btn_layout.dart';
import 'package:apptubey/screens/play_list/home_Video_item_widget.dart';
import 'package:apptubey/screens/play_list/play_all_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../get/play_list_getx_controller.dart';
import '../../get/video_getx_controller.dart';
import '../constant.dart';
import '../my_vedio/show_offerring.dart';
import '../video_ditails/d_video_item_widget.dart';
import '../video_ditails/video_d.dart';

class PlayList extends StatefulWidget {
  PlayListModel id;

  PlayList(this.id);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  PlayListGetxController playListGetxController = PlayListGetxController.to;
  var _value = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 0), () {
      playListGetxController.getVideoFromPlayList(widget.id.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title: Text(
          AppLocalizations.of(context)!.play_list  ,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ))
        ],
      ),
      body: Obx(() {
        return playListGetxController.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : playListGetxController.playList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(children: [
                      Text(
                        widget.id.name!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: 'avater',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: BtnLayout(
                              title:
                                  AppLocalizations.of(context)!.play_play_list ,
                              value: 0,
                              groupValue: _value,
                              onChanged: (value) => setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PlayAllScreen(0, widget.id.name!)));
                                // NewAccountGetxController.to.changeIsCitizen(true);
                              }),
                            ),
                          ),
                          Opacity(
                            opacity: 1,
                            child: BtnLayout(
                                title: AppLocalizations.of(context)!.add_video,
                                value: 1,
                                groupValue: _value,
                                onChanged: (value) {
                                  print(VideoGetxController.to.userVideos.length);
                                  if (VideoGetxController
                                          .to.userVideos.length >= AppConstant.VIDEO_LIMIT_LENTH) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                showOffering()));
                                    // context.showSnackBar(
                                    //   message: AppLocalizations.of(context)!
                                    //       .have_exceeded_the_maximum_number_of_videos_for_the_free_account,
                                    //   error: true,
                                    // );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddVideoToPlayList(widget.id)));
                                  }
                                }),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${playListGetxController.playList.length} ${AppLocalizations.of(context)!.video}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontFamily: 'avater',
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(height: 10,),
                              itemCount: playListGetxController.playList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                

                      //            return DVideoItemWidget(
                      //         video: playListGetxController.playList[index],
                      //         index: index,
                      //         click: (){
                      //               Navigator.push(
                      //            context,
                      //      MaterialPageRoute(
                      //       builder: (context) =>
                      //         VideoDitails1(currentVideo: playListGetxController.playList[index])
                      //         // DetailPage(currentVideo: widget.video)
                      //    ));
                      // }

                      //       );
                            // return Container();

                                return HomeVideoItemWidget(
                                    playListGetxController.playList[index],
                                    index: index,
                                    name: widget.id.name!,
                                    id: widget.id.id,onTap: (name) {
                                      Navigator.pushReplacement(
                                      context,
                                       MaterialPageRoute(
                                           builder: (context) => PlayAllScreen(index, name)));
                                    },
                                    );
                              }),
                        ],
                      ),
                    ]))
                : Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Opacity(
                              opacity: 0.0,
                              child: BtnLayout(
                                title: AppLocalizations.of(context)!
                                    .play_play_list,
                                value: 0,
                                groupValue: _value,
                                onChanged: (value) => setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayAllScreen(
                                              0, widget.id.name!)));
                                  // NewAccountGetxController.to.changeIsCitizen(true);
                                }),
                              ),
                            ),
                            BtnLayout(
                                title: AppLocalizations.of(context)!.add_video,
                                value: 0,
                                groupValue: _value,
                                onChanged: (value) {
                                  print(VideoGetxController.to.userVideos.length);
                                  if (VideoGetxController
                                      .to.userVideos.length >= AppConstant.VIDEO_LIMIT_LENTH) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                showOffering()));
                                    // context.showSnackBar(
                                    //   message: AppLocalizations.of(context)!
                                    //       .have_exceeded_the_maximum_number_of_videos_for_the_free_account,
                                    //   error: true,
                                    // );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddVideoToPlayList(widget.id)));
                                  }
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SvgPicture.asset("assets/noVideos.svg",
                            semanticsLabel: 'Acme Logo'),
                        SizedBox(
                          height: 10.h,
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 80.w),
                        //   child: Text.rich(
                        //     TextSpan(
                        //       text: AppLocalizations.of(context)!
                        //           .and_you_add_videos_here,
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.normal,
                        //         color: Colors.black,
                        //         fontSize: 12.sp,
                        //         fontFamily: 'avater',
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  );
      }),
    );
  }
}
