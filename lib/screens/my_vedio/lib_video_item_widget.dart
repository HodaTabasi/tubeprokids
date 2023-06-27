// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:apptubey/firebase/fb_firestore.dart';
import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/screens/bottom_navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../get/play_list_getx_controller.dart';
import '../video_ditails/video_d.dart';

class LibVideoItemWidget extends StatefulWidget {
  LibVideoItemWidget({
    Key? key,
    required this.video,
    required this.index,
  }) : super(key: key);
  final Video video;
  int index;

  @override
  State<LibVideoItemWidget> createState() => _libVideoItemWidgetState();
}

class _libVideoItemWidgetState extends State<LibVideoItemWidget> with Helpers{
  VideoGetxController videoGetxController = VideoGetxController.to;

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
        VideoGetxController.to.userType = true;

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoDitails1(
                      currentVideo: widget.video,
                    )));
      },
      child: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300),borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
             
                Container(
                    width: 100.w,
                    height: 105.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                       borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        getThumbnail(videoId: convertUrlToId(widget.video.url)!),
                        fit: BoxFit.cover,
                      ),
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.r),
                        child: Text(
                          widget.video.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontFamily: 'avater',
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16.0.r, vertical: 8.r),
                        child: Text.rich(
                          TextSpan(
                            text: AppLocalizations.of(context)!.added_date + "  ",
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
                IconButton(
                  onPressed: () {
                    setState(() {
                      _displayDialog(context);
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Future<void> _displayDialog(BuildContext context) async {
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
                  showLoaderDialog(context);
                  await FbFirestoreController().delete(widget.video.id);
                  PlayListGetxController.to.deleteVideoFromModle(widget.video.id);

                 Navigator.pop(context);
                 Navigator.pop(context);
                  videoGetxController.read();
                  videoGetxController.readUserVideos();
                  // Navigator.pushReplacementNamed(context, '/bottom_nav');
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

  bool cheakIfArabic(word){
    RegExp regExp = new RegExp(r"^[\u0621-\u064A\u0660-\u0669 ]+$",
      caseSensitive: true,
      multiLine: true,
    );
    // print(regExp.hasMatch(word).toString());
    return regExp.hasMatch(word);
  }
}
