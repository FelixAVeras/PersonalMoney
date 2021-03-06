import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/models/transactionmodel.dart';

class HistoryPage extends StatelessWidget {
  final transactionBloc = new TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: transactionBloc.transactionStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final transHistory = snapshot.data;

        if (transHistory.length == 0) {
          return Center(
            child: Text('No hay datos que mostrar'),
          );
        }

        return ListView.builder(
            itemCount: transHistory.length,
            itemBuilder: (context, i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) =>
                      transactionBloc.deleteStreamById(transHistory[i].id),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                        padding: EdgeInsets.all(7),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Stack(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Column(
                                          children: [
                                            Row(children: [
                                              Text('Descriptcion: ' +
                                                  transHistory[i].description)
                                            ]),
                                            Row(children: [
                                              Text('Fecha: ' +
                                                  transHistory[i].currentDate)
                                            ])
                                          ],
                                        ))
                                  ],
                                ))
                          ],
                        )),
                  ),
                ));
      },
    );
  }
}
