import 'package:apptubey/get/play_list_getx_controller.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/screens/play_list/play_list_screen.dart';
import 'package:apptubey/utils/fb_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/play_list_modle.dart';
import '../preferences/shared_pref_controller.dart';

class FbFirestoreController with FirebaseHelper {
  ///Functions
  ///1) Create
  ///2) Read
  ///3) Update
  ///4) Delete

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FbResponse> create(Video video) async {
    print("fdfg ${video.description}");
    return await _firestore
        .collection('Videos')
        .doc(video.id)
        .set(video.toMap())
        .then((value) => successResponce)
        .catchError((error) => errorResponce);
  }

  update(Video video) async {
    print("fdfdcsg");
    await _firestore
        .collection('Videos')
        .doc(video.id)
        .set(video.toMap(), SetOptions(merge: true))
        .then((value) => successResponce)
        .catchError((error) => errorResponce);
  }

  Future<FbResponse> delete(String id) async {
    return await _firestore
        .collection('Videos')
        .doc(id)
        .delete()
        .then((value) => successResponce)
        .catchError((error) => errorResponce);
  }

  read() async {
    return await _firestore.collection('Videos').get().then((value) => value);
  }

  Stream<QuerySnapshot> readStream() async* {
    yield* _firestore
        .collection('Videos')
        .where('user_id', isEqualTo: 'admin')
        .where('is_visible', isEqualTo: true)
        .where('country', arrayContainsAny: ['all',SharedPrefController()
        .getValueFor(key: PrefKeys.country.name)])
        .snapshots();
  }

  Future<FbResponse> addToExistPlayList(PlayListModel playList, vedio) async {
    playList.vedios!.add(vedio.id);
    return await _firestore
        .collection('PlayList')
        .doc(playList.id)
        .set(playList.toJson())
        .then((value) => successResponce)
        .catchError((error) => errorResponce);
  }

  Future<List<Video>> getVideoPlayList(playListId) async {
    List<Video> myList = [];
    return await _firestore
        .collection('PlayList')
        .doc(playListId)
        .get()
        .then((value) {
      value.data()!['vedios'].map((element) async {
        myList.add(await _firestore
            .collection("Videos")
            .doc(element)
            .get()
            .then((value) {
          return Video.fromMap(value.data()!);
        }));
        print(myList);
      });

      return myList;
    });
  }
}
