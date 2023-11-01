import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/domain/repository/task_repository.dart';

class TaskUseCase {
  TaskRepository taskRepository;

  TaskUseCase(this.taskRepository);

  Future<List<Task>> getAllTaskExecute() => taskRepository.getAllTask();

  Future<String> insertTaskExecute(Task task) =>
      taskRepository.insertTask(task);

  Future<List<Map<String, dynamic>>> getAllTaskRemoteExecute() =>
      taskRepository.getAllTaskRemote();

  Future<String> insertTaskRemoteExecute(Task task) =>
      taskRepository.insertTaskRemote(task);

  Future<String> insertTaskCacheExecute(Task task) =>
      taskRepository.insertTaskCache(task);

  Future<void> deleteTaskCacheExecute() => taskRepository.deleteTaskCache();

  Future<List<Task>> getAllTaskCacheExecute() =>
      taskRepository.getAllTaskCache();

  Future<String> insertImageRemoteExecute(String pathImage) =>
      taskRepository.insertImageRemote(pathImage);
}
