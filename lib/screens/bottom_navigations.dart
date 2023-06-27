// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:apptubey/screens/Favourite/fav_screen.dart';
import 'package:apptubey/screens/Home/home_screen.dart';
import 'package:apptubey/screens/my_vedio/my_vedio_screen.dart';
import 'package:apptubey/screens/play_list/play_name_screen.dart';
import 'package:apptubey/screens/profile/profile_screen.dart';
import 'package:apptubey/screens/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

import '../get/language_getx_controller.dart';
import '../get/video_getx_controller.dart';
import '../models/bn_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../preferences/shared_pref_controller.dart';
import 'constant.dart';
import 'my_vedio/show_offerring.dart';

class BottomNavigation extends StatefulWidget {
  static String routeName = "/bottom_nav";

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
  with SingleTickerProviderStateMixin {

  BottomNavigationController bottomNavigationController = Get.put(BottomNavigationController());

  late List<BnScreen> screens;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      VideoGetxController.to.readUserVideos();
    });

  }

  @override
  Widget build(BuildContext context) {

         final LanguageGetxController languageGetxController =
  Get.put<LanguageGetxController>(LanguageGetxController());
  
    screens = <BnScreen>[
      BnScreen(title: AppLocalizations.of(context)!.home, widget: HomeScreen()),
      BnScreen(
          title: AppLocalizations.of(context)!.library,
          widget: MyVideoScreens()),
      BnScreen(
          title: AppLocalizations.of(context)!.favorite,
          widget: PlayNameScreen()),
      BnScreen(
          title: AppLocalizations.of(context)!.profile,
          widget: ProfileScreen()),
    ];

    
      

    return GetBuilder<BottomNavigationController>(

   
              builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: screens[controller.selectedPageIndex].widget,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xffE20000),
            onPressed: () {
              if(!SharedPrefController().getValueFor(key: PrefKeys.sub.name)){
                if (VideoGetxController.to.userVideos.length >= AppConstant.VIDEO_LIMIT_LENTH) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>showOffering()));
                  // context.showSnackBar(
                  //   message: AppLocalizations.of(context)!
                  //       .have_exceeded_the_maximum_number_of_videos_for_the_free_account,
                  //   error: true,
                  // );
                } else {
                  Navigator.pushNamed(context, "/add_video");
                }
              }else {
                Navigator.pushNamed(context, "/add_video");
              }

            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar:
               SizedBox(
                height: 80.h,
                child: SizedBox(
                  height: 80.h,
                  child: BottomAppBar(
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    shape: const CircularNotchedRectangle(),
                    notchMargin: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        languageGetxController.language.value ==
                                'ar'
                            ? Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 0
                                        ? 'assets/selected_home.svg'
                                        : 'assets/unselected_home.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                    setState(() {
                                    controller.updataIndex(0);

                                    });
                                  },
                                ),
                              )
                            : Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 0
                                        ? 'assets/home_e_selected.svg'
                                        : 'assets/home_e_unselected.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                    setState(() {
                                     controller.updataIndex(0);

                                    });
                                  },
                                ),
                              ),
                        languageGetxController.language.value ==
                                'ar'
                            ? Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 1
                                        ? 'assets/selected_lib.svg'
                                        : 'assets/unselected_lib.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      controller.updataIndex(1);
                                    });
                                  },
                                ),
                              )
                            : Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 1
                                        ? 'assets/library_e_selected.svg'
                                        : 'assets/library_e_unselected.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                    controller.updataIndex(1);
                                   
                                  },
                                ),
                              ),
                        languageGetxController.language.value == 'ar'
                            ? Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 2
                                        ? 'assets/72_66_select.svg'
                                        : 'assets/72_66.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                  controller.updataIndex(2);

                                  },
                                ),
                              )
                            : Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 2
                                        ? 'assets/playlist_e_selected.svg'
                                        : 'assets/playList_e_unselect.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                    controller.updataIndex(2);

                                  },
                                ),
                              ),
                        languageGetxController.language.value ==
                                'ar'
                            ? Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                    controller.selectedPageIndex == 3
                                        ? 'assets/selected_profile.svg'
                                        : 'assets/unselected_profile.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                   controller.updataIndex(3);

                                  },
                                ),
                              )
                            : Expanded(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  iconSize: 80,
                                  icon: SvgPicture.asset(
                                     controller.selectedPageIndex == 3
                                        ? 'assets/profile_e_selected.svg'
                                        : 'assets/profile_e_nuselect.svg',
                                    semanticsLabel: 'Acme Logo',
                                  ),
                                  onPressed: () {
                                   controller.updataIndex(3);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
          
        );
      }
    );
  }
}

// class EnglishButtom extends StatefulWidget {
//   @override
//   State<EnglishButtom> createState() => _EnglishButtomState();
// }
//
// class _EnglishButtomState extends State<EnglishButtom> {
//   int selectedPageIndex = 0;
//
//   late List<BnScreen> screens;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80.h,
//       child: BottomAppBar(
//         elevation: 5,
//         clipBehavior: Clip.antiAlias,
//         color: Colors.white,
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 0
//                       ? 'assets/home_e_selected.svg'
//                       : 'assets/home_e_unselected.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 0;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 1
//                       ? 'assets/library_e_selected.svg'
//                       : 'assets/library_e_unselected.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 1;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 2
//                       ? 'assets/playlist_e_selected.svg'
//                       : 'assets/playList_e_unselect.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 2;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 3
//                       ? 'assets/profile_e_selected.svg'
//                       : 'assets/profile_e_nuselect.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 3;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ArabicButtom extends StatefulWidget {
//   const ArabicButtom({Key? key}) : super(key: key);
//
//   @override
//   State<ArabicButtom> createState() => _ArabicButtomState();
// }
//
// class _ArabicButtomState extends State<ArabicButtom> {
//   int selectedPageIndex = 0;
//
//   late List<BnScreen> screens;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80.h,
//       child: BottomAppBar(
//         elevation: 5,
//         clipBehavior: Clip.antiAlias,
//         color: Colors.white,
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 0
//                       ? 'assets/selected_home.svg'
//                       : 'assets/unselected_home.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 0;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 1
//                       ? 'assets/selected_lib.svg'
//                       : 'assets/unselected_lib.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 1;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 2
//                       ? 'assets/72_66_select.svg'
//                       : 'assets/72_66.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 2;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: IconButton(
//                 padding: EdgeInsets.all(0),
//                 iconSize: 80,
//                 icon: SvgPicture.asset(
//                   selectedPageIndex == 3
//                       ? 'assets/selected_profile.svg'
//                       : 'assets/unselected_profile.svg',
//                   semanticsLabel: 'Acme Logo',
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     selectedPageIndex = 3;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class BottomNavigationController extends GetxController{


     int _selectedPageIndex = 0;
     int get selectedPageIndex => _selectedPageIndex;


     void updataIndex(int index,{bool notify = true}){
      _selectedPageIndex = index;
      if(notify){
      update();
      }
     }

} 