import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AddPayment extends StatefulWidget {
  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  DateTime current = new DateTime.now();

  Future<void> _selectDate(BuildContext ctx) async {
    final DateTime pickDate = await showDatePicker(
      context: ctx,
      initialDate: current,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (pickDate != null) {
      setState(() {
        current = pickDate;
      });
    }
  }

  Widget content() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Form(
            child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Item',
                prefixIcon: Icon(Icons.add_chart),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(children: [
                    Icon(Icons.access_time),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      formatDate(current, [dd, '-', mm, '-', yyyy]) +
                          '     (Press For Change)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Item Detail',
                  prefixIcon: Icon(Icons.perm_device_information),
                ),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: null,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                inputFormatters: [
                  ThousandsFormatter(allowFraction: true),
                ],
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text('Clear'),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Save'),
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Payment'),
      ),
      body: SingleChildScrollView(child: content()),
    );
  }
}
