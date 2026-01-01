import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/helpers/theme/appColorsTheme.dart'; // Para formatear moneda y fecha

class DebtCard extends StatelessWidget {
  final String description;
  final String amount;
  final String createdAt;
  final VoidCallback onTap;

  const DebtCard({
    Key? key,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormatHelper formatHelper = FormatHelper();
    DateTime date = DateTime.parse(createdAt);

    return Card.outlined(
      child: InkWell(
        onTap: onTap, // Navegará a la pantalla 3 (Detalle)
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(amount, style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w800)),
          subtitle: Text("${description} - ${formatHelper.formatDate(context, date.toString())}", style: TextStyle(fontWeight: FontWeight.bold, ),),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          // isThreeLine: true,
        ),
      ),
    );
  }
}