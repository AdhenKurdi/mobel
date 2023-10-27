import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/domain/usecase/task_usecase.dart';

class AddController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController date = TextEditingController();
  String formatDate(DateTime value) {
    return DateFormat.yMMMMd().format(value);
  }

  Rx<File?> selectedImage = Rx<File?>(null);

  Rx<String> pathImage = "".obs;

  Rx<String> latitude = "".obs;

  Rx<String> longitude = "".obs;

  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());

  Rx<String> _currentAddress = "".obs;
  Rx<Position?> _currentPosition = Rx<Position?>(null);

  String _message = '';
  String get message => _message;

  List<Task> _listTask = [];
  List<Task> get listTask => _listTask;

  final TaskUseCase taskUseCase = GetIt.I.get<TaskUseCase>();

  // TaskUseCase taskUseCase = TaskUseCase()

  @override
  void onInit() {
    
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    description.dispose();
    quantity.dispose();
    date.dispose();
    print('Controller disposed');
    super.onClose();
  }

  FutureOr<void> insertTask(Task task) async {
    final result = await taskUseCase.insertTaskExecute(task);
    _message = result;
    print(_message);
  }

  FutureOr<void> getAllTask() async {
    final result = await taskUseCase.getAllTaskExecute();
    _listTask = result;
  }

  FutureOr<void> pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    selectedImage.value = File(returnedImage.path);
    pathImage(returnedImage.path);
  }

  FutureOr<void> pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    selectedImage.value = File(returnedImage.path);
    pathImage(returnedImage.path);
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);
      latitude(position.latitude.toString());
      longitude(position.longitude.toString());
      _currentPosition(position);

      getAddressFromLatLng(_currentPosition.value!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress(
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
