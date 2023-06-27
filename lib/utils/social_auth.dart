import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../firebase_options.dart';
import '../models/users.dart';
import '../preferences/shared_pref_controller.dart';

class AuthSocial {
  AuthSocial._();

  static final AuthSocial instance = AuthSocial._();

  factory AuthSocial() => instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS? DefaultFirebaseOptions.currentPlatform.iosClientId :DefaultFirebaseOptions.currentPlatform.androidClientId,
    scopes: [
      'email',
    ],
  );



  // Future<UserCredential> signInWithFacebook(context) async {
  //   // Trigger the sign-in flow
  //   FacebookAuth.instance.logOut();
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //   print("dfs ${loginResult.message}");
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //   FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   // Once signed in, return the UserCredential
  //   var signInWithCredential = await FirebaseAuth.instance
  //       .signInWithCredential(facebookAuthCredential);
  //   if (signInWithCredential.user != null &&
  //       signInWithCredential.user!.uid.isNotEmpty) {
  //     // uid => db
  //     // SharedPref.instance.setUserLogin(true);
  //     addUserData(signInWithCredential.user!,context1: context);
  //     return signInWithCredential;
  //   } else {
  //     throw "error login";
  //   }
  // }


  Future<UserCredential> signInWithGoogle(context) async {
    // Trigger the authentication flow
    _googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var signInWithCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    if (signInWithCredential.user != null &&
        signInWithCredential.user!.uid.isNotEmpty) {
      // uid => db
      // SharedPref.instance.setUserLogin(true);
      addUserData(signInWithCredential.user!,context1:context);
      return signInWithCredential;
    } else {
      throw "error login";
    }
  }

  addUserData(User user1,{context1}) async {
    Users user = Users();
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    user.id = user1.uid.toString();
    user.name = user1.displayName ??"No Name";
    user.email = user1.email.toString();
    user.accountTypeEN = 'Free Account';
    user.accountTypeAR = 'حساب مجاني';
    user.country = 'Palstaine';
    user.subscraption = false;
    user.date = formattedDate;
    user.isVisible = true;
    user.videosNumber = 0.toString();
    user.image =user1.photoURL?? "https://media.istockphoto.com/id/1209654046/vector/user-avatar-profile-icon-black-vector-illustration.jpg?s=612x612&w=0&k=20&c=EOYXACjtZmZQ5IsZ0UUp1iNmZ9q2xl1BD1VvN6tZ2UI=";

    FirebaseFirestore.instance
        .collection("Users")
        .doc(user1.uid.toString())
        .set(user.toMap())
        .then((value) {
      SharedPrefController().save(user1.uid.toString());
      Navigator.pushReplacementNamed(context1, "/bottom_nav");
    }).catchError((onError) {
      print(onError);
    });
    // AnalyticsHelper.instance.logEvent(AnalyticsHelper.loginEvent,
    //     parameters: {"email": user.email.toString()});
  }

  void signOut() {
    try {
      _googleSignIn.signOut();
      // FacebookAuth.instance.logOut();
    } catch (e) {
      // Logger().e(e);
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple(context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of rawNonce.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(

      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an OAuthCredential from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in appleCredential.identityToken, sign in will fail.
    try {
      /*return */
      var userCredential = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential)
          .catchError((onError) {
        // Logger().e(onError);
        Get.snackbar("Sorry !",
            " An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.");
      });
      if (userCredential.user != null) {
        print(userCredential.user!.displayName);
        print(userCredential.user!.photoURL);
        addUserData(userCredential.user!,context1:context);
        return userCredential;
      } else {
        Get.snackbar("Sorry !", "account exists with different credential");
        throw "account exists with different credential";
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Sorry !", e.message.toString());
      // Logger().e(e.message);
      throw e.message.toString();
    }
  }
}