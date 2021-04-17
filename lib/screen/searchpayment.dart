import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypaied/model/config.dart';
import 'package:mypaied/screen/editscreen.dart';
import 'package:mypaied/widget/progressdialog.dart';

import 'detailscreen.dart';

class SearchPayment extends StatefulWidget {
  @override
  _SearchPaymentState createState() => _SearchPaymentState();
}

class _SearchPaymentState extends State<SearchPayment> {
  var format = NumberFormat.decimalPattern("lo_LA");
  DateTime fromDate = DateTime.now().subtract(Duration(days: 10));
  DateTime toDate = DateTime.now();
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();
  String fromDatePicker;
  dynamic totalSum = 0;
  ProcessingDialog prdlog;

  List myList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fromDateController.text = formatDate(fromDate, [dd, '/', mm, '/', yyyy]);
    toDateController.text = formatDate(toDate, [dd, '/', mm, '/', yyyy]);
    // getData();
  }

  Future<void> getData() async {
    prdlog.show();
    myList = [];
    totalSum = 0;
    try {
      var client = new Dio();
      client.options.headers['Authorization'] =
          "Bearer " + await FirebaseAuth.instance.currentUser.getIdToken(true);
      Response<Map> res = await client.get(Config().getHostName() +
          "payment/search/${formatDate(fromDate, [
            dd,
            '-',
            mm,
            '-',
            yyyy
          ])}/${formatDate(toDate, [dd, '-', mm, '-', yyyy])}");

      Map<String, dynamic> total = res.data['total'][0];
      Map<String, dynamic> listData;
      //
      totalSum = format.format(total['total']);
      for (int i = 0; i < res.data['listdata'].length; i++) {
        myList.add(res.data['listdata'][i]);
      }
      prdlog.close();
      setState(() {});
    } catch (ex) {
      prdlog.close();
      print(ex);
      setState(() {});
    }
  }

  Future<void> _setFromDate(BuildContext ctx) async {
    DateTime fromPickDate = await showDatePicker(
        context: ctx,
        initialDate: fromDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (fromPickDate != null) {
      setState(() {
        fromDate = fromPickDate;
      });
    }
  }

  Future<void> _setToDate(BuildContext ctx) async {
    DateTime toPickDate = await showDatePicker(
        context: ctx,
        initialDate: toDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (toPickDate != null) {
      setState(() {
        toDate = toPickDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    prdlog = new ProcessingDialog(context, "ກະລຸນາລໍຖ້າ");
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext cts) => SearchPayment(),
                      ));
                })
          ],
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ຄົ້ນຫາລາຍການ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'ວັນທີ່ ${formatDate(fromDate, [
                  dd,
                  '/',
                  mm,
                  '/',
                  yyyy
                ])} - ${formatDate(
                  toDate,
                  [dd, '/', mm, '/', yyyy],
                )}',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 2, right: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ຈາກ: ' +
                              formatDate(fromDate, [dd, '/', mm, '/', yyyy]),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'ເລືອກ',
                          ),
                          onTap: () {
                            _setFromDate(context);
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ເຖິງ: ' +
                              formatDate(toDate, [dd, '/', mm, '/', yyyy]),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          child: Text(
                            'ເລືອກ',
                          ),
                          onTap: () {
                            _setToDate(context);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {
                  getData();
                },
                child: Row(
                  children: [
                    Icon(Icons.search),
                    Text('ຄົ້ນຫາ'),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              color: Colors.black12,
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 5),
              child: Row(
                children: [
                  Text(
                    'ຈຳນວນເງິນ: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    this.totalSum.toString() + " LAK",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 1,
              color: Colors.black12,
            ),
            myList.length == 0
                ? Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('ບໍ່ມີຂໍ້ມູນ'),
                  )
                : Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: myList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      myList[index]['item'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      format.format(myList[index]['amount']) +
                                          " LAK",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  ],
                                ),
                                Text(formatDate(
                                    DateTime.parse(myList[index]['pay_date']),
                                    [dd, '/', mm, '/', yyyy])),
                              ],
                            ),
                            onTap: () {
                              MaterialPageRoute detailScreen =
                                  new MaterialPageRoute(
                                      builder: (BuildContext ctx) =>
                                          PaymentDetail(myList[index]));
                              Navigator.of(context).push(detailScreen);
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                        title: Text(
                                          "ລາຍການ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  print(myList[index]);
                                                  MaterialPageRoute route = new MaterialPageRoute(builder: (BuildContext ctx)=>PaymentEditScreen(myList[index]));
                                                  Navigator.of(context).push(route);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      color: Colors.orange,
                                                    ),
                                                    Text("   ແກ້ໄຂ"),
                                                  ],
                                                ),
                                              ),
                                              width: double.infinity,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black12,
                                            ),
                                            Container(
                                              child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    Text("   ລຶບ"),
                                                  ],
                                                ),
                                              ),
                                              width: double.infinity,
                                            ),
                                          ],
                                        ));
                                  });
                            },
                          );
                        }),
                  ),
          ],
        ));
  }
}
