import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:uuid/uuid.dart';

class PaymentEditScreen extends StatefulWidget {
  var data;
  PaymentEditScreen({this.data});

  @override
  _PaymentEditScreenState createState() =>
      _PaymentEditScreenState(data: this.data);
}

class _PaymentEditScreenState extends State<PaymentEditScreen> {
  var data;
  _PaymentEditScreenState({this.data});
  //Controller define
  TextEditingController item = new TextEditingController();
  TextEditingController detail = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  TextEditingController pay_date = new TextEditingController();

  var formatNumber = NumberFormat.decimalPattern("en_US");

  DateTime pickTime;

  final formKey = GlobalKey<FormState>();

  var imageFile;

  Widget imageWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item.text = this.data['item'];
    detail.text = this.data['detail'];
    amount.text = formatNumber.format(this.data['amount']).toString();
    String data = formatDate(
        DateTime.parse(this.data['pay_date']), [dd, '/', mm, '/', yyyy]);
    pay_date.text = data;
    print(this.data['photo']);
  }

  void _setDateTime() async {
    DateTime pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    pay_date.text = formatDate(pickDate, [dd, '/', mm, '/', yyyy]);
  }

  //Avatar image
  Widget avatarImage() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/avatar.png'),
      ),
    );
  }

  //Rest API Image
  Widget restImage() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(this.data['photo']),
      ),
    );
  }

  Widget fileImage(File file) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(10),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10), child: Image.file(file)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageWidget == null) {
      if (this.data['photo'] == '') {
        imageWidget = avatarImage();
      } else {
        imageWidget = restImage();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ແກ້ໄຂລາຍການ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageWidget == null ? Text('Loading') : imageWidget,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () async {
                      imageFile = null;
                      imageWidget = null;
                      //Image source from galltery
                      var imagePickGallery = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                          maxWidth: 800,
                          maxHeight: 800);
                      if (imagePickGallery != null) {
                        imageFile = File(imagePickGallery.path);
                        setState(() {
                          imageWidget = fileImage(imageFile);
                        });
                      }
                    }),
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () async {
                      imageFile = null;
                      imageWidget = null;
                      var imageCamera = await ImagePicker().getImage(
                          source: ImageSource.camera,
                          imageQuality: 50,
                          maxWidth: 800,
                          maxHeight: 800);
                      if (imageCamera != null) {
                        imageFile = File(imageCamera.path);
                        setState(() {
                          imageWidget = fileImage(imageFile);
                        });
                      }
                    }),
              ],
            ),
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: item,
                      decoration: InputDecoration(
                        icon: Icon(Icons.add_circle_outline),
                        labelText: "ລາຍການ",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ເພີ່ມຂໍ້ມູນ';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: detail,
                      decoration: InputDecoration(
                        icon: Icon(Icons.details),
                        labelText: "ລາຍລະອຽດ",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: amount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.money_rounded),
                        labelText: "ຈຳນວນເງິນ",
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      inputFormatters: [
                        ThousandsFormatter(allowFraction: true),
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ເພີ່ມຂໍ້ມູນ';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: TextFormField(
                            controller: pay_date,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              icon: Icon(Icons.date_range),
                              labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            validator: (value) {
                              try {
                                var convertDate = DateFormat("dd/mm/yyyy");
                                convertDate.parse(value);
                                if (value.isEmpty) {
                                  return 'ເພີ່ມຂໍ້ມູນ';
                                }
                                return null;
                              } catch (e) {
                                print(e);
                                return 'ຂໍ້ມູນບໍ່ຖືກຕ້ອງ';
                              }
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _setDateTime();
                          },
                          child: Text("ເລືອກ"),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            // await Firebase.initializeApp();
                            // firebaseStorage.Reference ref;
                            // String imageFilename = Uuid().v1();
                            // //upload new image
                            // ref = firebaseStorage.FirebaseStorage.instance
                            //     .ref()
                            //     .child('Items/$imageFilename.png');
                            // await ref.putFile(imageFile);
                            // //Delete old image
                            // if (this.data['photo'] != '') {
                            //   var name = firebaseStorage
                            //       .FirebaseStorage.instance
                            //       .refFromURL(this.data['photo']);
                            //   ref = firebaseStorage.FirebaseStorage.instance
                            //       .ref()
                            //       .child('Items/$name');
                            //   await ref.delete();
                            // }
                            // print(imageFilename);
                            await Firebase.initializeApp();
                            firebaseStorage.Reference ref;
                            //upload new image
                              var name = firebaseStorage
                                  .FirebaseStorage.instance
                                  .refFromURL('https://firebasestorage.googleapis.com/v0/b/mypaied.appspot.com/o/Items%2Fc9a7ce00-a2da-11eb-9359-67c1fa221d15.png?alt=media&token=d747c49d-358a-487b-89f4-579f30a6163d');
                              print('Image name: ' + name.name);
                              ref = firebaseStorage.FirebaseStorage.instance
                                  .ref()
                                  .child('Items/${name.name}');
                              await ref.delete();
                          }
                        },
                        child: Text('ບັນທຶກ'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
