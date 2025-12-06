import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnakcHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/transactions/addTransaction.dart';
import 'package:personalmoney/pages/transactions/detailtransaction.dart';
import 'package:sqflite/sqflite.dart';

class TransactionPage extends StatefulWidget {
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final SQLHelper _sqlHelper = SQLHelper();
  final FormatHelper formatHelper = FormatHelper();
  
  List<TransactionModel> _transactions = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    List<TransactionModel> transactions = await _sqlHelper.getTransactions();
    double totalAmount = 0.0;

    for (var transaction in transactions) {
      if (transaction.transType == 'income') {
        totalAmount += transaction.amount;
      } else if (transaction.transType == 'expense') {
        totalAmount -= transaction.amount;
      }
    }

    setState(() {
      _transactions = transactions;
      _totalAmount = totalAmount;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionPage()));
              
              _loadTransactions();
            },
            icon: Icon(Icons.add),
            tooltip: 'Add Transaction',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_transactions.isEmpty) {
      return Center(child: Text('No hay transacciones', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.grey)));
    }

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        TransactionModel transaction = _transactions[index];
        
        return Dismissible(
          key: Key(transaction.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) async {
            await _sqlHelper.deleteTrans(transaction.id!);
            
            setState(() {
              _transactions.removeAt(index);
            });

            SnackHelper.showMessage(context, 'Transaccion "${transaction.name}" eliminada');

            _loadTransactions();
          },
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailTransactionPage(transaction: transaction))
            ),
            leading: Icon(
              transaction.transType == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
              color: transaction.transType == 'income' ? Colors.green : Colors.red,
            ),
            title: Text(transaction.name),
            // subtitle: Text(_formatDate(transaction.date.toString())),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.categoryName ?? "Sin categoría",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(formatHelper.formatDate(transaction.date!)),
              ],
            ),
            trailing: Text(
              formatHelper.formatAmount(transaction.amount),
              style: TextStyle(
                fontSize: 16.0,
                color: transaction.transType == 'income' ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}