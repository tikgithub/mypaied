import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypaied/model/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Hisotry extends StatefulWidget {
  @override
  _HisotryState createState() => _HisotryState();
}

class _HisotryState extends State<Hisotry> {
  var format = NumberFormat('#,##,000', 'lo_LA');
  ScrollController _scrollController = new ScrollController();
  int _currentMax = 0;
  int _pageCount = 10;
  bool isMore = false;
  List<dynamic> myList = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    _getMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  _getMore() async {
    print("Get more daa");
    setState(() {
      isMore = true;
    });
    // await Future.delayed(const Duration(milliseconds: 2000), () {});
    var client = new Dio();
    client.options.headers['Authorization'] =
        "Bearer " + await FirebaseAuth.instance.currentUser.getIdToken(true);
    Response res = await client
        .get(Config().getHostName() + "payment/$_currentMax/$_pageCount");
    print(res.data);
    for (int i = 0; i < res.data.length; i++) {
      myList.add(res.data[i]);
    }
    setState(() {
      _currentMax += _pageCount;
      isMore = false;
    });
  }

  // Future<String> getImageLink(String imageName) async {
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child("Items")
  //       .child(imageName);
  //   var imageFile = await ref.getDownloadURL();
  //   return imageFile;
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ປະຫວັດລາຍຈ່າຍ'),
      ),
      body: ListView.builder(
          itemCount: myList.length == 0 ? 1 : myList.length + 1,
          controller: _scrollController,
          itemExtent: 80,
          itemBuilder: (BuildContext ctx, int index) {
            if (index == myList.length) {
              if (isMore == true) {
                return CupertinoActivityIndicator();
              } else {
                return ListTile();
              }
              // return isMore == true
              //     ? CupertinoActivityIndicator()
              //     : Container();
            } else {
              return ListTile(
                title: Text(myList[index]['item']),
              );
            }
          }),
    );
  }
}
