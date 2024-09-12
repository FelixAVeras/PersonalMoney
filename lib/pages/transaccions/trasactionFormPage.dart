import 'package:flutter/material.dart';

enum ExpenseType { gasto, ganancia }

enum IconLabel {
  AlquilerRenta('Alquiler'),
  Transporte('Transporte'),
  ComidaMercado('Mercado'),
  Entretenimiento('Entretenimiento'),
  Telefono('Telefono'),
  Internet('Internet'),
  Ropa('Ropa'),
  Ahorros('Ahorros'),
  Electricidad('Electricidad'),
  Agua('Agua'),
  Otros('Otros');

  const IconLabel(this.label);
  final String label;
}

class TransactionsFormPage extends StatefulWidget {
  @override
  _TransactionsFormPageState createState() => _TransactionsFormPageState();
}

class _TransactionsFormPageState extends State<TransactionsFormPage> {
  final _formKey = GlobalKey<FormState>();

  ExpenseType? _type = ExpenseType.gasto;
  String type = 'gasto';

  final TextEditingController iconController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones', style: TextStyle(color: Colors.white)),
        //centerTitle: true,
        backgroundColor: Color(0xFF78c2ad),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text('Las transacciones se guardaran con la fecha y hora actual.', 
                  style: TextStyle(fontSize: 19, 
                    fontStyle: FontStyle.italic, 
                    color: Color.fromARGB(255, 160, 159, 159)),
                ),
                SizedBox(height: 15.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descripción de la Transacción',
                    hintText: 'Ej: Compra Zapatos',
                    prefixIcon: Icon(Icons.title_rounded, color: Color(0xFF78c2ad))
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                SizedBox(height: 35.0),
                Column(
                  children: [
                    Text('Tipo Transaccion', 
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 160, 159, 159))
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: ListTile(
                          title: const Text('Gasto'),
                          leading: Radio<ExpenseType>(
                            value: ExpenseType.gasto,
                            groupValue: _type,
                            onChanged: (ExpenseType? value) {
                              setState(() {
                                _type = value;
                                // type = 'gasto';
                              });
                            },
                          ),
                        )),
                        Expanded(child: ListTile(
                          title: const Text('Ganancia'),
                          leading: Radio<ExpenseType>(
                            value: ExpenseType.ganancia,
                            groupValue: _type,
                            onChanged: (ExpenseType? value) {
                              setState(() {
                                _type = value;
                                // type = 'ganancia';
                              });
                            },
                          ),
                        ))
                      ],
                    )
                  ],
                ),
                SizedBox(height: 35.0),
                DropdownMenu<IconLabel>(
                  expandedInsets: EdgeInsets.zero,
                  //width: double.infinity,
                  controller: iconController,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  leadingIcon: const Icon(Icons.search_rounded, color: Color(0xFF78c2ad)),
                  label: Text('Categoria'),
                  dropdownMenuEntries: IconLabel.values.map<DropdownMenuEntry<IconLabel>>(
                    (IconLabel icon) {
                      return DropdownMenuEntry<IconLabel>(
                        value: icon,
                        label: icon.label,
                      );
                    }
                  ).toList(),
                ),
                SizedBox(height: 35.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Monto de la Transacción',
                    prefixIcon: Icon(Icons.money, color: Color(0xFF78c2ad))
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 55.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200,45),
                    backgroundColor: Color(0xFF78c2ad),
                  ),
                  onPressed: () {}, 
                  child: Text('Guardar', style: TextStyle(color: Colors.white))
                )
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   icon: Icon(Icons.save_alt_outlined, color: Colors.white),
      //   label: Text('Guardar', style: TextStyle(color: Colors.white)),
      //   backgroundColor: Color(0xFF78c2ad),
      //   elevation: 1,
      // ),
    );
  }
}