import 'package:flutter/material.dart';
import 'package:personalmoney/bloc/transactions_bloc.dart';

class CurrencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrencyPageState();
  }
}

class _CurrencyPageState extends State<CurrencyPage> {
  final streamTransaction = new TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Personal Money'),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(children: <Widget>[
            Text(
              'Convertidor de Divisas',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            CurrencyExchangeForm(),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Container(
                child: Text('Convertir'),
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.teal,
              textColor: Colors.white,
              onPressed: () {},
            )
          ]),
        ),
      ),
    );
  }

  doConvertion() async {}
}

class CurrencyExchangeForm extends StatefulWidget {
  CurrencyExchangeForm({Key key}) : super(key: key);

  @override
  _CurrencyExchangeFormState createState() => _CurrencyExchangeFormState();
}

class _CurrencyExchangeFormState extends State<CurrencyExchangeForm> {
  final _formKey = GlobalKey<FormState>();
  final descriptionField = TextEditingController();

  String dropdownValue = 'Peso Dominicano';
  String dropdownValueTwo = 'Peso Dominicano';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  labelText: 'Monto/Cantidad',
                  border: OutlineInputBorder(),
                  hintText: 'Monto a convertir'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese un monto/cantidad valido';
                }
                return null;
              },
              controller: descriptionField,
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Center(
                child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.teal),
                    underline: Container(
                      height: 2,
                      color: Colors.teal,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Dolar Estadounidense',
                      'Euro',
                      'Libra Esterlina',
                      'Peso Dominicano'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList())),
          ),
          SizedBox(height: 25.0),
          Center(
            child: OutlineButton(
              onPressed: () {
                // if (_formKey.currentState.validate()) {
                //   // Process data.
                // }
              },
              textColor: Theme.of(context).primaryColor,
              child: Icon(Icons.sync_alt),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Center(
                child: DropdownButton<String>(
                    value: dropdownValueTwo,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.teal),
                    underline: Container(
                      height: 2,
                      color: Colors.teal,
                    ),
                    onChanged: (String newValueTwo) {
                      setState(() {
                        dropdownValueTwo = newValueTwo;
                      });
                    },
                    items: <String>[
                      'Dolar Estadounidense',
                      'Euro',
                      'Libra Esterlina',
                      'Peso Dominicano'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList())),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
                child: Column(
              children: [
                Text('Resultado', style: TextStyle(fontSize: 14.0)),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '0.00',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
