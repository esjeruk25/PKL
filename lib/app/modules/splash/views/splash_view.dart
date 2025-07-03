import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../home/views/home_view.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), (){
      Get.off(() => HomeView(), transition: Transition.fadeIn, duration: Duration(seconds: 2));
    });

    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 37, 70, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/new.png',
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              print('Image loading error: $error');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50, color: Colors.red),
                  Text('Image not found', style: TextStyle(color: Colors.red)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}