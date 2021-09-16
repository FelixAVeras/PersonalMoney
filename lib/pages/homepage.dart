import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/pages/currencyPage.dart';
import 'package:personalmoney/pages/dashboradpage.dart';
import 'package:personalmoney/pages/historypage.dart';
import 'package:flutter/widgets.dart';
import 'package:personalmoney/pages/loginpage.dart';
import 'package:personalmoney/pages/myprofile.dart';
import 'package:personalmoney/pages/transactionpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentAddress;
  int currentIndex = 0;

  // final transactionBloc = new TransactionsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text("Personal Money"),
          //   // centerTitle: true,
          //   // bottom: TabBar(
          //   //   tabs: [
          //   //     Tab(/*icon: Icon(Icons.home),*/ text: 'Inicio'),
          //   //     Tab(/*icon: Icon(Icons.calendar_today),*/ text: 'Historial'),
          //   //     // Tab(/*icon: Icon(Icons.sync_alt),*/ text: 'Convertidor Div.'),
          //   //   ],
          //   //   indicatorWeight: 4,
          //   //   indicatorColor: Colors.white,
          //   // ),
          //   // actions: [
          //   //   IconButton(
          //   //     icon: Icon(Icons.add),
          //   //     onPressed: () {
          //   //       Navigator.push(
          //   //           context,
          //   //           MaterialPageRoute(
          //   //               builder: (context) => TransactionPage()));
          //   //     },
          //   //     tooltip: 'Nueva Transaccion',
          //   //   )
          //   // ],
          // ),
          // body: _loadPage(currentIndex),
          // body: DashboardPage(),
          // body: TabBarView(
          //     children: [DashboardPage(), HistoryPage() /*, CurrencyPage()*/]),
          body: HistoryPage(),
          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: [
          //       DrawerHeader(
          //         decoration: BoxDecoration(
          //           color: Theme.of(context).primaryColor,
          //         ),
          //         child: Text('Personal Money - Menu',
          //             style: TextStyle(color: Colors.white, fontSize: 24)),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.person),
          //         title: Text('Mi Perfil'),
          //         onTap: () => {
          //           Navigator.of(context).pop(),
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => MyProfilePage()))
          //         },
          //       ),
          //       Divider(),
          //       ListTile(
          //         leading: Icon(Icons.settings),
          //         title: Text('Configuración'),
          //         onTap: () {},
          //       ),
          //       Divider(),
          //       ListTile(
          //         leading: Icon(Icons.logout),
          //         title: Text('Cerrar Sesión'),
          //         onTap: () => {
          //           Navigator.of(context).pop(),
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => LoginPage()))
          //         },
          //       )
          //     ],
          //   ),
          // ),
          // bottomNavigationBar: _customBottomNavigationBar(),
          // floatingActionButton: FloatingActionButton.extended(
          //   label: Text('Nueva Transacción'),
          //   icon: Icon(Icons.add),
          //   onPressed: () => {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => TransactionPage()))
          //   },
          // ),
        ));
  }
}
