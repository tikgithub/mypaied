import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/model/config.dart';
import 'package:mypaied/screen/addnewpayment.dart';

import 'history.dart';

class Menu extends StatelessWidget {
  //For store data from list
  var listItem;

  //Function overide
  Function updateScreen;

  Menu(Function updateScreen);

  //Screnn Handle Variable
  Widget screenWidget;

  handleScreen(Widget widget) {
    screenWidget = widget;
  }

  Widget menuBlock(String imageFilePath, String label) {
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
          handleScreen(new Hisotry());
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
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  void getItem() async {
    //Refresh item variable
    listItem = null;

    var client = new Dio();
    client.options.headers['authorization'] =
        'Bearer ' + await FirebaseAuth.instance.currentUser.getIdToken(true);
    Response res = await client.get(Config().getHostName() + 'item/list');
    listItem = res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            menuBlock('images/statement.png', 'ປະຫວັດການຈ່າຍເງິນ'),
            menuBlock('images/money-bag.png', 'ສະແດງຍອດລວມລາຍຈ່າຍ'),
            menuBlock('images/accountant.png', 'ສ້າງລາຍຈ່າຍສະເພາະ'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          MaterialPageRoute route = new MaterialPageRoute(
            builder: (BuildContext ctx) => AddPayment(),
          );
          Navigator.of(context).push(route);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
