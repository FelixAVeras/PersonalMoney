import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/pages/addBudgetPage.dart';

class BudgetPage extends StatefulWidget {
  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  SQLHelper _sqlHelper = SQLHelper();

  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;

  List<Map<String, dynamic>> needsExpenses = [];
  List<Map<String, dynamic>> wantsExpenses = [];
  List<Map<String, dynamic>> savingsExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    needsExpenses = await _sqlHelper.getExpensesByCategory(1);  // Necesidades
    wantsExpenses = await _sqlHelper.getExpensesByCategory(2);  // Deseos
    savingsExpenses = await _sqlHelper.getExpensesByCategory(3); // Ahorros

    setState(() {});
  }

  String formatAmount(double amount) {
    final format = NumberFormat("#,##0.00", "en_US");
    return format.format(amount);
  }

  String formatDate(String datetime) {
    DateTime date = DateTime.parse(datetime);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Presupuestos'),
        elevation: 2,
        scrolledUnderElevation: 4,
        centerTitle: false,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money_rounded, size: 50.0, color: Colors.teal,),
                title: const Text('RD\$ 95,487.69', style: TextStyle(fontSize: 18.0)),
                subtitle: const Text('Ingreso Principal', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'Editar Monto', 
                  onPressed: () {},
                  splashColor: Colors.teal[200],
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 10.0),
            const Text('Desglose de Gastos', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 10.0),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if (index == 0) isExpanded1 = !isExpanded1;
                  if (index == 1) isExpanded2 = !isExpanded2;
                  if (index == 2) isExpanded3 = !isExpanded3;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('Necesidades (50%)'),
                    );
                  },
                  body: Column(
                    children: needsExpenses.map((expense) {
                      return FutureBuilder(
                        future: _sqlHelper.getSubcategoryNameById(expense['subcategory_id']), // Aquí llamamos a la función desde SqlHelper
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return ListTile(
                              title: Text('Monto: RD\$ ${formatAmount(expense['amount'])}'),
                              subtitle: Text(
                                  'Fecha: ${formatDate(expense['datetime'])} | Subcategoría: ${snapshot.data}'),
                            );
                          } else {
                            return ListTile(
                              title: Text('Cargando...'),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                  isExpanded: isExpanded1,
                  canTapOnHeader: true,
                ),
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) =>
                      ListTile(title: Text('Deseos (30%)')),
                  body: Column(
                    children: wantsExpenses.map((expense) {
                      return FutureBuilder(
                        future: _sqlHelper.getSubcategoryNameById(expense['subcategory_id']), // Aquí llamamos a la función desde SqlHelper
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return ListTile(
                              title: Text('Monto: RD\$ ${formatAmount(expense['amount'])}'),
                              subtitle: Text(
                                  'Fecha: ${formatDate(expense['datetime'])} | Subcategoría: ${snapshot.data}'),
                            );
                          } else {
                            return ListTile(
                              title: Text('Cargando...'),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                  isExpanded: isExpanded2,
                ),
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) =>
                      ListTile(title: Text('Ahorros (20%)')),
                  body: Column(
                    children: savingsExpenses.map((expense) {
                      return FutureBuilder(
                        future: _sqlHelper.getSubcategoryNameById(expense['subcategory_id']), // Aquí llamamos a la función desde SqlHelper
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return ListTile(
                              title: Text('Monto: RD\$ ${formatAmount(expense['amount'])}'),
                              subtitle: Text(
                                  'Fecha: ${formatDate(expense['datetime'])} | Subcategoría: ${snapshot.data}'),
                            );
                          } else {
                            return ListTile(
                              title: Text('Cargando...'),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                  isExpanded: isExpanded3,
                ),
              ],
              elevation: 2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpensePage())),
        child: Icon(Icons.add_rounded),
        tooltip: 'Agregar monto',
        elevation: 2,
        backgroundColor: Colors.teal,
      ),
    );
  }
}