// import 'dart:html';

import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/helper/helper.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/models/users.dart';
import 'package:apptubey/utils/fb_helper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../helper/helper.dart';
import '../models/fb_response.dart';
import '../utils/fb_helper.dart';

class FbAuthController with FirebaseHelper, Helpers {
  ///Functions:
  /// 1) signInWithEmailAndPassword
  /// 2) createAccountWithEmailAndPassword
  /// 3) signOut
  /// 4) forgetPassword
  ///

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FbResponse> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser != null){
        LogInResult _ = await Purchases.logIn(_auth.currentUser!.uid);
        // LogInResult result = await Purchases.logIn(_auth.currentUser!.uid);

      }
      await getData(userCredential.user!.uid);
        return FbResponse('Logged in successfully',true,);
      // }
    } on FirebaseAuthException catch (e) {
      return FbResponse(e.message ?? '', false);
    } catch (e) {
      return FbResponse('Something went wrong', false);
    }
  }

  Future<FbResponse> createAccount(Users user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: user.email, password: user.password!);

      user.id = userCredential.user!.uid;
      saveUserData(user);
      // if (userCredential.user != null && !userCredential.user!.emailVerified) {
      //   await userCredential.user!.sendEmailVerification();
      // }
      return successResponce;
    } on FirebaseAuthException catch (e) {
      return FbResponse(e.message ?? '', false);
    } catch (e) {
      return errorResponce;
    }
  }

  Future<void> signOut() async {
    try{
    await Purchases.logOut();
    }catch(_){
    }
    await _auth.signOut();
  }

  User get currentUser => _auth.currentUser!;

  Future<FbResponse> forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return FbResponse('Reset email sent successfully', true);
    } on FirebaseAuthException catch (e) {
      return FbResponse(e.message ?? '', false);
    } catch (e) {
      return FbResponse('Something went wrong', false);
    }
  }

  bool get loggedIn => _auth.currentUser != null;

  Future<FbResponse> saveUserData(Users user) async {
    return await _firestore
        .collection('Users')
        .doc(user.id)
        .set(user.toMap())
        .then((value) {
      SharedPrefController().save(user.id,sub:user.subscraption,subExpire:user.subscraption_duration);
      return successResponce;
    }).catchError((error) => errorResponce);
  }

  Future<FbResponse> udateUserData(id, user) async {
    return await _firestore
        .collection('Users')
        .doc(id)
        .update(user)
        .then((value) {
      return successResponce;
    }).onError((error, stackTrace) {
      return errorResponce;});
  }

  getData(id) async {
    return await _firestore
        .collection('Users')
        .doc(id)
        .get()
        .then((value) async {
         Users user = Users.fromMap(value.data()!);
         await SharedPrefController().save(user.id,sub: user.subscraption??false,subExpire: user.subscraption_duration);
    }).catchError((error) {
    });
  }
}
