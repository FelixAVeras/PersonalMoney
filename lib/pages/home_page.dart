import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnakcHelper.dart';
import 'package:personalmoney/pages/categoryPage.dart';
import 'package:personalmoney/pages/transactions/addTransaction.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/pages/transactions/detailtransaction.dart';
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
              child: Text(
                'Personal Money',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => AllocateBudgetPage())
                // );
              },
              trailing: Icon(Icons.arrow_forward),
            ),
            const Divider(),
            // ListTile(
            //   leading: Icon(Icons.category),
            //   title: Text('Categories'),
            //   onTap: () {
            //     Navigator.pop(context);

            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => CategoryPage())
            //     );
            //   },
            //   trailing: Icon(Icons.arrow_forward),
            // ),
            // const Divider(),
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
              leading: Icon(Icons.settings),
              title: Text('Settings'),
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
      body: Column(
        children: [
          _buildTotalCard(),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card.outlined(
        child: ListTile(
          leading: Icon(Icons.wallet, size: 40, color: Colors.teal),
          title: Text(
            _formatAmount(_totalAmount),
            style: TextStyle(
              fontSize: 19.0, fontWeight: FontWeight.bold,
              color: _totalAmount >= 0 ? Colors.green : Colors.red,
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
