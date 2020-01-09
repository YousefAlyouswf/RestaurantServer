import 'package:flutter/material.dart';
import 'package:restaurantapp/screens/home/adddishes.dart';
import 'package:restaurantapp/screens/home/addsection.dart';

class ButtonsToAdd extends StatelessWidget {
  Function StartAnewSection;
  ButtonsToAdd(this.StartAnewSection);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.brown[400])),
            child: Text(
              "إظافة قسم",
              style: TextStyle(fontSize: 18),
            ),
            elevation: 5,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddSection();
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(100.0),
                side: BorderSide(color: Colors.brown[400])),
            child: Text(
              "إظافة طبق",
              style: TextStyle(fontSize: 18),
            ),
            elevation: 5,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddDishes();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
