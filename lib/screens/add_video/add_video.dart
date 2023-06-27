import 'dart:io';
import 'dart:math';

import 'package:apptubey/firebase/fb_firestore.dart';
import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:apptubey/screens/add_video/text_area.dart';
import 'package:apptubey/screens/bottom_navigations.dart';
import 'package:apptubey/screens/constant.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart' as intl;

import '../../general/btn_layout.dart';
import '../my_vedio/show_offerring.dart';
import 'add_video_text_feild_widget.dart';
import 'add_video_url_text_feild_widget.dart';

class AddVideo extends StatefulWidget {
  AddVideo({super.key, this.currentVideo});

  static String routeName = "/add_video";
  Video? currentVideo;

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> with Helpers{
  VideoGetxController videoGetxController = VideoGetxController.to;

  late TextEditingController _descriptionTextController;
  late TextEditingController _urlTextController;

  AdManagerInterstitialAd? _interstitialAd;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    VideoGetxController.to.nameTextController = widget.currentVideo != null
        ? TextEditingController(text: widget.currentVideo!.title)
        : TextEditingController();
    _descriptionTextController = widget.currentVideo != null
        ? TextEditingController(text: widget.currentVideo!.description)
        : TextEditingController(text: " ");
    _urlTextController = widget.currentVideo != null
        ? TextEditingController(text: widget.currentVideo!.url)
        : TextEditingController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    AdManagerInterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-6698036413009346/2842752467'
            : 'ca-app-pub-6698036413009346/1215698225',
        request: AdManagerAdRequest(),
        adLoadCallback: AdManagerInterstitialAdLoadCallback(
          onAdLoaded: (AdManagerInterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
            setState(() {
              isLoading = true;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
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
    if(!SharedPrefController().getValueFor(key: PrefKeys.sub.name)){
      if (isLoading) {
        _interstitialAd!.show();
      }
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffF2F2F2),
          title: Text(
            _isNewVideo
                ? AppLocalizations.of(context)!.add_video
                : AppLocalizations.of(context)!.edit_video,
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
                    child: Text(AppLocalizations.of(context)!.video_link,
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
                      "assets/icon2.svg",
                      AppLocalizations.of(context)!.video_name,
                      controller.nameTextController),
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
                    _isNewVideo
                        ? AppLocalizations.of(context)!.add_video
                        : AppLocalizations.of(context)!.edit_video,
                    () => _performSave(),
                  ),
                ],
              ),
            );
          },
        ));
  }

  bool get _isNewVideo => widget.currentVideo == null;

  void _performSave() {
    if (_checkData()) {
      _save();
    }
  }

  bool _checkData() {
    if (_urlTextController.text.isNotEmpty &&
        VideoGetxController.to.nameTextController.text.isNotEmpty &&
        Uri.parse(_urlTextController.text).isAbsolute && getYouTubeUrl(_urlTextController.text)) {
      if(!SharedPrefController().getValueFor(key: PrefKeys.sub.name)){
        if (VideoGetxController.to.userVideos.length >= AppConstant.VIDEO_LIMIT_LENTH) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>showOffering()));
          // context.showSnackBar(
          //   message: AppLocalizations.of(context)!
          //       .have_exceeded_the_maximum_number_of_videos_for_the_free_account,
          //   error: true,
          // );
          return false;
        }
      }
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
    FbResponse fbResponse = _isNewVideo
        ? await FbFirestoreController().create(video)
        : await FbFirestoreController().update(video);

    Navigator.pop(context);
    if (fbResponse.success) {
      // videoGetxController.read();
      // videoGetxController.readUserVideos();
      videoGetxController.nameTextController.text = "";
      Navigator.pushReplacementNamed(context, '/bottom_nav');
      Get.find<BottomNavigationController>().updataIndex(1);
    }
    context.showSnackBar(message: fbResponse.message);
  }

  Video get video {
    Video video = _isNewVideo ? Video() : widget.currentVideo!;
    if (!_isNewVideo) {
      video.url = _urlTextController.text;
      video.description = _descriptionTextController.text;
      video.title = VideoGetxController.to.nameTextController.text;
      video.country =
          SharedPrefController().getValueFor(key: PrefKeys.country.name);
    } else {
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
    }

    return video;
  }

  void clear() {
    VideoGetxController.to.nameTextController.clear();
    _descriptionTextController.clear();
    _urlTextController.clear();
  }
  bool getYouTubeUrl(String content) {
    RegExp regExp = RegExp(
        r'((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?'
    );
    String? matches = regExp.stringMatch(content);
    if (matches == null) {
      return false; // Always returns here while the video URL is in the content paramter
    }
    // final String youTubeUrl = matches;
    return true;
  }

}
