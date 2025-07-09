import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
// import 'package:math_expressions/math_expressions.dart';
class CalculatorHomePage extends GetView<HomeController> {
  const CalculatorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Color(0xFFB9D2D2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(() => Text(
                          controller.input.value,
                          style: TextStyle(fontSize: 24, color: Colors.black54),
                        )),
                    SizedBox(height: 10),
                    Obx(() => Text(
                          controller.result.value,
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Digital',
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 120),
            Expanded(
              flex: 5,
              child: buildButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    final buttons = [
      ['AC', '()', '%', '/'],
      ['7', '8', '9', 'x'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', 'C', '='],
    ];
    return Column(
      children: buttons.map((row) {
        return Expanded(
          child: Row(
            children: row.map((text) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: ElevatedButton(
                    onPressed: () => controller.onButtonPressed(text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.getButtonColor(text),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: controller.getTextColor(text),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
//ye