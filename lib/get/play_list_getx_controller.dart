import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../firebase/fb_firestore.dart';
import '../models/fb_response.dart';
import '../models/play_list_modle.dart';
import '../models/video_model.dart';
import '../preferences/shared_pref_controller.dart';
import '../utils/fb_helper.dart';

class PlayListGetxController extends GetxController with FirebaseHelper {
  RxList<Video> playList = <Video>[].obs;

  RxList<PlayListModel> playListModel = <PlayListModel>[].obs;
  RxBool isLoading = false.obs;
  final FbFirestoreController _dbController = FbFirestoreController();

  String currentUrl = "";

  int index = 0;

  static PlayListGetxController get to => Get.find<PlayListGetxController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  onInit() {
    // getPlayList();
    getPlayListName();
  }

  setCurentUrl(url, {index}) {
    print(url);
    print(index);
    currentUrl = url;
    if (index != null) {
      this.index = index;
      update();
    }
    // Get.appUpdate();
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

  getVideoFromPlayList(playListId) async {
    playList.value = [];
    isLoading.value = true;
    await _firestore.collection('PlayList').doc(playListId).get().then((value) {
      playList.value = [];
      value.data()!['vedios'].forEach((element) async {
        await _firestore.collection("Videos").doc(element).get().then((value) {
          playList.add(Video.fromMap(value.data()!));
        });
      });
    });

    Future.delayed(const Duration(seconds: 1),(){
      isLoading.value = false;

    });
  }

  Future<List<PlayListModel>> getPlayList() async {
    playList = <Video>[].obs;
    isLoading.value = true;
    return await _firestore
        .collection('PlayList')
        .where('userid',
            isEqualTo:
                SharedPrefController().getValueFor(key: PrefKeys.id.name))
        .get()
        .then((value1) {
      if (value1 == null) {
        return [];
      } else {
        return value1.docs.map((e) {
          return PlayListModel.fromJson(e.data());
        }).toList();
      }
    });
  }

  getPlayListName() async {
    playListModel = <PlayListModel>[].obs;
    isLoading.value = true;
    await _firestore.collection('PlayList').where('userid',isEqualTo:SharedPrefController().getValueFor(key: PrefKeys.id.name))
        .get()
        .then((value1) {
              playListModel = <PlayListModel>[].obs;

      value1.docs.map((e) {
        playListModel.add(PlayListModel.fromJson(e.data()));
      }).toList();
    });
    isLoading.value = false;
  }

  Future<FbResponse> createPlayList(name, {video = null}) async {
    DocumentReference document = _firestore.collection("PlayList").doc();
    PlayListModel playList = PlayListModel(
        id: document.id,
        name: name,
        userid: SharedPrefController().getValueFor(key: PrefKeys.id.name),
        vedios: video != null ? [video.id] : []);

    return await _firestore
        .collection('PlayList')
        .doc(document.id)
        .set(playList.toJson())
        .then((value) {
      playListModel.add(playList);
      refresh();
      return successResponce;
    }).catchError((error) => errorResponce);
  }

  Future<FbResponse> deletePlayList(id) async {
    return _firestore.collection('PlayList').doc(id).delete().then((value) {
      int index = playListModel.indexWhere((element) => element.id == id);
      playListModel.removeAt(index);
      return successResponce;
    }).catchError((error) => errorResponce);
  }

  Future<FbResponse> deleteVideoFromPlayList(id,videoId){
    int index = playListModel.indexWhere((element) => element.id == id);
    playListModel[index].vedios!.removeWhere((element) => element == videoId);
    return _firestore.collection('PlayList').doc(id).update(playListModel[index].toJson()).then((value) {
      playList.removeWhere((element) => element.id == videoId);
      return successResponce;
    }).catchError((error) => errorResponce);
  }

  Future<FbResponse> createToPlayList(
      PlayListModel playList, Video video) async {
    return await _firestore
        .collection('Videos')
        .doc(video.id)
        .set(video.toMap())
        .then((value) async {
      playList.vedios!.add(video.id);

      return await _firestore
          .collection('PlayList')
          .doc(playList.id)
          .update(playList.toJson())
          .then((value) => successResponce)
          .catchError((error) => errorResponce);
    }).catchError((error) => errorResponce);
  }

  void deleteVideoFromModle(String id) {
    playListModel.any((element1) {
      print("fsefe ${element1.vedios}");
      print("dca $id");
      element1.vedios?.removeWhere((element) => element == id);
      _firestore.collection('PlayList').doc(element1.id).update(element1.toJson());
      print("dfssd ${element1.vedios}");
      return true;
    });
    print("dfssd ${playListModel[0].vedios}");
  }
}
