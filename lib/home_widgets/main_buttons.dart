import 'package:flutter/material.dart';
import 'package:restaurantapp/screens/home/adddishes.dart';
import 'package:restaurantapp/screens/home/addsection.dart';
import 'package:restaurantapp/screens/home/order.dart';

class ButtonsToAdd extends StatelessWidget {
  ButtonsToAdd();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
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
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(100.0),
                    side: BorderSide(color: Colors.brown[400])),
                child: Text(
                  "الــطــلــبــات",
                  style: TextStyle(fontSize: 22),
                ),
                elevation: 5,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return OrderList();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
