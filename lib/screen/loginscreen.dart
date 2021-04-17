import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypaied/screen/register.dart';
import 'package:mypaied/widget/progressdialog.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Method

  //Define ProgressDialog
  ProcessingDialog processingDialog;

  //Username
  final TextEditingController txtUsername = TextEditingController();
  //Password
  final TextEditingController txtPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  FirebaseAuth auth;

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
              processingDialog.show();
              FirebaseAuth auth = FirebaseAuth.instance;
              auth
                  .signInWithEmailAndPassword(
                      email: txtUsername.text.trim(),
                      password: txtPassword.text.trim())
                  .then((value) async {
                //Close ProgressIndicator
                await processingDialog.close();
                //Goto Home Screen
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => Home());
                Navigator.of(context)
                    .pushAndRemoveUntil(route, (route) => false);
              }).catchError((error) {
                print(error);

                processingDialog.close();
                //Show error exception dialog
                showLoginExceptionDialog(error.code, error.message);
              });
            }
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

  void showLoginExceptionDialog(String code, String content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            elevation: 3,
            content: Column(
              children: [
                Icon(
                  Icons.lock_clock,
                  color: Colors.redAccent,
                  size: 60,
                ),
                Text(content)
              ],
              mainAxisSize: MainAxisSize.min,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Login failed '),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.black38,
                )
              ],
            ),
            actions: [
              // ignore: deprecated_member_use
              RaisedButton(
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  void hideProgress() {
    Future.delayed(
      Duration(milliseconds: 500),
    ).then((value) => progressDialog.hide());
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
    Firebase.initializeApp().then((value) {
      auth = FirebaseAuth.instance;
      var user = auth.currentUser;
      // if (user != null) {
      //   MaterialPageRoute route = MaterialPageRoute(builder: (value) => Home());
      //   Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {

    //create new Instance
    processingDialog = new ProcessingDialog(
        context, 'Please Wait While User information is Authorizing');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: showContent(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Register'),
        icon: Icon(Icons.app_registration),
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (value) => Register());
          Navigator.of(context)
              .pushAndRemoveUntil(materialPageRoute, (route) => false);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
