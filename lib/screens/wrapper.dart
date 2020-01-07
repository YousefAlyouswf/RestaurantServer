import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';
import 'auth/auth.dart';
import 'package:restaurantapp/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Return to Home or Auth Widgets

    final user = Provider.of<User>(context);
    if (user == null) {
      return Auth();
    } else {
      return Home();
    }
  }
}
