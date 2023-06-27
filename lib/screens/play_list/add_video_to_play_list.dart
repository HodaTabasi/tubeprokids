import 'dart:math';

import 'package:apptubey/get/play_list_getx_controller.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/models/play_list_modle.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../firebase/fb_firestore.dart';
import '../../general/btn_layout.dart';
import '../../get/video_getx_controller.dart';
import '../../models/fb_response.dart';
import '../../models/video_model.dart';
import '../../preferences/shared_pref_controller.dart';
import '../add_video/add_video_text_feild_widget.dart';
import '../add_video/add_video_url_text_feild_widget.dart';
import '../add_video/text_area.dart';
import 'package:intl/intl.dart' as intl;

class AddVideoToPlayList extends StatefulWidget {
  PlayListModel playListModel;
  AddVideoToPlayList(this.playListModel);


  @override
  State<AddVideoToPlayList> createState() => _AddVideoToPlayListState();
}

class _AddVideoToPlayListState extends State<AddVideoToPlayList> with Helpers{
  PlayListGetxController videoGetxController = Get.put(PlayListGetxController());

  late TextEditingController _nameTextController;
  late TextEditingController _descriptionTextController;
  late TextEditingController _urlTextController;

  @override
  void initState() {
    super.initState();
    VideoGetxController.to.nameTextController = TextEditingController();
    _descriptionTextController =  TextEditingController(text: " ");
    _urlTextController = TextEditingController();
  }

  @override
  void dispose() {
    VideoGetxController.to.nameTextController.dispose();
    _descriptionTextController.dispose();
    _urlTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title: Text(
           AppLocalizations.of(context)!.add_video,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,))
        ],
      ),
      body: GetBuilder<VideoGetxController>(
          builder: (controller) {
            return Padding(
          padding: EdgeInsets.all(16.0.r),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.r),
                child: Text( AppLocalizations.of(context)!.video_link,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.w500,
                    )),
              ),
              AddVideoURLTextFeildWidget(
                "assets/icon.svg",
                AppLocalizations.of(context)!.video_link,
                _urlTextController,
              ),
              // AddVideoTextFeildWidget(
              //   "assets/icon.svg", AppLocalizations.of(context)!.video_link, _urlTextController,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.r),
                child: Text(AppLocalizations.of(context)!.video_name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.w500,
                    )),
              ),
              AddVideoTextFeildWidget(
                  "assets/icon2.svg", AppLocalizations.of(context)!.video_name, controller.nameTextController),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.r),
                child: Text(AppLocalizations.of(context)!.video_description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.w500,
                    )),
              ),
              TextAreaWidget(controller: _descriptionTextController),
              SizedBox(
                height: 50.h,
              ),
              BtnLayout(
                AppLocalizations.of(context)!.add_video,
                    () => _performSave(),
              ),
            ],
          ),
        );}
      ),
    );
  }


  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_urlTextController.text.isNotEmpty &&
        VideoGetxController.to.nameTextController.text.isNotEmpty
    ) {
      return true;
    }
    context.showSnackBar(
      message: AppLocalizations.of(context)!.enter_the_required_data,
      error: true,
    );
    return false;
  }

  Future<void> _save() async {
    showLoaderDialog(context);
    FbResponse fbResponse = await PlayListGetxController.to.createToPlayList(widget.playListModel,video);
    Navigator.pop(context);
    if (fbResponse.success) {
      VideoGetxController.to.nameTextController.text = "";
      PlayListGetxController.to.getPlayListName();
      PlayListGetxController.to.getVideoFromPlayList(widget.playListModel.id);
      VideoGetxController.to.readUserVideos();
      // PlayListGetxController.to.playList.add(video);
      Navigator.pop(context);
    }
    context.showSnackBar(message: fbResponse.message);
  }

  Video get video {
    Video video = Video();
      Random random = Random();
      int randomNumber = random.nextInt(1000000000);
      var now = DateTime.now();
      var formatter = intl.DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      video.id = randomNumber.toString();
      video.title = VideoGetxController.to.nameTextController.text;
      video.description = _descriptionTextController.text;
      video.url = _urlTextController.text;
      video.country = [];
      video.country
          .add(SharedPrefController().getValueFor(key: PrefKeys.country.name));
      video.date = formattedDate;
      video.views = 0.toString();
      video.isVisible = true;
      video.userId = SharedPrefController().getValueFor(key: PrefKeys.id.name);

    return video;
  }

  void clear() {
    _nameTextController.clear();
    _descriptionTextController.clear();
    _urlTextController.clear();
  }
}

