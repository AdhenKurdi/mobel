import 'package:task_mobel/app/domain/entity/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTask();
  Future<String> insertTask(Task task);

  Future<List<Map<String, dynamic>>> getAllTaskRemote();
  Future<String> insertTaskRemote(Task task);
}
