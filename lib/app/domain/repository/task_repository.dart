import 'package:task_mobel/app/domain/entity/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTask();
  Future<String> insertTask(Task task);

  Future<List<Map<String, dynamic>>> getAllTaskRemote();
  Future<String> insertTaskRemote(Task task);
  Future<String> insertImageRemote(String pathImage);

  Future<String> insertTaskCache(Task task);
  Future<void> deleteTaskCache();
  Future<List<Task>> getAllTaskCache();
}
