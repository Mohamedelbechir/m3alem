import 'package:flutter/material.dart';

class PassagerInterfacePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PassagerInterfacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Home page",style: TextStyle(fontSize: 25),)),
    );
  }
}
