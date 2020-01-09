import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restaurantapp/services/authServices.dart';
import 'package:restaurantapp/services/firestoreServices.dart';

class AddSection extends StatefulWidget {
  @override
  _AddSectionState createState() => _AddSectionState();
}

class _AddSectionState extends State<AddSection> {
  final AuthService _authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String sectionName = '';
  String imageLink = '';
  String error = '';
  String imageError = '';
  String url;
  File _image;
  var selectedSection;
  //Progress dialog
  ProgressDialog pr;
  double percentage = 0.0;


  Future uploadImage() async {
    pr.show();
    String fileName = '${DateTime.now()}.png';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorage.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await firebaseStorage.getDownloadURL() as String;

    if (url.isNotEmpty) {
      
      firestoreService.UpdateSection(sectionName, url);
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
                    "إنشاء قسم جديد",
                    style: TextStyle(fontSize: 18, color: Colors.brown[400]),
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
                        hintText: "أسم القسم"),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20),
                    validator: (val) => val.isEmpty ? 'أسم القسم مطلوب' : null,
                    onChanged: (val) {
                      setState(() {
                        sectionName = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 25,
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
