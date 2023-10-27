import 'dart:async';

import 'package:task_mobel/app/data/datasource/helper/task_database_helper.dart';
import 'package:task_mobel/app/data/datasource/local/local_data_source_task.dart';
import 'package:task_mobel/app/data/models/task_model.dart';
import 'package:task_mobel/app/utils/exception.dart';

class LocalDataSourceTaskImpl extends LocalDataSourceTask {
  final TaskDatabaseHelper taskDatabaseHelper;

  LocalDataSourceTaskImpl({required this.taskDatabaseHelper});

  @override
  FutureOr<String> insertTask(TaskModel entity) async {
    try {
      await taskDatabaseHelper.insertTask(entity);
      return 'Adding data successfully';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  FutureOr<List<TaskModel>> getAllTask() async {
    try {
      final result = await taskDatabaseHelper.getTasks();
      return result.map((e) => TaskModel.fromMap(e)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
