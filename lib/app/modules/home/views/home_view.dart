import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:task_mobel/app/components/task_item_card.dart';

import 'package:task_mobel/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.task),
            onPressed: () {
              Get.toNamed(Routes.ADDS);
            }),
        body: RefreshIndicator(
          child: Obx(() {
            return controller.listTaskRemote.isEmpty
                ? ListView.builder(
                    itemCount: controller.listTask.length,
                    itemBuilder: (context, index) {
                      return TaskItemCard(null, controller.listTask[index]);
                    },
                  )
                : ListView.builder(
                    itemCount: controller.listTaskRemote.length,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                          controller.listTaskRemote[index], null);
                    },
                  );
          }),
          onRefresh: () async {
            await controller.loadData();
            print("hello");
            
          },
        ));
  }
}
