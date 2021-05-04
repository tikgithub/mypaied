import 'package:flutter/material.dart';
import 'package:mypaied/screen/addnewpayment.dart';
import 'package:mypaied/screen/history.dart';
import 'package:mypaied/screen/paymentpurpose.dart';
import 'package:mypaied/screen/profile.dart';
import 'package:mypaied/screen/searchpayment.dart';
import 'package:mypaied/screen/simplelazyloading.dart';

// ignore: must_be_immutable
class Menu extends StatefulWidget {
  //For store data from list
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var listItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget menuBlock(String imageFilePath, String label, screen) {
      return Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
        decoration: BoxDecoration(
            color: Colors.white70,
            border: Border(
                bottom: BorderSide(
              color: Colors.black,
              width: 1,
            ))),
        child: TextButton(
          onPressed: () {
            MaterialPageRoute historypage = new MaterialPageRoute(builder: (BuildContext ctx) => screen);
            Navigator.of(context).push(historypage);
          },
          child: Row(
            children: [
              Image.asset(
                imageFilePath,
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              menuBlock('images/statement.png', 'ປະຫວັດລາຍຈ່າຍ', Hisotry()),
              menuBlock('images/money-bag.png', 'ຄົ້ນຫາລາຍຈ່າຍ', SearchPayment()),
              menuBlock('images/avatar.png', 'Profile', Profile()),
            ],
          ),
        ),
        floatingActionButton: Row(
          children: [
            Spacer(
              flex: 1,
            ),
            FloatingActionButton(
              onPressed: () {
                MaterialPageRoute router = new MaterialPageRoute(builder: (BuildContext ctx) => PaymentPurpose());
                Navigator.of(context).push(router);
              },
              child: Icon(Icons.payments),
              heroTag: '01',
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                MaterialPageRoute router = new MaterialPageRoute(builder: (BuildContext ctx) => AddPayment());
                Navigator.of(context).push(router);
              },
              child: Icon(Icons.add),
              heroTag: '02',
            ),
          ],
        ));
  }
}
