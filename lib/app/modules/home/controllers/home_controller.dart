import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/domain/usecase/task_usecase.dart';
import 'package:task_mobel/app/routes/app_pages.dart';
import 'package:task_mobel/app/utils/utils.dart';

class HomeController extends GetxController {
  RxList<Task> listTask = <Task>[].obs;
  List<Task> get taskList => listTask;

  RxList<Map<String, dynamic>> listTaskRemote = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get taskListRemote => listTaskRemote;

  late StreamSubscription<ConnectivityResult> subscription;

  final TaskUseCase taskUseCase = GetIt.I.get<TaskUseCase>();

  Rx<bool> isConnected = true.obs;
  bool autoPostExecuted = false;

  FutureOr<void> getAllTask() async {
    final resultTask = await taskUseCase.getAllTaskExecute();
    final resultCache = await taskUseCase.getAllTaskCacheExecute();
    final result = [...resultTask, ...resultCache];
    listTask(result);
    print(result);
    listTask.refresh();
  }

  FutureOr<void> insertTask(Task task) async {
    final result = await taskUseCase.insertTaskExecute(task);
    print(result);
  }

  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      showCustomSnackbar("Warning ", "No Connection", Colors.yellow, true);
      isConnected(false);
      getAllTask();
    } else {
      isConnected(true);
      autoPost();
      getAllTaskRemote();

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  _loadData() async {
    await Get.find<HomeController>().getAllTaskRemote();
    autoPost();
  }

  Future<void> autoPost() async {
    if(isConnected.value && !autoPostExecuted){
      autoPostExecuted = true;
      String post = "";
      final result = await taskUseCase.getAllTaskCacheExecute();
      print("${result.length} haihai");
      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          print("perulangan ke $i");
          final element = result[i];
          final imageUrl =
              await taskUseCase.insertImageRemoteExecute(element.photo);
          element.photo = imageUrl;
          post = await taskUseCase.insertTaskRemoteExecute(element);
        }
      }

      if (post != "") showCustomSnackbar("Success", post, Colors.green, false);
      await taskUseCase.deleteTaskCacheExecute();
      await getAllTaskRemote();
    }
  }

  Future<void> loadData() async {
    if (isConnected.value) {
      await getAllTaskRemote();
    } else {
      await getAllTask();
    }
  }

  FutureOr<void> getAllTaskRemote() async {
    List<Map<String, dynamic>> result =
        await taskUseCase.getAllTaskRemoteExecute();

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
