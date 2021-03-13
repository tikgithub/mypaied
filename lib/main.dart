import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mypaied/screen/loginscreen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)),
      home: LoginScreen(),
    );
  }
}
