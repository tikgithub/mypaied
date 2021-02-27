import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/screen/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'loginscreen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Variable
  String email;
  String password;
  String password2;
  ProgressDialog pr;
  final TextEditingController _pass1 = TextEditingController();
  final formKey = GlobalKey<FormState>();

//Method define
  Widget showContent() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showImageSelector(),
            showImageControlButton(),
            showEmailForm(),
            showPasswordForm(),
            showPasswordForm2(),
            showSaveButton(),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(String title, String content) {
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
                    onPressed: () {
                      MaterialPageRoute pageRoute =
                          MaterialPageRoute(builder: (value) => LoginScreen());
                      Navigator.of(context)
                          .pushAndRemoveUntil(pageRoute, (route) => false);
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

  Widget showImageSelector() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Image.asset(
        'images/avatar.png',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 0.5,
      ),
    );
  }

  Widget showImageControlButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.camera,
            size: 50,
          ),
          onPressed: () {},
        ),
        SizedBox(
          width: 50,
        ),
        IconButton(
          icon: Icon(
            Icons.folder,
            size: 50,
            color: Colors.yellow.shade800,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget showEmailForm() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Email Address',
        ),
        onSaved: (value) {
          this.email = value.trim();
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please file the value here';
          } else if (!(value.contains('@') && value.contains('.'))) {
            return 'Please file the email with the correct value';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget showPasswordForm() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Password',
        ),
        controller: _pass1,
        onSaved: (value) {
          this.password = value.trim();
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter your password';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget showPasswordForm2() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Re-Password',
        ),
        onSaved: (value) {
          this.password2 = value.trim();
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please fill to confirm the password';
          } else if ((value != _pass1.text)) {
            return 'Password 1 = $value and $password2';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget showSaveButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: RaisedButton(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        color: Colors.blueGrey,
        child: Text('Register'),
        onPressed: () {
          pr.show();
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            register();
          }
        },
      ),
    );
  }

  Future<void> register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      Future.delayed(
        Duration(milliseconds: 1000),
      ).then((v) {
        pr.hide();
        showSuccessDialog('Done',
            'User registeration completed, try again when login screen');
      });
    }).catchError((response) {
      print('error');
      Future.delayed(
        Duration(milliseconds: 500),
      ).then((v) {
        pr.hide();
      });
    });
  }

  void returnLoginScreen() {
    MaterialPageRoute materialPageRoute =
        new MaterialPageRoute(builder: (value) => LoginScreen());
    Navigator.of(context)
        .pushAndRemoveUntil(materialPageRoute, (route) => false);
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    //Define Progress dialog
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Please wait while your request is processing',
      progressWidget: Container(
        padding: EdgeInsets.all(10),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            MaterialPageRoute materialPageRoute =
                MaterialPageRoute(builder: (value) => LoginScreen());
            Navigator.of(context)
                .pushAndRemoveUntil(materialPageRoute, (route) => false);
          },
        ),
        title: Text('Register'),
      ),
      body: showContent(),
    );
  }
}
