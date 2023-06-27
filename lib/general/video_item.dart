import 'package:apptubey/get/favourite_getx_controller.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:apptubey/screens/video_ditails/video_ditails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../get/video_getx_controller.dart';
import '../screens/video_ditails/vedio_d1.dart';
import '../screens/video_ditails/video_d.dart';
import '../screens/video_ditails/video_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoItem extends StatefulWidget {
  VideoItem({
    required this.video,
    required this.isUser,
    required this.index,
    required this.width,
  });

  Video video;
  bool isUser;
  int index;
  double width;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  FavouriteGetxController controller = Get.put(FavouriteGetxController());
  String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.medium,
    bool webp = false,
  }) {
    return webp
        ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
        : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        VideoGetxController.to.index = widget.index;
        VideoGetxController.to.setCurentUrl(widget.video.url);
        VideoGetxController.to.userType = widget.isUser ? true : false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VideoDitails1(currentVideo: widget.video)
                    // DetailPage(currentVideo: widget.video)
                    ));
      },
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
               borderRadius:const BorderRadius.only(topLeft:Radius.circular(12),topRight:Radius.circular(12) ),
              child: Image.network(
              getThumbnail(videoId: convertUrlToId(widget.video.url)!),
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.colorBurn,
              height: 150,
              width: Get.width,
            )),
            Container(
              padding: const EdgeInsets.only(top: 12, left: 16,right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: const TextStyle(
                      color: Colors.black,
                      // overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                  ),
                  Text("${widget.video.views} " + AppLocalizations.of(context)!.view,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'avater',
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
