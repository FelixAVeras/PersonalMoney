import 'package:flutter/material.dart';
import 'package:personalmoney/pages/budgetPage.dart';
import 'package:personalmoney/pages/dashboardPage.dart';
import 'package:personalmoney/pages/transactionPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetPages = [
    DashboardPage(),
    BudgetPage(),
    TransactionPage(),
    Center(child: const Text('Pantalla de Reportes'))
  ];

  List<String> _titlePages = [
    'Dashboard',
    'Presupuestos',
    'Transacciones',
    'Reportes'
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(_titlePages[_selectedIndex], style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.question_mark)),
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) async {
              switch(value) {
                case 'markAll':
                  // checkAllItems();
                  break;
                case 'unMarkAll':
                  // uncheckAllItems();
                  break;
                case 'unMarkAll':
                  // uncheckAllItems();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Mi Perfil')),
              const PopupMenuItem(value: 'settings', child: Text('Configuracion')),
              const PopupMenuItem(value: 'logout', child: Text('Salir'))
            ]
          )
        ],
      ),
      body: _widgetPages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            activeIcon: Icon(Icons.pie_chart, color: Colors.teal),
            label: 'Dashboard'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_rounded), 
            activeIcon: Icon(Icons.wallet_rounded, color: Colors.teal),
            label: 'Presupuestos'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            activeIcon: Icon(Icons.sync_alt, color: Colors.teal),
            label: 'Transacciones'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            activeIcon: Icon(Icons.bar_chart, color: Colors.teal),
            label: 'Reportes'
          ),
        ],
      ),
    );
  }
}