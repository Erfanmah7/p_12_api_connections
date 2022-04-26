import 'package:flutter/material.dart';
import 'package:p_12_api_connections/screens/homescreen.dart';
import 'package:p_12_api_connections/screens/login_screen.dart';
import 'package:p_12_api_connections/screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
