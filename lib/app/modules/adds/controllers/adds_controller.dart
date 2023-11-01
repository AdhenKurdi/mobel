import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_mobel/app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_mobel/app/domain/entity/task.dart';
import 'package:task_mobel/app/domain/usecase/task_usecase.dart';
import 'package:task_mobel/app/modules/home/controllers/home_controller.dart';
import 'package:task_mobel/app/routes/app_pages.dart';

class AddsController extends GetxController {
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

  Rx<String> pathImageUrl = "".obs;

  Rx<String> latitude = "".obs;

  Rx<String> longitude = "".obs;

  var isConnected = true;

  Rx<bool> isLoading = false.obs;

  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());

  Rx<String> currentAddress = "".obs;
  Rx<Position?> _currentPosition = Rx<Position?>(null);

  String _message = '';
  String get message => _message;

  late StreamSubscription<ConnectivityResult> subscription;

  List<Function> delayedActions = [];

  final TaskUseCase taskUseCase = GetIt.I.get<TaskUseCase>();

  // TaskUseCase taskUseCase = TaskUseCase()

  @override
  void onInit() async {
    date.text = formatDate(DateTime.now());
    subscription =
        Connectivity().onConnectivityChanged.listen(updateConnectionStatus);
    updateConnectionStatus(await Connectivity().checkConnectivity());

    print(isConnected);
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    description.dispose();
    quantity.dispose();
    date.dispose();
    subscription.cancel();
    super.onClose();
  }

  void updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      showCustomSnackbar("Warning ", "No Connection", Colors.yellow, true);
      isConnected = false;
      print(" $isConnected hehe");
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      isConnected = true;
      print(" $isConnected heho");
      // checkAndExecuteDelayedActions();
    }
  }

  FutureOr<void> insertTask(Task task) async {
    print(" $isConnected hehes");
    if (isConnected) {
      isLoading(true);
      final imageUrl =
          await taskUseCase.insertImageRemoteExecute(pathImage.value);
      task.photo = imageUrl;
      final result = await taskUseCase.insertTaskRemoteExecute(task);
      _message = result;
      isLoading(false);

      Get.offAllNamed(Routes.HOME);
      Get.put(HomeController());
      showCustomSnackbar("Success", _message, Colors.green, false);
    } else {
      // insertTaskDelayed()
      isLoading(true);
      final result = await taskUseCase.insertTaskCacheExecute(task);
      _message = result;
      isLoading(false);

      Get.offAllNamed(Routes.HOME);
      
      // Get.back();
      showCustomSnackbar("Success", _message, Colors.green, false);
    }
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
      currentAddress(
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}');
      print(currentAddress);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // void insertTaskDelayed(Task task) {
  //   delayedActions.add(() => insertTask(task));
  // }

  // void checkAndExecuteDelayedActions() {
  //   if (delayedActions.isNotEmpty) {
  //     final delayedAction = delayedActions.removeAt(0);
  //     delayedAction();
  //   }
  // }

  // Future<void> addStringListToSharedPreferences(List<String> stringList) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setStringList('myStringListKey', stringList);
  // }

  // Future<List<String>> getStringListFromSharedPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getStringList('myStringListKey') ?? [];
  // }
}
