import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restaurantapp/models/foods_items.dart';
import 'package:restaurantapp/services/authServices.dart';
import 'dart:io';

import 'package:restaurantapp/services/firestoreServices.dart';

class AddDishes extends StatefulWidget {
  @override
  _AddDishesState createState() => _AddDishesState();
}

class _AddDishesState extends State<AddDishes> {
  //-------------------> Foods List <-------------------

  List<Foods> foods = new List<Foods>();
  List<DropdownMenuItem<Foods>> _dropDownMenu;
  Foods _selectedFoods;

  onChangeDropFoods(Foods selectedFoods) {
    setState(() {
      _selectedFoods = selectedFoods;
    });
  }

  //-------------------> END Foods List <-------------------
  final AuthService _authService = AuthService();

  //Progress dialog
  ProgressDialog pr;
  double percentage = 0.0;
  //--------Function to add into Foods
  Future uploadImage() async {
    pr.show();
    String fileName = '${DateTime.now()}.png';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorage.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await firebaseStorage.getDownloadURL() as String;

    if (url.isNotEmpty) {
      firestoreService.UpdateFoods(sectionName, url, price, _selectedFoods.id);
      Fluttertoast.showToast(
          msg: "تمت أظافة القسم",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green[200],
          textColor: Colors.white,
          fontSize: 16.0);
    }
    pr.hide();
  }

  //------------------------------------->>>>>>>>
  String url;
  File _image;

  final FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String sectionName = '';
  String imageLink = '';
  String price = '';
  String error = '';
  String imageError = '';
  var sectionValue;
  var secID;
//---------------------------------------->>>>>>
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }

    //init progress dialog
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    //Optional
    pr.style(
      message: '...جاري الرفع',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("قائمة الطعام"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text("خروج"),
            onPressed: () async {
              await _authService.signOUt();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.brown[50],
          elevation: 15,
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "إظافة طبق",
                    style: TextStyle(fontSize: 18, color: Colors.brown[400]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: SizedBox(
                              height: 180,
                              width: 180,
                              child: (_image != null)
                                  ? Image.file(_image, fit: BoxFit.fill)
                                  : Image.network(
                                      'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/diner-restaurant-logo-design-template-0899ae0c7e72cded1c0abc4fe2d76ae4_screen.jpg?ts=1561476509',
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: IconButton(
                          iconSize: 50,
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.image),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "أسم الطبق"),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20),
                    validator: (val) =>
                        val.isEmpty ? 'يجب كتابة اسم الطبق' : null,
                    onChanged: (val) {
                      setState(() {
                        sectionName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "سعر الطبق"),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20),
                    validator: (val) => val.isEmpty ? 'يجب كتابة السعر' : null,
                    onChanged: (val) {
                      setState(() {
                        price = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  //--------------------------------------------------------->
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('category').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading...");
                      } else {
                        for (var i = 0;
                            i < snapshot.data.documents.length;
                            i++) {
                          //Name
                          String snap = snapshot.data.documents[i]['name'];

                          //ID
                          String snapID = snapshot.data.documents[i].documentID;
                          if (snapshot.data.documents.length > foods.length) {
                            foods.add(Foods(snapID, snap));
                          } else {
                            break;
                          }
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            DropdownButton<Foods>(
                              items: foods.map((Foods f) {
                                return DropdownMenuItem(
                                  value: f,
                                  child: Text(f.name),
                                );
                              }).toList(),
                              onChanged: onChangeDropFoods,
                              value: _selectedFoods,
                              hint: Text("الأقسام المتاحة"),
                            )
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedButton(
                      child: Text(
                        "إنشاء",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: Colors.pink[400],
                      onPressed: () async {
                        if (_formKey.currentState.validate() ||
                            _image != null) {
                          uploadImage();
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
