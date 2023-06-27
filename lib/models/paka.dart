import 'package:get/get.dart';

import '../preferences/shared_pref_controller.dart';

class Paka {
  String id;
  String name;
  String price;

  Paka(this.id, this.name, this.price);

}

List<Paka> pacakesDiscounts = GetPlatform.isIOS ? [
  Paka("1", SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'شهر':"1 month", "tube_fifthy_1111_1m"),
  Paka("2", SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'سنوي':"yearly", "tube_fifthy_1111_1y"),
  Paka("3", SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'للابد':"all", "tube_fifthy_555_alltime"),
] : [
    Paka("1", SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'شهر':"1 month", "tubey_1111_1m_discount"),
    Paka("1", SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'سنوي':"yearly", "tubey_1111_1y_discount"),
    Paka("3", SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'للابد':"all", "tubey-1111-life-discount"),


];




