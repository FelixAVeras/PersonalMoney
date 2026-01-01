import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnackHelper.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/models/DebtsModel.dart';

class AddDebtsPage extends StatefulWidget {
  @override
  State<AddDebtsPage> createState() => _AddDebtsPageState();
}

class _AddDebtsPageState extends State<AddDebtsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final SQLHelper sqlHelper = SQLHelper();
  // final FormatHelper formatHelper = FormatHelper();
  // final BudgetService budgetService = BudgetService();

  Future<bool> _saveDebt() async {
    try {
      final String desc = _descriptionController.text;
      final double? amount = double.tryParse(_amountController.text);

      if (amount == null) return false;

      // Creamos el objeto Debt (el ID es null porque es autoincrement)
      final newDebt = DebtModel(
        description: desc,
        totalAmount: amount,
        createdAt: DateTime.now().toIso8601String(),
        isSettled: 0,
      );

      // Llamamos al método que creamos en el DatabaseHelper
      await sqlHelper.insertDebt(newDebt);
      return true;
    } catch (e) {
      print("Error al guardar deuda: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(
        // title: Text(AppLocalizations.of(context)!.budget),
        title: Text('Agregar Deuda'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: const Icon(Icons.title),
                  labelText: 'Descripcion',
                  hintText: 'Ej. Préstamo Hipotecario',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty)
                        // ? AppLocalizations.of(context)!.emptyDescriptionMsg
                        ? 'La descripcion no puede estar vacia'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  icon: const Icon(Icons.attach_money_rounded),
                  labelText: 'Monto Prestado',
                  hintText: '0.00',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'El monto es obligatorio';
                  if (double.tryParse(v) == null) return 'Ingresa un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 64),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await _saveDebt();
                      
                      if (mounted) {
                        if (success) {
                          SnackHelper.showMessage(context, 'Deuda guardada correctamente');
                          
                          Navigator.pop(context, true);
                        } else {
                          SnackHelper.showMessage(context, 'Error al guardar la deuda');
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF78c2ad),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.save_alt),
                  label: Text(
                    AppLocalizations.of(context)!.btnSaveChanges,
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}