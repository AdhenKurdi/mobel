import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/domain/usecase/task_usecase.dart';
import 'package:task_mobel/app/utils/utils.dart';

class HomeController extends GetxController {
  RxList<Task> listTask = <Task>[].obs;
  List<Task> get taskList => listTask;

  RxList<Map<String, dynamic>> listTaskRemote = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get taskListRemote => listTaskRemote;

  late StreamSubscription<ConnectivityResult> subscription;

  final TaskUseCase taskUseCase = GetIt.I.get<TaskUseCase>();

  Rx<bool> isConnected = true.obs;

  FutureOr<void> getAllTask() async {
    final result = await taskUseCase.getAllTaskExecute();
    listTask(result);
    listTask.refresh();
    print("hehe ${result.toSet().toList()}");
  }

  FutureOr<void> insertTask(Task task) async {
    final result = await taskUseCase.insertTaskExecute(task);
    print(result);
  }

  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      showCustomSnackbar("Warning ", "No Connection", Colors.yellow, true);
      getAllTask();
      print("true");
    } else {
      getAllTaskRemote();
      print("false");
      isConnected(true);
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  FutureOr<void> getAllTaskRemote() async {
    List<Map<String, dynamic>> result =
        await taskUseCase.getAllTaskRemoteExecute();
    print(result);

    listTaskRemote(result);
    listTaskRemote.refresh();
    for (Map<String, dynamic> taskData in result) {
      final task = Task(
          id: taskData['id'],
          name: taskData['name'],
          description: taskData['description'],
          quantity: taskData['quantity'],
          latitude: taskData['latitude'],
          longitude: taskData['longitude'],
          photo: taskData['photo'],
          date: taskData['date'],
          address: taskData['address']);
      print(taskData['id']);
      await insertTask(task);
    }
  }

  @override
  void onInit() async {
    subscription =
        Connectivity().onConnectivityChanged.listen(updateConnectionStatus);
    updateConnectionStatus(await Connectivity().checkConnectivity());
    print(taskList);
    super.onInit();
  }
}
