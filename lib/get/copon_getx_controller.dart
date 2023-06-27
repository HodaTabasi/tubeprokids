import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/copon.dart';
import '../models/fb_response.dart';
import '../models/users.dart';
import '../preferences/shared_pref_controller.dart';
import '../utils/fb_helper.dart';

class CoponGextController extends GetxController with FirebaseHelper {
  RxBool isLoading = false.obs;
  RxList<Copon> coponList = <Copon>[].obs;
  RxInt allNumCopon = 0.obs;
  RxString sufixPhone = "+972".obs;
  String? verificationId;
  Users? user;
///////////////////////
  final num1Controller = TextEditingController();
  final num2Controller = TextEditingController();
  final num3Controller = TextEditingController();
  final num4Controller = TextEditingController();
  final num5Controller = TextEditingController();
  final num6Controller = TextEditingController();

  ///////////////

  String makeCode() {
    var num1 = num1Controller.text;
    var num2 = num2Controller.text;
    var num3 = num3Controller.text;
    var num4 = num4Controller.text;
    var num5 = num5Controller.text;
    var num6 = num6Controller.text;
    return num1 + num2 + num3 + num4 + num5 + num6;
  }


  TextEditingController coponPerTextController = TextEditingController();

  static CoponGextController get to => Get.find<CoponGextController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  changePhone(code){
    print(code);
    sufixPhone.value = "+"+code;
    update();
  }

  Future<bool> getCopon(String id,identifer) async {
    return await _firestore.collection('copon')
        .doc(id).get().then((value) {
          if(value.data() != null){
            print(value.data());
            // final beneficiaries_number = value.data()?['beneficiaries_number'];
            // allNumCopon.value = beneficiaries_number;
            // if(value.data()?['coponNum'] <= value.data()?['beneficiaries_number']){
            //   return false;
            // } else
            //  if(value.data()?['coponPer'] == identifer){
            //   return true;
            // } else {
            //   return false;
            // }
            return true;
            // print(value.data()?['coponPer']);
            // return true;
          }else {
            return false;
          }
    }).onError((error, stackTrace) => false);
  }

  Future<FbResponse> updateCoponNumber(id) async {
    int data = allNumCopon.value+1;
    return await _firestore
        .collection('copon')
        .doc(id)
        .update({'beneficiaries_number':data})
        .then((value) {
      return successResponce;
    }).onError((error, stackTrace) {
      return errorResponce;});
  }

    Future<FbResponse> addSubscriberUserWithCoupon(String userID , String couponName , String productName) async {
    int data = allNumCopon.value+1;
    DocumentReference document = _firestore.collection("subscriper_users_coupon").doc();
    return await _firestore
        .collection('subscriper_users_coupon')
        .doc(document.id)
        .set({'user_id':userID,"coupon_name":couponName,"product_name":productName})
        .then((value) {
      return successResponce;
    }).onError((error, stackTrace) {
      return errorResponce;});
  }

  Future<bool> getFlag() async {
    return await _firestore.collection('flag')
        .doc("1").get().then((value) {
      if(value.data() != null){
        return value.data()?['boole'];
        // print(value.data()?['coponPer']);
        // return true;
      }else {
        return false;
      }
    }).onError((error, stackTrace) => false);
  }
}



// Future<FbResponse> deleteCopon(id) async {
//   return  _firestore
//       .collection('copon')
//       .doc(id)
//       .delete()
//       .then((value) {
//     int index =coponList.indexWhere((element) => element.coponId ==id) ;
//     coponList.removeAt(index);
//     return successResponse;
//   }).catchError((error) => errorResponse);
// }
//
//
// Future<FbResponse> createCoupn({coponId, coponNum,coponPer}) async {
//   return _firestore
//       .collection('copon')
//       .doc(coponId)
//       .set({"coponId": coponId, "coponNum": coponNum,"coponPer":coponPer})
//       .then((value) {
//         coponList.add(Copon(coponId, coponNum, coponPer));
//         return successResponse; }
//   )
//       .catchError((error) => errorResponse);
// }}
