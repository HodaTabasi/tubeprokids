
import 'package:apptubey/models/fb_response.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';

mixin FirebaseHelper {
  FbResponse get successResponce => FbResponse(SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'تمت المهمة بنجاح':'accomplished Successfully', true);
  FbResponse get errorResponce => FbResponse(SharedPrefController().getValueFor(key: PrefKeys.lang.name) == 'ar'?'Something failed ' :'', false);
}
