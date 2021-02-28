import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/model/user.dart';
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

  //Method init flutter
  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().then((value) {
      auth = FirebaseAuth.instance;
      db = FirebaseFirestore.instance;

      db
          .collection("Users")
          .where('email', isEqualTo: auth.currentUser)
          .get()
          .then((query) {
        Map<String, dynamic> maps = query.docs[0].data();
        print(maps['photo']);
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

  @override
  Widget build(BuildContext context) {
    //Firebase run

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
