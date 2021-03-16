import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AddPayment extends StatefulWidget {
  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  //Define for using in showDateTimePicker()
  DateTime current = new DateTime.now();
  //Define text controller
  final TextEditingController txtItemController = TextEditingController();
  final TextEditingController txtAmountController = TextEditingController();
  final TextEditingController txtDetailController = new TextEditingController();
  //Define Goboalkey for controlling the text
  final formKey = GlobalKey<FormState>();

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
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: txtItemController,
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please add some text';
                    }
                    return null;
                  },
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
                    controller: txtDetailController,
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
                    controller: txtAmountController,
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter any amount';
                      }
                      return null;
                    },
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
                          onPressed: () {
                            formKey.currentState.reset();
                            // txtAmountController.clear();
                            // txtDetailController.clear();
                            // txtItemController.clear();
                          },
                          child: Text('Clear'),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                            }
                          },
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
