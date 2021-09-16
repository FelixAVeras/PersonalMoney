// import 'dart:async';

// import 'package:personalmoney/helpers/databasehelper.dart';

// class TransactionsBloc {
//   static final TransactionsBloc _singelton = new TransactionsBloc._internal();

//   factory TransactionsBloc() {
//     return _singelton;
//   }

//   TransactionsBloc._internal() {
//     getAllStreams();
//   }

//   final _transactionStreamController =
//       StreamController<List<TransactionModel>>.broadcast();

//   Stream<List<TransactionModel>> get transactionStream =>
//       _transactionStreamController.stream;

//   dispose() {
//     _transactionStreamController?.close();
//   }

//   getAllStreams() async {
//     _transactionStreamController.sink
//         .add(await DatabaseHelper.db.getAllTransactions());
//   }

//   addStream(TransactionModel transactionModel) async {
//     await DatabaseHelper.db.createTransaction(transactionModel);
//     getAllStreams();
//   }

//   deleteStreamById(int id) async {
//     await DatabaseHelper.db.deleteTransactionById(id);
//     getAllStreams();
//   }

//   deleteAllStreams() async {
//     await DatabaseHelper.db.deleteAllTransactions();
//     getAllStreams();
//   }
// }
