import 'package:flutter/material.dart';

import 'SizeConfig.dart';

MaterialColor colorCustom = MaterialColor(0xFF058638, color);
const kPrimaryColor = Color(0xFF058638);

Map<int, Color> color = {
  50: Color(0xFF9BD5B4),
  100: Color(0xFF40B66B),
  200: Color(0xFF3E865F),
  300: Color(0xFF5DCB88),
  400: Color(0xFF3B945F),
  500: kPrimaryColor,
  600: Color(0xFF058638),
  700: Color(0xFF056B2B),
  800: Color(0xFF046E2D),
  900: Color(0xFF023817),
};
final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
  fillColor: Colors.white,
  filled: true,
    counterStyle: TextStyle(height: double.minPositive,),
    counterText: ""
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: Color(0xffDCDCDC)),
  );
}

// List<Service> service = [
//   Service('assets/images/consult.svg','طلب استشارة','طلب استشارة من أي طبيب',''),
//   Service('assets/images/date.svg','حجز موعد','اضغط هنا لحجز موعد',''),
//   Service('assets/images/doctor.svg','الأطباء','ابحث عن طبيب في القائمة',''),
//   Service('assets/images/report.svg','فتح ملف طبي','اضغط لفتح ملف طبي جديد',''),
// ];