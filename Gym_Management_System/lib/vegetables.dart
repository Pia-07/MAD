import 'package:flutter/material.dart';

class Vegetables extends StatefulWidget {
  const Vegetables({super.key});

  @override
  State<Vegetables> createState() => _VegetablesState();
}

class _VegetablesState extends State<Vegetables> {
var mylist=["tomato","onion","carrot","beetroot","potato","garlic","capsicum","cauliflower","sweetpotato","frenchbeans"];
var image=["assets/images/whatsapp.png","assets/images/facebook.png","assets/images/instagram.png","assets/images/whatsapp.png","assets/images/facebook.png","assets/images/instagram.png","assets/images/whatsapp.png","assets/images/facebook.png","assets/images/instagram.png","assets/images/whatsapp.png"];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vegetable List"),
        backgroundColor: Colors.blue,
      ),
      body:ListView.builder(
        itemCount: mylist.length,
        itemBuilder: (context,index){
          return Card(
           child: ListTile(
              leading:Image.asset(image[index]) ,
            title: Text(mylist[index]),
            trailing: Icon(Icons.next_week_outlined),
            onTap: () {
              print("Hello $index");
            },
            ),
            
          );
        },
      )
    );
  }
}
