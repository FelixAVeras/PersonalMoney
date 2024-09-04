import 'package:flutter/material.dart';
import 'package:personalmoney/pages/budgetPage.dart';
import 'package:personalmoney/pages/dashboardPage.dart';
import 'package:personalmoney/pages/transactionPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PersonalMoney', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Personal Money')),
            ListTile(
              leading: const Icon(Icons.wallet_rounded),
              title: Text('Presupuestos'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetPage()));
              },
              splashColor: Colors.teal.shade200,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Transacciones'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage()));
              },
              splashColor: Colors.teal.shade200,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.calculate_rounded),
              title: Text('Calculadoras'),
              onTap: () {},
              splashColor: Colors.teal.shade200,
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.bar_chart_rounded),
              title: Text('Reportes'),
              onTap: () {},
              splashColor: Colors.teal.shade200,
            )
          ],
        ),
      ),
      body: DashboardPage()
    );
  }
}