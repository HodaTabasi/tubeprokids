

// We use name route
// All our routes will be available here
import 'package:apptubey/screens/Favourite/fav_screen.dart';
import 'package:apptubey/screens/Home/home_screen.dart';
import 'package:apptubey/screens/add_video/add_video.dart';
import 'package:apptubey/screens/my_vedio/my_vedio_screen.dart';
import 'package:apptubey/screens/profile/my_coupon.dart';
import 'package:apptubey/screens/profile/profile_screen.dart';
import 'package:apptubey/screens/setting/setting.dart';
import 'package:apptubey/screens/video_ditails/video_ditails.dart';
import 'package:flutter/material.dart';

import '../screens/bottom_navigations.dart';
import '../screens/change_password/change_pass.dart';
import '../screens/first_one.dart';
import '../screens/otp/otp_screen.dart';
import '../screens/play_list/play_name_screen.dart';
import '../screens/setting/web_view_screen.dart';
import '../screens/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  FirstScreen.routeName: (context) => FirstScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ViewViewScreen.routeName: (context) => ViewViewScreen(),
  OTPScreen.routeName: (context) => OTPScreen(),
  BottomNavigation.routeName: (context) => BottomNavigation(),
  // ////////////////
  MyVideoScreens.routeName: (context) => MyVideoScreens(),
  FavScreen.routeName: (context) => FavScreen(),
  AddVideo.routeName: (context) => AddVideo(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  // //////////
  Setting.routeName: (context) => Setting(),
  ChangePass.routeName: (context) => ChangePass(),
  PlayNameScreen.routeName: (context) => PlayNameScreen(),
  MyCouponScreen.routeName: (context) => MyCouponScreen(),


  // CreateAccount.routeName: (context) => CreateAccount(),
  // ////////////
  // HomeScreen.routeName: (context) => HomeScreen(),
  // ForgetPassword.routeName: (context) => ForgetPassword(),
  // CreateAccountNext.routeName: (context) => CreateAccountNext(),
  // VitalSigns.routeName: (context) => VitalSigns(),
  // ////////
  // MedicalRecipes.routeName: (context) => MedicalRecipes(),
  // Vaccinations.routeName: (context) => Vaccinations(),
  // VitalSigns.routeName: (context) => VitalSigns(),
  // TestResults.routeName: (context) => TestResults(),
  // MyDoctorsScreen.routeName: (context) => MyDoctorsScreen(),
  // InsuranceApprovals.routeName: (context) => InsuranceApprovals(),
  // SickLeave.routeName: (context) => SickLeave(),
  // FamillyScreen.routeName: (context) => FamillyScreen(),
  // RexcordBooking.routeName: (context) => RexcordBooking(),
  // OfferScreen.routeName: (context) => OfferScreen(),
  // OfferDetails.routeName: (context) => OfferDetails(),
  // MyAppointmentBooking.routeName: (context) => MyAppointmentBooking(),
  // PaymentScreen.routeName: (context) => PaymentScreen(),
  // PaymentRecord.routeName: (context) => PaymentRecord(),
  // ReservationData.routeName: (context) => ReservationData(),
  // DoneScreens.routeName: (context) => DoneScreens(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
  // ButtomNavigations.routeName: (context) => ButtomNavigations(),
  // EditProfile.routeName: (context) => EditProfile(),
  // EditInsuranceData.routeName: (context) => EditInsuranceData(),
  // ChangePassword.routeName: (context) => ChangePassword(),
  // OTPScreen.routeName: (context) => OTPScreen(),
  // LoginDoneScreens.routeName: (context) => LoginDoneScreens(),
};
