import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypaied/model/config.dart';
import 'package:mypaied/widget/progressdialog.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:uuid/uuid.dart';

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
  //Image file
  var imageFile;
  var imageThumnailPath = 'images/avatar.png';
  //Directory information
  final baseFolder = "";

  //Image source control
  ImageSource imageSource;
  //Processing dialog
  ProcessingDialog processingDialog;

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
                showPhotoSelection(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: OutlinedButton(
                          onPressed: () {
                            formKey.currentState.reset();
                            setState(() {
                              imageFile = null;
                              txtAmountController.clear();
                              txtDetailController.clear();
                              txtItemController.clear();
                            });
                          },
                          child: Text('Clear'),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              processingDialog.show();
                              //Upload image to firebase server
                              await Firebase.initializeApp();
                              //check photo was select or note
                              String imageFileName= '';
                              firebaseStorage.Reference ref;
                              if (imageFile == null) {
                                print('User not select image');
                                imageFileName = '';
                              }else{

                                //Generate filename of image
                                String newFileName = Uuid().v1();
                                ref = firebaseStorage
                                    .FirebaseStorage.instance
                                    .ref()
                                    .child('Items/$newFileName.png');
                                await ref.putFile(imageFile);

                                 imageFileName =  await ref.getDownloadURL();
                                //Upload image file done
                              }

                              //Send data to API


                              var client = new Dio();
                              client.options.headers['authorization'] =
                                  'Bearer ' +
                                      await FirebaseAuth.instance.currentUser
                                          .getIdToken(true);
                              Response res = await client.post(
                                  Config().getHostName() + 'payment',
                                  data: {
                                    'item': txtItemController.text,
                                    'pay_date': formatDate(
                                      current,
                                      [yyyy, '-', mm, '-', dd],
                                    ),
                                    'detail': txtDetailController.text,
                                    'photo': imageFileName,
                                    'amount': txtAmountController.text
                                        .replaceAll(',', ''),
                                    'email':
                                        FirebaseAuth.instance.currentUser.email,
                                  }).catchError((error) {
                                processingDialog.close();
                              });

                              processingDialog.close();
                              Navigator.of(context).pop();
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

  Future<void> showImageSelectionDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  imageSource = ImageSource.gallery;
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Gallery')
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  imageSource = ImageSource.camera;
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Camera'),
                  ],
                ),
              ),
            ],
            title: Text('Please select Image source'),
          );
        });
  }

  Widget showPhotoSelection() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: GestureDetector(
                  onTap: () async {
                    //Set image source to null when tap photo select
                    imageSource = null;
                    //Show image selection photo dialog
                    await showImageSelectionDialog();
                    //check image was selected ?
                    if (imageSource != null) {
                      //Show image in thumnail'
                      var imageData = await ImagePicker().getImage(
                          source: imageSource,
                          imageQuality: 10,
                          maxHeight: 800,
                          maxWidth: 800);
                      setState(() {
                        imageFile = File(imageData.path);
                      });
                    }
                  },
                  child: imageFile == null
                      ? Image.asset(
                          imageThumnailPath,
                        )
                      : Image.file(imageFile),
                ),
              ),
            ],
          ),
          Container(
            child: Text('Tap to select photo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    processingDialog = new ProcessingDialog(context, 'Please wait');
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Payment'),
      ),
      body: SingleChildScrollView(child: content()),
    );
  }
}
