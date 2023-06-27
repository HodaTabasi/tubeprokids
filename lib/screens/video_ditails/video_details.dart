import 'package:apptubey/screens/video_ditails/videoheader.dart';
import 'package:apptubey/screens/video_ditails/videolist.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../get/video_getx_controller.dart';
import '../../models/video_model.dart';


class DetailPage extends StatefulWidget {
  static String routeName = "/video_details";
  final Video currentVideo;

  final List<String> links=["iMEhjsiHbwM","vZPOiMzUBCE","aJOTlE1K90k","pRpeEdMmmQ0","GXoErccq0vw","iMEhjsiHbwM","vZPOiMzUBCE","aJOTlE1K90k","pRpeEdMmmQ0","GXoErccq0vw"];
  DetailPage({
    Key? key,
    required this.currentVideo,

  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  ScrollController? _scrollViewController;
    late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
    late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    super.initState();
     _scrollViewController = new ScrollController();
      String? id =
        YoutubePlayer.convertUrlToId(VideoGetxController.to.currentUrl);
    _controller = YoutubePlayerController(
      initialVideoId: id!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        hideControls: VideoGetxController.to.isHideController,
        // controlsVisibleAtStart: false,
         showLiveFullscreenButton: true,
        // hideThumbnail: true,
        // useHybridComposition: false,
        startAt: VideoGetxController.to.startAt,),
    );
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: _buildScaffoldContent(context));
  }

  Widget _buildScaffoldContent(BuildContext context) {
    return  GetBuilder<VideoGetxController>(builder: (controller) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 180,
              pinned: false,
              floating: true,
              forceElevated: true,
              flexibleSpace: _buildSliverAppBarContent(controller),
               
            ),
            _buildPageBody(context,controller)
          ],
        );
      }
    );
  }

  FlexibleSpaceBar _buildSliverAppBarContent(VideoGetxController controller) {
    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            widget.currentVideo.url,
            fit: BoxFit.cover,
          ),
          
          Container(
            child: videoPlayer(controller),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.15, 0.5],
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        


        ],
      ),
    );
  }

  Widget _buildPageBody(BuildContext context,VideoGetxController controller) {
    return _buildVideoDetailList(context,controller);
  }

  Widget _buildVideoDetailList(BuildContext context,VideoGetxController controller) {
    return new SliverFillRemaining(
        child: Scaffold(
        body: DetailsTab(widget: widget,controller: controller,),

            ));
  } 


  Widget videoPlayer(VideoGetxController controller){
   return YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            
            progressColors:const ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
            // aspectRatio: 19.h/6.w,
            progressIndicatorColor: Colors.blueAccent,
            onReady: () {
              setState(() {
                _isPlayerReady = true;
              });
              _controller.addListener(listener);
            },
            onEnded: (data) {
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
            },    
          );
  }

    void listener() {
    if (_isPlayerReady) {
      // print(_isPlayerReady);
      //&& !_controller.value.isFullScreen
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

}

class DetailsTab extends StatelessWidget {
  final VideoGetxController controller;
  const DetailsTab({
    Key? key,
    required this.widget,
    required this.controller,

  }) : super(key: key);

  final DetailPage widget;

  @override
  Widget build(BuildContext context) {
    return VideoList(videoHeader: VideoHeader(title:widget.currentVideo.title,subtitle:widget.currentVideo.title),links: widget.links, videos: controller.userType
                              ? controller.userVideos
                              : controller.videos,);
  }
}
