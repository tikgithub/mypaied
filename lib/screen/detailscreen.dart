import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentDetail extends StatelessWidget {
  var _data;

  var headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  var priceStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red);

  var format = NumberFormat('#,##,000', 'lo_LA');

  PaymentDetail(data) {
    this._data = data;
  }

  @override
  Widget build(BuildContext context) {
    print(_data);
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('ລາຍຈ່າຍ'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: this._data['photo'].toString().isEmpty
                      ? Image.asset('images/pay.png')
                      : Image.network(
                          this._data['photo'],
                          width: MediaQuery.of(context).size.width / 2,
                        ),
                ),
              ),
              Container(
                height: 0.5,
                color: Colors.grey,
                padding: EdgeInsets.only(left: 20, right: 20),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ລາຍການ: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Flexible(
                    child: Text(
                      this._data['item'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'ລາຄາ: ',
                    style: headerStyle,
                  ),
                  Text(
                    format.format(
                          this._data['amount'],
                        ) +
                        ' LAK',
                    style: priceStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'ວັນທີ່: ',
                    style: headerStyle,
                  ),
                  Text(
                    formatDate(DateTime.parse(this._data['pay_date']),
                        [dd, '/', mm, '/', yyyy]),
                    style: headerStyle,
                  )
                ],
              ),
              Row(children: [
                Text("ລາຍລະອຽດ: ",style: headerStyle),
                Text(this._data['detail'],  style: headerStyle),
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
