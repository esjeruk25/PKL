import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/splash/views/splash_view.dart';
import 'app/modules/splash/controllers/splash_controller.dart';
import 'app/modules/home/controllers/home_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(), // ← Now this correctly references your actual SplashView
      initialBinding: BindingsBuilder(() {
        Get.put(SplashController());
        Get.put(HomeController());
      }),
    );
  }
}