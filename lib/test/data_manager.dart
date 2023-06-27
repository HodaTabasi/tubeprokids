// import 'dart:async';
//
// import 'package:apptubey/models/video_model.dart';
// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:video_player/video_player.dart';
//
// import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploed;
//
// class DataManager {
//   DataManager({required this.flickManager, required this.urls});
//
//   int currentPlaying = 0;
//   final FlickManager flickManager;
//   final List<Video> urls;
//
//   late Timer videoChangeTimer;
//
//   static String _getVideoId(String url) {
//     try {
//       var id = '';
//       id = url.substring(url.indexOf('?v=') + '?v='.length);
//
//       return id;
//     } catch (e) {
//       return "";
//     }
//   }
//
//   Future<String> convertToMP4(String vedioUrl) async {
//     var yt = exploed.YoutubeExplode();
//     var streamInfo = await yt.videos.streamsClient.getManifest(_getVideoId(vedioUrl));
//
//     yt.close();
//     return streamInfo.video.first.url.toString();
//   }
//
//   Future<String> getNextVideo() async {
//     currentPlaying++;
//     return await convertToMP4(urls[currentPlaying].url);
//   }
//
//   bool hasNextVideo() {
//     return currentPlaying != urls.length - 1;
//   }
//
//   bool hasPreviousVideo() {
//     return currentPlaying != 0;
//   }
//
//   skipToNextVideo([Duration? duration]) async {
//     if (hasNextVideo()) {
//       flickManager.handleChangeVideo(
//           VideoPlayerController.network(await convertToMP4(urls[currentPlaying + 1].url)),
//           videoChangeDuration: duration);
//
//       currentPlaying++;
//     }
//   }
//
//   skipToPreviousVideo() async {
//     if (hasPreviousVideo()) {
//       currentPlaying--;
//       flickManager.handleChangeVideo(
//           VideoPlayerController.network(await convertToMP4(urls[currentPlaying].url)));
//     }
//   }
//
//   cancelVideoAutoPlayTimer({required bool playNext}) {
//     if (playNext != true) {
//       currentPlaying--;
//     }
//
//     flickManager.flickVideoManager
//         ?.cancelVideoAutoPlayTimer(playNext: playNext);
//   }
// }
