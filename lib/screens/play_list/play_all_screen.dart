import 'package:apptubey/screens/play_list/d_video_item_playlist.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../get/play_list_getx_controller.dart';
import '../../helper/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/video_model.dart';
import 'home_Video_item_widget.dart';

class PlayAllScreen extends StatefulWidget {
  int index;
  String name;

  PlayAllScreen(this.index, this.name);

  @override
  State<PlayAllScreen> createState() => _PlayAllScreenState();
}

class _PlayAllScreenState extends State<PlayAllScreen> with Helpers {
  PlayListGetxController playListGetxController= PlayListGetxController.to;
  late YoutubePlayerController _controller;
    bool _muted = false;


  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  bool isFullScreen = false;

  @override
  initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {

    String? id = YoutubePlayer.convertUrlToId(playListGetxController.playList[widget.index].url);
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
    // if (_isPlayerReady && mounted) {
    //   //&& !_controller.value.isFullScreen
    //   setState(() {
    //     _playerState = _controller.value.playerState;
    //     _videoMetaData = _controller.metadata;
    //   });
    // }
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
        onReady: () {
          setState(() {
                      _isPlayerReady = true;

          });
          _controller.addListener(listener);
        },
        onEnded: (data) {
          if (widget.index <
              playListGetxController.playList.length - 1) {
            String? id = YoutubePlayer.convertUrlToId(playListGetxController.playList[++widget.index].url);
            _controller.load(id!);
            _controller.notifyListeners();
          }else {
            widget.index = 0;
            String? id = YoutubePlayer.convertUrlToId(playListGetxController.playList[widget.index].url);
            _controller.load(id!);
            _controller.notifyListeners();
          }
        },
      ),
      builder: (context, player) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xffF2F2F2),
            title: Text(
              widget.name  ,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'avater'),
            ),
            actions: [
              InkWell(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: ""));
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
              // InkWell(
              //   onTap: () {
              //     _deleteVideo(context, widget.currentVideo.id);
              //   },
              //   child: Icon(
              //     Icons.delete,
              //     size: 25.r,
              //     color: Colors.red.shade400,
              //   ),
              // ),

                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,))
            ],
            elevation: 0,
            centerTitle: true,
          ),
          body: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
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
                                if (widget.index < playListGetxController.playList.length - 1) {
                                  widget.index ++;
                                  String? id = YoutubePlayer.convertUrlToId(
                                      playListGetxController.playList[
                                      widget.index]
                                          .url);
                                  _controller.load(id!);
                                  _controller.notifyListeners();
                                } else {
                                  context.showSnackBar(
                                      message: AppLocalizations.of(context)!
                                          .no_video,
                                      error: true);
                                }
                              },
                              icon: Icon(Icons.skip_next, color: Colors.white),
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
                                if (widget.index > 0) {
                                  widget.index--;
                                  String? id = YoutubePlayer.convertUrlToId(
                                      playListGetxController.playList[widget.index]
                                          .url);
                                  _controller.load(id!);
                                  _controller.notifyListeners();
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


              GetBuilder<PlayListGetxController>(
              builder: (controller) {
                  return Text(
                    playListGetxController.playList[playListGetxController.index].title,
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
                  );
                }
              ),

               Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: _isPlayerReady
                                ? () { 
                                  List<Video> videos = PlayListGetxController.to.playList ;
                                  final index = PlayListGetxController.to.index - 1;
                                  if (index == -1) {return;}
                                   final video = videos[index];
                                  _controller.load(YoutubePlayer.convertUrlToId(video.url)!);
                                   PlayListGetxController.to.setCurentUrl(video.url,index:index );

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
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: _isPlayerReady
                                ? () {
                                  List<Video> videos = PlayListGetxController.to.playList ;
                                  final index = PlayListGetxController.to.index + 1;
                                  if (index == videos.length) {return;}
                                   final video = videos[index];
                                  _controller.load(YoutubePlayer.convertUrlToId(video.url)!);
                                   PlayListGetxController.to.setCurentUrl(video.url,index:index );
                                  }
                                :
                                 null,
                          ),
                        ],
                      ),
                 

              GetX<PlayListGetxController>(
                builder: (controller) {
                  return controller.isLoading.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.red,
                          ),
                        )
                      : controller.playList.isEmpty
                          ? Column(
                              children: [
                                SvgPicture.asset("assets/noVideos.svg",
                                    semanticsLabel: 'Acme Logo'),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 80.w),
                                  child: Text.rich(
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .and_you_add_videos_here,
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontFamily: 'avater',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 12,),
                                itemCount: controller.playList.length,
                                // physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return DVideoItemPlayListWidget(
                                      video:  controller.playList[index], index: index,
                                      click: (){
                                        widget.index = index;
                                        controller.setCurentUrl(controller.playList[index].url);

                                        _controller.load(YoutubePlayer.convertUrlToId(controller.currentUrl)!);
                                        _controller.notifyListeners();
                                      }
                                  );
                                }),
                          );
                },
              ),
            ],
          )),
    );
  }
}
