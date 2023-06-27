import 'package:apptubey/get/favourite_getx_controller.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/screens/Favourite/video_ditailsF.dart';
import 'package:apptubey/screens/video_ditails/video_ditails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavItemWidget extends StatefulWidget {
  const FavItemWidget({
    Key? key,
    required this.video,
    required this.index,
  }) : super(key: key);
  final Video video;
  final int index;

  @override
  State<FavItemWidget> createState() => _FavItemWidgetState();
}

class _FavItemWidgetState extends State<FavItemWidget> {
  FavouriteGetxController favouriteGetxController =
      Get.put(FavouriteGetxController());
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

    return "";
  }

  String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = false,
  }) {
    return webp
        ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
        : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FavouriteGetxController.to.index = widget.index;
        FavouriteGetxController.to.setCurentUrl(widget.video.url);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VideoDitailsF(currentVideo: widget.video)));
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 130.w,
                width: double.infinity,
                margin: EdgeInsets.only(left: 8.r, right: 8.r),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: const Radius.circular(20)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0),
                          blurRadius: 3)
                    ]),
                child:  Image.network(getThumbnail(videoId: convertUrlToId(widget.video.url)!),fit: BoxFit.cover,)
              ),
              Container(
                height: 65.h,
                width: double.infinity,
                margin: EdgeInsets.only(left: 8.r, right: 8.r),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.r),
                        bottomLeft: const Radius.circular(20)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 0),
                          blurRadius: 3)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.r),
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            widget.video.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: 'avater',
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0.r, vertical: 2.r),
                      child: Text.rich(
                        TextSpan(
                          text: AppLocalizations.of(context)!.added_date,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 12.sp,
                              fontFamily: 'avater'),
                          children: <TextSpan>[
                            TextSpan(
                              onEnter: (PointerEnterEvent) {
                                print("object");
                              },
                              text: widget.video.date,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                  fontFamily: 'avater'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(50.0.r))),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    favouriteGetxController.delete(
                        widget.video.id, widget.index);
                  });
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
