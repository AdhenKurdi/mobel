import 'package:get/get.dart';

import '../modules/add/bindings/add_binding.dart';
import '../modules/add/views/add_view.dart';
import '../modules/adds/bindings/adds_binding.dart';
import '../modules/adds/views/adds_view.dart';
import '../modules/detail/bindings/detail_binding.dart';
import '../modules/detail/views/detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD,
      page: () => const AddView(),
      binding: AddBinding(),
    ),
    GetPage(
      name: _Paths.ADDS,
      page: () => const AddsView(),
      binding: AddsBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL,
      page: () => DetailView(),
      binding: DetailBinding(),
    ),
  ];
}
