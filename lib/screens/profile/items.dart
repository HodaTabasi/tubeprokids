import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TextItem extends StatelessWidget {
  String hint;
  bool isVisable = false;
  late VoidCallback prsee;

  TextItem(this.hint, this.prsee, {this.isVisable = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: prsee,
      child: Container(
        // margin:  EdgeInsets.symmetric(horizontal: 16.r,vertical: 8.r),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 0.8.r),
            borderRadius: BorderRadius.circular(5.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(0, 1),
                  blurRadius: 2)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.r, vertical: 16.r),
              child: Text(
                hint,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'avater',
                    fontWeight: FontWeight.bold),
              ),
            )),
            Opacity(
              child: Padding(
                padding: EdgeInsets.all(16.0.r),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 20.sp,
                ),
              ),
              opacity: isVisable ? 0 : 1,
            )
          ],
        ),
      ),
    );
  }
}
