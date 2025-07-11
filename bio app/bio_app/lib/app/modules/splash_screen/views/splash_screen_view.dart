import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B5CF6), // Purple
              Color(0xFF6B46C1), // Dark Purple
              Color(0xFF4C1D95), // Darker Purple
              Color(0xFF1F2937), // Dark Gray
              Color(0xFF000000), // Black
            ],
            stops: [0.0, 0.3, 0.6, 0.8, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: controller.scaleAnimation.value,
                child: Opacity(
                  opacity: controller.fadeAnimation.value,
                  child: Text(
                    'Neutron',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4.0,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 10,
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.3),
                        ),
                        Shadow(
                          offset: const Offset(0, 0),
                          blurRadius: 20,
                          // ignore: deprecated_member_use
                          color: const Color(0xFF8B5CF6).withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}