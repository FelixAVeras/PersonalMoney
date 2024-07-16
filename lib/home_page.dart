import 'package:flutter/material.dart';
import 'package:personalmoney/pages/fixedexpensesPage.dart';
import 'package:personalmoney/pages/unforseeneventPage.dart';
import 'package:personalmoney/pages/dashboardPage.dart';

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
        title: Text('PersonalMoney', style: TextStyle(color: Colors.white)),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings_rounded, color: Colors.white), tooltip: 'Ajustes',),
          IconButton(onPressed: () {}, icon: Icon(Icons.person_rounded, color: Colors.white), tooltip: 'Mi Perfil',)
        ]
      ),
      body: [
        DashboardPage(),
        ImprevistosPage(),
        FixedExpensesPage()
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer_rounded),
            label: 'Trans. Rápidas',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: Icon(Icons.pie_chart_rounded),
            label: 'Gastos Fijos',
          ),
        ],

      ),
    );
  }
}