import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProcessingDialog {
  ProgressDialog pr;

  ProcessingDialog(BuildContext context, String message) {
    //Define Progress dialog
    pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    pr.style(
        message: message,
        progressWidget: Container(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ));
  }

  void show() {
    pr.show();
  }

  Future close() async {
    await Future.delayed(new Duration(microseconds: 500)).then((value) async {
      await pr.hide();
    });
  }
}
