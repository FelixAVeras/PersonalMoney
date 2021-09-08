import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/pages/transactionpage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DatabaseHelper dbhelper;
  int totalCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Card(
                    child: ListTile(
                      title: Text('\$$totalCount',
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center),
                      subtitle: Text('Balance Total',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                          textAlign: TextAlign.center),
                    ),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                          title: Text(
                            'Ganancias',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'this is a description of the Ganancias',
                              textAlign: TextAlign.center)),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ListTile(
                          title: Text(
                            'Perdidas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'this is a description of the Ganancias',
                              textAlign: TextAlign.center)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TransactionPage()));
          },
          label: Text('Nueva Transaccion'),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  Future loadTotal() {
    final Future futureDB = dbhelper.initDB();

    return futureDB.then((db) {
      Future<int> futureTotal = dbhelper.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }
}
