import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/databasehelper.dart';
import 'package:personalmoney/models/transactionmodel.dart';
import 'package:personalmoney/pages/detailtransaction.dart';

class HistoryPage extends StatelessWidget {
  // final transactionBloc = new TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Historial'),
      //   centerTitle: true,
      // ),
      body: FutureBuilder<List<TransactionModel>>(
          future: DatabaseHelper.db.getAllTransactions(),
          builder: (BuildContext context,
              AsyncSnapshot<List<TransactionModel>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final trans = snapshot.data;

            if (trans.length == 0) {
              return Center(child: Text('No hay informacion'));
            }

            return ListView.builder(
                itemCount: trans.length,
                itemBuilder: (context, i) => Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) =>
                        DatabaseHelper.db.deleteTransactionById(trans[i].id),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsPage(trans[i])));
                      },
                      leading: Icon(Icons.attach_money,
                          color: Theme.of(context).primaryColor),
                      title: Text(trans[i].description +
                          ' - \$' +
                          trans[i].amount.toString()),
                      subtitle: Text(trans[i].currentDate),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                    )));
          }),
    );
  }
}
