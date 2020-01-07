import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/authServices.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[Text("صفحة الدخول")],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                new Container(
                  child: new Image.asset(
                    'images/logo.png',
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "البريد الايكتروني"),
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                  validator: (val) => val.isEmpty ? 'يجب كتابة الايميل' : null,
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "الرقم السري"),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 20),
                  obscureText: true,
                  validator: (val) => val.isEmpty ? 'الرقم السري مطلوب' : null,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text(
                    "دخول",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.pink[400],
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result =
                          await _authService.siginFirebaseWithEmailAndPassword(
                              email + "@gmail.com", password + "23456");

                      if (result == null) {
                        setState(() {
                          error = 'البيانات غير صحيحة';
                        });
                      } else {
                        setState(() {
                          error = '';
                        });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
