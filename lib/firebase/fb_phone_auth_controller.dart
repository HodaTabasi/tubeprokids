
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../get/copon_getx_controller.dart';
import '../helper/helper.dart';
import '../models/fb_response.dart';
import '../screens/bottom_navigations.dart';
import '../screens/otp/otp_screen.dart';
import '../screens/splash_screen.dart';
import 'fb_auth_controller.dart';



class FireBaseAuthPhoneController with Helpers{
  FirebaseAuth _fbAuth = FirebaseAuth.instance;
  static FireBaseAuthPhoneController? _inestance ;
  FireBaseAuthPhoneController._();

  factory FireBaseAuthPhoneController(){
    return _inestance ??=FireBaseAuthPhoneController._();
  }

  // Future<void> verifyPhoneNumber({phoneNumber,context}) async {
  //
  //   await _fbAuth.verifyPhoneNumber(
  //     phoneNumber: '+966$phoneNumber',
  //     verificationCompleted: (PhoneAuthCredential credential) {
  //       NewAccountGetxController.to.smsCode = credential.smsCode!;
  //       Navigator.pushNamed(context, OTPScreen.routeName);
  //       //save data code
  //       print("success ${credential.smsCode}");
  //
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       String smsCode = 'xxxx';
  //       // Create a PhoneAuthCredential with the code
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //           verificationId: verificationId, smsCode: smsCode);
  //       print("ggggggggtg $verificationId");
  //       // Sign the user in (or link) with the credential
  //       await _fbAuth.signInWithCredential(credential);
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //
  //     },
  //   );
  //
  // }

  Future<void> verifyPhoneNumber1({userPhone, context,flag}) async {
    print("gggggggggggg ${CoponGextController.to.sufixPhone}${userPhone}");
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    // String userPhoneNumber = "+91 " + _phoneNumberController.text.toString().trim();
    // print(userPhoneNumber);
    //  +970123456789

    /// Handle This
    // oTPPinTrials.value += 1 ;

    /// if Phone Auto Handled OTP Received Message
    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential _phoneAuthCredential ) async {
      print('verificationCompleted');
      print(_phoneAuthCredential);
      // Provider.of<NewUserProvider>(context, listen: false).changeLoading(false);
      afterPhoneVerification (context) ;
      // if(  Provider.of<MainProvider>(context,
      //     listen: false).isReset){
      //   PhoneAuthCredential _phoneAuthCredential =
      //   PhoneAuthProvider.credential(verificationId: Provider.of<NewUserProvider>(context, listen: false).verificationId , smsCode: "" );
      //   Provider.of<MainProvider>(context,
      //       listen: false).smsCode = _phoneAuthCredential.smsCode!;
      // }else{
      //   afterPhoneVerification (context) ;
      // }
    }

    void verificationFailed( FirebaseAuthException _e) {
      Navigator.pop(context);
      print('verificationFailed');
      print(_e);
      print(_e.code);

    }


    /// if Phone Didn't Handled OTP Received Message Automaticly
    // void codeSent(String verificationId, [int code]) {
    void codeSent(String _verificationId, int? _resendToken ) async {
      Navigator.pop(context);
      print( 'codeSent' );
      print( _verificationId );
      print( 'resendToken' );
      print( _resendToken.toString() );

      CoponGextController.to.verificationId = _verificationId ;


      Navigator.pushNamed(context, OTPScreen.routeName);
    }

    void codeAutoRetrievalTimeout(String _verificationId ) {
      Navigator.pop(context);
      print('codeAutoRetrievalTimeout');
      // _authController.registerRefuseReason.value = errorOTPTimeOut ;
      print( _verificationId );

    }

    await _fbAuth.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: "${CoponGextController.to.sufixPhone}$userPhone" ,
      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      // timeout: Duration(milliseconds: 10000),
      timeout: const Duration(seconds: 120),
      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      // verificationCompleted: verificationCompleted ,
      /// Called when the verification is failed
      verificationFailed: verificationFailed ,
      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent ,
      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
    ); // All the callbacks are above


  }

  Future<void> handleManualOTP (String _otpCode,context) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential _phoneAuthCredential =
    PhoneAuthProvider.credential(verificationId: CoponGextController.to.verificationId! , smsCode: _otpCode );

    print(_phoneAuthCredential.smsCode);

      afterPhoneVerification (context) ;

  }


  Future<void> afterPhoneVerification(context) async {
    showLoaderDialog(context);
    FbResponse fbResponse = await FbAuthController().createAccount(CoponGextController.to.user!);
    Navigator.pop(context);
    if (fbResponse.success) {
      // Navigator.pop(context);
     showSnackBar(context, message: fbResponse.message, error: !fbResponse.success);

      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName,(_)=>false);
    } else
      showSnackBar(context, message: fbResponse.message, error: !fbResponse.success);
  }
  }
