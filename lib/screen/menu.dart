import 'package:flutter/material.dart';
import 'package:mypaied/screen/addnewpayment.dart';

class Menu extends StatelessWidget {
  Widget menuBlock(String imageFilePath, String label) {
    return Container(
      decoration: BoxDecoration(),
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextButton(
        onPressed: () {},
        child: Column(
          children: [
            Image.asset(
              imageFilePath,
              width: 100,
              height: 100,
            ),
            Text(label)
          ],
        ),
      ),
    );
  }

  Widget arrangeMenu() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [menuBlock('images/avatar.png', '')],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [arrangeMenu()],
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
