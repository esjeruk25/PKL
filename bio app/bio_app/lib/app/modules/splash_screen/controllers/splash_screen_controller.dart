import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));
    
    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));
    
    animationController.forward();
  }

  @override
  void onReady() {
    super.onReady();
    
    Future.delayed(const Duration(seconds: 3), () {
      
      Get.offNamed('/home'); 
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}