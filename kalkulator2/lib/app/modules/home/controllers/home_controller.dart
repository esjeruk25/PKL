import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
class HomeController extends GetxController {
  var input = ''.obs;
  var result = '0'.obs;
  void onButtonPressed(String text){
    if (text == 'AC') {
      input.value ='';
      result.value = '0';
    } else if (text == 'C'){
      if(input.isNotEmpty){
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } else if (text == '='){
      _calculateResult();
    }else {
      input.value += (text == 'x') ? '*' : text;
    }
  }
  void _calculateResult () {
    try {
      Parser p = Parser();
      Expression exp = p.parse(input.value);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result.value = eval.toStringAsFixed(0);
    }catch (_) {
      result.value = 'Gabisa';
    }
  }
  Color getButtonColor(String text)
{
  if (text == 'AC' || text == 'C') return Colors.red.shade400;
  if (text == '()' || text == '%') return Colors.teal.shade300;
  if (text == 'x' || text == '-' || text == '/' || text == '+') return Colors.blue.shade700;
  if (text == '=') return Colors.yellow;
  return Color(0xFFDCEAE9);
}
 Color getTextColor (String text){
  if (text == '=' || text == 'AC' || text == 'C') return Colors.white;
  return Colors.black;
 }
}