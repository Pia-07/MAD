import 'package:flutter/material.dart';

class ECommerce extends StatefulWidget {   // <-- renamed to match main.dart
  const ECommerce({super.key});

  @override
  State<ECommerce> createState() => _ECommerceState();
}

class _ECommerceState extends State<ECommerce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce"),
        backgroundColor: Colors.lime,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Whatsapp"),
            subtitle: const Text("Subtitle"),
            leading: Image.asset("assets/images/whatsapp.png"),
            trailing: const Icon(Icons.navigate_next_outlined),
          ),
          ListTile(
            title: const Text("Facebook"),
            subtitle: const Text("Subtitle"),
            leading: Image.asset("assets/images/facebook.png"),
            trailing: const Icon(Icons.navigate_next_outlined),
          ),
          ListTile(
            title: const Text("Instagram"),
            subtitle: const Text("Subtitle"),
            leading: Image.asset("assets/images/instagram.png"),
            trailing: const Icon(Icons.navigate_next_outlined),
          ),
        ],
      ),
    );
  }
}
