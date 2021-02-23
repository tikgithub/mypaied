import 'package:flutter/material.dart';
import 'package:mypaied/screen/home.dart';

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
          style: TextStyle(fontSize: 18),
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white, fontSize: 28)),
        ),
      ]),
    );
  }

  Widget showPassword() {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white, fontSize: 28)),
        ),
      ]),
    );
  }

  Widget showLoginButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        onPressed: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (value)=>Home());
          Navigator.of(context).pushAndRemoveUntil(materialPageRoute, (route) => false);
        },
        child: Text('Login'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    color: Colors.white12,
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
            ],
          ),
        )
      ],
    );
  }
}
