import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/screen/register.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Method

  //Username
  final TextEditingController txtUsername = TextEditingController();
  //Password
  final TextEditingController txtPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  //Progressbar dialog
  ProgressDialog progressDialog;

  Widget showLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage('images/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget showUsername() {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          controller: txtUsername,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Username cannot null';
            } else if (!(value.contains('@') && value.contains('.'))) {
              return 'username not match any email format';
            } else {
              return null;
            }
          },
        ),
      ]),
    );
  }

  Widget showPassword() {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          obscuringCharacter: "*",
          controller: txtPassword,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.text,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Password cannot null';
            } else {
              return null;
            }
          },
        ),
      ]),
    );
  }

  Widget showLoginButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: RaisedButton(
          color: Colors.grey.shade200,
          padding: EdgeInsets.all(15),
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print('username: ' +
                  txtUsername.text +
                  ' password: ' +
                  txtPassword.text);
              progressDialog.show();
              Future.delayed(Duration(milliseconds: 500)).then((value) {
                progressDialog.hide();
              });
            }
            // MaterialPageRoute materialPageRoute =
            //     MaterialPageRoute(builder: (value) => Home());
            // Navigator.of(context)
            //     .pushAndRemoveUntil(materialPageRoute, (route) => false);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.login),
              SizedBox(
                width: 10,
              ),
              Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          )),
    );
  }

  Widget showRegisterButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: RaisedButton(
        color: Colors.grey.shade500,
        padding: EdgeInsets.all(15),
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (value) => Register());
          Navigator.of(context)
              .pushAndRemoveUntil(materialPageRoute, (route) => false);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.app_registration),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget showContent() {
    return Container(
      child: Stack(
        children: [
          Container(
            child: Image.asset(
              'images/mbbackground.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showLogo(),
                Form(
                  key: formKey,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(18),
                      child: Column(
                        children: [
                          showUsername(),
                          showPassword(),
                          showLoginButton(),
                          showRegisterButton(),
                        ],
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Login method
  Future<void> loginWithUsernamePassword() async {
    FirebaseAuth auth = FirebaseAuth.instance;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    //Define Progress dialog
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
      message: 'Please wait while your request is processing',
      progressWidget: Container(
        padding: EdgeInsets.all(10),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: showContent(),
    );
  }
}
