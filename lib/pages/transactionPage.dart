import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/addBudgetPage.dart';
import 'package:personalmoney/pages/partials/translist.dart';

class TransactionPage extends StatefulWidget {
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  SQLHelper _sqlHelper = SQLHelper();

  List<TransactionModel>? transList;

  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    if (transList == null) {
      transList = [];
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Transacciones'),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
      ),
      body: new Container(
        child: new Center(
          child: new FutureBuilder(
            future: loadTransactionList(), 
            builder: (context, snapshot) {
              return transList!.length > 0 
              ? new TransList(trans: transList!) 
              : new Center(child: Text('No hay informacion para mostrar')); 
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpensePage())),
        child: Icon(Icons.add_rounded),
        tooltip: 'Agregar Transaccion',
        elevation: 2,
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future loadTransactionList() {
    final Future futureDb = _sqlHelper.initDB();

    return futureDb.then((db) {
      Future<List<TransactionModel>> futureTrans = _sqlHelper.trans();

      futureTrans.then((value) => setState(() { this.transList = transList; }));
    });
  }

  Future loadTotal() {
    final Future futureDB = _sqlHelper.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = _sqlHelper.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }
}