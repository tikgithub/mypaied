import 'package:flutter/material.dart';
import 'package:mypaied/screen/loginscreen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MaterialPageRoute materialPageRoute =
                  MaterialPageRoute(builder: (value) => LoginScreen());
              Navigator.of(context)
                  .pushAndRemoveUntil(materialPageRoute, (route) => false);
            },
          ),
          title: Text('Register'),
        ),
      );
  }
}
