
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'Screens/Shoppinglist.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
     // set brightness for the status bar text
      systemNavigationBarColor: Colors.deepPurple.shade900
  ));

  runApp(


      MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple.shade900,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade900,
          elevation: 0,
          
          title:Row(
            children: [
              Text('GRO',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
            ,             Text('HOUSE',style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),)
            ],
          ),
          actions: [
            Image.asset('assets/images/db.png',height: 100,)
          ],

        ),
        body: ShoppingList(),
      ),
    );
  }
}

