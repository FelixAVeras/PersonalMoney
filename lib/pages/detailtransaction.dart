import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/databasehelper.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage(this.transactionModel);

  TransactionModel transactionModel;

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  DetailsPageState();

  DatabaseHelper dbHelper;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalles'),
          // centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: 440,
                          child: Column(
                            children: [
                              Text('Descripcion:',
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 16.0)),
                              Text(widget.transactionModel.description,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              SizedBox(height: 10.0),
                              Text('Descripcion:',
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 16.0)),
                              Text(
                                  '\$' +
                                      widget.transactionModel.amount.toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              SizedBox(height: 10.0),
                              Text('Descripcion:',
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 16.0)),
                              Text(widget.transactionModel.currentDate,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
