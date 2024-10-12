import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/partials/addTrans.dart';
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
      // appBar: AppBar(
      //   title: Text('Transacciones', style: TextStyle(color: Colors.white)),
      //   elevation: 2,
      //   scrolledUnderElevation: 4,
      //   centerTitle: false,
      //   backgroundColor: Colors.teal,
      //   iconTheme: IconThemeData(color: Colors.white),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDataWidget()));

      //         if (result == true) {
      //           setState(() => loadTransactionList());
      //         }
      //       }, 
      //       icon: Icon(Icons.add_circle_rounded),
      //       tooltip: 'Agregar Transaccion',
      //     )
      //   ],
      // ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: FutureBuilder(
            future: loadTransactionList(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!.length > 0) {
                return TransList(trans: snapshot.data!);
              } else {
                return Center(child: Text('No hay información para mostrar'));
              }
            }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddDataWidget())),
        child: Icon(Icons.add_rounded),
        tooltip: 'Agregar monto',
        elevation: 2,
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<List<TransactionModel>> loadTransactionList() async {
    await _sqlHelper.initDB();

    return await _sqlHelper.trans();
  }

  Future<void> loadTotal() async {
    await _sqlHelper.initDB();

    int total = await _sqlHelper.countTotal();

    setState(() => this.totalCount = total);
  }
}