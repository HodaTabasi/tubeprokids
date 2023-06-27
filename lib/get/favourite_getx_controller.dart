import 'package:apptubey/database/controllers/favourite_db_controller.dart';
import 'package:apptubey/models/process_response.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:get/get.dart';

class FavouriteGetxController extends GetxController {
  RxList<Video> videosItems = <Video>[].obs;
  RxBool loading = false.obs;

  List orderCart = [].obs;

  static FavouriteGetxController get to => Get.find<FavouriteGetxController>();

  bool isHideController = false;
  int startAt = 0;
  int index = 0;
  String currentUrl = "";

  @override
  void onInit() {
    read();
    super.onInit();
  }

  final FavourireDbController _dbController = FavourireDbController();

  changeListIndexP(){
    index+=1;
  }
  changeListIndexM(){
    index-=1;
  }
  setCurentUrl(url){
    currentUrl = url;
  }


  Future<ProcessResponse> create(Video video) async {
    int newRowId = await _dbController.create(video);
    if (newRowId != 0) {
      videosItems.add(video);
      return getResponse(newRowId != 0);
    }
    return getResponse(false);
  }

  void read() async {
    loading.value = true;
    videosItems.value = await _dbController.read();
    loading.value = false;
  }

  Future<ProcessResponse> delete(String id, int index) async {
    bool result = await _dbController.delete(id);

    if (result) {
      videosItems.removeAt(index);
    }

    return getResponse(result);
  }

  ProcessResponse getResponse(bool success) {
    return ProcessResponse(
      message:
          success ? 'Operation completed successfully' : 'Operation failed!',
      success: success,
    );
  }
}
