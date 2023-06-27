import 'dart:io';

import 'package:apptubey/firebase/fb_auth_controller.dart';
import 'package:apptubey/get/user_getx_controller.dart';
import 'package:apptubey/get/video_getx_controller.dart';
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/models/users.dart';
import 'package:apptubey/screens/play_list/play_list_screen.dart';
import 'package:apptubey/screens/profile/my_coupon.dart';
import 'package:apptubey/screens/splash_screen.dart';
import 'package:apptubey/utils/context_extenssion.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchases_flutter/purchases_flutter.dart';


import '../../api/purchase_api.dart';
import '../../preferences/shared_pref_controller.dart';
import '../Favourite/fav_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bottom_navigations.dart';
import '../my_vedio/show_offerring.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile_screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserGetxController userGetxController = Get.find();
  late ImagePicker _imagePicker;
  late TextEditingController _textFieldController;
  File? _photo;


Future<void> testData() async{

 PurchaseApi.checkCustomerStatus();
  CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  print("customerInfo $customerInfo");
  if (customerInfo.entitlements.all["premium"]!.isActive ) {
  // Grant user "pro" access
  customerInfo.entitlements.all["premium"]!.isSandbox;
  customerInfo.entitlements.all["premium"]!.expirationDate;
  customerInfo.entitlements.all["premium"]!.originalPurchaseDate;
  customerInfo.entitlements.all["premium"]!.ownershipType;
  customerInfo.entitlements.active;
  print("Wewewewe");
  }else {
  print("nooooooo");

    // premium
  }

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userGetxController.getCurrentUser();
      // testData();
    });
    _textFieldController = TextEditingController();
    _imagePicker = ImagePicker();

  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffF2F2F2),
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'avater'),
        ),
        // actions: [
        //   Icon(
        //     Icons.search_sharp,
        //     size: 33.r,
        //     color: Colors.grey.shade400,
        //   ),
        //   SizedBox(
        //     width: 8.w,
        //   ),
        // ],
        elevation: 0,
        centerTitle: true,
      ),
      body:
      SizedBox(
          width: double.infinity,
          child: GetX<UserGetxController>(
            builder: (controller) {
              return controller.isLoading.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(children: [
                            SizedBox(
                              height: 100.h,
                              width: 100.w,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    controller.currentUser.value.image),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Container(
                                      width: 30.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffD53D76),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0.r))),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18.r,
                                      )),
                                ))
                          ]),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: SharedPrefController().getValueFor(key: PrefKeys.sub.name),
                                  child: Image.asset("assets/crown.png",width: 20.w,height: 20.h,)),
                              SizedBox(width: 15.w,),
                              Text(
                                controller.currentUser.value.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontFamily: 'avater',
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _displayTextInputDialog(context),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue.shade400,
                                ),
                              )
                            ],
                          ),
                          Text(
                            controller.currentUser.value.email,
                            style: TextStyle(
                              color: const Color(0xff666666),
                              fontSize: 16.sp,
                              fontFamily: 'avater',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                           height: 20.h,
                          ),
                          Divider(
                            // height: 3,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: Text(
                              AppLocalizations.of(context)!.setting,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily: 'avater',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, "/setting");
                            },
                            // contentPadding: EdgeInsets.all(0),
                          ),
                          Divider(
                            // height: 19,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                           ...[ UserGetxController.to.currentUser.value.couponId == null ? const SizedBox() : ListTile(
                            leading: const Icon(Icons.countertops),
                            title: Text(
                              AppLocalizations.of(context)!.my_coupon,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily: 'avater',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, MyCouponScreen.routeName);
                            },
                            // contentPadding: EdgeInsets.all(0),
                          ),
                         UserGetxController.to.currentUser.value.couponId == null ? const SizedBox() : Divider(
                            // height: 19,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),],
                          ListTile(
                            leading: const Icon(Icons.policy),
                            title: Text(
                              AppLocalizations.of(context)!.policy,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily: 'avater',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, "/webview_screen");
                            },
                            // contentPadding: EdgeInsets.all(0),
                          ),
                          Divider(
                            // height: 19,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                          ListTile(
                            onTap: () async {
                              await FbAuthController().signOut();
                              await SharedPrefController().logout();
                              // VideoGetxController.to.dispose();
                              Future.delayed(const Duration(seconds: 1), () {
                                // exit(0);
                                Get.find<BottomNavigationController>().updataIndex(0,notify: false);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, LoginScreen.routeName,ModalRoute.withName('/'));
                              });


                            },
                            leading: const Icon(Icons.logout),
                            title: Text(
                              AppLocalizations.of(context)!.logout,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily: 'avater',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // contentPadding: EdgeInsets.all(0),
                          ),
                          Divider(
                            // height: 19,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                          // ListTile(
                          //   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FavScreen())),
                          //   leading:
                          //   const Icon(Icons.favorite,),
                          //   title: Text(
                          //     AppLocalizations.of(context)!.favorite,
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 16.sp,
                          //       fontFamily: 'avater',
                          //       fontWeight: FontWeight.normal,
                          //     ),
                          //   ),
                          //   // contentPadding: EdgeInsets.all(0),
                          // ),


                           SizedBox(
                            height: 10.h,
                          ),

                          Visibility(
                            visible: !SharedPrefController().getValueFor(key: PrefKeys.sub.name),
                            child: SizedBox(
                              height: 48,
                              // width: 100.w,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: InkWell(
                                    onTap: () {
                                      _displayAlertDialog(context);
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient:  LinearGradient(
                                          begin: Alignment.center,
                                          colors: [
                                           Color(0xffE20000),
                                             Colors.red.withOpacity(0.6)
                                        ]),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.subscription,
                                          style: TextStyle(
                                              fontFamily: "avater", color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 30.h,
                          ),
                          InkWell(
                            onTap: () async {
                              FbResponse responce = await userGetxController.deleteUser();
                              if(responce.success){
                                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.falied)));
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.delete_account,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontFamily: 'avater',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                        ],
                      ),
                    );
            },
          )),
    );
  }

  void _pickImage() async {
    XFile? imageFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _photo = File(imageFile.path);
      });

      var image = await uploadFile(_photo);
      userGetxController.currentUser.value.image = image;
      FbResponse fbResponse = await userGetxController.updateUser(
          user: userGetxController.currentUser.value);
      if (fbResponse.success) {
        // Navigator.popAndPushNamed(context, '/bottom_nav');
      }
      context.showSnackBar(message: fbResponse.message);
    }
  }

  Future<String> uploadFile(File? image) async {
    final storageReference =
        FirebaseStorage.instance.ref('files/');
    final mainStorage = storageReference.child("${DateTime.now()}_image");
    TaskSnapshot uploadTask = await mainStorage.putFile(image!);

    if(uploadTask.state == TaskState.success){
      return await mainStorage.getDownloadURL();
    }else {
      context.showSnackBar(message: "",error: true);
      return "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png";
    }


  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text(AppLocalizations.of(context)!.full_name),
            content: TextField(
              controller: _textFieldController,
              decoration:  InputDecoration(hintText: AppLocalizations.of(context)!.full_name),
            ),
            actions: <Widget>[
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.edit,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  userGetxController.currentUser.value.name =
                      _textFieldController.text;

                  FbResponse fbResponse = await userGetxController.updateUser(
                      user: userGetxController.currentUser.value);
                  if (fbResponse.success) {
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    });
                  }
                  context.showSnackBar(message: fbResponse.message);
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:  Text(AppLocalizations.of(context)!.titlew),
            content: Text(AppLocalizations.of(context)!.mssage1),
            actions: <Widget>[
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.yes,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>showOffering()));
                },
              ),
              TextButton(
                child:  Text(
                  AppLocalizations.of(context)!.no1 ,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  },
              ),
            ],
          );
        });
  }

}
