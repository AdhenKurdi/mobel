import 'dart:async';

import 'package:task_mobel/app/data/models/task_model.dart';

abstract class LocalDataSourceTask {

  FutureOr<String> insertTask(TaskModel entity);

  FutureOr<List<TaskModel>> getAllTask();
  
}
