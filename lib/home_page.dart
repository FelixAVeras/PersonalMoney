import 'package:flutter/material.dart';
import 'package:personalmoney/pages/budgetPage.dart';
import 'package:personalmoney/pages/dashboardPage.dart';
import 'package:personalmoney/pages/transactionPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _selectedIndex = 0;

  // List<Widget> _widgetPages = [
  //   DashboardPage(),
  //   BudgetPage(),
  //   TransactionPage(),
  //   Center(child: const Text('Pantalla de Reportes'))
  // ];

  // List<String> _titlePages = [
  //   'Dashboard',
  //   'Presupuestos',
  //   'Transacciones',
  //   'Reportes'
  // ];

  // void _onItemTapped(int index) {
  //   setState(() => _selectedIndex = index);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(_titlePages[_selectedIndex], style: TextStyle(color: Colors.white)),
        title: Text('Personal Money', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white)
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.teal,
      //         ),
      //         child: Text('Personal Money')
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.wallet_rounded),
      //         title: Text('Presupuestos'),
      //         onTap: () {
      //           Navigator.pop(context);

      //           Navigator.push(context, MaterialPageRoute(builder: (context) => BudgetPage()));
      //         },
      //         splashColor: Colors.teal.shade200,
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.sync_alt),
      //         title: Text('Transacciones'),
      //         onTap: () {
      //           Navigator.pop(context);

      //           Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage()));
      //         },
      //         splashColor: Colors.teal.shade200,
      //       ),
      //       // ListTile(
      //       //   leading: Icon(Icons.calculate_rounded),
      //       //   title: Text('Calculadoras'),
      //       //   onTap: () {},
      //       //   splashColor: Colors.teal.shade200,
      //       // ),
      //       // ListTile(
      //       //   leading: Icon(Icons.bar_chart_rounded),
      //       //   title: Text('Reportes'),
      //       //   onTap: () {},
      //       //   splashColor: Colors.teal.shade200,
      //       // )
      //     ],
      //   ),
      // ),
      body: DashboardPage(),
      // body: _widgetPages.elementAt(_selectedIndex),
      // bottomNavigationBar: NavigationBar(
      //   labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //   selectedIndex: _selectedIndex,
      //   onDestinationSelected: _onItemTapped,
      //   indicatorColor: Colors.teal,
      //   destinations: [
      //     NavigationDestination(
      //       icon: Icon(Icons.pie_chart),
      //       selectedIcon: Icon(Icons.pie_chart, color: Colors.white),
      //       label: 'Dashboard'
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.wallet_rounded), 
      //       selectedIcon: Icon(Icons.wallet_rounded, color: Colors.white),
      //       label: 'Presupuestos'
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.sync_alt),
      //       selectedIcon: Icon(Icons.sync_alt, color: Colors.white),
      //       label: 'Transacciones'
      //     ),
      //     NavigationDestination(
      //       icon: Icon(Icons.bar_chart),
      //       selectedIcon: Icon(Icons.bar_chart, color: Colors.white),
      //       label: 'Reportes'
      //     ),
      //   ],
      // ),
    );
  }
}