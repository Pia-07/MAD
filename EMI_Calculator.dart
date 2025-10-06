import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EMIApp());
}

class EMIApp extends StatelessWidget {
  const EMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EMI Calculator",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EMICalculator(),
    );
  }
}

class EMICalculator extends StatefulWidget {
  const EMICalculator({super.key});

  @override
  State<EMICalculator> createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  final TextEditingController loanController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  double? emi;
  double? totalPayment;
  double? totalInterest;

  void calculateEMI() {
    double principal = double.tryParse(loanController.text) ?? 0;
    double annualRate = double.tryParse(rateController.text) ?? 0;
    double months = double.tryParse(tenureController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || months <= 0) {
      setState(() {
        emi = null;
        totalPayment = null;
        totalInterest = null;
      });
      return;
    }

    double monthlyRate = annualRate / (12 * 100);
    double emiCalc = (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    setState(() {
      emi = emiCalc;
      totalPayment = emiCalc * months;
      totalInterest = totalPayment! - principal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EMI Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: loanController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount Required",
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Rate of Interest (%)",
                prefixIcon: Icon(Icons.percent),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: tenureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Time Duration (Months)",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateEMI,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Calculate EMI",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            if (emi != null)
              Column(
                children: [
                  Text("EMI: ₹${emi!.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Total Payment: ₹${totalPayment!.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Total Interest: ₹${totalInterest!.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
