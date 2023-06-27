
import 'package:apptubey/models/mm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PakaItem extends StatelessWidget {
  String title;
  String value;
  String groupValue;
  ValueChanged onChanged;
  String data;
  String price;


  PakaItem({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.data,
  required this.price});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: (){
        onChanged(value);
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.symmetric(horizontal: 16.r,vertical: 8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          border: Border.all(color: !isSelected ?Colors.grey.withOpacity(0.6):const Color(0xff0195d5), width: 0.8.r),
          // boxShadow: [
          //   BoxShadow(
          //     offset: Offset(0, 10),
          //     blurRadius: 70,
          //     color: Colors.grey.withOpacity(0.23),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontFamily: 'avater',
                  fontWeight: FontWeight.bold,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price,
                    style:  TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 13.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 8.h,
                ),
                Text(data,
                    style:  TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontFamily: 'avater',
                      fontWeight: FontWeight.normal,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

