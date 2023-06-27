// import 'dart:io';
//
// import 'package:apptubey/firebase/fb_firestore.dart';
// import 'package:apptubey/get/favourite_getx_controller.dart';
// import 'package:apptubey/get/video_getx_controller.dart';
// import 'package:apptubey/models/fb_response.dart';
// import 'package:apptubey/models/video_model.dart';
// import 'package:apptubey/utils/context_extenssion.dart';
// import 'package:flick_video_player/flick_video_player.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:pod_player/pod_player.dart';
// import 'package:video_player/video_player.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart' as exploed;
//
// import '../../helper/helper.dart';
// import '../../test/controls.dart';
// import '../../test/data_manager.dart';
// import '../add_video/add_video.dart';
// import '../constant.dart';
// import '../play_list/play_list_buttom_sheet.dart';
//
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class VideoDitails extends StatefulWidget {
//   static String routeName = "/video_details";
//   final Video currentVideo;
//   bool? isUser;
//   bool isFav = false;
//
//   VideoDitails({required this.currentVideo, this.isUser, this.isFav = false});
//
//   @override
//   State<VideoDitails> createState() => _VideoDitailsState();
// }
//
// class _VideoDitailsState extends State<VideoDitails> with Helpers {
//   VideoGetxController videoGetxController = Get.put(VideoGetxController());
//
//   late FlickManager flickManager;
//   late DataManager dataManager;
//   late List<Video> urls;
//   AdManagerInterstitialAd? _interstitialAd;
//
//   bool isLoading = false;
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
//
//   Future<String> convertToMP4(String vedioUrl) async {
//     var yt = exploed.YoutubeExplode();
//     var streamInfo = await yt.videos.streamsClient.getManifest(_getVideoId(vedioUrl));
//     yt.close();
//     return streamInfo.video.first.url.toString();
//   }
//
//   @override
//   initState()  {
//     super.initState();
//     getData();
//     videoGetxController.updateViews(widget.currentVideo);
//   }
//
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//     AdManagerInterstitialAd.load(
//         adUnitId:
//             Platform.isAndroid ? 'ca-app-pub-6698036413009346/2842752467' : 'ca-app-pub-6698036413009346/1215698225',
//         request: AdManagerAdRequest(),
//         adLoadCallback: AdManagerInterstitialAdLoadCallback(
//           onAdLoaded: (AdManagerInterstitialAd ad) {
//             // Keep a reference to the ad so you can show it later.
//             this._interstitialAd = ad;
//             setState(() {
//               isLoading = true;
//             });
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('InterstitialAd failed to load: $error');
//           },
//         ));
//   }
//
//   Future<void> getData() async {
//     urls = !widget.isFav
//         ? widget.isUser!
//             ? VideoGetxController.to.userVideos.value
//             : VideoGetxController.to.videos.value
//         : FavouriteGetxController.to.videosItems;
//     flickManager = FlickManager(
//       videoPlayerController: VideoPlayerController.network(
//           await convertToMP4(urls
//               .where((element) => element.id == widget.currentVideo.id)
//               .first
//               .url),
//           videoPlayerOptions: VideoPlayerOptions(
//               allowBackgroundPlayback: false, mixWithOthers: false)),
//       onVideoEnd: () async {
//         await dataManager.skipToNextVideo(Duration(seconds: 5));
//         setState(() {});
//       },
//     );
//
//     dataManager = DataManager(flickManager: flickManager, urls: urls);
//     dataManager.currentPlaying =
//         urls.indexWhere((element) => element.id == widget.currentVideo.id);
//   }
//
//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       _interstitialAd!.show();
//     }
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: const Color(0xffF2F2F2),
//           title: Text(
//             AppLocalizations.of(context)!.video,
//             style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 fontFamily: 'avater'),
//           ),
//           actions: [
//             InkWell(
//               onTap: () async {
//                 await Clipboard.setData(
//                     ClipboardData(text: widget.currentVideo.url));
//                 showAlertDialog(context);
//               },
//               child: Icon(
//                 Icons.copy,
//                 size: 25.r,
//                 color: Colors.grey.shade400,
//               ),
//             ),
//             SizedBox(
//               width: 8.w,
//             ),
//             InkWell(
//               onTap: () {
//                 _deleteVideo(context, widget.currentVideo.id);
//               },
//               child: Icon(
//                 Icons.delete,
//                 size: 25.r,
//                 color: Colors.red.shade400,
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: ((context) => AddVideo(
//                               currentVideo: widget.currentVideo,
//                             ))));
//               },
//               child: Icon(
//                 Icons.edit,
//                 size: 25.r,
//                 color: Colors.blue.shade400,
//               ),
//             ),
//           ],
//           elevation: 0,
//           centerTitle: true,
//         ),
//         body: FutureBuilder<void>(
//           future: getData(),
//           builder: ((context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.connectionState == ConnectionState.done) {
//               return VisibilityDetector(
//                   key: ObjectKey(flickManager),
//                   onVisibilityChanged: (visibility) {
//                     if (visibility.visibleFraction == 0 && this.mounted) {
//                       flickManager.flickControlManager?.autoPause();
//                     } else if (visibility.visibleFraction == 1) {
//                       flickManager.flickControlManager?.autoResume();
//                     }
//                   },
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(8.0.r),
//                         child: Stack(children: [
//                           FlickVideoPlayer(
//                             flickManager: flickManager,
//                             preferredDeviceOrientationFullscreen: [
//                               DeviceOrientation.portraitUp,
//                               DeviceOrientation.landscapeLeft,
//                               DeviceOrientation.landscapeRight,
//                             ],
//                             preferredDeviceOrientation: [
//                               DeviceOrientation.portraitUp,
//                               DeviceOrientation.landscapeLeft,
//                               DeviceOrientation.landscapeRight,
//                               DeviceOrientation.portraitDown,
//                             ],
//                             flickVideoWithControls: FlickVideoWithControls(
//                               controls: CustomOrientationControls(
//                                   dataManager: dataManager),
//                             ),
//                             flickVideoWithControlsFullscreen:
//                                 FlickVideoWithControls(
//                               videoFit: BoxFit.fitWidth,
//                               controls: CustomOrientationControls(
//                                   dataManager: dataManager),
//                             ),
//                           ),
//                         ]),
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0.r),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               urls[dataManager.currentPlaying].title,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 16.sp,
//                                 fontFamily: 'avater',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 3,
//                             ),
//                             ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.transparent,
//                                     elevation: 0,
//                                     foregroundColor: Colors.red),
//                                 onPressed: () {
//                                   showModalBottomSheet(
//                                     isScrollControlled: false,
//                                     backgroundColor: Colors.transparent,
//                                     context: context,
//                                     builder: (context) => PlayListButtomSheet(
//                                         urls[dataManager.currentPlaying]),
//                                   );
//                                   // displayTextInputDialog(context,_controller,urls[dataManager.currentPlaying]);
//                                 },
//                                 child: Text(AppLocalizations.of(context)!.save))
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(16.0.r),
//                         child: Text(
//                           " ${AppLocalizations.of(context)!.added_date} ${urls[dataManager.currentPlaying].date} ",
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14.sp,
//                             fontFamily: 'avater',
//                             fontWeight: FontWeight.normal,
//                           ),
//                           maxLines: 2,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(16.0.r),
//                         child: Text(
//                             AppLocalizations.of(context)!.video_description,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16.sp,
//                               fontFamily: 'avater',
//                               fontWeight: FontWeight.bold,
//                             )),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(16.0.r),
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16.r),
//                             color: Colors.white,
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.all(10.0.r),
//                             child: Text(
//                               urls[dataManager.currentPlaying].description,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 16.sp,
//                                 fontFamily: 'avater',
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ));
//             } else {
//               return Center(
//                 child: Text(
//                   AppLocalizations.of(context)!.no_video,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontFamily: 'Tajawal',
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               );
//             }
//           }),
//         ));
//     // return Scaffold(
//     //   body: PodVideoPlayer(controller: controller),
//     //     // body:FlickVideoPlayer(
//     //     //     flickManager: flickManager
//     //     // )
//     // );
//   }
//
//   void _deleteVideo(BuildContext context, String id) async {
//     FbResponse fbResponse = await FbFirestoreController().delete(id);
//     if (fbResponse.success) {
//       Navigator.pushReplacementNamed(context, '/bottom_nav');
//     }
//
//     context.showSnackBar(
//         message: fbResponse.message, error: !fbResponse.success);
//   }
// }
