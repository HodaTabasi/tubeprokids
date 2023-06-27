import 'package:shared_preferences/shared_preferences.dart';

enum PrefKeys {loggedIn, id, name, email, lang, country, image ,sub,subExpire}

class SharedPrefController {
  SharedPrefController._internal();

  late SharedPreferences _sharedPreferences;
  static SharedPrefController? _instance;

  factory SharedPrefController() {
    return _instance ??= SharedPrefController._internal();
  }

  Future<void> initPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> save(id, {sub, subExpire}) async {
    //print(sub);

    print(id);

    await _sharedPreferences.setString(PrefKeys.id.name, id);
    await _sharedPreferences.setBool(PrefKeys.loggedIn.name, true);
    await _sharedPreferences.setBool(PrefKeys.sub.name, sub??false);
    await _sharedPreferences.setString(PrefKeys.subExpire.name, subExpire??"");
  }
  Future<void> saveCountry(country) async {
    await _sharedPreferences.setString(PrefKeys.country.name, country);
  }

  Future<void> saveSub(sub) async {
    await _sharedPreferences.setBool(PrefKeys.sub.name, sub);
}
  Future<void> saveSubE(sub,subExpire) async {
    await _sharedPreferences.setBool(PrefKeys.sub.name, sub);
    await _sharedPreferences.setString(PrefKeys.subExpire.name, subExpire??"");
  }



  bool get loggedIn =>
      _sharedPreferences.getBool(PrefKeys.loggedIn.name) ?? false;

  T? getValueFor<T>({required String key}) {
    if (_sharedPreferences.containsKey(key)) {
      return _sharedPreferences.get(key) as T;
    }
    return null;
  }

  

  Future<bool> changeLanguage({required String language}) async {
    return _sharedPreferences.setString(PrefKeys.lang.name, language);
  }

  Future<bool> removeValueFor({required String key}) async {
    if (_sharedPreferences.containsKey(key)) {
      return _sharedPreferences.remove(key);
    }
    return false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PrefKeys.loggedIn.name);
    _sharedPreferences.remove(PrefKeys.email.name);
    // _sharedPreferences.remove(PrefKeys.id.name);

    // _sharedPreferences.setBool(PrefKeys.loggedIn.name, false);
  }

  Future<bool> clear() async {
    return _sharedPreferences.clear();
  }
}

// class Shape {
//   factory Shape() {
//     return Circle();
//   }
// }
//
// class Circle extends Shape {}
