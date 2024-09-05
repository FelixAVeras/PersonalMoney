import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:personalmoney/models/TransactionModel.dart';

class TransList extends StatelessWidget {
  final List<TransactionModel> trans;

  TransList({Key? key, required this.trans}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trans == null ? 0 : trans.length,
      itemBuilder: (BuildContext context, index) {
        
        return Card(
          child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: trans[index].transType == 'earning' ? Icon(Icons.attach_money, color: Colors.green): Icon(Icons.money_off, color: Colors.red,),
              title: Text(trans[index].name),
              subtitle: Text('RD\$${trans[index].amount.toString()}' + ' - ' + trans[index].date),
            ),
          ),
        );
      }
    );
  }
}
