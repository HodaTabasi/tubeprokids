import 'package:apptubey/firebase/fb_firestore.dart';
import 'package:apptubey/models/process_response.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoGetxController extends GetxController {
  RxList<Video> videos = <Video>[].obs;
  RxList<Video> userVideos = <Video>[].obs;
  RxString? videoName;

  late TextEditingController nameTextController;

  bool isHideController = false;
  int startAt = 0;
  int index = 0;
  String currentUrl = "";
  Video? currentVideo;
  bool userType = false;

  RxBool isLoading = false.obs;
  final FbFirestoreController _dbController = FbFirestoreController();

  static VideoGetxController get to => Get.find<VideoGetxController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  onInit() {
    print("object");
    read();
    readUserVideos();
  }

  Future<ProcessResponse> create(Video video) async {
    return _dbController
        .create(video)
        .then((value) => getResponse(true))
        .catchError((e) => getResponse(false));
  }

  chanageVideoName(name) {
    nameTextController.text = name;
    update();
  }

  changeListIndexP() {
    index += 1;
  }

  changeListIndexM() {
    index -= 1;
  }
  changeListIndexToZero() {
    index = 0;
  }

  setCurentUrl(url, {index}) {
    // print(url);
    // print(index);
    currentUrl = url;
    if (index != null) {
      this.index = index;
      update();
    }
    // Get.appUpdate();
  }

  read() async {
    videos.value = [];
    isLoading.value = true;
    await _firestore
        .collection('Videos')
        .where('user_id', isEqualTo: 'admin')
        .where('country', arrayContains: 'all')
        .where('is_visible', isEqualTo: true)
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        videos.add(Video.fromMap(value.docs[i].data()));
      }
      await _firestore
          .collection('Videos')
          .where('user_id', isEqualTo: 'admin')
          .where('country',
              arrayContains: SharedPrefController()
                  .getValueFor(key: PrefKeys.country.name))
          .where('is_visible', isEqualTo: true)
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          videos.add(Video.fromMap(value.docs[i].data()));
        }
      });
    });
    isLoading.value = false;
  }

  readUserVideos() async {
    print(" dfsdjn;dois ${SharedPrefController().getValueFor(key:PrefKeys.id.name)}");
    userVideos.value = [];
    isLoading.value = true;
    await _firestore
        .collection('Videos')
        .where('user_id', isEqualTo: SharedPrefController().getValueFor(key: PrefKeys.id.name,),)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
          userVideos.add(Video.fromMap(value.docs[i].data()));
      }


          userVideos.sort((a, b) {
          int aDate = DateTime.parse(a.date ).microsecondsSinceEpoch;
          int bDate = DateTime.parse(b.date).microsecondsSinceEpoch;
          return bDate.compareTo(aDate);
});
    });
    isLoading.value = false;
  }

  updateViews(Video video) async {
    int views = int.parse(video.views);
    views++;
    video.views = views.toString();
    await _firestore.collection('Videos').doc(video.id).set(
          video.toMap(),
          SetOptions(merge: true),
        );

  }

  ProcessResponse getResponse(bool success) {
    return ProcessResponse(
      message:
          success ? 'Operation completed successfully' : 'Operation failed!',
      success: success,
    );
  }

  void updateVideosViews(List<Video> videss){
    videos.value = videss;
  }
}
