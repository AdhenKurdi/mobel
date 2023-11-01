import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/routes/app_pages.dart';

class TaskItemCard extends StatelessWidget {
  final Map<String, dynamic>? taskData;
  final Task? taskDatas;

  TaskItemCard(this.taskData,this.taskDatas);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.DETAIL, arguments: taskData ?? taskDatas);
      },
      child: taskData != null ? Card(
        margin: const EdgeInsets.all(10),
        elevation: 10,
        shadowColor: Colors.grey,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: CachedNetworkImage(
            imageUrl: taskData!['photo'],
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                Lottie.asset("assets/loading.json", height: 50, width: 50),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          title: Text(taskData!['name']),
          subtitle: Text(taskData!['description']),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),
        ),
      ) : Card(
              margin: const EdgeInsets.all(10),
              elevation: 10,
              shadowColor: Colors.grey,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: taskDatas!.photo.contains("http") ? CachedNetworkImage(
                  imageUrl: taskDatas!.photo,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Lottie.asset(
                      "assets/loading.json",
                      height: 50,
                      width: 50),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ): ClipOval(
                    child: Image.file(
                          File(taskDatas!.photo),
                          width: 80.0,
                          height: 80.0,
                        ),
                ),
                title: Text(taskDatas!.name),
                subtitle: Text(taskDatas!.description),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ),
    );
  }
}
