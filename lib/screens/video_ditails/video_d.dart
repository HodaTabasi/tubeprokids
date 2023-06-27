import 'dart:developer';

import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../firebase/fb_firestore.dart';
import '../../get/video_getx_controller.dart';
import '../../helper/helper.dart';
import '../../models/fb_response.dart';
import '../../models/video_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../add_video/add_video.dart';
import '../play_list/play_list_buttom_sheet.dart';
import 'd_video_item_widget.dart';

class VideoDitails1 extends StatefulWidget {
  static String routeName = "/video_details";
  final Video currentVideo;

  const VideoDitails1({super.key, required this.currentVideo});

  @override
  State<VideoDitails1> createState() => _VideoDitails1State();
}

class _VideoDitails1State extends State<VideoDitails1> with Helpers {
  late YoutubePlayerController _controller;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  bool _muted = false;

  @override
  void initState() {

        String? id =
        YoutubePlayer.convertUrlToId(VideoGetxController.to.currentUrl);
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
      // ..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    VideoGetxController.to.updateViews(widget.currentVideo);
    
    super.initState();

  }

  // void listener() {
  //   if (_isPlayerReady) {
  //     // print(_isPlayerReady);
  //     //&& !_controller.value.isFullScreen
  //     setState(() {
  //       // _playerState = _controller.value.playerState;
  //       // _videoMetaData = _controller.metadata;
  //     });
  //   }
  // }

