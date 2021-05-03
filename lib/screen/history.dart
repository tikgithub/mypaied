import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypaied/model/config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mypaied/model/total_monthly.dart';

import 'detailscreen.dart';

class Hisotry extends StatefulWidget {
  @override
  _HisotryState createState() => _HisotryState();
}

class _HisotryState extends State<Hisotry> {
  var format = NumberFormat.decimalPattern('lo_LA');
  ScrollController _scrollController = new ScrollController();
  int _currentMax = 0;
  int _pageCount = 10;
  bool isMore = false;
  List<dynamic> myList = new List<dynamic>();
  dynamic totalPay;
  dynamic monthPay = '';

  @override
  void initState() {
    super.initState();
    _getMore();
    getTotalMonthlyData();
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

  Future<void> getTotalMonthlyData() async {
    var client = new Dio();
    client.options.headers['Authorization'] =
        "Bearer " + await FirebaseAuth.instance.currentUser.getIdToken(true);
    Response<String> response =
        await client.get(Config().getHostName() + "payment/total_month");
    List resJson = json.decode(response.data);
    TotalMonthly mon =
        resJson.map((e) => new TotalMonthly.fromJson(e)).toList()[0];
    monthPay = mon.month;
    totalPay = mon.total;
    setState(() {});
  }

  Future<String> getImageLink(String imageName) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Items")
        .child(imageName);
    var imageFile = await ref.getDownloadURL();
    return imageFile;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext cts) => Hisotry(),
                    ));
              })
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ລາຍຈ່າຍ'),
            Row(
              children: [
                Text(
                  'ປະຈຳເດືອນ ' + monthPay.toString() + ' : ',
                  style: TextStyle(fontSize: 15),
                ),
                totalPay == null
                    ? Image.asset(
                        'images/loading.gif',
                        width: 20,
                        height: 20,
                      )
                    : Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          format.format(totalPay) + ' LAK',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: myList.length == 0 ? 1 : myList.length + 1,
          controller: _scrollController,
          itemExtent: 100,
          itemBuilder: (BuildContext ctx, int index) {
            if (index == myList.length) {
              if (isMore == true) {
                return CupertinoActivityIndicator();
              } else {
                return ListTile();
              }
            } else {
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.black26),
                )),
                padding:
                    EdgeInsets.only(left: 0, top: 10, right: 5, bottom: 10),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.yellow,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: myList[index]['photo'].toString().isEmpty
                          ? AssetImage('images/pay.png')
                          : NetworkImage(
                              myList[index]['photo'],
                            ),
                    ),
                  ),
                  onTap: () {
                    print(myList[index]['id']);
                    MaterialPageRoute detailScreen = new MaterialPageRoute(
                        builder: (BuildContext ctx) =>
                            PaymentDetail(myList[index]));
                    Navigator.of(context).push(detailScreen);
                  },
                  trailing: Icon(Icons.navigate_next),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              myList[index]['item'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(formatDate(
                            DateTime.parse(myList[index]['pay_date']),
                            [dd, '/', mm, '/', yyyy],
                          )),
                        ],
                      ),
                      Text(
                        format.format(
                              myList[index]['amount'],
                            ) +
                            ' LAK',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(myList[index]['detail']),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
