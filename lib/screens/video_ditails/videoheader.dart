import 'package:flutter/material.dart';
class VideoHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const VideoHeader({
    Key? key,
    required this.title,
    required this.subtitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Text(this.title,
          style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'avater',
                    fontWeight: FontWeight.bold,
        )),
        Text(
          this.subtitle,
          style:const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'avater',
                    fontWeight: FontWeight.w300,
        ),
        ),
      ],),
    );

  }
}
