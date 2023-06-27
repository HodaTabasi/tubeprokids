import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BtnLayout extends StatelessWidget {
  late String title;
  late VoidCallback prsee;
  EdgeInsetsGeometry? margin;
  
  // late Function prsee;

  BtnLayout(this.title,this.prsee,{this.margin});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: margin ?? EdgeInsets.all(16.0.r),
        height: 50.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0.r),
          clipBehavior: Clip.hardEdge,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffFF0000)),
                padding: MaterialStateProperty.all(EdgeInsets.all(10.r)),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16.sp,color: Colors.white))),
            onPressed: prsee,
            child: Text("$title",style: TextStyle(fontSize: 16.sp,color: Colors.white,fontWeight: FontWeight.w700,fontFamily: 'avater'),),

          ),
        ),
      ),
    );
  }

  // (){
  // NavigationService.navigationService.navigateTo(GMap.routeName);
  // // showDialog(context: context,
  // //     builder: (BuildContext context){
  // //       return CustomDialogBox(
  // //         title: "Custom Dialog Demo",
  // //         // descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
  // //         // text: "Yes",
  // //       );
  // //     }
  // // );
  // },


}
