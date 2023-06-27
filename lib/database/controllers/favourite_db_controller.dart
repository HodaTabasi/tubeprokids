
import 'package:apptubey/database/db_operations.dart';
import 'package:apptubey/models/video_model.dart';
import 'package:apptubey/preferences/shared_pref_controller.dart';

class FavourireDbController extends DbOperations<Video> {
  String userId = SharedPrefController().getValueFor(key: PrefKeys.id.name)!;

  @override
  Future<int> create(Video model) async {
    return await database.insert(Video.tableName, model.toMap());
  }

  @override
  Future<bool> delete(String id) async {
    int countOfDeletedRows = await database.delete(
      Video.tableName,
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
    return countOfDeletedRows == 1;
  }

  @override
  Future<List<Video>> read() async {
    List<Map<String, dynamic>> rowsMap = await database.rawQuery(
        'SELECT * FROM favourite WHERE user_id = ?',[userId]);
    return rowsMap.map((rowMap) => Video.fromMap(rowMap)).toList();
  }
  


}
