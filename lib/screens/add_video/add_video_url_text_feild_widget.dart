import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ex ;

import '../../get/video_getx_controller.dart';
class AddVideoURLTextFeildWidget extends StatelessWidget {
  String icon;
  String hint;
  TextEditingController controller;

  AddVideoURLTextFeildWidget(this.icon, this.hint, this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300,width: 0.8),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r),bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r)),
          // borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r),bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r)),
          borderSide: BorderSide(color: Colors.grey.shade300,width: 0.8),
        ),
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        hintStyle:  TextStyle(
            color: const Color(0xffA3A3A3), fontSize: 16.sp, fontFamily: 'avater'),
        prefix: SvgPicture.asset(icon,
            semanticsLabel: 'Acme Logo',color: Colors.grey),
      ),
      onChanged: (val) async {
        if(Uri.parse(val).isAbsolute){
          var yt = ex.YoutubeExplode();
          var video = await yt.videos.get(val); // Returns a Video instance.

          var title = video.title; // "Scamazon Prime"
          var author = video.author; // "Jim Browning"
          var duration = video.duration;

          VideoGetxController.to.chanageVideoName(title);
          //print(title);
        }

      },
    );
  }
}
