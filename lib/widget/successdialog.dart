import 'package:flutter/material.dart';

class MyAlertDialog {
  final Function _externalFunction;

  MyAlertDialog(this._externalFunction);

  void showSuccessDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.done_all_outlined,
                color: Colors.green,
                size: 40,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Text(
              content,
              textAlign: TextAlign.end,
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaisedButton(
                    onPressed: this._externalFunction,
                    child: Text('OK'),
                    color: Colors.blueGrey,
                  )
                ],
              ),
            ],
          );
        });
  }

  void showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.error_outline_outlined,
                color: Colors.green,
                size: 40,
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: Text(
              content,
              textAlign: TextAlign.end,
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                    color: Colors.blueGrey,
                  )
                ],
              ),
            ],
          );
        });
  }
}
