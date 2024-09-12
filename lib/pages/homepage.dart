import 'package:flutter/material.dart';
import 'package:personalmoney/pages/accounts/accountPage.dart';
import 'package:personalmoney/pages/dashboradpage.dart';
import 'package:personalmoney/pages/transaccions/transactionPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Money', style: TextStyle(color: Colors.white)),
        // centerTitle: true,
        backgroundColor: Color(0xFF78c2ad),
      ),
      body: <Widget>[
        DashboardPage(),
        // AccountsPage(),
        TransactionsPage(),
        Center(child: Text('Pantalla de Reportes')),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.teal,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.attach_money_sharp),
          //   label: 'Cuentas',
          // ),
          NavigationDestination(
            icon: Icon(Icons.sync_alt_rounded),
            label: 'Transacciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reportes',
          ),
        ],
      )
    );
  }
}