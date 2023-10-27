import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/routes/app_pages.dart';

class CardTask extends StatelessWidget {
  Task task;

  CardTask({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.DETAIL, arguments: task);
      },
      child: Card(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(task.name),
                subtitle: Text(task.date),
              ))),
    );
  }
}
