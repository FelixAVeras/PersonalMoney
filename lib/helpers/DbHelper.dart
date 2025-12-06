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
        name TEXT NOT NULL,
        category_id INTEGER,
        amount REAL NOT NULL,
        date TEXT,
        type TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        subcategory_id INTEGER,
        amount REAL NOT NULL,
        datetime TEXT
      )
    ''');

    // Insertar categorías fijas para el modelo 50-30-20
    // await db.execute('''
    //   INSERT INTO categories (name, description)
    //   VALUES ('Needs', 'Essential expenses like housing, food, etc.')
    // ''');

    // await db.execute('''
    //   INSERT INTO categories (name, description)
    //   VALUES ('Wants', 'Expenses on entertainment, leisure, etc.')
    // ''');

    // await db.execute('''
    //   INSERT INTO categories (name, description)
    //   VALUES ('Savings', 'Savings and investments for future financial security.')
    // ''');
    await db.execute('''
      INSERT INTO categories (name)
      VALUES ('Home'), 
      ('Entertainment'),
      ('Food'),
      ('Charity'),
      ('Utilities'),
      ('Auto'),
      ('Education'),
      ('Health & Wellness'),
      ('Shopping'),
      ('Others')
    ''');
  }

  Future<int> insertCategory(CategoryModel category) async {
    Database dbClient = await db;
    return await dbClient.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CategoryModel>> getCategories() async {
    Database dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('categories');
    
    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  } 

  Future<int> insertTransaction(TransactionModel transaction) async {
    Database dbClient = await db;
    int id = await dbClient.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    _transactionController.sink.add(await getTransactions()); // Emit updated list of transactions
    
    return id;
  }

  // Future<List<TransactionModel>> getTransactions() async {
  //   Database dbClient = await db;
  //   final List<Map<String, dynamic>> maps = await dbClient.query('transactions');
    
  //   return List.generate(maps.length, (i) {
  //     return TransactionModel.fromMap(maps[i]);
  //   });
  // }

  Future<int> insertImprevisto(ImprevistoModel imprevisto) async {
    Database dbClient = await db;
    int id = await dbClient.insert('imprevistos', imprevisto.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
    final List<Map<String, dynamic>> maps = await dbClient.query('imprevistos');
    
    return List.generate(maps.length, (i) {
      return ImprevistoModel.fromMap(maps[i]);
    });
  }

  Future<int> insertExpense(int categoryId, int subcategoryId, double amount, DateTime datetime) async {
    final Database dbClient = await db;
    
    Map<String, dynamic> expense = {
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'amount': amount,
      'datetime': datetime.toIso8601String(),
    };
    
    return await dbClient.insert('expenses', expense);
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory(int categoryId) async {
    final Database dbClient = await db;

    return await dbClient.query(
      'expenses',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<String> getSubcategoryName(int subcategoryId) async {
    final Database dbClient = await db;
    var result = await dbClient.query(
      'subcategories',
      where: 'id = ?',
      whereArgs: [subcategoryId],
    );

    if (result.isNotEmpty) {
      return result.first['name'] as String;
    } else {
      return 'Desconocida';
    }
  }

  Future<String> getSubcategoryNameById(int subcategoryId) async {
    switch (subcategoryId) {
      case 1:
        return 'Vivienda';
      case 2:
        return 'Alimentación';
      case 3:
        return 'Transporte';
      case 4:
        return 'Salud';
      case 5:
        return 'Educación';
      case 6:
        return 'Necesidades Secundarias';
      case 7:
        return 'Entretenimiento';
      case 8:
        return 'Viajes';
      case 9:
        return 'Hobbies';
      case 10:
        return 'Cubrir eventualidades';
      case 11:
        return 'Fondo de emergencia';
      case 12:
        return 'Pago de deudas';
      case 13:
        return 'Inversiones a largo plazo';
      default:
        return 'Categoría desconocida';
    }
  }

  void addImprevistosToStream() async {
    final imprevistos = await getImprevistos();
    _imprevistoController.sink.add(imprevistos);
  }

  // Transactions
  Future<List<TransactionModel>> trans() async {
    // final Database db = await database;
    final Database dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient.query('transactions');

    return List.generate(maps.length, (i) {
      return TransactionModel(
        id: maps[i]['id'],
        date: maps[i]['date'],
        name: maps[i]['name'],
        transType: maps[i]['type'],
        amount: maps[i]['amount'],
      );
    });
  }

  Future<int> countTotal() async {
    final Database dbClient = await db;

    final int? sumEarning = Sqflite
        .firstIntValue(await dbClient.rawQuery('SELECT SUM(amount) FROM transactions WHERE type = "earning"'));
    
    final int? sumExpense = Sqflite
        .firstIntValue(await dbClient.rawQuery('SELECT SUM(amount) FROM transactions WHERE type = "expense"'));
    
    return ((sumEarning  == null? 0: sumEarning) - (sumExpense == null? 0: sumExpense));
  }

  Future<void> updateTrans(TransactionModel trans) async {
    final Database dbClient = await db;

    await dbClient.update(
      'transactions',
      trans.toMap(),
      where: "id = ?",
      whereArgs: [trans.id],
    );
  }

  Future<void> deleteTrans(int id) async {
    final Database dbClient = await db;

    await dbClient.delete(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
  
  Future<List<TransactionModel>> getTransactions() async {
    final Database dbClient = await db;

    final List<Map<String, dynamic>> maps = await dbClient.rawQuery('''
      SELECT t.*, c.name as category_name
      FROM transactions t
      LEFT JOIN categories c ON c.id = t.category_id
      ORDER BY t.date DESC
    ''');

    return maps.map((map) {
      return TransactionModel.fromMap({
        ...map,
        "category_name": map["category_name"],
      });
    }).toList();
  }

  void dispose() {
    _transactionController.close();
    _imprevistoController.close();
  }
}