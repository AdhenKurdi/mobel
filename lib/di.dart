import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_mobel/app/data/datasource/helper/task_database_helper.dart';
import 'package:task_mobel/app/data/datasource/local/impl/local_data_source_task_impl.dart';
import 'package:task_mobel/app/data/datasource/local/local_data_source_task.dart';
import 'package:task_mobel/app/data/datasource/remote/impl/remote_data_source_task_impl.dart';
import 'package:task_mobel/app/data/datasource/remote/remote_data_source_task.dart';
import 'package:task_mobel/app/data/repository/task_repository_impl.dart';
import 'package:task_mobel/app/domain/repository/task_repository.dart';
import 'package:task_mobel/app/domain/usecase/task_usecase.dart';

final locator = GetIt.instance;

void init() {
  locator.registerLazySingleton(() => TaskUseCase(locator()));

  locator.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(localDataSourceTask: locator(),remoteDataSourceTask: locator()));

  locator.registerLazySingleton<LocalDataSourceTask>(
      () => LocalDataSourceTaskImpl(taskDatabaseHelper: locator()));

  locator.registerLazySingleton<RemoteDataSourceTask>(
      () => RemoteDataSourceTaskImpl());    

  locator.registerLazySingleton<TaskDatabaseHelper>(() => TaskDatabaseHelper());
}
