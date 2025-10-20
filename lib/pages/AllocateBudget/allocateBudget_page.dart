import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/AlertHelper.dart';

class AllocateBudgetPage extends StatefulWidget{
  @override
  State<AllocateBudgetPage> createState() => _AllocateBudgetPageState();
}

class _AllocateBudgetPageState extends State<AllocateBudgetPage> {
  double totalAmount = 0.0;
  double needsAmount = 0.0;
  double wantsAmount = 0.0;
  double savingsAmount = 0.0;

  TextEditingController _incomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distribuir Presupuesto'),
        actions: [
          IconButton(onPressed: () {
            DialogHelper.infoDialog(
              context: context,
              title: 'Distribución de Presupuesto',
              message: 'Aquí puedes distribuir tu presupuesto entre diferentes categorías. Este sistema esta diseñado para ayudarte a gestionar mejor tus finanzas y asegurarte de que no gastas más de lo que tienes en cada área utilizando el sistema 50-30-20.'
            );
          }, 
          icon: Icon(Icons.info_outline))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFormField(
              controller: _incomeController,
              decoration: InputDecoration(
                labelText: 'Ingreso Mensual Promedio',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                hintText: 'Ingresa tu ingreso mensual',
              ),
            ),
            SizedBox(height: 10),
            TextButton(onPressed: () {}, child: Text('Cambiar Porcentajes')),
            Card.outlined(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Necesidades (50%)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                    SizedBox(height: 8),
                    Text('Gastos esenciales como vivienda, comida, transporte, etc.'),
                    SizedBox(height: 8),
                    Text('\$${needsAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Deseos (30%)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                    SizedBox(height: 8),
                    Text('Gastos no esenciales como entretenimiento, viajes, etc.'),
                    SizedBox(height: 8),
                    Text('\$${wantsAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Divider(),
                    Text('Futuros (20%)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 8),
                    Text('Ahorros, inversiones, pago de deudas, etc.'),
                    SizedBox(height: 8),
                    Text('\$${savingsAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_incomeController.text.isEmpty) {
                  DialogHelper.errorDialog(
                    context: context,
                    title: 'Error',
                    message: 'Por favor ingresa tu ingreso mensual.'
                  );
                  return;
                }

                totalAmount = double.tryParse(_incomeController.text) ?? 0.0;
                needsAmount = totalAmount * 0.5;
                wantsAmount = totalAmount * 0.3;
                savingsAmount = totalAmount * 0.2;

                setState(() {});
                
              },
              child: Text('Distribuir'),
            ),
          ],
        ),
      )
    );
  }

  
}