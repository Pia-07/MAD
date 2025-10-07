import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyScreen1(), debugShowCheckedModeBanner: false);
  }
}

class MyScreen1 extends StatefulWidget {
  const MyScreen1({super.key});

  @override
  State<MyScreen1> createState() => _MyScreen1State();
}

class _MyScreen1State extends State<MyScreen1> {
  TextEditingController txt1 = new TextEditingController();
  TextEditingController txt2 = new TextEditingController();
  var myans = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello World"),
        backgroundColor: Colors.amber[200],
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Sum Demo", style: TextStyle(fontSize: 30)),
            TextField(controller: txt1),
            TextField(controller: txt2),
            ElevatedButton(
              onPressed: () {
                doSum();
              },
              child: Text("+"),
            ),
            Text("$myans"),
          ],
        ),
      ),
    );
  }

  void doSum() {
    var a = txt1.text;
    var b = txt2.text;
    var c = int.parse(a) + int.parse(b);
    setState(() {
      myans = "sum is $c";
    });
  }
}