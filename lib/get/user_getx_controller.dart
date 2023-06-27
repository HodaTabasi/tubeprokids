import 'package:apptubey/models/process_response.dart';
import 'package:apptubey/models/users.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:apptubey/utils/fb_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../firebase/fb_auth_controller.dart';
import '../models/subscripe_coupon.dart';

class UserGetxController extends GetxController with FirebaseHelper {
  Rx<Users> currentUser = Users().obs;
  RxList<Users> subScribitionUsers = (List<Users>.of([])).obs;

  RxBool isLoading = false.obs;

  static UserGetxController get to => Get.find<UserGetxController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  onInit() {
    getCurrentUser();
  }

  getCurrentUser() async {
    isLoading.value = true;
    await _firestore
        .collection('Users')
        .doc(SharedPrefController().getValueFor(key: PrefKeys.id.name))
        .get()
        .then((value) async {
      await _firestore
          .collection('Videos')
          .where('user_id',
              isEqualTo:
                  SharedPrefController().getValueFor(key: PrefKeys.id.name))
          .get()
          .then((value1) {
            print("fddsfsdfs ${value.data()}");
        currentUser.value = Users.fromMap(value.data()!);
        currentUser.value.videosNumber = value1.docs.length.toString();
        SharedPrefController().saveCountry(currentUser.value.country);
      });
    }).catchError((e) => null);
    isLoading.value = false;
  }

  updateUser({required Users user}) async {
    return await _firestore
        .collection('Users')
        .doc(currentUser.value.id)
        // .set(user.toMap(), SetOptions(merge: true))
        .update(user.toMap())
        .then((value) => successResponce)
        .catchError((e) => errorResponce);
  }

  deleteUser() async {
    return await _firestore
        .collection('Users')
        .doc(currentUser.value.id)
    // .set(user.toMap(), SetOptions(merge: true))
        .delete()
        .then((value) async {
      await FbAuthController().currentUser.delete();
      return successResponce;})
        .catchError((e) => errorResponce);
  }

  ProcessResponse getResponse(bool success) {
    return ProcessResponse(
      message:
          success ? 'Operation completed successfully' : 'Operation failed!',
      success: success,
    );
  }



  Future<void> getUserCoupons({required String coupon}) async {
    isLoading.value = true;
    List<Users> subScription = [];
    List<SubscribeCoupon> subScriptionCpubon = [];

    await _firestore
        .collection('subscriper_users_coupon')
        .where('coupon_name', isEqualTo: coupon)
        .get()
        .then((subScriptionUserIds) async {
      subScriptionUserIds.docs.forEach((element) {
        subScriptionCpubon.add(SubscribeCoupon.fromJson(element.data()));
      });

      await Future.wait(subScriptionCpubon.map((element) async {
        await _firestore
            .collection('Users')
            .doc(element.userId)
            .get()
            .then((value1) {
          final user = Users.fromMap(value1.data()!);
          subScription.add(user);
        });
      }));

      print("users = ${subScription.length}");
    }).catchError((e) => null);
    subScribitionUsers.value = subScription.obs;
    isLoading.value = false;
  }
}
