import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';

class TransDetailPage extends StatefulWidget {
  TransDetailPage(this.trans);

  final TransactionModel trans;

  @override
  State<TransDetailPage> createState() => _TransDetailPageState();
}

class _TransDetailPageState extends State<TransDetailPage> {
  _TransDetailPageState();

  SQLHelper _sqlHelper = SQLHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Card(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: 440,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Transaction Name:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                            Text(widget.trans.name)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Transaction Type:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                            Text(widget.trans.transType)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Amount:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                            Text(widget.trans.amount.toString())
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Transaction Date:', style: TextStyle(color: Colors.black.withOpacity(0.8))),
                            Text(widget.trans.date)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            ElevatedButton(
                              // onPressed: () async => Navigator.push(context, MaterialPageRoute(builder: (context) => EditDataWidget(widget.trans))),
                              onPressed: () {},
                              child: Text('Editar', style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _confirmDialog();
                              },
                              child: Text('Eliminar', style: TextStyle(color: Colors.white))
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              )
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure want delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                final initDB = _sqlHelper.initDB();
                initDB.then((db) async {
                  await _sqlHelper.deleteTrans(widget.trans.id!);
                });

                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}