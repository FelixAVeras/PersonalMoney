import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';
import 'package:personalmoney/models/transactionmodel.dart';

// class DashboardPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardPageState();
//   }
// }

// class _DashboardPageState extends State<DashboardPage> {
//   @override
//   Widget build(BuildContext context) {

//   }
// }

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        _customAppBackGround(context),
        SizedBox(height: 10.0, width: double.infinity),
        _dashboardData(context)
      ],
    )));
  }

  //BackGround App
  Widget _customAppBackGround(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundApp = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(26, 188, 156, 1.0),
        Color.fromRGBO(26, 188, 156, 1.0)
      ])),
    );

    return Stack(
      children: [
        backgroundApp,
        Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Text('\$ 46,598.36',
                  style: TextStyle(color: Colors.white, fontSize: 30.0)),
              SizedBox(height: 10.0, width: double.infinity),
              Text('Ultima Trans.',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
              Text('05-Feb-2021 - \$ 1,450.00',
                  style: TextStyle(color: Colors.white, fontSize: 18.0))
            ],
          ),
        )
      ],
    );
  }

  Widget _dashboardData(BuildContext context) {
    // return Text('Hola Felix');
    // return HistoryPage();
    final transactionBloc = new TransactionsBloc();

    return StreamBuilder<List<TransactionModel>>(
      stream: transactionBloc.transactionStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<TransactionModel>> snapshot) {
        // if (!snapshot.hasData) {
        //   return Center(child: CircularProgressIndicator());
        // }

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
