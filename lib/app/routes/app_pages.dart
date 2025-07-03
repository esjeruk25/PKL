import 'package:get/get.dart';
import 'package:test_app/app/modules/home/bindings/home_binding.dart';
import 'package:test_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:test_app/app/modules/splash/views/splash_view.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fade,
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fade,
    ),
  ];
}
