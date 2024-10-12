import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
// import 'package:intl/intl.dart';

class AddExpensePage extends StatefulWidget {
  // final Function(int, int, double, DateTime) onAddExpense;

  // AddExpensePage({required this.onAddExpense});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Necesidades';
  String _selectedSubcategory = 'Vivienda';
  double _amount = 0.0;

  Map<String, List<String>> _subcategories = {
    'Necesidades': ['Vivienda', 'Alimentación', 'Transporte', 'Salud', 'Educación'],
    'Deseos': ['Necesidades Secundarias', 'Entretenimiento', 'Viajes', 'Hobbies'],
    'Ahorros': ['Cubrir eventualidades', 'Fondo de emergencia', 'Pago de deudas', 'Inversiones a largo plazo'],
  };

  final SQLHelper _sqlHelper = SQLHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Gasto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para seleccionar la categoría
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categoría'),
                value: _selectedCategory,
                items: _subcategories.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _selectedSubcategory = _subcategories[_selectedCategory]![0];
                  });
                },
              ),
              SizedBox(height: 20),
              // Campo para seleccionar la subcategoría
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Subcategoría'),
                value: _selectedSubcategory,
                items: _subcategories[_selectedCategory]!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategory = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              // Campo para ingresar el monto
              TextFormField(
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un monto';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    DateTime now = DateTime.now();

                    await _sqlHelper.insertExpense(
                      _getCategoryId(_selectedCategory),
                      _getSubcategoryId(_selectedSubcategory),
                      _amount,
                      now 
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para obtener el ID de la categoría
  int _getCategoryId(String category) {
    switch (category) {
      case 'Necesidades':
        return 1;
      case 'Deseos':
        return 2;
      case 'Ahorros':
        return 3;
      default:
        return 0;
    }
  }

  // Método para obtener el ID de la subcategoría
  int _getSubcategoryId(String subcategory) {
    Map<String, int> subcategoryIds = {
      'Vivienda': 1,
      'Alimentación': 2,
      'Transporte': 3,
      'Salud': 4,
      'Educación': 5,
      'Necesidades Secundarias': 6,
      'Entretenimiento': 7,
      'Viajes': 8,
      'Hobbies': 9,
      'Cubrir eventualidades': 10,
      'Fondo de emergencia': 11,
      'Pago de deudas': 12,
      'Inversiones a largo plazo': 13,
    };
    return subcategoryIds[subcategory] ?? 0;
  }
}
