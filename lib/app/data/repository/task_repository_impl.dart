import 'dart:async';

import 'package:task_mobel/app/data/datasource/local/local_data_source_task.dart';
import 'package:task_mobel/app/data/datasource/remote/remote_data_source_task.dart';
import 'package:task_mobel/app/data/models/task_model.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSourceTask localDataSourceTask;
  final RemoteDataSourceTask remoteDataSourceTask;

  const TaskRepositoryImpl(
      {required this.localDataSourceTask, required this.remoteDataSourceTask});

  @override
  Future<List<Task>> getAllTask() async {
    final result = await localDataSourceTask.getAllTask();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<String> insertTask(Task task) async {
    try {
      final result =
          await localDataSourceTask.insertTask(TaskModel.fromEntity(task));
      return result;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllTaskRemote() {
    return remoteDataSourceTask.getAllTask();
  }

  @override
  Future<String> insertTaskRemote(Task task) {
    return remoteDataSourceTask.insertTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTaskCache() {
    return localDataSourceTask.deleteTaskCache();
  }

  @override
  Future<String> insertTaskCache(Task task) {
    return localDataSourceTask.insertTaskCache(TaskModel.fromEntity(task));
  }

  @override
  Future<List<Task>> getAllTaskCache() async {
    final result = await localDataSourceTask.getAllTaskCache();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<String> insertImageRemote(String pathImage) {
    return remoteDataSourceTask.insertImage(pathImage);
  }
}
