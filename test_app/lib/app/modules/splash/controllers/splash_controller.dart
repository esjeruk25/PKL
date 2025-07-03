import 'package:get/get.dart';
import '../../home/views/home_view.dart'; // pastikan ini sudah di-import

class SplashController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const HomeView()); // ✅ fix disini
    });
  } 
  void increment() => count.value++;
}
