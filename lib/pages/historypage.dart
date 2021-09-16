// import 'package:flutter/material.dart';
// import 'package:personalmoney/helpers/databasehelper.dart';
// import 'package:personalmoney/models/transactionmodel.dart';
// import 'package:personalmoney/pages/detailtransaction.dart';

// class HistoryPage extends StatelessWidget {
//   // final transactionBloc = new TransactionsBloc();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: AppBar(
//         //   title: Text('Historial'),
//         //   centerTitle: true,
//         // ),
//         body: FutureBuilder<List<TransactionModel>>(
//             future: DatabaseHelper.db.getAllTransactions(),
//             builder: (BuildContext context,
//                 AsyncSnapshot<List<TransactionModel>> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               final trans = snapshot.data;

//               if (trans.length == 0) {
//                 return Center(child: Text('No hay informacion'));
//               }

//               return ListView.builder(
//                   itemCount: trans.length,
//                   itemBuilder: (context, i) => Dismissible(
//                       key: UniqueKey(),
//                       background: Container(color: Colors.red),
//                       onDismissed: (direction) =>
//                           DatabaseHelper.db.deleteTransactionById(trans[i].id),
//                       child: ListTile(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => DetailsPage(trans[i])));
//                         },
//                         // leading: trans[i].transType == 'earning'
//                         //     ? Icon(Icons.attach_money,
//                         //         color: Theme.of(context).primaryColor)
//                         //     : Icon(Icons.money_off, color: Colors.red),
//                         leading: Icon(Icons.local_atm),
//                         title: Text(trans[i].description +
//                             ' - \$' +
//                             trans[i].amount.toString()),
//                         subtitle: Text(trans[i].currentDate),
//                         trailing: Icon(
//                           Icons.keyboard_arrow_right,
//                           color: Colors.grey,
//                         ),
//                       )));
//             }),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             DatabaseHelper.db.deleteAllTransactions();
//           },
//           child: Icon(Icons.delete_forever),
//           backgroundColor: Colors.red,
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';
import 'package:personalmoney/pages/transactionlist.dart';
import 'package:personalmoney/pages/transactionpage.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DbConn dbconn = DbConn();
  List<TransactionModel> transList;
  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    if (transList == null) {
      transList = List<TransactionModel>();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Money'),
      ),
      body: new Container(
        child: new Center(
            child: new FutureBuilder(
          future: loadList(),
          builder: (context, snapshot) {
            return transList.length > 0
                ? new TransList(trans: transList)
                : new Center(
                    child: new Text('No hay informacion que mostrar',
                        style: TextStyle(
                            color: Colors.grey[400], fontSize: 20.0)));
          },
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        label: Text('Nueva Transaccion'),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new FutureBuilder(
          future: loadTotal(),
          builder: (context, snapshot) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Total: $totalCount',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
            );
          },
        ),
        color: Colors.grey,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future loadList() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<List<TransactionModel>> futureTrans = dbconn.trans();
      futureTrans.then((transList) {
        setState(() {
          this.transList = transList;
        });
      });
    });
  }

  Future loadTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = dbconn.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }

  _navigateToAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionPage()),
    );
  }
}
