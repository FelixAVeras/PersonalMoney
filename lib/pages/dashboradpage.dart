import 'package:flutter/material.dart';
import 'package:personalmoney/pages/transactionpage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();

  // Widget build(BuildContext context) {
  //   return
  // }

  // Widget _customBackground(BuildContext context) {
  //   final size = MediaQuery.of(context).size;

  //   final backgroundApp = Container(
  //     height: size.height * 0.4,
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //         gradient: LinearGradient(colors: <Color>[
  //       Color.fromRGBO(26, 188, 156, 1.0),
  //       Color.fromRGBO(26, 188, 156, 1.0)
  //     ])),
  //   );

  //   return Stack(
  //     children: [
  //       backgroundApp,
  //       Container(
  //         padding: EdgeInsets.only(top: 50.0),
  //         child: Column(
  //           children: [
  //             Text('Ult. Transaccion',
  //                 style: TextStyle(color: Colors.white, fontSize: 16.0)),
  //             SizedBox(height: 5.0, width: double.infinity),
  //             Text('1,024.98',
  //                 style: TextStyle(color: Colors.white, fontSize: 30.0)),
  //             SizedBox(height: 5.0, width: double.infinity),
  //             Text('Fecha: 10/10/2020',
  //                 style: TextStyle(color: Colors.white, fontSize: 25.0))
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Widget _historyListTrans() {
  //   return Center(
  //     child: Card(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           const ListTile(
  //             leading: Icon(Icons.alternate_email),
  //             title: Text('Pago Mensualidad Internet'),
  //             subtitle: Text('Pago de la mensualidad del Internet de la casa.'),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: <Widget>[
  //               TextButton(
  //                 child: const Text('DETALLES'),
  //                 onPressed: () {},
  //               ),
  //               const SizedBox(width: 8),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text('Este es el Home')),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TransactionPage()));
          },
          label: Text('Nueva Transaccion'),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ));
    ;
  }
}
