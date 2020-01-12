import 'package:flutter/material.dart';
import 'package:restaurantapp/home_widgets/main_buttons.dart';
import 'package:restaurantapp/services/authServices.dart';
import 'dart:io';
import 'package:restaurantapp/services/firestoreServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:path/path.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url;
  File _image;
  var selectedSection;

  //-----------------------init Firebase messaging
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    _fcm.getToken().then((token){
print(token);
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Message: $message");
        final snackbar = SnackBar(
          content: Text(message['Notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () {},
          ),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("Message: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("Message: $message");
      },
    );
  }
  //-----------------------END init Firebase messaging

  //Progress dialog
  ProgressDialog pr;
  double percentage = 0.0;

  //Function to uplouad image to fire storage and get the url
  Future uploadImage(BuildContext context) async {
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
      Navigator.pop(context);
    }
    pr.hide();
  }

  final AuthService _authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String sectionName = '';
  String imageLink = '';
  String error = '';
  String imageError = '';

  @override
  Widget build(BuildContext context) {
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
        child: ButtonsToAdd(),
      ),
    );
  }
}
