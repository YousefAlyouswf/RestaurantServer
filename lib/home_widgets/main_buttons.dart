import 'package:flutter/material.dart';

class ButtonsToAdd extends StatelessWidget {
  Function StartAnewSection;
  Function AddNewDishes;
  ButtonsToAdd(this.StartAnewSection, this.AddNewDishes);
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
            onPressed: StartAnewSection,
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
            onPressed: AddNewDishes,
          ),
        ),
      ],
    );
  }
}
