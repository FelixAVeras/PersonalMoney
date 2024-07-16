import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personalmoney/helpers/DbHelper.dart';
import 'package:personalmoney/models/imprevistoModel.dart';

enum SampleItem { itemOne, itemTwo }

class ImprevistosPage extends StatefulWidget {
  @override
  _ImprevistosPageState createState() => _ImprevistosPageState();
}

class _ImprevistosPageState extends State<ImprevistosPage> {
  final SQLHelper _sqlHelper = SQLHelper();
  late Stream<List<ImprevistoModel>> _imprevistosStream;
  List<ImprevistoModel> _imprevistos = [];

  @override
  void initState() {
    super.initState();
    _imprevistosStream = _sqlHelper.imprevistosStream;
    
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      List<ImprevistoModel> imprevistos = await _sqlHelper.getImprevistos();
      setState(() {
        _imprevistos = imprevistos;
      });
    } catch (e) {
      print('Error loading imprevistos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones Rápidas', style: TextStyle(fontSize: 24.0, color: Colors.teal, fontWeight: FontWeight.w600)),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddImprevistoDialog,
        child: Icon(Icons.add_rounded, color: Colors.white),
        backgroundColor: Colors.teal.shade300,
      ),
    );
  }

  Widget _buildBody() {
    if (_imprevistos.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return _buildImprevistosList();
    }
  }

  Widget _buildImprevistosList() {
    return ListView.builder(
      itemCount: _imprevistos.length,
      itemBuilder: (context, index) {
        final imprevisto = _imprevistos[index];
        final formatDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(imprevisto.date));

        return ListTile(
          title: Text(imprevisto.description + ' - \$${imprevisto.amount}'),
          subtitle: Text('Fecha: $formatDate'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: 'Editar',
                onPressed: () => _showEditImprevistoDialog(imprevisto),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Eliminar',
                onPressed: () => _deleteImprevisto(imprevisto.id!),
              ),
            ],
          ),
          // trailing: PopupMenuButton (
          //   onSelected: (value) => _handlePopupMenuSelection(value, context, imprevisto.id as ImprevistoModel),
          //   itemBuilder: (context) => [
          //     const PopupMenuItem(value: 'edit', child: Text('Editar')),
          //     const PopupMenuItem(value: 'delete', child: Text('Eliminar'))
          //   ],
          // ),
        );
      },
    );
  }

  // void _handlePopupMenuSelection(String value, BuildContext context, ImprevistoModel model) {
  //   switch (value) {
  //     case 'edit':
  //       _showEditImprevistoDialog(model);
  //       break;
  //     case 'delete':
  //       _deleteImprevisto(model.id!);
  //       break;
  //   }
  // }



  Future<void> _showAddImprevistoDialog() async {
    await _showImprevistoDialog();
  }

  Future<void> _showEditImprevistoDialog(ImprevistoModel imprevisto) async {
    await _showImprevistoDialog(imprevisto: imprevisto);
  }

  Future<void> _showImprevistoDialog({ImprevistoModel? imprevisto}) async {
    final _descriptionController = TextEditingController(text: imprevisto?.description);
    final _amountController = TextEditingController(text: imprevisto?.amount.toString());
    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(imprevisto == null ? 'Agregar Imprevisto' : 'Editar Imprevisto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un monto';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor ingrese un monto válido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final description = _descriptionController.text;
                  final amount = double.parse(_amountController.text);
                  final date = DateTime.now().toIso8601String();

                  if (imprevisto == null) {
                    await _sqlHelper.insertImprevisto(ImprevistoModel(
                      description: description,
                      amount: amount,
                      date: date,
                    ));

                    _fetchInitialData();
                  } else {
                    await _sqlHelper.updateImprevisto(ImprevistoModel(
                      id: imprevisto.id,
                      description: description,
                      amount: amount,
                      date: date,
                    ));
                  }

                  Navigator.of(context).pop();

                  _fetchInitialData();
                }
              },
              child: Text(imprevisto == null ? 'AGREGAR' : 'ACTUALIZAR'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteImprevisto(int id) async {
    await _sqlHelper.deleteImprevisto(id);
    setState(() {
      _imprevistos.removeWhere((imprevisto) => imprevisto.id == id);
    });
  }

  @override
  void dispose() {
    _sqlHelper.dispose();
    super.dispose();
  }
}
