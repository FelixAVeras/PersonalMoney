import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/pages/currencyPage.dart';
import 'package:personalmoney/pages/dashboradpage.dart';
import 'package:personalmoney/pages/historypage.dart';
// import 'package:personalmoney/pages/historypage.dart';
// import 'package:personalmoney/pages/transactionpage.dart';
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
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.delete_forever),
        //       onPressed: transactionBloc.deleteAllStreams),
        // ],
      ),
      // body: _loadPage(currentIndex),
      body: DashboardPage(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Personal Money - Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Resumen'),
              onTap: () => {
                Navigator.of(context).pop(),
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Presupuesto Mensual'),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryPage()))
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.sync_alt),
              title: Text('Convertidor de Divisas'),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CurrencyPage()))
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()))
              },
            )
          ],
        ),
      ),
      // bottomNavigationBar: _customBottomNavigationBar(),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text('Nueva Transacción'),
      //   icon: Icon(Icons.add),
      //   onPressed: () => {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => TransactionPage()))
      //   },
      // ),
    );
  }

  // Widget _loadPage(int currentPage) {
  //   switch (currentPage) {
  //     case 0:
  //       return DashboardPage();
  //     case 1:
  //       return HistoryPage();

  //     default:
  //       return DashboardPage();
  //   }
  // }

  // Widget _customBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     currentIndex: currentIndex,
  //     onTap: (index) {
  //       setState(() {
  //         currentIndex = index;
  //       });
  //     },
  //     items: [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.access_time), label: 'Historial'),
  //     ],
  //   );
  // }
}
