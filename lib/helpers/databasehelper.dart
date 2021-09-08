import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personalmoney/models/transactionmodel.dart';
export 'package:personalmoney/models/transactionmodel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database _database;
  static final DatabaseHelper db = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'PersonalMoneyDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE transactions ('
          'id INTEGER PRIMARY KEY,'
          'description TEXT,'
          'currentDate TEXT,'
          'amount REAL,'
          'type TEXT'
          ')');
    });
  }

  Future<int> countTotal() async {
    final Database db = await database;
    final int sumEarning = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT SUM(amount) FROM transactions WHERE type = "earning"'));
    final int sumExpense = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT SUM(amount) FROM transactions WHERE type = "expense"'));
    return ((sumEarning == null ? 0 : sumEarning) -
        (sumExpense == null ? 0 : sumExpense));
  }

  // Get All transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final result = await db.query('transactions');

    List<TransactionModel> transactionList = result.isNotEmpty
        ? result.map((tm) => TransactionModel.fromJson(tm)).toList()
        : [];

    return transactionList;
  }

  // Get transaction by ID
  Future<TransactionModel> getTransactionByID(int id) async {
    final db = await database;
    final result =
        await db.query('transactions', where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty ? TransactionModel.fromJson(result.first) : null;
  }

  // Create new transaction
  createTransaction(TransactionModel transactionModel) async {
    final db = await database;
    final result = await db.insert('transactions', transactionModel.toJson());

    return result;
  }

  // Update transaction
  Future<int> updateTransaction(TransactionModel transactionModel) async {
    final db = await database;
    final result = await db.update('transactions', transactionModel.toJson(),
        where: 'id = ?', whereArgs: [transactionModel.id]);

    return result;
  }

  // Delete transaction by ID
  Future<int> deleteTransactionById(int id) async {
    final db = await database;
    final result =
        await db.delete('transactions', where: 'id = ?', whereArgs: [id]);

    return result;
  }

  // Delete all transaction
  Future<int> deleteAllTransactions() async {
    final db = await database;
    final result = await db.rawDelete('DELETE FROM transactions');

    return result;
  }
}