    void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
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
    VideoGetxController.to.startAt = 0;
    VideoGetxController.to.isHideController = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoGetxController>(builder: (controller) {
      return YoutubePlayerBuilder(
        // onEnterFullScreen: () {SystemChrome.setPreferredOrientations([]);
     
        // },

      //   onExitFullScreen: () {
      //   // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
      //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      // },

      onExitFullScreen: () {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
          },
          

    player:YoutubePlayer(
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
          onEndedViddeo(controller);
        },
      ),
              builder: (context, player) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: const Color(0xffF2F2F2),
                title: Text(
                  AppLocalizations.of(context)!.video ,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'avater'),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: buildSettingsRow(controller),
                  ),
                ],
                elevation: 0,
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal:0.0.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16.h / 9.w,
                      child: _controller != null
                          ? Stack(children: [
                              player,
                              
                              Positioned(
                                top: MediaQuery.of(context).size.height / 9.h,
                                left: MediaQuery.of(context).size.width / 1.5.w,
                                child: Visibility(
                                  visible: !_controller.value.isPlaying,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.userType) {
                                        if (controller.index <
                                            controller.userVideos.length -
                                                1) {
                                          controller
                                              .changeListIndexP();
                                          String? id = YoutubePlayer.convertUrlToId(controller.userVideos[controller.index].url);
                                          _controller.load(id!);
                                          _controller.notifyListeners();
                                        } else {
                                          controller
                                              .changeListIndexToZero();
                                          String? id =
                                          YoutubePlayer.convertUrlToId(
                                              controller.userVideos[controller.index].url);
                                          _controller.load(id!);
                                          _controller.notifyListeners();
                                          // context.showSnackBar(
                                          //     message:
                                          //         AppLocalizations.of(context)!
                                          //             .no_video,
                                          //     error: true);
                                        }
                                      } else {
                                        if (controller.index <
                                            controller.videos.length -
                                                1) {
                                          VideoGetxController.to
                                              .changeListIndexP();
                                          String? id =
                                              YoutubePlayer.convertUrlToId(
                                                  controller.videos[controller.index]
                                                      .url);
                                          _controller.load(id!);
                                          _controller.notifyListeners();
                                        } else {
                                          VideoGetxController.to
                                              .changeListIndexToZero();
                                          String? id =
                                          YoutubePlayer.convertUrlToId(
                                              controller.videos[controller.index]
                                                  .url);
                                          _controller.load(id!);
                                          _controller.notifyListeners();
                                          // context.showSnackBar(
                                          //     message:
                                          //         AppLocalizations.of(context)!
                                          //             .no_video,
                                          //     error: true);
                                        }
                                      }
                                    },
                                    icon: Icon(Icons.skip_next,
                                        color: Colors.white),
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
                                      if (controller.userType) {
                                        if (controller.index > 0) {
                                          controller.changeListIndexM();
                                          String? id =
                                              YoutubePlayer.convertUrlToId(
                                                  controller.userVideos[controller.index].url);
                                          _controller.load(id!);
                                          _controller.notifyListeners();
                                        } else {
                                          context.showSnackBar(
                                              message:AppLocalizations.of(context)!.no_video,
                                              error: true);
                                        }
                                      } else {
                                        if (controller.index > 0) {
                                          controller.changeListIndexM();
                                          String? id =
                                              YoutubePlayer.convertUrlToId(
                                                  controller.videos[controller.index]
                                                      .url);
                                          _controller.load(id!);
                                          _controller.notifyListeners();
                                        } else {
                                          context.showSnackBar(
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .no_video,
                                              error: true);
                                        }
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
                    //comment 2 here
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userType
                                ? controller
                                .userVideos[VideoGetxController.to.index]
                                .title
                                : controller
                                .videos[VideoGetxController.to.index].title,
                            style: GoogleFonts.tajawal(
                              color: Colors.black,
                              textStyle: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                              fontSize: 16.sp,
                              //fontFamily: 'avater',
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                          Row(children: [
                          Visibility(
                          visible: !controller.userType,child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4,),
                          Text( controller.userType
                                ? controller
                                .userVideos[VideoGetxController.to.index]
                                .views
                                : controller
                                .videos[VideoGetxController.to.index].views + " " + AppLocalizations.of(context)!.view  + " - " + widget.currentVideo.date,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'avater',
                            fontWeight: FontWeight.normal,
                          )),
                        ],
                      ),
                          )

                          ],)
                        ],
                      ),
                    ),

                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _isPlayerReady
                            ? () { 
                                    // List<Video> videos = controller.userType ? controller.userVideos : controller.videos ;
                                    // String? id = YoutubePlayer.convertUrlToId(controller.videos[--controller.index].url);
                      
                                // controller.setCurentUrl(video.url,index: index);
                      
                                // _controller.load(YoutubePlayer.convertUrlToId(controller.currentUrl)!);
                      
                                //     _controller.load(id!);
                                //     _controller.notifyListeners();
                      
                              List<Video> videos = controller.userType ? controller.userVideos : controller.videos ;
                              final index = controller.index - 1;
                              if (index == -1) {return;}
                               final video = videos[index];
                              _controller.load(YoutubePlayer.convertUrlToId(video.url)!);
                                controller.setCurentUrl(video.url,index:index );
                      
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: _isPlayerReady
                            ? () {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                setState(() {});
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.unMute()
                                    : _controller.mute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.black,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: _isPlayerReady
                            ? () {
                                 List<Video> videos = controller.userType ? controller.userVideos : controller.videos ;
                              final index = controller.index + 1;
                              if (index == videos.length) {return;}
                               final video = videos[index];
                              _controller.load(YoutubePlayer.convertUrlToId(video.url)!);
                                controller.setCurentUrl(video.url,index:index );
                              }
                            :
                             null,
                      ),
                                        ],
                                      ),

                    Visibility(
                      visible: controller.userType,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                foregroundColor: Colors.red),
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: false,
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => PlayListButtomSheet(
                                    controller.userType
                                        ? controller.userVideos[
                                    controller.index]
                                        : controller.videos[
                                    controller.index]),
                              );
                              // displayTextInputDialog(context,_controller,urls[dataManager.currentPlaying]);
                            },
                            child: Text(AppLocalizations.of(context)!.save_play_list,style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontFamily: 'avater',
                  fontWeight: FontWeight.bold,
               ))),
                      ),
                    ),
                    //////////////////////
                    Expanded(
                      child: ListView.separated(
                        // itemCount: 20,
                        separatorBuilder: (context, index) => SizedBox(height: 12,),
                          itemCount: controller.userType
                              ? controller.userVideos.length
                              : controller.videos.length,
                           scrollDirection: Axis.vertical,
                          //  shrinkWrap: true,
                          // physics: ClampingScrollPhysics(),
                          // physics: const NeverScrollableScrollPhysics(),
                          // padding: EdgeInsets.all(16.r),
                          itemBuilder: (context, index) {
                            return DVideoItemWidget(
                              video: controller.userType
                                  ? controller.userVideos[index]
                                  : controller.videos[index],
                              index: index,
                              click: (){
                                if(controller.userType && controller.userVideos[index].url == controller.currentUrl){
                                  return;
                                }else if(!controller.userType && controller.videos[index].url == controller.currentUrl) {
                                  return;
                                }
                                final video = controller.userType ? controller.userVideos[index] : controller.videos[index];
                                controller.setCurentUrl(video.url,index: index);
                                
                                controller.updateViews(video);
                                _controller.load(YoutubePlayer.convertUrlToId(controller.currentUrl)!);
                              }

                            );
                          }),
                    )
                  ],
                ),
              ),
          ));
    });
  }

  Future<void> _displayDialog(BuildContext context,id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:  Text(AppLocalizations.of(context)!.are_you_sure_delete),
            actions: <Widget>[
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  _deleteVideo(context,id);
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
  void _deleteVideo(BuildContext context, String id) async {
    FbResponse fbResponse = await FbFirestoreController().delete(id);
    if (fbResponse.success) {
      // deeeeeeee
      Navigator.pushReplacementNamed(context, '/bottom_nav');
    }
    context.showSnackBar(
        message: fbResponse.message, error: !fbResponse.success);
  }

  Widget buildSettingsRow(VideoGetxController controller){
    return Row(children: [
       Visibility(
                    visible: controller.userType,
                    child: InkWell(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(
                            text: controller.userType
                                ? controller
                                    .userVideos[controller.index].url
                                : controller
                                    .videos[controller.index].url));
                        showAlertDialog(context);
                      },
                      child: Icon(
                        Icons.copy,
                        size: 25.r,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Visibility(
                    visible: controller.userType,
                    child: InkWell(
                      onTap: () {
                        _displayDialog(context, controller.userType
                            ? controller
                            .userVideos[controller.index].id
                            : controller.videos[controller.index].id);

                      },
                      child: Icon(
                        Icons.delete,
                        size: 25.r,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ),
                   const SizedBox(
                    width: 12,
                  ),
                  Visibility(
                    visible: controller.userType,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AddVideo(
                                      currentVideo: controller.userType
                                              ? controller.userVideos[controller.index]
                                              : controller.videos[controller.index],
                                    ))));
                      },
                      child: Icon(
                        Icons.edit,
                        size: 25.r,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ),
    ],);
  }

  void onEndedViddeo(VideoGetxController controller){
       if (controller.userType) {
                if (controller.index <
                    controller.userVideos.length - 1) {
                  String? id = YoutubePlayer.convertUrlToId(controller.userVideos[++controller.index].url);
                  _controller.load(id!);
                  _controller.notifyListeners();
                }else {
                  controller.changeListIndexToZero();
                  String? id = YoutubePlayer.convertUrlToId(controller.userVideos[controller.index].url);
                  _controller.load(id!);
                  _controller.notifyListeners();
                }
              } else {
                if (controller.index <
                    controller.videos.length - 1) {
                  String? id = YoutubePlayer.convertUrlToId(controller.videos[++controller.index].url);
                  _controller.load(id!);
                  _controller.notifyListeners();
                }else {
                  controller.changeListIndexToZero();
                  String? id = YoutubePlayer.convertUrlToId(controller.videos[controller.index].url);
                  _controller.load(id!);
                  _controller.notifyListeners();
                }
              }
  }
}
