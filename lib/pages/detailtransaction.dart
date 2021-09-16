import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';
import 'package:personalmoney/pages/homepage.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage(this.transactionModel);

  TransactionModel transactionModel;

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  DetailsPageState();

  DbConn dbconn = DbConn();

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Esta seguro que desea esta transaccion?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                final initDB = dbconn.initDB();
                initDB.then((db) async {
                  await dbconn.deleteTrans(widget.transactionModel.id);
                });

                // Navigator.popUntil(
                //     context, ModalRoute.withName(Navigator.defaultRouteName));

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            FlatButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles - ' + widget.transactionModel.description),
        centerTitle: true,
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
                            Text('Descripcion:',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8))),
                            Text(widget.transactionModel.description,
                                style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      //   child: Column(
                      //     children: <Widget>[
                      //       Text('Tipo Transaccion:',
                      //           style: TextStyle(
                      //               color: Colors.black.withOpacity(0.8))),
                      //       Text(widget.transactionModel.transType,
                      //           style: Theme.of(context).textTheme.title)
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Monto Transaccion:',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8))),
                            Text(widget.transactionModel.amount.toString(),
                                style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Text('Fecha de Transaccion:',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8))),
                            Text(widget.transactionModel.currentDate,
                                style: Theme.of(context).textTheme.title)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          children: <Widget>[
                            // RaisedButton(
                            //   splashColor: Colors.red,
                            //   onPressed: () {
                            //     // _navigateToEditScreen(context, widget.trans);
                            //   },
                            //   child: Text('Editar',
                            //       style: TextStyle(color: Colors.black)),
                            //   color: Colors.yellow[600],
                            // ),
                            RaisedButton(
                              splashColor: Colors.red,
                              onPressed: () {
                                _confirmDialog();
                              },
                              child: Text('Eliminar',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                            )
                          ],
                        ),
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
