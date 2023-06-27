import 'dart:developer';

import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../firebase/fb_firestore.dart';
import '../../get/favourite_getx_controller.dart';
import '../../get/video_getx_controller.dart';
import '../../helper/helper.dart';
import '../../models/fb_response.dart';
import '../../models/video_model.dart';
import '../add_video/add_video.dart';

class VideoDitailsF extends StatefulWidget {
  static String routeName = "/video_details";
  final Video currentVideo;

  const VideoDitailsF({super.key, required this.currentVideo});

  @override
  State<VideoDitailsF> createState() => _VideoDitailsFState();
}

class _VideoDitailsFState extends State<VideoDitailsF> with Helpers {
  late YoutubePlayerController _controller;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    String? id =
    YoutubePlayer.convertUrlToId(FavouriteGetxController.to.currentUrl);
    _controller = YoutubePlayerController(
      initialVideoId: id!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted) {
      //&& !_controller.value.isFullScreen
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    FavouriteGetxController.to.startAt = 0;
    FavouriteGetxController.to.isHideController = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(

         onExitFullScreen: () {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
          },
          
          
        // onExitFullScreen: () {
        //   // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        // },
        // onEnterFullScreen: () {
        //   SystemChrome.setPreferredOrientations([]);
        //   //DeviceOrientation.landscapeLeft
        //   isFullScreen = true;
        // },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
             topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              log('Settings Tapped!');
            },
          ),
        ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            if (FavouriteGetxController.to.index <
                FavouriteGetxController.to.videosItems.length - 1) {
              String? id = YoutubePlayer.convertUrlToId(FavouriteGetxController
                  .to.videosItems[++FavouriteGetxController.to.index].url);
              _controller.load(id!);
            }
          }
  
        ),
        builder: (context, player) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xffF2F2F2),
              title: Text(
                AppLocalizations.of(context)!.video_description,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'avater'),
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(
                        text: FavouriteGetxController
                            .to.videosItems[FavouriteGetxController.to.index].url));
                    showAlertDialog(context);
                  },
                  child: Icon(
                    Icons.copy,
                    size: 25.r,
                    color: Colors.grey.shade400,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                InkWell(
                  onTap: () {
                    _deleteVideo(
                        context,
                        FavouriteGetxController
                            .to.videosItems[FavouriteGetxController.to.index].id);
                  },
                  child: Icon(
                    Icons.delete,
                    size: 25.r,
                    color: Colors.red.shade400,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => AddVideo(
                                  currentVideo: FavouriteGetxController
                                      .to.videosItems[FavouriteGetxController.to.index],
                                ))));
                  },
                  child: Icon(
                    Icons.edit,
                    size: 25.r,
                    color: Colors.blue.shade400,
                  ),
                ),
              ],
              elevation: 0,
              centerTitle: true,
            ),
            body: ListView(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _controller != null
                      ? Stack(children: [
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: player,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 9.h,
                            left: MediaQuery.of(context).size.width / 1.5.w,
                            child: Visibility(
                              visible: !_controller.value.isPlaying,
                              child: IconButton(
                                onPressed: () {
                                  if (FavouriteGetxController.to.index <
                                      FavouriteGetxController.to.videosItems.length -
                                          1) {
                                    FavouriteGetxController.to.changeListIndexP();
                                    String? id = YoutubePlayer.convertUrlToId(
                                        FavouriteGetxController
                                            .to
                                            .videosItems[
                                                FavouriteGetxController.to.index]
                                            .url);
                                    _controller.load(id!);
                                  } else {
                                    context.showSnackBar(
                                        message: AppLocalizations.of(context)!
                                            .no_video,
                                        error: true);
                                  }
                                },
                                icon:
                                    Icon(Icons.skip_next, color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 9.h,
                            right: MediaQuery.of(context).size.width / 1.5.w,
                            child: Visibility(
                              visible: !_controller.value.isPlaying,
                              child: IconButton(
                                onPressed: () {
                                  if (FavouriteGetxController.to.index > 0) {
                                    FavouriteGetxController.to.changeListIndexM();
                                    String? id = YoutubePlayer.convertUrlToId(
                                        FavouriteGetxController
                                            .to
                                            .videosItems[
                                                FavouriteGetxController.to.index]
                                            .url);
                                    _controller.load(id!);
                                  } else {
                                    context.showSnackBar(
                                        message: AppLocalizations.of(context)!
                                            .no_video,
                                        error: true);
                                  }
                                },
                                icon: Icon(Icons.skip_previous,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ])
                      : const Center(child: CircularProgressIndicator()),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(onPressed: (){
                //       if(FavouriteGetxController.to.index < FavouriteGetxController.to.videos.length){
                //
                //         FavouriteGetxController.to.changeListIndexP();
                //         FavouriteGetxController.to.setCurentUrl(FavouriteGetxController.to.videos[FavouriteGetxController.to.index].url);
                //         Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (BuildContext context) => super.widget));
                //       }else {
                //         context.showSnackBar(
                //             message: "انتهت القائمة", error: true);
                //       }
                //     }, icon: Icon(Icons.fast_forward_outlined)),
                //     IconButton(onPressed: (){
                //       print(_controller.value.isControlsVisible);
                //       // setState(() {
                //       //   _controller.updateValue(YoutubePlayerValue(
                //       //     isControlsVisible: !_controller.value.isControlsVisible,
                //       //   ));
                //       // });
                //       FavouriteGetxController.to.saveIsControlHide(_controller.value.position.inSeconds);
                //       _controller.updateValue(YoutubePlayerValue(
                //         isControlsVisible: FavouriteGetxController.to.isHideController,
                //       ));
                //       // Navigator.pushReplacement(
                //       //     context,
                //       //     MaterialPageRoute(
                //       //         builder: (BuildContext context) => super.widget));
                //     }, icon: Icon(Icons.lock_outline)),
                //     IconButton(onPressed: (){
                //       if(FavouriteGetxController.to.index >= 0){
                //
                //         FavouriteGetxController.to.changeListIndexM();
                //         print(FavouriteGetxController.to.index);
                //         FavouriteGetxController.to.setCurentUrl(FavouriteGetxController.to.videos[FavouriteGetxController.to.index].url);
                //         Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (BuildContext context) => super.widget));
                //       }else {
                //         context.showSnackBar(
                //             message: "انتهت القائمة", error: true);
                //       }
                //     }, icon: Icon(Icons.fast_rewind_outlined)),
                //   ],
                // ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.r),
                  child: Text(
                    FavouriteGetxController
                        .to.videosItems[FavouriteGetxController.to.index].title,
                    style: TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Text(
                    "${AppLocalizations.of(context)!.added_date} ${FavouriteGetxController.to.videosItems[FavouriteGetxController.to.index].date}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Text(AppLocalizations.of(context)!.video_description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontFamily: 'avater',
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0.r),
                      child: Text(
                        FavouriteGetxController.to
                            .videosItems[FavouriteGetxController.to.index].description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontFamily: 'avater',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  // Widget i_buildYtbView() {
  //   return AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: _controller != null
  //         ? Column(
  //       children: [
  //         Stack(
  //           children: [
  //             YoutubePlayerIFrame(
  //               aspectRatio: 16/9,
  //
  //               controller: _controller,
  //
  //
  //             ),
  //
  //             Positioned(
  //               top: 50,bottom: 50,right: MediaQuery.of(context).size.width*0.15,left: MediaQuery.of(context).size.width*0.15,
  //               child: YoutubePlayerControllerProvider(
  //                   controller: _controller,
  //
  //                   child:  Column(children: [
  //                     YoutubeValueBuilder(
  //                       builder: (context,value){
  //                         return Visibility(
  //                           visible:  _controller.value.playerState == PlayerState.paused?true:false,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             // crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               IconButton(
  //                                 icon: const  Icon( Icons.skip_previous,color: Colors.white,size: 35, ),
  //                                 onPressed: _controller.previousVideo,
  //                               ),
  //                               SizedBox(width: 170,),
  //
  //                               IconButton(
  //                                 icon: const Icon(Icons.skip_next,color: Colors.white,size: 35,),
  //                                 onPressed: _controller.nextVideo,
  //                               ),
  //
  //                             ],
  //                           ),);
  //                       },
  //
  //                     ),
  //
  //
  //
  //                   ],)
  //               ),),
  //
  //
  //
  //           ],
  //
  //         ),
  //
  //       ],
  //     )
  //          ),
  //   );
  // }

  void _deleteVideo(BuildContext context, String id) async {
    FbResponse fbResponse = await FbFirestoreController().delete(id);
    if (fbResponse.success) {
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    }
    context.showSnackBar(
        message: fbResponse.message, error: !fbResponse.success);
  }
}
