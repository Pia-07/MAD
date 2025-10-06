import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String currentOperation = '';
  int firstNumber = 0;
  int secondNumber = 0;
  String operator = '';
  String correctAnswer = '';
  String userAnswer = '';
  String resultMessage = '';
  bool showResult = false;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resultMessage = "Choose an operation to start!";
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void generateQuestion(String operation) {
    setState(() {
      currentOperation = operation;
      userAnswer = '';
      _answerController.clear();
      resultMessage = '';
      showResult = false;

      Random random = Random();
      if (operation == 'Mix') {
        List<String> operators = ['+', '-', '×', '÷'];
        operator = operators[random.nextInt(4)];
      } else {
        operator = operation;
      }

      if (operator == '÷') {
        secondNumber = random.nextInt(9) + 1;
        int quotient = random.nextInt(10) + 1;
        firstNumber = secondNumber * quotient;
      } 
      else {
        firstNumber = random.nextInt(20) + 1;
        secondNumber = random.nextInt(20) + 1;
      }

      switch (operator) {
        case '+':
          correctAnswer = (firstNumber + secondNumber).toString();
          break;
        case '-':
          if (firstNumber < secondNumber) {
            int temp = firstNumber;
            firstNumber = secondNumber;
            secondNumber = temp;
          }
          correctAnswer = (firstNumber - secondNumber).toString();
          break;
        case '×':
          correctAnswer = (firstNumber * secondNumber).toString();
          break;
        case '÷':
          correctAnswer = (firstNumber ~/ secondNumber).toString();
          break;
      }
    });
  }

  void checkAnswer() {
    if (userAnswer.isEmpty) {
      setState(() {
        resultMessage = "Please enter an answer!";
        showResult = true;
      });
      return;
    }

    try {
      int userInput = int.parse(userAnswer);
      if (userInput.toString() == correctAnswer) {
        setState(() {
          resultMessage = "Correct! Great job!";
          showResult = true;
          userAnswer = '';
          _answerController.clear();
        });
        Future.delayed(const Duration(seconds: 1), () {
          generateQuestion(currentOperation);
        });
      } else {
        setState(() {
          resultMessage = "Answer is wrong, please try again!";
          showResult = true;
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = "Please enter a valid number!";
        showResult = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.cyan,
        fontFamily: 'ComicNeue',
        scaffoldBackgroundColor: const Color.fromARGB(255, 187, 248, 245),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 28, color: Color(0xFF6A1B9A)),
          bodyMedium: TextStyle(fontSize: 24, color: Color(0xFF6A1B9A)),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Math Learning With Fun",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.cyan,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOperationButton('Addition', '+', Colors.lime),
                  _buildOperationButton('Subtraction', '-', Colors.orange),
                  _buildOperationButton('Multiplication', '×', Colors.yellow),
                  _buildOperationButton('Division', '÷', Colors.purple),
                  _buildOperationButton('Mix', 'Mix', Colors.cyan),
                ],
              ),
              const SizedBox(height: 30),
              if (currentOperation.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan[50],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    '$firstNumber $operator $secondNumber = ___',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (currentOperation.isNotEmpty)
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _answerController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: "Your answer",
                      hintStyle: const TextStyle(
                        color: Color(0xFF8E24AA),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                        userAnswer = value;
                        showResult = false;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),
              if (currentOperation.isNotEmpty)
                ElevatedButton(
                  onPressed: checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Check",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: showResult ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  resultMessage,
                  style: TextStyle(
                    fontSize: 28,
                    color: resultMessage.contains("Correct") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperationButton(String label, String operation, Color color) {
    return ElevatedButton(
      onPressed: () {
        generateQuestion(operation);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
