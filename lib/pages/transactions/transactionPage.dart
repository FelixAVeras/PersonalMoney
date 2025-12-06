import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/transactions/addTransaction.dart';
import 'package:personalmoney/pages/transactions/detailtransaction.dart';

class TransactionPage extends StatefulWidget {
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final SQLHelper _sqlHelper = SQLHelper();
  final FormatHelper formatHelper = FormatHelper();
  
  List<TransactionModel> _transactions = [];
  // double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    List<TransactionModel> transactions = await _sqlHelper.getTransactions();
    // double totalAmount = 0.0;

    // for (var transaction in transactions) {
    //   if (transaction.transType == 'income') {
    //     totalAmount += transaction.amount;
    //   } else if (transaction.transType == 'expense') {
    //     totalAmount -= transaction.amount;
    //   }
    // }

    setState(() {
      _transactions = transactions;
      // _totalAmount = totalAmount;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Transactions'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionPage()));
              
              _loadTransactions();
            },
            icon: Icon(Icons.add_circle),
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
    return Center(
      child: Text(
        'No hay transacciones',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }

  final grouped = _groupByCategory();
  final categories = grouped.keys.toList();

  return ListView.builder(
    padding: EdgeInsets.all(8),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      final category = categories[index];
      final items = grouped[category]!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------- Header Categoria ----------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(formatHelper.getCategoryIcon(category), size: 26, color: Colors.blueGrey),
                SizedBox(width: 10),
                Text(
                  category,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // -------- Lista de transacciones --------
          ...items.map((transaction) {
            return ListTile(
              leading: Icon(
                transaction.transType == 'income'
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: transaction.transType == 'income' ? Colors.green : Colors.red,
              ),
              title: Text(transaction.name),
              subtitle: Text(formatHelper.formatDate(transaction.date.toString())),
              trailing: Text(
                formatHelper.formatAmount(transaction.amount),
                style: TextStyle(
                  color: transaction.transType == 'income' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailTransactionPage(transaction: transaction))
            ));
          }).toList(),
        ],
      );
    },
  );
}


  Map<String, List<TransactionModel>> _groupByCategory() {
    Map<String, List<TransactionModel>> grouped = {};

    for (var t in _transactions) {
      String key = t.categoryName ?? "Unknow Category";

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(t);
    }

    return grouped;
  }
}