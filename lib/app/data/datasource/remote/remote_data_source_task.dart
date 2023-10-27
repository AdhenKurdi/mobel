import 'dart:async';

import 'package:task_mobel/app/data/models/task_model.dart';

abstract class RemoteDataSourceTask {
  Future<String> insertTask(TaskModel entity);

  Future<List<Map<String, dynamic>>> getAllTask();
}
