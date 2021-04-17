import 'package:flutter/material.dart';

class PaymentEditScreen extends StatefulWidget {
  var data;
  PaymentEditScreen(data);

  @override
  _PaymentEditScreenState createState() => _PaymentEditScreenState();
}

class _PaymentEditScreenState extends State<PaymentEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ແກ້ໄຂລາຍການ'),
      ),
    );
  }
}
