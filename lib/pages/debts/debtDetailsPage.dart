import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart';
import 'package:personalmoney/l10n/app_localizations.dart';
import 'package:personalmoney/l10n/app_localizations_en.dart';

class DebtDetailPage extends StatefulWidget {
  final Map<String, dynamic> debt; // Pasamos los datos iniciales

  const DebtDetailPage({Key? key, required this.debt}) : super(key: key);

  @override
  State<DebtDetailPage> createState() => _DebtDetailPageState();
}

class _DebtDetailPageState extends State<DebtDetailPage> {
  final SQLHelper sqlHelper = SQLHelper();
  final FormatHelper formatHelper = FormatHelper();

  late Future<List<Map<String, dynamic>>> _paymentsFuture;
  final TextEditingController _paymentController = TextEditingController();

  Map<String, dynamic>? _currentDebt;

  void _loadDebtData() async {
    final data = await sqlHelper.getDebtWithRemainingAmount(widget.debt['id']);
    setState(() {
      _currentDebt = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshPayments();
    _loadDebtData();
  }

  void _refreshPayments() {
    setState(() {
      _paymentsFuture = sqlHelper.getPaymentsForDebt(widget.debt['id']);
    });
  }

  // Función para mostrar el diálogo de abono
  void _showAbonarDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registrar Abono"),
        content: TextField(
          controller: _paymentController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            prefixText: '\$ ',
            labelText: "Monto del abono",
            prefixIcon: Icon(Icons.attach_money),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(AppLocalizations.of(context)!.cancel)
          ),
          ElevatedButton(
            onPressed: () async {
              if (_paymentController.text.isNotEmpty) {
                double amount = double.parse(_paymentController.text);
                await sqlHelper.insertPayment(widget.debt['id'], amount);
                
                _paymentController.clear();
                
                if (mounted) Navigator.pop(context);
                
                _refreshPayments();
              }
            },
            child: const Text("Abonar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
      ? Colors.grey.shade200
      : const Color(0xFF1E1E1E),
      appBar: AppBar(title: Text(widget.debt['description'])),
      body: Column(
        children: [
          // CABECERA: Resumen de la deuda
          const SizedBox(height: 15),
          // Container(
          //   // padding: const EdgeInsets.all(100),
          //   // color: AppColors.info.withOpacity(0.1),
          //   child: Column(
          //     children: [
          //       const Text("Saldo Pendiente", style: TextStyle(fontSize: 16)),
          //       const SizedBox(height: 8),
          //       // Aquí calculamos el saldo dinámicamente si quieres, 
          //       // por ahora usamos el total_amount
          //       Text(
          //         currency.format(widget.debt['total_amount']), 
          //         style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE95420))
          //       ),
          //     ],
          //   ),
          // ),

          Column(
            children: [
              Text("Monto Original: ${formatHelper.formatAmount(widget.debt['total_amount'])}"),
              
              const SizedBox(height: 10),

              Text(
                "Saldo Actual:", 
                style: TextStyle(fontSize: 18)
              ),
              
              Text(
                formatHelper.formatAmount(widget.debt['remaining_amount']), // Este es el valor que baja
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: AppColors.danger
                )
              ),
            ],
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Historial de Pagos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          // LISTA DE ABONOS
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _paymentsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty) return const Center(child: Text("No hay abonos registrados"));

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final payment = snapshot.data![index];
                    return ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(currency.format(payment['amount'])),
                      subtitle: Text(formatHelper.formatDateWithTime(context, payment['payment_date'])),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // BOTONES DE ACCIÓN
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () { /* Lógica de Eliminar */ },
                icon: const Icon(Icons.delete),
                label: Text(AppLocalizations.of(context)!.delete),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _showAbonarDialog,
                icon: const Icon(Icons.add),
                label: const Text("Abonar"),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}