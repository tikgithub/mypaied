import 'package:flutter/material.dart';
import 'package:mypaied/screen/home.dart';
import 'package:mypaied/screen/register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Method

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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ]),
    );
  }

  Widget showPassword() {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.text,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white, fontSize: 18)),
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
            MaterialPageRoute materialPageRoute =
                MaterialPageRoute(builder: (value) => Home());
            Navigator.of(context)
                .pushAndRemoveUntil(materialPageRoute, (route) => false);
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
                Container(
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
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
