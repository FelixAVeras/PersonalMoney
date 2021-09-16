import 'package:flutter/material.dart';
import 'package:personalmoney/models/transactionmodel.dart';
import 'package:personalmoney/pages/detailtransaction.dart';

class TransList extends StatelessWidget {
  final List<TransactionModel> trans;
  TransList({Key key, this.trans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: trans == null ? 0 : trans.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: trans[index].transType == 'earning'
                ? Icon(
                    Icons.attach_money,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.money_off,
                    color: Colors.red,
                  ),
            title: Text(trans[index].description),
            subtitle: Text(trans[index].amount.toString() +
                ' - ' +
                trans[index].currentDate),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsPage(trans[index])),
              );
            },
          );
        });
  }
}
