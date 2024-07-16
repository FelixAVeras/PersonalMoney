// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:personalmoney/models/CategoryModel.dart';
// import 'package:personalmoney/models/TransactionModel.dart';
// import 'package:personalmoney/models/imprevistoModel.dart';
// import 'package:sqflite/sqflite.dart'; // Import your TransactionModel

// class SQLHelper {
//   static Database? _db;
  
//   final _transactionController = StreamController<List<TransactionModel>>.broadcast();
//   final _imprevistoController = StreamController<List<ImprevistoModel>>.broadcast();

//   Stream<List<TransactionModel>> get transactionsStream => _transactionController.stream;
//   Stream<List<ImprevistoModel>> get imprevistosStream => _imprevistoController.stream;

//   Future<Database> get db async {
//     _db ??= await initDB();
//     return _db!;
//   }

//   Future<Database> initDB() async {
//     String path = join(await getDatabasesPath(), 'expenses_database.db');
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   void _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE categories (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         description TEXT
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE transactions (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         category_id INTEGER,
//         amount REAL NOT NULL,
//         date TEXT,
//         FOREIGN KEY (category_id) REFERENCES categories (id)
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE imprevistos (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         description TEXT NOT NULL,
//         amount REAL NOT NULL,
//         date TEXT
//       )
//     ''');

//     // Insert fixed categories for 50-30-20 model
//     await db.execute('''
//       INSERT INTO categories (name, description)
//       VALUES ('Needs', 'Essential expenses like housing, food, etc.')
//     ''');

//     await db.execute('''
//       INSERT INTO categories (name, description)
//       VALUES ('Wants', 'Expenses on entertainment, leisure, etc.')
//     ''');

//     await db.execute('''
//       INSERT INTO categories (name, description)
//       VALUES ('Savings', 'Savings and investments for future financial security.')
//     ''');
//   }

//   Future<int> insertCategory(CategoryModel category) async {
//     Database dbClient = await db;
//     int id = await dbClient.insert('categories', category.toMap());
//     return id;
//   }

//   Future<int> insertTransaction(TransactionModel transaction) async {
//     Database dbClient = await db;
//     int id = await dbClient.insert('transactions', transaction.toMap());
//     _transactionController.sink.add(await getTransactions()); // Emit updated list of transactions
//     return id;
//   }

//   Future<List<CategoryModel>> getFixedCategories() async {
//     Database dbClient = await db;
//     List<Map<String, dynamic>> maps = await dbClient.query(
//       'categories',
//       where: 'name IN (?, ?, ?)',
//       whereArgs: ['Needs', 'Wants', 'Savings'],
//     );
//     return List.generate(maps.length, (i) {
//       return CategoryModel(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//         description: maps[i]['description'],
//       );
//     });
//   }

//   Future<List<TransactionModel>> getTransactions() async {
//     Database dbClient = await db;
//     List<Map<String, dynamic>> maps = await dbClient.query('transactions');
//     return List.generate(maps.length, (i) {
//       return TransactionModel(
//         id: maps[i]['id'],
//         categoryId: maps[i]['category_id'],
//         amount: maps[i]['amount'],
//         date: maps[i]['date'],
//       );
//     });
//   }

//   Future<int> insertImprevisto(ImprevistoModel imprevisto) async {
//     Database dbClient = await db;
//     int id = await dbClient.insert('imprevistos', imprevisto.toMap());
//     _imprevistoController.sink.add(await getImprevistos()); // Emit updated list of imprevistos
//     return id;
//   }

//   Future<int> updateImprevisto(ImprevistoModel imprevisto) async {
//     Database dbClient = await db;
//     int id = await dbClient.update(
//       'imprevistos',
//       imprevisto.toMap(),
//       where: 'id = ?',
//       whereArgs: [imprevisto.id],
//     );
//     _imprevistoController.sink.add(await getImprevistos()); // Emit updated list of imprevistos
//     return id;
//   }

//   Future<int> deleteImprevisto(int id) async {
//     Database dbClient = await db;
//     int result = await dbClient.delete(
//       'imprevistos',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     _imprevistoController.sink.add(await getImprevistos()); // Emit updated list of imprevistos
//     return result;
//   }

//   Future<List<ImprevistoModel>> getImprevistos() async {
//     Database dbClient = await db;
//     List<Map<String, dynamic>> maps = await dbClient.query('imprevistos');
//     return List.generate(maps.length, (i) {
//       return ImprevistoModel(
//         id: maps[i]['id'],
//         description: maps[i]['description'],
//         amount: maps[i]['amount'],
//         date: maps[i]['date'],
//       );
//     });
//   }

//   void dispose() {
//     _transactionController.close();
//   }
// }

import 'dart:async';
import 'package:path/path.dart';
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/models/imprevistoModel.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Database? _db;
  
  final _transactionController = StreamController<List<TransactionModel>>.broadcast();
  final _imprevistoController = StreamController<List<ImprevistoModel>>.broadcast();

  Stream<List<TransactionModel>> get transactionsStream => _transactionController.stream;
  Stream<List<ImprevistoModel>> get imprevistosStream => _imprevistoController.stream;

  Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'expenses_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        amount REAL NOT NULL,
        date TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE imprevistos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT
      )
    ''');

    // Insert fixed categories for 50-30-20 model
    await db.execute('''
      INSERT INTO categories (name, description)
      VALUES ('Needs', 'Essential expenses like housing, food, etc.')
    ''');

    await db.execute('''
      INSERT INTO categories (name, description)
      VALUES ('Wants', 'Expenses on entertainment, leisure, etc.')
    ''');

    await db.execute('''
      INSERT INTO categories (name, description)
      VALUES ('Savings', 'Savings and investments for future financial security.')
    ''');
  }

  Future<int> insertCategory(CategoryModel category) async {
    Database dbClient = await db;
    int id = await dbClient.insert('categories', category.toMap());
    return id;
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    Database dbClient = await db;
    int id = await dbClient.insert('transactions', transaction.toMap());
    _transactionController.sink.add(await getTransactions()); // Emit updated list of transactions
    return id;
  }

  Future<List<CategoryModel>> getFixedCategories() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      'categories',
      where: 'name IN (?, ?, ?)',
      whereArgs: ['Needs', 'Wants', 'Savings'],
    );
    return List.generate(maps.length, (i) {
      return CategoryModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  Future<List<TransactionModel>> getTransactions() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('transactions');
    return List.generate(maps.length, (i) {
      return TransactionModel(
        id: maps[i]['id'],
        categoryId: maps[i]['category_id'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }

  Future<int> insertImprevisto(ImprevistoModel imprevisto) async {
    Database dbClient = await db;
    int id = await dbClient.insert('imprevistos', imprevisto.toMap());
    _imprevistoController.sink.add(await getImprevistos()); // Emit updated list of imprevistos
    return id;
  }

  Future<int> updateImprevisto(ImprevistoModel imprevisto) async {
    Database dbClient = await db;
    int id = await dbClient.update(
      'imprevistos',
      imprevisto.toMap(),
      where: 'id = ?',
      whereArgs: [imprevisto.id],
    );
    _imprevistoController.sink.add(await getImprevistos()); // Emit updated list of imprevistos
    return id;
  }

  Future<int> deleteImprevisto(int id) async {
    Database dbClient = await db;
    int result = await dbClient.delete(
      'imprevistos',
      where: 'id = ?',
      whereArgs: [id],
    );
    _imprevistoController.sink.add(await getImprevistos()); // Emit updated list of imprevistos
    return result;
  }

  Future<List<ImprevistoModel>> getImprevistos() async {
    Database dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query('imprevistos');
    return List.generate(maps.length, (i) {
      return ImprevistoModel(
        id: maps[i]['id'],
        description: maps[i]['description'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }

  void addImprevistosToStream() async {
    final imprevistos = await getImprevistos();
    _imprevistoController.sink.add(imprevistos);
  }

  void dispose() {
    _transactionController.close();
    _imprevistoController.close();
  }
}
