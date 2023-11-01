import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  DetailView({Key? key}) : super(key: key);

  GoogleMapController? _gmapsController;

  @override
  Widget build(BuildContext context) {
    Get.put(DetailController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('DetailView'),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  height: 1000, // Atur tinggi sesuai kebutuhan Anda
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: controller.taskObject == null ? 
                                 CachedNetworkImage(
                                        imageUrl: controller.taskMap!['photo'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            width: 200,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(15)),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        },
                                      ) : controller.taskObject!.photo.contains("") ? CachedNetworkImage(
                                        imageUrl: controller.taskObject!.photo,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            width: 200,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(15)),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        },
                                      ) : Image.file(File(controller.taskObject!.photo),
                                        width: 200,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Expanded(
                                  child: Container(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start, // Ratakan teks ke kiri
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Name",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      controller.taskObject == null
                                          ? controller.taskMap!['name']
                                          : controller.taskObject!.name,
                                      textAlign: TextAlign
                                          .left, // Ratakan teks ke kiri
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Description",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      controller.taskObject == null
                                          ? controller.taskMap!['description']
                                          : controller.taskObject!.description,
                                      textAlign: TextAlign
                                          .left, // Ratakan teks ke kiri
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Date ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      controller.taskObject == null
                                          ? controller.taskMap!['date']
                                          : controller.taskObject!.date,
                                      textAlign: TextAlign
                                          .left, // Ratakan teks ke kiri
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Address",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      controller.taskObject == null
                                          ? controller.taskMap!['address']
                                          : controller.taskObject!.address,
                                      textAlign: TextAlign
                                          .left, // Ratakan teks ke kiri
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                          // Widget untuk setengah pertama di sini
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                "Detail Address (Location)",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: double.infinity,
                                height: 500,
                                child: GoogleMap(
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _gmapsController = controller;
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        double.parse(controller.taskObject ==
                                                null
                                            ? controller.taskMap!['latitude']
                                            : controller.taskObject!.latitude),
                                        double.parse(controller.taskObject ==
                                                null
                                            ? controller.taskMap!['longitude']
                                            : controller
                                                .taskObject!.longitude)),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                        markerId: const MarkerId("marker1"),
                                        position: LatLng(
                                            double.parse(
                                                controller.taskObject == null
                                                    ? controller
                                                        .taskMap!['latitude']
                                                    : controller
                                                        .taskObject!.latitude),
                                            double.parse(
                                                controller.taskObject == null
                                                    ? controller
                                                        .taskMap!['longitude']
                                                    : controller.taskObject!
                                                        .longitude)),
                                        draggable: true,
                                        icon: BitmapDescriptor.defaultMarker),
                                  },
                                  zoomControlsEnabled:
                                      true, // Aktifkan kontrol zoom
                                  myLocationEnabled:
                                      true, // Aktifkan tampilan lokasi pengguna
                                  myLocationButtonEnabled: true,
                                  gestureRecognizers: <Factory<
                                      OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                                  onCameraMove: (CameraPosition position) {
                                    // Kembalikan true untuk mengaktifkan interaksi dengan peta
                                  },
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ))));
  }
}
