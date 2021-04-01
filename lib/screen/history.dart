import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypaied/model/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Hisotry extends StatefulWidget {
  @override
  _HisotryState createState() => _HisotryState();
}

class _HisotryState extends State<Hisotry> {
  List<Map<String, dynamic>> itemsAll = [];
  var format = NumberFormat('#,##,000', 'lo_LA');
  bool isloading = false;
  ScrollController _sc = new ScrollController();
  static int page = 0;

  @override
  void initState() {
    super.initState();
    //load data
    _getData(page);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        //loadata here
      }
    });
  }

  void _getData(int index) async {
    var client = new Dio();
    client.options.headers['Authorization'] =
        'Bearer ' + await FirebaseAuth.instance.currentUser.getIdToken(true);
    Response response = await client.get(
      Config().getHostName() + 'payment/0/3',
    );
    List dataList = new List();
    print(response.data.length);
    //return List<Map<String, dynamic>>.from(json.decode(response.data));
  }

  Widget showCard(index) {
    return Card(
      elevation: 8,
      //margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: showListItem(
          itemsAll[index]['item'],
          itemsAll[index]['amount'].toString(),
          itemsAll[index]['photo'],
          DateTime.parse(itemsAll[index]['pay_date']),
        ),
      ),
    );
  }

  showListTile(
    String title,
    String price,
    String imageLink,
  ) {
    return ListTile(
      //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 200,
          maxHeight: 200,
        ),
        child: Image.network(imageLink, fit: BoxFit.cover),
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            price,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    );
  }

  Future<String> getImageLink(String imageName) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Items")
        .child(imageName);
    var imageFile = await ref.getDownloadURL();
    return imageFile;
  }

  Widget showListItem(
      String title, String price, String imageLink, DateTime date) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: () {
          print('this tap');
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageLink),
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                format.format(
                      double.parse(
                        price.toString(),
                      ),
                    ) +
                    ' ${format.currencySymbol}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'ວັນທີ: ' +
                    formatDate(
                      date,
                      [dd, '-', mm, '-', yyyy],
                    ),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndication() {
    return new Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: isloading ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
        itemCount: itemsAll.length,
        itemBuilder: (context, index) {
          return showCard(index);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ປະຫວັດລາຍຈ່າຍ'),
        ),
        body: _buildList());
  }
}
