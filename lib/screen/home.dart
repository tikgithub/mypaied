import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/model/config.dart';
import 'package:mypaied/screen/loginscreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mypaied/screen/menu.dart';
import 'package:mypaied/widget/loadingscreen.dart';
import 'package:mypaied/widget/progressdialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String useremail = 'Loading...';
  FirebaseAuth auth;
  //FireStore define
  FirebaseFirestore db;
  //FireStore Collection
  CollectionReference userCollection;
  //Filename of image storer
  String imageFileName;

  Widget screenShow;

  ProcessingDialog processingDialog;

  //Profile Imagenetwork
  var urlProfile;

  String hostname = new Config().getHostName();

  //Screen handle variable
  Widget screenHandle;
  Widget subScreen = Menu();

  //Method init flutter
  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().then((value) async {
      auth = FirebaseAuth.instance;
      db = FirebaseFirestore.instance;
      auth.currentUser.getIdToken(true).then((value) {
        print(value.toString());
      });

      imageFileName = await getImage();

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Users')
          .child(imageFileName);
      urlProfile = await ref.getDownloadURL();
      print(urlProfile);
      setState(() {
        useremail = auth.currentUser.email;
      });
    });
  }

  updateScreen(Widget widget) {
    setState(() {
      screenHandle = widget;
    });
  }

  Future<String> getImage() async {
    var client = new Dio();
    client.options.headers['authorization'] =
        'Bearer ' + await FirebaseAuth.instance.currentUser.getIdToken(true);
    var response = await client.get(Config().getHostName() + 'user/getByEmail');
    Map<String, dynamic> user = jsonDecode(response.toString());
    return user['photo'].toString();
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

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
    MaterialPageRoute route =
        MaterialPageRoute(builder: (value) => LoginScreen());
    Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
  }

  Widget showPhoto() {
    return Container(
      child: Column(
        children: [
          urlProfile != null
              ? resizePhoto(
                  Image.network(urlProfile),
                )
              : Container(),
          Container(
            padding: EdgeInsets.all(10),
          ),
          Text(
            'Login By: $useremail',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget resizePhoto(Widget img) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(2, 3),
          ),
        ],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(urlProfile),
        ),
      ),
    );
  }

  Widget fullBody() {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 300,
              child: DrawerHeader(
                child: showPhoto(),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          )
        ],
        title: Center(
          child: Text('Home Page'),
        ),
      ),
      body: Menu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return urlProfile == null ? LoadingScreen() : fullBody();
  }
}
