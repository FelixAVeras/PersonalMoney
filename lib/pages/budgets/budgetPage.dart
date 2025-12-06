import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Budget'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: MediaQuery.of(context).size.width, // FORZAR ANCHO COMPLETO
            child: DataTable(
              columnSpacing: 40, // Ajusta el espacio entre columnas
              columns: <DataColumn>[
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Budget')),
              ],
              rows: <DataRow>[
                DataRow(cells: [
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Elemento')),
                  DataCell(Text('Elemento')),
                ])
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.teal,
        elevation: 2,
        tooltip: 'Add budget',
        child: Icon(Icons.add),
      ),
    );

  }
}