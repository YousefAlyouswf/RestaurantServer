import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/models/order_request.dart';
import 'package:restaurantapp/services/authServices.dart';
import 'package:restaurantapp/services/firestoreServices.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class _OrderListState extends State<OrderList> {
  //--------------Order List-----------------
  List<Order> orderFoods = new List<Order>();
  List<DropdownMenuItem<Order>> _listViewOrder;
  //--------------End Order List-----------------

  //------------ Authentication Call
  final AuthService _authService = AuthService();
//-------------- End Authentication Call

  //------------ FirestoreService Call
  final FirestoreService _firestoreService = FirestoreService();
//-------------- End FirestoreService Call

  String statusText;
  String statusCode;

  List<String> idList = List();

  List<String> orderStatus = List<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("الطلبات"),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Requests').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          } else {
            // for (var i = 0; i < snapshot.data.documents.length; i++) {
            //   //ID
            //   String snap_id = snapshot.data.documents[i].documentID;

            //   //Name
            //   String snap_name = snapshot.data.documents[i]['name'];

            //   //Phone
            //   String snap_phone = snapshot.data.documents[i]['phone'];

            //   //Address
            //   String snap_address = snapshot.data.documents[i]['address'];

            //   //Status
            //   String snap_status = snapshot.data.documents[i]['status'];

            //   if (snapshot.data.documents.length > orderFoods.length) {
            //     orderFoods.add(Order(
            //         snap_id, snap_name, snap_phone, snap_address, snap_status));
            //   } else {
            //     break;
            //   }
            // }

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                if (snapshot.data.documents[index].data['status'] == '0') {
                  statusText = 'يتم التحضير';
                } else if (snapshot.data.documents[index].data['status'] ==
                    '1') {
                  statusText = 'في الطريق اليك';
                } else {
                  statusText = 'تم توصيل الطلب';
                }
                for (var i = 0; i < snapshot.data.documents.length; i++) {
                  orderStatus.add('يتم تحضير الطلب');
                }

                return Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          onLongPress: () {
                            _asyncConfirmDialog(context, snapshot, index);
                          },
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.documents[index]
                                                .documentID,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).accentColor,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                          DropdownButton(
                                            hint: Text('حالة الطلب'),
                                            items: _dropDownItem(),
                                            onChanged: (val) {
                                              setState(() {
                                                orderStatus[index] = val;
                                              });
                                              if (orderStatus[index] ==
                                                  "يتم تحضير الطلب") {
                                                statusCode = '0';
                                              } else if (orderStatus[index] ==
                                                  "الطلب في طريقه اليك") {
                                                statusCode = '1';
                                              } else {
                                                statusCode = '2';
                                              }
                                            },
                                            value:
                                                orderStatus[index].toString(),
                                          ),
                                          RaisedButton(
                                            child: Text('تحديث'),
                                            onPressed: () {
                                              Firestore.instance
                                                  .collection('Requests')
                                                  .document(snapshot
                                                      .data
                                                      .documents[index]
                                                      .documentID)
                                                  .updateData(
                                                      {'status': statusCode});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          title: Text(
                              snapshot.data.documents[index].documentID +
                                  '  ' +
                                  statusText),
                          subtitle: Text(
                            snapshot.data.documents[index].data['name'] +
                                '\n' +
                                snapshot.data.documents[index].data['phone'] +
                                '\n' +
                                snapshot.data.documents[index].data['address'] +
                                '\n' +
                                snapshot.data.documents[index].data['total'],
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context,
      AsyncSnapshot<QuerySnapshot> snapshot, int index) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تأكيد الحذف', textDirection: TextDirection.rtl),
          content: Text(
            'رقم الطلب ${snapshot.data.documents[index].documentID}',
            textDirection: TextDirection.rtl,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('حذف'),
              onPressed: () {
                _firestoreService
                    .orderDelete(snapshot.data.documents[index].documentID);
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = [
      "يتم تحضير الطلب",
      "الطلب في طريقه اليك",
      "تم توصيل الطلب"
    ];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }
}
