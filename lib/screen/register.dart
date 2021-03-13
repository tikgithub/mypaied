import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypaied/model/config.dart';
import 'package:mypaied/model/user.dart';
import 'package:mypaied/screen/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'loginscreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dio/dio.dart';

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
  firebase_storage.FirebaseStorage storage;
  FirebaseFirestore firestore;

  //Holding image data when select
  File imageFile;

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
      child: imageFile == null
          ? Image.asset(
              'images/avatar.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.5,
            )
          : Image.file(imageFile,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.5),
    );
  }

//Camera and folder image button Widget
  Widget showImageControlButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.camera,
            size: 50,
          ),
          onPressed: () {
            chooseImageSource(ImageSource.camera);
          },
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
          onPressed: () {
            chooseImageSource(ImageSource.gallery);
          },
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
        obscureText: true,
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
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Re-Password',
        ),
        onSaved: (value) {
          this.password2 = value.trim();
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Please fill to confirm the password';
          } else if ((value.toString() != _pass1.text)) {
            return 'Password 1 = $value and ${_pass1.text}';
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
        onPressed: () async {
          print('register click');

          if (imageFile == null) {
            showAlertDialog('Please check your profile photo');
            return;
          }

          print('after send');
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            //show Progress dialog
            pr.show();
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password)
                .then((value) async {
              //Upload Image to Firebase Store
              //Genertate new Filename
              String newFileName = Uuid().v1();
              firebase_storage.Reference ref = firebase_storage
                  .FirebaseStorage.instance
                  .ref()
                  .child('Users/$newFileName.png');

              ref.putFile(imageFile).then((value) async {
                //Send Data Email and Photo filename to API Heroku
                await sendRegistData(email, '$newFileName.png');
                closeProgressDialog();
              });
            }).catchError((error) {
              print(error.message);
              closeProgressDialog();
            });
          }
        },
      ),
    );
  }

  Future sendRegistData(String email, String photo) async {
    var dio = Dio();
    Response response =
        await dio.post(new Config().getHostName() + 'user/register', data: {
      'email': email,
      'photo': photo,
    });
    print(response.data.toString());
  }

  void showAlertDialog(String content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Warning'),
            content: Text(content),
            actions: [
              RaisedButton(
                child: Text('OK'),
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> register(String photoFile) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      //Get current user
      // var currentUser = auth.currentUser;
      //FirebaseFireStore reference
      CollectionReference userReference = firestore.collection('Users');
      //Prepare new Data for new user
      UserModel userModel = new UserModel(email, photoFile);

      //Add Data to firestore
      userReference.add(userModel.toMap()).then((value) {
        closeProgressDialog();
      }).catchError((error) {
        closeProgressDialog();
      });
    }).catchError((response) {
      closeProgressDialog();
    });
  }

  Future<void> closeProgressDialog() async {
    setState(() {
      Future.delayed(
        Duration(milliseconds: 1000),
      ).then((v) {
        pr.hide().whenComplete(() {
          showSuccessDialog('Done',
              'User registeration completed, try again when login screen');
        });
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

  // Method to working with Image source
  Future<void> chooseImageSource(ImageSource img) async {
    try {
      var imageData =
          await ImagePicker().getImage(source: img, imageQuality: 50);
      setState(() {
        imageFile = File(imageData.path);
      });
    } catch (ex) {
      setState(() {
        imageFile = null;
      });
      print(ex);
    }
  }

//Method to show errordialog
  void exceptionDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Error!!!'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 2,
                  color: Colors.blueGrey,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //Firestorage initailize
    storage = firebase_storage.FirebaseStorage.instance;
    //Firestore initailize
    firestore = FirebaseFirestore.instance;

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

// pr.show();
//             //Define new UUID
//             var uuid = Uuid();
//             // Create new filename with random string
//             String newName = uuid.v1() + '.png';
//             // Upload to firebase cloud
//             registerAPICall(email, newName);
//             closeProgressDialog();
//             // storage.ref('Users/$newName').putFile(imageFile).then((value) {
//             //   //Perform user registration to firebase
//             //   // register(newName);

//             // }).catchError((error) {
//             //   closeProgressDialog();
//             // });
