import 'package:flutter/material.dart';

class ThirdScreen extends StatefulWidget {
const ThirdScreen({super.key});

@override
State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Screen"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children:[
          Text("Third Screen"),
        ],
      )
    );
  }
}