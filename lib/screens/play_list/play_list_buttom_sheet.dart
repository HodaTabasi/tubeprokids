import 'package:apptubey/get/play_list_getx_controller.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/screens/constant.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../firebase/fb_firestore.dart';
import '../../get/user_getx_controller.dart';
import '../../models/fb_response.dart';
import '../../models/play_list_modle.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayListButtomSheet extends StatefulWidget {
  Video url;

  PlayListButtomSheet(this.url);

  @override
  State<PlayListButtomSheet> createState() => _PlayListButtomSheetState();
}

class _PlayListButtomSheetState extends State<PlayListButtomSheet> {
  TextEditingController _controller = TextEditingController();

  List<bool> isChecked = List<bool>.filled(70, false);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FutureBuilder<List<PlayListModel>>(
          future: PlayListGetxController.to.getPlayList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "القوائم",
                    textAlign: TextAlign.start,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      displayTextInputDialog(context,
                          video: widget.url, textFieldController: _controller);
                    },
                    leading: const Icon(Icons.add),
                    title: Text(
                      AppLocalizations.of(context)!.new_list,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontFamily: 'avater',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // contentPadding: EdgeInsets.all(0),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () async {
                          FbResponse fbResponse = await FbFirestoreController().addToExistPlayList(snapshot.data![index],widget.url);
                          Navigator.pop(context);
                          // if (fbResponse.success) {
                          //   Future.delayed(const Duration(milliseconds: 500), () {
                          //
                          //   });
                          // }
                          context.showSnackBar(message: fbResponse.message);
                        },
                        leading: Icon(Icons.list_alt),
                        title: Text(snapshot.data![index].name!),
                      );
                    },
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.play_list,
                    textAlign: TextAlign.start,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      displayTextInputDialog(context,
                          video: widget.url, textFieldController: _controller);
                    },
                    leading: const Icon(Icons.add),
                    title: Text(
                      "قائمة جديدة",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontFamily: 'avater',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.no_video,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }
            //   SizedBox(
            //
            //   height: 50,
            //   child: ListView(
            //     children: [
            //       TextField(
            //         controller: textFieldController,
            //         decoration: const InputDecoration(hintText: "الاسم الجديد"),
            //       ),
            //       ListView.builder(
            //           itemCount: 5,
            //           shrinkWrap: true,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemBuilder: (context, index) {
            //             return Text("قائمة");
            //           }),
            //     ],
            //   ),
            // );
          },
        ));
  }
}
