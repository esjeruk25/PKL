import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});
  
  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0.0;
  double _num2 = 0.0;
  String _operator = "";
  bool _operatorPressed = false;
  String _history = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0.0;
        _num2 = 0.0;
        _operator = "";
        _operatorPressed = false;
        _history = "";
      } else if (buttonText == "AC") {
        _output = "0";
        _currentInput = "";
        _num1 = 0.0;
        _num2 = 0.0;
        _operator = "";
        _operatorPressed = false;
        _history = "";
      } else if (buttonText == "()") {
      } else if (buttonText == "%" || buttonText == "÷" || buttonText == "×" || buttonText == "-" || buttonText == "+") {
        if (_currentInput.isNotEmpty) {
          _num1 = double.tryParse(_currentInput) ?? 0.0;
        }
        
        if (buttonText == "%") {
          if (_currentInput.isNotEmpty) {
            double value = double.tryParse(_currentInput) ?? 0.0;
            value = value / 100;
            _currentInput = value.toString();
            _output = _currentInput;
          }
          return;
        }
        
        _operator = buttonText;
        _operatorPressed = true;
        _history = "$_currentInput $_operator ";
        _currentInput = "";
      } else if (buttonText == "=") {
        if (_currentInput.isNotEmpty && _operator.isNotEmpty) {
          _num2 = double.tryParse(_currentInput) ?? 0.0;
          _history += _currentInput;
          
          double result = 0.0;
          switch (_operator) {
            case "+":
              result = _num1 + _num2;
              break;
            case "-":
              result = _num1 - _num2;
              break;
            case "×":
              result = _num1 * _num2;
              break;
            case "÷":
              if (_num2 != 0) {
                result = _num1 / _num2;
              } else {
                _output = "Error";
                return;
              }
              break;
          }
          
          if (result == result.toInt()) {
            _output = result.toInt().toString();
          } else {
            _output = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          }
          
          _currentInput = _output;
          _operator = "";
          _operatorPressed = false;
        }
      } else if (buttonText == ".") {
        if (!_currentInput.contains(".")) {
          if (_currentInput.isEmpty) {
            _currentInput = "0.";
          } else {
            _currentInput += ".";
          }
          _output = _currentInput;
        }
      } else {
        if (_operatorPressed) {
          _currentInput = buttonText;
          _operatorPressed = false;
        } else {
          if (_currentInput == "0") {
            _currentInput = buttonText;
          } else {
            _currentInput += buttonText;
          }
        }
        _output = _currentInput;
      }
    });
  }

  Widget _buildButton(String buttonText, Color backgroundColor, Color textColor, {bool isWide = false}) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8C5C5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_history.isNotEmpty)
                      Text(
                        _history,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black54,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      _output,
                      style: const TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8C5C5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
            // Button area
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [

                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("AC", const Color(0xFFFF6B6B), Colors.white),
                          _buildButton("()", const Color(0xFF4ECDC4), Colors.white),
                          _buildButton("%", const Color(0xFF4ECDC4), Colors.white),
                          _buildButton("÷", const Color(0xFF45B7D1), Colors.white),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("7", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("8", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("9", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("×", const Color(0xFF45B7D1), Colors.white),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("4", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("5", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("6", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("-", const Color(0xFF45B7D1), Colors.white),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("1", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("2", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("3", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("+", const Color(0xFF45B7D1), Colors.white),
                        ],
                      ),
                    ),
                    

                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("0", const Color(0xFFB8C5C5), Colors.black, isWide: true),
                          _buildButton(".", const Color(0xFFB8C5C5), Colors.black),
                          _buildButton("C", const Color(0xFFFF6B6B), Colors.white),
                          _buildButton("=", const Color(0xFFFFD93D), Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}