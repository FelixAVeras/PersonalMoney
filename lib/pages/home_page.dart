import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/pages/transactions/addTransaction.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/transactions/detailtransaction.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SQLHelper _sqlHelper = SQLHelper();
  
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('PersonalMoney', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => AddtransactionPage()));
              
              _loadTransactions();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTotalCard(),
          
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(Icons.attach_money, size: 40, color: Colors.teal),
          title: Text(
            _formatAmount(_totalAmount),
            style: TextStyle(
              fontSize: 19.0, fontWeight: FontWeight.bold,
              color: _totalAmount >= 0 ? Colors.green : Colors.red,
            ),
          ),
          subtitle: Text('Monto Total', style: TextStyle(fontSize: 16.0)),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US', 
      symbol: '\$', 
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    
    return formatter.format(parsedDate);
  }

  // Widget _buildTransactionList() {
  //   if (_transactions.isEmpty) {
  //     return Center(child: Text('No hay transacciones'));
  //   }

  //   return ListView.builder(
  //     padding: EdgeInsets.all(8.0),
  //     itemCount: _transactions.length,
  //     itemBuilder: (context, index) {
  //       TransactionModel transaction = _transactions[index];
  //       // return ListTile(
  //       //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTransactionPage())),
  //       //   leading: Icon(
  //       //     transaction.transType == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
  //       //     color: transaction.transType == 'income' ? Colors.green : Colors.red,
  //       //   ),
  //       //   title: Text(transaction.name),
  //       //   subtitle: Text(_formatDate(transaction.date)),
  //       //   trailing: Text(
  //       //     _formatAmount(transaction.amount),
  //       //     style: TextStyle(
  //       //       fontSize: 16.0,
  //       //       color: transaction.transType == 'income' ? Colors.green : Colors.red,
  //       //     ),
  //       //   ),
  //       // );
  //       return Dismissible(
  //         key: ,
  //         onDismissed: (direction) {
            
  //         },
  //         child: ListTile(
  //           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTransactionPage())),
  //           leading: Icon(
  //             transaction.transType == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
  //             color: transaction.transType == 'income' ? Colors.green : Colors.red,
  //           ),
  //           title: Text(transaction.name),
  //           subtitle: Text(_formatDate(transaction.date)),
  //           trailing: Text(
  //             _formatAmount(transaction.amount),
  //             style: TextStyle(
  //               fontSize: 16.0,
  //               color: transaction.transType == 'income' ? Colors.green : Colors.red,
  //             ),
  //           ),
  //         )
  //       );
  //     },
  //   );
  // }

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

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${transaction.name} eliminada', style: TextStyle(fontSize: 16.0)))
            );

            _loadTransactions();
          },
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailTransactionPage())
            ),
            leading: Icon(
              transaction.transType == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
              color: transaction.transType == 'income' ? Colors.green : Colors.red,
            ),
            title: Text(transaction.name),
            subtitle: Text(_formatDate(transaction.date)),
            trailing: Text(
              _formatAmount(transaction.amount),
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
