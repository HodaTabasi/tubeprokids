import 'package:apptubey/screens/video_ditails/videoheader.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/video_model.dart';
import 'd_video_item_widget.dart';

class VideoList extends StatelessWidget {
  final VideoHeader videoHeader;
  final  List<Video> videos;
  const VideoList({
    Key? key,
    required this.links,
    required this.videoHeader,
    required this.videos
  }) : super(key: key);

  final List<String> links;

  @override
  Widget build(BuildContext context) {


    return ListView.separated(itemCount: videos.length,
    separatorBuilder: (BuildContext context,int index){
      return Divider();
    },
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context,int index){
      if(index==0){
        return this.videoHeader;
      }
      return ListTile(
        leading: Image.network(
        getThumbnail(videoId: convertUrlToId(videos[index].url)!),fit: BoxFit.cover,
        width: 200.00,
        height: 2920.00,
      ),
      title: Text(
       videos[index].date,
        style:const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'avater'),
      ),
    );
    },
    );
  }

    String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.medium,
    bool webp = false,
  }) {
    return webp
        ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
        : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';}
        
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
}

