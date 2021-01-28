import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/pages/dashboradpage.dart';
import 'package:personalmoney/pages/historypage.dart';
import 'package:personalmoney/pages/transactionpage.dart';
import 'package:personalmoney/pages/loginpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentAddress;
  int currentIndex = 0;
  final transactionBloc = new TransactionsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Money"),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.delete_forever),
        //       onPressed: transactionBloc.deleteAllStreams),
        // ],
      ),
      body: _loadPage(currentIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Personal Money - Menu'),
              decoration: BoxDecoration(color: Colors.teal),
            ),
            ListTile(
              title: Text('Resumen'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Presupuesto Mensual'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Convertidor de Divisas'),
              onTap: () => {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => CurrencyPage()))
              },
            ),
            ListTile(
              title: Text('Configuración'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()))
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: _customBottomNavigationBar(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Nueva Transacción'),
        icon: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TransactionPage()))
        },
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _loadPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return DashboardPage();
      case 1:
        return HistoryPage();

      default:
        return DashboardPage();
    }
  }

  Widget _customBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.access_time), label: 'Historial'),
      ],
    );
  }
}
