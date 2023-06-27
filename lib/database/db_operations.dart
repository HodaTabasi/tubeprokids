import 'package:apptubey/database/db_controller.dart';
import 'package:sqflite/sqflite.dart';

abstract class DbOperations<Model> {
  final Database database = DbController().database;

  // final int userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name) ?? 0;

  Future<int> create(Model model);

  Future<List<Model>> read();
  Future<bool> delete(String id);
}
