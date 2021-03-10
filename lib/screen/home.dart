import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/model/config.dart';
import 'package:mypaied/screen/loginscreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String useremail;
  FirebaseAuth auth;
  //FireStore define
  FirebaseFirestore db;
  //FireStore Collection
  CollectionReference userCollection;
  String hostname = new Config().getHostName();

  //Method init flutter
  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().then((value) {
      auth = FirebaseAuth.instance;
      db = FirebaseFirestore.instance;

      auth.currentUser.getIdToken(true).then((value) {
        print(value.toString());
      });

      setState(() {
        useremail = auth.currentUser.email;
      });
    });
  }

  //Method define

  //backgroud and content control

  Widget showContent() {
    return Container(
      child: Column(
        children: [
          Text('Login: $useremail'),
        ],
      ),
    );
  }

  void callHttp() async {
    print('HTTP CALL HERE *************************');
    var response = await http.get("$hostname/test");
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    callHttp();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => LoginScreen());
              Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
            },
          )
        ],
        title: Center(
          child: Text('Home Page'),
        ),
      ),
      body: showContent(),
    );
  }
}
