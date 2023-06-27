// import 'package:apptubey/utils/context_extenssion.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
//
// import '../../firebase/fb_firestore.dart';
// import '../../get/video_getx_controller.dart';
// import '../../helper/helper.dart';
// import '../../models/fb_response.dart';
// import '../../models/video_model.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// import '../add_video/add_video.dart';
// import '../play_list/play_list_buttom_sheet.dart';
// import 'd_video_item_widget.dart';
//
// class videodd extends StatefulWidget {
//   final Video currentVideo;
//
//   const videodd({super.key, required this.currentVideo});
//
//
//   @override
//   State<videodd> createState() => _videoddState();
// }
//
// class _videoddState extends State<videodd> with Helpers {
//   bool autoPlay = false;
//  late YoutubePlayerController _controller;
//
//   bool  isFullScreen = false;
//   @override
//   void initState() {
//     _controller = YoutubePlayerController(
//       params: const YoutubePlayerParams(
//         showFullscreenButton: true,
//         enableCaption: false,
//         enableKeyboard: false,
//         showVideoAnnotations: false,
//         playsInline: false,
//         enableJavaScript: false,
//         showControls: false,
//         loop: false,
//         strictRelatedVideos: true,
//
//         // showControls: false,
//       )
//     )..onInit = () {
//         _controller.loadVideoById(videoId: YoutubePlayerController.convertUrlToId(VideoGetxController.to.currentUrl)!);
//     }
//       ..onFullscreenChange = (isFullScreen) {
//       isFullScreen = !isFullScreen;
//         print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
//       };
//
//     // SystemChrome.setPreferredOrientations([
//     //   DeviceOrientation.landscapeRight,
//     //   DeviceOrientation.landscapeLeft,
//     //   DeviceOrientation.portraitUp,
//     //   DeviceOrientation.portraitDown,
//     // ]);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetBuilder<VideoGetxController>(builder: (controller) {
//       return YoutubePlayerScaffold(
//         controller: _controller,
//         // aspectRatio: 16.w / 9.h,
//         builder: (context, player)  {
//           return YoutubeValueBuilder(
//             controller: _controller, // This can be omitted, if using `YoutubePlayerControllerProvider`
//             builder: (context, value) {
//               return Scaffold(
//                   appBar: AppBar(
//                     automaticallyImplyLeading: false,
//                     backgroundColor: const Color(0xffF2F2F2),
//                     title: Text(
//                       AppLocalizations.of(context)!.video,
//                       style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           fontFamily: 'avater'),
//                     ),
//                     actions: [
//                       Visibility(
//                         visible: controller.userType,
//                         child: InkWell(
//                           onTap: () async {
//                             await Clipboard.setData(ClipboardData(
//                                 text: controller.userType
//                                     ? controller
//                                     .userVideos[controller.index].url
//                                     : controller
//                                     .videos[controller.index].url));
//                             showAlertDialog(context);
//                           },
//                           child: Icon(
//                             Icons.copy,
//                             size: 25.r,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 8.w,
//                       ),
//                       Visibility(
//                         visible: controller.userType,
//                         child: InkWell(
//                           onTap: () {
//                             _displayDialog(context, controller.userType
//                                 ? controller
//                                 .userVideos[controller.index].id
//                                 : controller.videos[controller.index].id);
//
//                           },
//                           child: Icon(
//                             Icons.delete,
//                             size: 25.r,
//                             color: Colors.red.shade400,
//                           ),
//                         ),
//                       ),
//                       Visibility(
//                         visible: controller.userType,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: ((context) => AddVideo(
//                                       currentVideo: controller.userType
//                                           ? controller.userVideos[controller.index]
//                                           : controller.videos[controller.index],
//                                     ))));
//                           },
//                           child: Icon(
//                             Icons.edit,
//                             size: 25.r,
//                             color: Colors.blue.shade400,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20.w,
//                       ),
//                       IconButton(onPressed: (){
//                         Navigator.pop(context);
//                       }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,))
//
//                     ],
//                     elevation: 0,
//                     centerTitle: true,
//                   ),
//
//                   body: Stack(
//                     children: [
//                       // Visibility(
//                       //   visible: isFullScreen,
//                       //     child: Stack(children: [
//                       //      AspectRatio(
//                       //          aspectRatio:MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
//                       //          child: player),
//                       //      Positioned(
//                       //        top: MediaQuery.of(context).size.height / 9.h,
//                       //        left: MediaQuery.of(context).size.width / 1.5.w,
//                       //        child: Visibility(
//                       //          visible:  !(value.playerState == PlayerState.playing),
//                       //          child: IconButton(
//                       //            onPressed: () {
//                       //              if (controller.userType) {
//                       //                if (controller.index <
//                       //                    controller.userVideos.length -
//                       //                        1) {
//                       //                  controller
//                       //                      .changeListIndexP();
//                       //                  String? id =
//                       //                  YoutubePlayerController.convertUrlToId(controller.userVideos[controller.index].url);
//                       //                  _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                       //                  // _controller.loadVideo(controller.userVideos[controller.index].url);
//                       //                } else {
//                       //                  controller
//                       //                      .changeListIndexToZero();
//                       //                  String? id =  YoutubePlayerController.convertUrlToId(controller.userVideos[controller.index].url);
//                       //                  _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                       //                  // _controller.loadVideo(controller.userVideos[controller.index].url);
//                       //                  // context.showSnackBar(
//                       //                  //     message:
//                       //                  //         AppLocalizations.of(context)!
//                       //                  //             .no_video,
//                       //                  //     error: true);
//                       //                }
//                       //              } else {
//                       //                if (controller.index <
//                       //                    controller.videos.length -
//                       //                        1) {
//                       //                  VideoGetxController.to
//                       //                      .changeListIndexP();
//                       //                  String? id =  YoutubePlayerController.convertUrlToId(controller.videos[controller.index].url);
//                       //                  _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                       //                  // _controller.loadVideo(controller.videos[controller.index].url);
//                       //
//                       //                } else {
//                       //                  VideoGetxController.to
//                       //                      .changeListIndexToZero();
//                       //
//                       //                  String? id =  YoutubePlayerController.convertUrlToId(controller.videos[controller.index].url);
//                       //                  _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                       //                  // _controller.loadVideo(controller.videos[controller.index].url);
//                       //
//                       //
//                       //                  // context.showSnackBar(
//                       //                  //     message:
//                       //                  //         (context)!
//                       //                  //             .no_video,
//                       //                  //     error: true);
//                       //                }
//                       //              }
//                       //            },
//                       //            icon: Icon(Icons.skip_next,
//                       //                color: Colors.white),
//                       //          ),
//                       //        ),
//                       //      ),
//                       //      Positioned(
//                       //        top: MediaQuery.of(context).size.height / 9.h,
//                       //        right: MediaQuery.of(context).size.width / 1.5.w,
//                       //        child: Visibility(
//                       //          visible: !(value.playerState == PlayerState.playing),
//                       //          child: IconButton(
//                       //            onPressed: () {
//                       //              if (controller.userType) {
//                       //                if (controller.index > 0) {
//                       //                  controller.changeListIndexM();
//                       //                  String? id =
//                       //                  YoutubePlayerController.convertUrlToId(controller.userVideos[controller.index].url);
//                       //                  _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                       //                  // _controller.loadVideo(controller.userVideos[controller.index].url);
//                       //
//                       //                } else {
//                       //                  context.showSnackBar(
//                       //                      message:
//                       //                      AppLocalizations.of(context)!
//                       //                          .no_video,
//                       //                      error: true);
//                       //                }
//                       //              } else {
//                       //                if (controller.index > 0) {
//                       //                  controller.changeListIndexM();
//                       //                  String? id =
//                       //                  YoutubePlayerController.convertUrlToId(controller.videos[controller.index].url);
//                       //                  _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                       //                  // _controller.loadVideo(controller.videos[controller.index].url);
//                       //
//                       //                } else {
//                       //                  context.showSnackBar(
//                       //                      message:
//                       //                      AppLocalizations.of(context)!
//                       //                          .no_video,
//                       //                      error: true);
//                       //                }
//                       //              }
//                       //            },
//                       //            icon: Icon(Icons.skip_previous,
//                       //                color: Colors.white),
//                       //          ),
//                       //        ),
//                       //      ),
//                       //      Positioned(
//                       //          bottom: 0.w,
//                       //          right: 0.w,
//                       //          left: 0.w,
//                       //          child: Row(
//                       //            children: [
//                       //              IconButton(onPressed: (){
//                       //                setState(() {
//                       //                  isFullScreen = !isFullScreen;
//                       //                  print("object $isFullScreen");
//                       //                });
//                       //              }, icon: Icon(Icons.pages_sharp,color: Colors.white,)),
//                       //              Spacer(),
//                       //              IconButton(onPressed: (){
//                       //                value.playerState == PlayerState.playing
//                       //                    ? context.ytController.pauseVideo()
//                       //                    : context.ytController.playVideo();
//                       //              }, icon:  value.playerState == PlayerState.playing?Icon(Icons.pause,color: Colors.white,):Icon(Icons.play_arrow,color: Colors.white,)),
//                       //
//                       //
//                       //            ],
//                       //          ))
//                       //         ],)),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0.r),
//                         child: Column(
//                           //   physics: NeverScrollableScrollPhysics(),
//                           // padding: EdgeInsets.symmetric(horizontal: 16.0.r),
//                           // shrinkWrap: true,
//                           // crossAxisAlignment:CrossAxisAlignment.start ,
//                           children: [
//                             _controller != null
//                                 ? Stack(children: [
//                               player,
//                               Positioned(
//                                 top: MediaQuery.of(context).size.height / 9.h,
//                                 left: MediaQuery.of(context).size.width / 1.5.w,
//                                 child: Visibility(
//                                   visible:  !(value.playerState == PlayerState.playing),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       if (controller.userType) {
//                                         if (controller.index <
//                                             controller.userVideos.length -
//                                                 1) {
//                                           controller
//                                               .changeListIndexP();
//                                           String? id =
//                                           YoutubePlayerController.convertUrlToId(controller.userVideos[controller.index].url);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                                           // _controller.loadVideo(controller.userVideos[controller.index].url);
//                                         } else {
//                                           controller
//                                               .changeListIndexToZero();
//                                           String? id =  YoutubePlayerController.convertUrlToId(controller.userVideos[controller.index].url);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                                           // _controller.loadVideo(controller.userVideos[controller.index].url);
//                                           // context.showSnackBar(
//                                           //     message:
//                                           //         AppLocalizations.of(context)!
//                                           //             .no_video,
//                                           //     error: true);
//                                         }
//                                       } else {
//                                         if (controller.index <
//                                             controller.videos.length -
//                                                 1) {
//                                           VideoGetxController.to
//                                               .changeListIndexP();
//                                           String? id =  YoutubePlayerController.convertUrlToId(controller.videos[controller.index].url);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                                           // _controller.loadVideo(controller.videos[controller.index].url);
//
//                                         } else {
//                                           VideoGetxController.to
//                                               .changeListIndexToZero();
//
//                                           String? id =  YoutubePlayerController.convertUrlToId(controller.videos[controller.index].url);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                                           // _controller.loadVideo(controller.videos[controller.index].url);
//
//
//                                           // context.showSnackBar(
//                                           //     message:
//                                           //         AppLocalizations.of(context)!
//                                           //             .no_video,
//                                           //     error: true);
//                                         }
//                                       }
//                                     },
//                                     icon: Icon(Icons.skip_next,
//                                         color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: MediaQuery.of(context).size.height / 9.h,
//                                 right: MediaQuery.of(context).size.width / 1.5.w,
//                                 child: Visibility(
//                                   visible: !(value.playerState == PlayerState.playing),
//                                   child: IconButton(
//                                     onPressed: () {
//                                       if (controller.userType) {
//                                         if (controller.index > 0) {
//                                           controller.changeListIndexM();
//                                           String? id =
//                                           YoutubePlayerController.convertUrlToId(controller.userVideos[controller.index].url);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                                           // _controller.loadVideo(controller.userVideos[controller.index].url);
//
//                                         } else {
//                                           context.showSnackBar(
//                                               message:
//                                               AppLocalizations.of(context)!
//                                                   .no_video,
//                                               error: true);
//                                         }
//                                       } else {
//                                         if (controller.index > 0) {
//                                           controller.changeListIndexM();
//                                           String? id =
//                                           YoutubePlayerController.convertUrlToId(controller.videos[controller.index].url);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//                                           // _controller.loadVideo(controller.videos[controller.index].url);
//
//                                         } else {
//                                           context.showSnackBar(
//                                               message:
//                                               AppLocalizations.of(context)!
//                                                   .no_video,
//                                               error: true);
//                                         }
//                                       }
//                                     },
//                                     icon: Icon(Icons.skip_previous,
//                                         color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                   bottom: 0.w,
//                                   right: 0.w,
//                                   left: 0.w,
//                                   child: Row(
//                                     children: [
//                                       IconButton(onPressed: (){
//                                         setState(() {
//                                           isFullScreen = !isFullScreen;
//                                           _controller.enterFullScreen(lock: true);
//                                           // context.ytController.enterFullScreen(lock: true);
//                                         });
//                                       }, icon: Icon(Icons.pages_sharp,color: Colors.white,)),
//                                       Spacer(),
//                                       IconButton(onPressed: (){
//                                         value.playerState == PlayerState.playing
//                                             ? context.ytController.pauseVideo()
//                                             : context.ytController.playVideo();
//                                       }, icon:  value.playerState == PlayerState.playing?Icon(Icons.pause,color: Colors.white,):Icon(Icons.play_arrow,color: Colors.white,)),
//                                     ],
//                                   ))
//                             ])
//                                 : const Center(child: CircularProgressIndicator()),
//                             SizedBox(
//                               height: 10.h,
//                             ),
//                             //comment 2 here
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                 controller.userType
//                                     ? controller
//                                     .userVideos[VideoGetxController.to.index]
//                                     .title
//                                     : controller
//                                     .videos[VideoGetxController.to.index].title,
//                                 style: GoogleFonts.tajawal(
//                                   color: Colors.black,
//                                   textStyle: const TextStyle(
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   fontSize: 16.sp,
//                                   //fontFamily: 'avater',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 maxLines: 2,
//                               ),
//                             ),
//                             Visibility(
//                               visible: controller.userType,
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.transparent,
//                                         elevation: 0,
//                                         foregroundColor: Colors.red),
//                                     onPressed: () {
//                                       showModalBottomSheet(
//                                         isScrollControlled: false,
//                                         backgroundColor: Colors.transparent,
//                                         context: context,
//                                         builder: (context) => PlayListButtomSheet(
//                                             controller.userType
//                                                 ? controller.userVideos[
//                                             controller.index]
//                                                 : controller.videos[
//                                             controller.index]),
//                                       );
//                                       // displayTextInputDialog(context,_controller,urls[dataManager.currentPlaying]);
//                                     },
//                                     child: Text(AppLocalizations.of(context)!.save_play_list)),
//                               ),
//                             ),
//                             //////////////////////
//                             Expanded(
//                               child: ListView.builder(
//                                 // itemCount: 20,
//                                   itemCount: controller.userType
//                                       ? controller.userVideos.length
//                                       : controller.videos.length,
//                                   scrollDirection: Axis.vertical,
//                                   //  shrinkWrap: true,
//                                   // physics: ClampingScrollPhysics(),
//                                   // physics: const NeverScrollableScrollPhysics(),
//                                   // padding: EdgeInsets.all(16.r),
//                                   itemBuilder: (context, index) {
//                                     return DVideoItemWidget(
//                                         video: controller.userType
//                                             ? controller.userVideos[index]
//                                             : controller.videos[index],
//                                         index: index,
//                                         click: (){
//                                           print("dsasa ${controller.currentUrl}");
//                                           controller.setCurentUrl(controller.userType
//                                               ? controller.userVideos[index].url
//                                               : controller.videos[index].url,index: index);
//                                           String? id =
//                                           YoutubePlayerController.convertUrlToId(controller.currentUrl);
//                                           _controller.loadVideoById(videoId:  id!,startSeconds: 0);
//
//                                           // _controller.load(YoutubePlayer.convertUrlToId(controller.currentUrl)!);
//                                         }
//
//                                     );
//                                   }),
//                             )
//                           ],
//                         ),
//                       ),
//                     ] ,
//                   ));
//             });
//
//
//
//         },
//       );
//     });
//   }
//
//   Future<void> _displayDialog(BuildContext context,id) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: const Text('هل انت متأكد أنك تريد حذف الفيديو؟'),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text(
//                   'حذف',
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onPressed: () async {
//                   _deleteVideo(context,id);
//                 },
//               ),
//               TextButton(
//                 child: const Text(
//                   'رجوع',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onPressed: () async {
//                   Future.delayed(const Duration(milliseconds: 100), () {
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//             ],
//           );
//         });
//   }
//   void _deleteVideo(BuildContext context, String id) async {
//     FbResponse fbResponse = await FbFirestoreController().delete(id);
//     if (fbResponse.success) {
//       Navigator.pushReplacementNamed(context, '/bottom_nav');
//     }
//     context.showSnackBar(
//         message: fbResponse.message, error: !fbResponse.success);
//   }
//
//   @override
//   void dispose() {
//     _controller.close();
//     super.dispose();
//   }
// }
