import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                  child: InkWell(
                child: Container(
                    width: 350,
                    height: 80,
                    child: Column(children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Balance Actual',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              'RD\$ 3,628.59',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ])),
              )),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Card(
                            child: InkWell(
                                splashColor: Colors.teal,
                                onTap: () {},
                                child: Container(
                                    width: 350,
                                    height: 80,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Ganancias',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.teal),
                                        ),
                                        Text(
                                          'RD\$ 4,000.00',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ],
                                    ))))),
                    Expanded(
                        child: Card(
                            child: InkWell(
                                splashColor: Colors.red[300],
                                onTap: () {},
                                child: Container(
                                    width: 350,
                                    height: 80,
                                    child: Column(
                                      children: <Widget>[
                                        Text('Gastos',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red[300])),
                                        Text(
                                          'RD\$ 371.41',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ],
                                    ))))),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: InkWell(
              child: Container(
                  width: 350,
                  height: 160,
                  child: Column(children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Column(children: <Widget>[
                          Text(
                            'Última Transacción',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Almuerzo en McDonalds',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'RD\$ 371.41',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Fecha de Transacción: 10-Mar-2020',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ]))
                  ])),
            )),
          ),
        ],
      ),
    );
  }
}
