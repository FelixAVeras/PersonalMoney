import 'package:flutter/material.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/helpers/SnakcHelper.dart';
import 'package:personalmoney/helpers/formatHelper.dart';
import 'package:personalmoney/models/TransactionModel.dart';

class DetailTransactionPage extends StatefulWidget {
  final TransactionModel transaction;

  const DetailTransactionPage({required this.transaction, super.key});

  @override
  State<DetailTransactionPage> createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  SQLHelper _sqlHelper = SQLHelper();
  FormatHelper formatHelper = FormatHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Detail Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            // elevation: 3,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(12), // Bordes suaves
            // ),
            // color: Colors.white, // Fondo blanco limpio
            // shadowColor: Colors.black26, // Sombra sutil
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nombre de la transacción
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.transaction.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          widget.transaction.categoryName.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    )
                  ),

                  const Divider(color: Colors.black87,),

                  // Monto
                  Text(
                    formatHelper.formatAmount(widget.transaction.amount),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),

                  // Tipo
                  Text(
                    widget.transaction.transType,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.transaction.transType == 'income'
                          ? Colors.green[700]
                          : Colors.red[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Fecha
                  Text(
                    formatHelper.formatDate(widget.transaction.date.toString()),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),

                  const SizedBox(height: 10),
                  const Divider(color: Colors.black87,),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange,
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {},
                          icon: Icon(Icons.delete),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
