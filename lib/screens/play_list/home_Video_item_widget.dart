import 'package:apptubey/get/play_list_getx_controller.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/screens/play_list/play_all_screen.dart';
import 'package:apptubey/screens/play_list/play_name_screen.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/video_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeVideoItemWidget extends StatelessWidget with Helpers {
  Video playList;
  int index;
  String name;
  String? id;
  void Function(String)? onTap;

  HomeVideoItemWidget(this.playList,
      {this.name = "", required this.index, this.id,required this.onTap});

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
      onTap:(() {
        onTap!(name);
      })
      //  () {
      //   // VideoGetxController.to.index = index;
      //   // VideoGetxController.to.setCurentUrl(playList.url);
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => PlayAllScreen(index, name)));
      // }
      ,
      child: Container(
          decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 1), blurRadius: 3)
                  ]),
        child: Row(
          children: [
     
            Container(
              width: 100.w,
              height: 105.h,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  getThumbnail(videoId: convertUrlToId(playList.url)!),
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.3),
                  colorBlendMode: BlendMode.colorBurn,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.r),
                    child: Text(
                      playList.title ,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'avater',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0.r, vertical: 8.r),
                    child: Text.rich(
                      textAlign: TextAlign.start,
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
                            text: playList.date,
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
                onPressed: () async {
                  _displayDialog(context, index, PlayListGetxController.to);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20.w,
                )
                )
          ],
        ),
      ),
    );
  }
  Future<void> _displayDialog(BuildContext context, index, controller) async {
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
                  FbResponse reponse = await PlayListGetxController.to
                      .deleteVideoFromPlayList(id, playList.id);

                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.pushReplacementNamed(context, PlayNameScreen.routeName);
                  context.showSnackBar(
                      message: reponse.message, error: reponse.success);
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
    print(regExp.hasMatch(word).toString());
    return regExp.hasMatch(word);
  }
}
