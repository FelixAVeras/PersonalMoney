import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/budgets/budgetPage.dart';
import 'package:personalmoney/pages/transactions/transactionPage.dart';

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
    // _loadTransactions();
  }

  // Future<void> _loadTransactions() async {
  //   List<TransactionModel> transactions = await _sqlHelper.getTransactions();
  //   double totalAmount = 0.0;

  //   for (var transaction in transactions) {
  //     if (transaction.transType == 'income') {
  //       totalAmount += transaction.amount;
  //     } else if (transaction.transType == 'expense') {
  //       totalAmount -= transaction.amount;
  //     }
  //   }

  //   setState(() {
  //     _transactions = transactions;
  //     _totalAmount = totalAmount;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Overview'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Image.asset('assets/pigbank.png', width: 128.0)
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Transactions'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionPage())
                );
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Budget'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BudgetPage())
                );
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Trends'),
              onTap: () {
                
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.output),
              title: Text('Sign Out'),
              onTap: () {
                
              },
              trailing: Icon(Icons.arrow_back, color: Colors.red,),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTotalCard(),
            DataTable(
              columns: <DataColumn> [
                DataColumn(label: Expanded(child: Text('Category'))),
                DataColumn(label: Expanded(child: Text('Spent'))),
                DataColumn(label: Expanded(child: Text('Balance'))),
              ], 
              rows: <DataRow> [
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: <DataCell>[
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
              ]
            )
          ],
        ),
      )
    );
  }

  Widget _buildTotalCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.wallet, size: 40, color: Colors.teal),
          title: Text(
            _formatAmount(_totalAmount),
            style: TextStyle(
              fontSize: 19.0, fontWeight: FontWeight.bold,
              color: _totalAmount >= 0 ? Colors.green : Colors.grey.shade600,
            ),
          ),
          subtitle: Text('Monto Total (Monto Actual)', style: TextStyle(fontSize: 16.0)),
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
}
