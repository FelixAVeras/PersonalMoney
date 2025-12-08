// import 'dart:async';

// import 'package:path/path.dart';
// import 'package:personalmoney/models/CategoryModel.dart';
// import 'package:personalmoney/models/TransactionModel.dart';
// import 'package:personalmoney/models/budgetModel.dart';
// import 'package:personalmoney/models/imprevistoModel.dart';
// import 'package:sqflite/sqflite.dart';

// class SQLHelper {
//   static Database? _db;
  
//   final _transactionController = StreamController<List<TransactionModel>>.broadcast();
//   final _imprevistoController = StreamController<List<ImprevistoModel>>.broadcast();

//   Stream<List<TransactionModel>> get transactionsStream => _transactionController.stream;

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
//         name TEXT NOT NULL,
//         category_id INTEGER,
//         amount REAL NOT NULL,
//         date TEXT,
//         type TEXT,
//         month INTEGER,
//         year INTEGER,
//         FOREIGN KEY (category_id) REFERENCES categories (id)
//       )
//     ''');

//     await db.execute('''
//       CREATE TABLE expenses (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         category_id INTEGER,
//         subcategory_id INTEGER,
//         amount REAL NOT NULL,
//         datetime TEXT
//       )
//     ''');

//     // Insertar categorías fijas para el modelo 50-30-20
//     // await db.execute('''
//     //   INSERT INTO categories (name, description)
//     //   VALUES ('Needs', 'Essential expenses like housing, food, etc.')
//     // ''');

//     // await db.execute('''
//     //   INSERT INTO categories (name, description)
//     //   VALUES ('Wants', 'Expenses on entertainment, leisure, etc.')
//     // ''');

//     // await db.execute('''
//     //   INSERT INTO categories (name, description)
//     //   VALUES ('Savings', 'Savings and investments for future financial security.')
//     // ''');
//     await db.execute('''
//       INSERT INTO categories (name)
//       VALUES ('Home'), 
//       ('Entertainment'),
//       ('Food'),
//       ('Charity'),
//       ('Utilities'),
//       ('Auto'),
//       ('Education'),
//       ('Health & Wellness'),
//       ('Shopping'),
//       ('Others')
//     ''');

//     await db.execute('''
//       CREATE TABLE budgets (
//         id INTEGER PRIMARY KEY AUTOINCREMENT
//         category_id INTEGER NOT NULL
//         amount REAL NOT NULL
//         spent REAL NOT NULL
//         month INTEGER NOT NULL
//         year INTEGER NOT NULL
//       );
//     ''');
    
//     await db.execute('''
//       CREATE TABLE monthly_balance (
//         id INTEGER PRIMARY KEY AUTOINCREMENT
//         initial_balance REAL NOT NULL
//         spent REAL NOT NULL
//         left REAL NOT NULL
//         month INTEGER NOT NULL
//         year INTEGER NOT NULL
//       );
//     ''');
//   }

//   Future<int> insertCategory(CategoryModel category) async {
//     Database dbClient = await db;
//     return await dbClient.insert('categories', category.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<CategoryModel>> getCategories() async {
//     Database dbClient = await db;
//     final List<Map<String, dynamic>> maps = await dbClient.query('categories');
    
//     return List.generate(maps.length, (i) {
//       return CategoryModel.fromMap(maps[i]);
//     });
//   } 

//   Future<int> insertTransaction(TransactionModel transaction) async {
//     Database dbClient = await db;
//     int id = await dbClient.insert('transactions', transaction.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     _transactionController.sink.add(await getTransactions()); // Emit updated list of transactions
    
//     return id;
//   }

//   // Future<List<TransactionModel>> getTransactions() async {
//   //   Database dbClient = await db;
//   //   final List<Map<String, dynamic>> maps = await dbClient.query('transactions');
    
//   //   return List.generate(maps.length, (i) {
//   //     return TransactionModel.fromMap(maps[i]);
//   //   });
//   // }

//   Future<int> insertImprevisto(ImprevistoModel imprevisto) async {
//     Database dbClient = await db;
//     int id = await dbClient.insert('imprevistos', imprevisto.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
//     final List<Map<String, dynamic>> maps = await dbClient.query('imprevistos');
    
//     return List.generate(maps.length, (i) {
//       return ImprevistoModel.fromMap(maps[i]);
//     });
//   }

//   Future<int> insertExpense(int categoryId, int subcategoryId, double amount, DateTime datetime) async {
//     final Database dbClient = await db;
    
//     Map<String, dynamic> expense = {
//       'category_id': categoryId,
//       'subcategory_id': subcategoryId,
//       'amount': amount,
//       'datetime': datetime.toIso8601String(),
//     };
    
//     return await dbClient.insert('expenses', expense);
//   }

//   Future<List<Map<String, dynamic>>> getExpensesByCategory(int categoryId) async {
//     final Database dbClient = await db;

//     return await dbClient.query(
//       'expenses',
//       where: 'category_id = ?',
//       whereArgs: [categoryId],
//     );
//   }

//   Future<String> getSubcategoryName(int subcategoryId) async {
//     final Database dbClient = await db;
//     var result = await dbClient.query(
//       'subcategories',
//       where: 'id = ?',
//       whereArgs: [subcategoryId],
//     );

//     if (result.isNotEmpty) {
//       return result.first['name'] as String;
//     } else {
//       return 'Desconocida';
//     }
//   }

//   Future<String> getSubcategoryNameById(int subcategoryId) async {
//     switch (subcategoryId) {
//       case 1:
//         return 'Vivienda';
//       case 2:
//         return 'Alimentación';
//       case 3:
//         return 'Transporte';
//       case 4:
//         return 'Salud';
//       case 5:
//         return 'Educación';
//       case 6:
//         return 'Necesidades Secundarias';
//       case 7:
//         return 'Entretenimiento';
//       case 8:
//         return 'Viajes';
//       case 9:
//         return 'Hobbies';
//       case 10:
//         return 'Cubrir eventualidades';
//       case 11:
//         return 'Fondo de emergencia';
//       case 12:
//         return 'Pago de deudas';
//       case 13:
//         return 'Inversiones a largo plazo';
//       default:
//         return 'Categoría desconocida';
//     }
//   }

//   void addImprevistosToStream() async {
//     final imprevistos = await getImprevistos();
//     _imprevistoController.sink.add(imprevistos);
//   }

//   // Transactions
//   Future<List<TransactionModel>> trans() async {
//     // final Database db = await database;
//     final Database dbClient = await db;

//     final List<Map<String, dynamic>> maps = await dbClient.query('transactions');

//     return List.generate(maps.length, (i) {
//       return TransactionModel(
//         id: maps[i]['id'],
//         date: maps[i]['date'],
//         name: maps[i]['name'],
//         transType: maps[i]['type'],
//         amount: maps[i]['amount'],
//       );
//     });
//   }

//   Future<int> countTotal() async {
//     final Database dbClient = await db;

//     final int? sumEarning = Sqflite
//         .firstIntValue(await dbClient.rawQuery('SELECT SUM(amount) FROM transactions WHERE type = "earning"'));
    
//     final int? sumExpense = Sqflite
//         .firstIntValue(await dbClient.rawQuery('SELECT SUM(amount) FROM transactions WHERE type = "expense"'));
    
//     return ((sumEarning  == null? 0: sumEarning) - (sumExpense == null? 0: sumExpense));
//   }

//   Future<void> updateTrans(TransactionModel trans) async {
//     final Database dbClient = await db;

//     await dbClient.update(
//       'transactions',
//       trans.toMap(),
//       where: "id = ?",
//       whereArgs: [trans.id],
//     );
//   }

//   Future<void> deleteTrans(int id) async {
//     final Database dbClient = await db;

//     await dbClient.delete(
//       'transactions',
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
  
//   Future<List<TransactionModel>> getTransactions() async {
//     final Database dbClient = await db;

//     final List<Map<String, dynamic>> maps = await dbClient.rawQuery('''
//       SELECT t.*, c.name as category_name
//       FROM transactions t
//       LEFT JOIN categories c ON c.id = t.category_id
//       ORDER BY t.date DESC
//     ''');

//     return maps.map((map) {
//       return TransactionModel.fromMap({
//         ...map,
//         "category_name": map["category_name"],
//       });
//     }).toList();
//   }

//   Future<int> insertBudget(BudgetModel budget) async {
//     final Database dbClient = await db;

//     return await dbClient.rawInsert(
//       '''
//       INSERT INTO budgets (category_id, amount, spent)
//       VALUES (?, ?, ?)
//       ''',
//       [budget.categoryId, budget.amount, budget.spent],
//     );
//   }

//   Future<int> updateBudget(BudgetModel budget) async {
//     final Database dbClient = await db;

//     return await dbClient.rawUpdate(
//       '''
//       UPDATE budgets
//       SET category_id = ?, amount = ?, spent = ?
//       WHERE id = ?
//       ''',
//       [
//         budget.categoryId,
//         budget.amount,
//         budget.spent,
//         budget.id,
//       ],
//     );
//   }

//   Future<int> deleteBudget(int id) async {
//     final Database dbClient = await db;

//     return await dbClient.rawDelete(
//       '''
//       DELETE FROM budgets
//       WHERE id = ?
//       ''',
//       [id],
//     );
//   }

//   Future<List<BudgetModel>> getBudgets() async {
//     final Database dbClient = await db;

//     final res = await dbClient.rawQuery('SELECT * FROM budgets');

//     return res.map((e) => BudgetModel.fromMap(e)).toList();
//   }

//   Future<BudgetModel?> getBudgetById(int id) async {
//     final Database dbClient = await db;

//     final res = await dbClient.rawQuery(
//       '''
//       SELECT * FROM budgets
//       WHERE id = ?
//       ''',
//       [id],
//     );

//     if (res.isNotEmpty) {
//       return BudgetModel.fromMap(res.first);
//     }
//     return null;
//   }

//   Future<BudgetModel?> getBudgetByCategory(int categoryId) async {
//     final Database dbClient = await db;

//     final res = await dbClient.rawQuery(
//       '''
//       SELECT * FROM budgets
//       WHERE category_id = ?
//       ''',
//       [categoryId],
//     );

//     if (res.isNotEmpty) {
//       return BudgetModel.fromMap(res.first);
//     }
//     return null;
//   }

//   Future<List<Map<String, dynamic>>> getBudgetOverview() async {
//     final Database dbClient = await db;

//     return await dbClient.rawQuery('''
//       SELECT 
//         c.name AS category_name,
//         b.amount,
//         b.spent
//       FROM budgets b
//       INNER JOIN categories c ON b.category_id = c.id
//       ORDER BY c.name ASC
//     ''');
//   }


//   void dispose() {
//     _transactionController.close();
//     _imprevistoController.close();
//   }
// }

// helpers/sql_helper.dart
import 'package:personalmoney/models/CategoryModel.dart';
import 'package:personalmoney/models/MonthlyBalanceModel.dart';
import 'package:personalmoney/models/TransactionModel.dart';
import 'package:personalmoney/models/budgetModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLHelper {
  static Database? _db;
  static const _dbName = 'personal_money.db';
  static const _dbVersion = 1;

  static Future<Database> db() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    // categories (ya tenías algo similar)
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      );
    ''');

    // transactions (añadimos month/year)
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        category_id INTEGER,
        type TEXT,
        date TEXT,
        month INTEGER,
        year INTEGER,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      );
    ''');

    // budgets: por categoría y mes
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        spent REAL NOT NULL DEFAULT 0,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      );
    ''');

    // monthly_balance: única fila por mes
    await db.execute('''
      CREATE TABLE monthly_balance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        initial_balance REAL NOT NULL,
        spent REAL NOT NULL DEFAULT 0,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL
      );
    ''');

    // seed categorías básicas (opcional)
    await db.insert('categories', {'name': 'Home', 'description': ''});
    await db.insert('categories', {'name': 'Entertainment', 'description': ''});
    await db.insert('categories', {'name': 'Food', 'description': ''});
    await db.insert('categories', {'name': 'Transport', 'description': ''});
    await db.insert('categories', {'name': 'Health', 'description': ''});
    await db.insert('categories', {'name': 'Others', 'description': ''});
  }

  // -------------------------
  // Transactions
  // -------------------------
  Future<int> insertTransaction(TransactionModel t) async {
    final dbClient = await db();
    final id = await dbClient.insert('transactions', t.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<TransactionModel>> getTransactions({int? month, int? year}) async {
    final dbClient = await db();
    List<Map<String, dynamic>> maps;

    if (month != null && year != null) {
      maps = await dbClient.rawQuery('''
        SELECT t.*, c.name as category_name
        FROM transactions t
        LEFT JOIN categories c ON c.id = t.category_id
        WHERE t.month = ? AND t.year = ?
        ORDER BY t.date DESC
      ''', [month, year]);
    } else {
      maps = await dbClient.rawQuery('''
        SELECT t.*, c.name as category_name
        FROM transactions t
        LEFT JOIN categories c ON c.id = t.category_id
        ORDER BY t.date DESC
      ''');
    }

    return maps.map((m) => TransactionModel.fromMap(m)).toList();
  }

  // -------------------------
  // Budgets
  // -------------------------
  static Future<int> insertBudget(BudgetModel b) async {
    final dbClient = await db();
    return await dbClient.rawInsert('''
      INSERT INTO budgets (category_id, amount, spent, month, year)
      VALUES (?, ?, ?, ?, ?)
    ''', [b.categoryId, b.amount, b.spent, b.month, b.year]);
  }

  // static Future<int> updateBudget(BudgetModel b) async {
  //   final dbClient = await db();
  //   return await dbClient.rawUpdate('''
  //     UPDATE budgets SET amount = ?, spent = ? WHERE id = ?
  //   ''', [b.amount, b.spent, b.id]);
  // }

  static Future<int> deleteBudget(int id) async {
    final dbClient = await db();
    return await dbClient.rawDelete('DELETE FROM budgets WHERE id = ?', [id]);
  }

  static Future<List<Map<String, dynamic>>> getBudgetsWithCategoryName(int month, int year) async {
    final dbClient = await db();
    return await dbClient.rawQuery('''
      SELECT b.*, c.name as category_name
      FROM budgets b
      LEFT JOIN categories c ON c.id = b.category_id
      WHERE b.month = ? AND b.year = ?
      ORDER BY c.name ASC
    ''', [month, year]);
  }

  // static Future<BudgetModel?> getBudgetByCategoryMonth(int categoryId, int month, int year) async {
  //   final dbClient = await db();
  //   final res = await dbClient.rawQuery('''
  //     SELECT * FROM budgets WHERE category_id = ? AND month = ? AND year = ?
  //   ''', [categoryId, month, year]);

  //   if (res.isEmpty) return null;
  //   return BudgetModel.fromMap(res.first);
  // }

  // add spent to budget (increment spent)
  static Future<void> addSpentToBudget(int categoryId, int month, int year, double value) async {
    final dbClient = await db();
    await dbClient.rawUpdate('''
      UPDATE budgets SET spent = spent + ? WHERE category_id = ? AND month = ? AND year = ?
    ''', [value, categoryId, month, year]);
  }

  // -------------------------
  // Monthly balance
  // -------------------------
  static Future<MonthlyBalanceModel?> getMonthlyBalance(int month, int year) async {
    final dbClient = await db();
    final res = await dbClient.rawQuery('''
      SELECT * FROM monthly_balance WHERE month = ? AND year = ?
    ''', [month, year]);

    if (res.isEmpty) return null;
    return MonthlyBalanceModel.fromMap(res.first);
  }

  static Future<int> insertMonthlyBalance(MonthlyBalanceModel m) async {
    final dbClient = await db();
    return await dbClient.rawInsert('''
      INSERT INTO monthly_balance (initial_balance, spent, month, year)
      VALUES (?, ?, ?, ?)
    ''', [m.initialBalance, m.spent, m.month, m.year]);
  }

  static Future<int> updateMonthlyBalance(MonthlyBalanceModel m) async {
    final dbClient = await db();
    return await dbClient.rawUpdate('''
      UPDATE monthly_balance SET initial_balance = ?, spent = ? WHERE id = ?
    ''', [m.initialBalance, m.spent, m.id]);
  }

  static Future<void> addSpentToMonthlyBalance(int month, int year, double value) async {
    final dbClient = await db();
    final mb = await getMonthlyBalance(month, year);
    if (mb == null) {
      // create new
      await insertMonthlyBalance(MonthlyBalanceModel(
        initialBalance: 0,
        spent: value,
        month: month,
        year: year,
      ));
    } else {
      await dbClient.rawUpdate('''
        UPDATE monthly_balance SET spent = spent + ? WHERE id = ?
      ''', [value, mb.id]);
    }
  }

  // -------------------------
  // Overview helpers
  // -------------------------
  static Future<Map<String, dynamic>> getOverviewTotals(int month, int year) async {
    final dbClient = await db();

    // total spent (from budgets.spent)
    final spentRes = await dbClient.rawQuery('''
      SELECT SUM(spent) as total_spent FROM budgets WHERE month = ? AND year = ?
    ''', [month, year]);

    double totalSpent = 0;
    if (spentRes.isNotEmpty && spentRes.first['total_spent'] != null) {
      totalSpent = (spentRes.first['total_spent'] as num).toDouble();
    }

    final mb = await getMonthlyBalance(month, year);
    final initial = mb?.initialBalance ?? 0;
    final left = initial - totalSpent;

    return {
      'initial': initial,
      'spent': totalSpent,
      'left': left,
    };
  }

  // -------------------------
  // Misc
  // -------------------------
  // static Future<List<Map<String, dynamic>>> getCategories() async {
  //   final dbClient = await db();
  //   return await dbClient.query('categories', orderBy: 'name ASC');
  // }

  Future<List<CategoryModel>> getCategories() async {
    Database dbClient = await db();
    final List<Map<String, dynamic>> maps = await dbClient.query('categories');
    
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }


  // dentro de class SQLHelper { ... }

  /// Devuelve el BudgetModel para una categoría en el mes/año actual.
  /// Retorna null si no existe.
  Future<BudgetModel?> getBudgetByCategory(int categoryId) async {
    final Database dbClient = await db();
    final now = DateTime.now();
    final month = now.month;
    final year = now.year;

    final res = await dbClient.rawQuery('''
      SELECT * FROM budgets
      WHERE category_id = ? AND month = ? AND year = ?
      LIMIT 1
    ''', [categoryId, month, year]);

    if (res.isEmpty) return null;
    return BudgetModel.fromMap(res.first);
  }

  /// Variante que permite buscar por category + month + year explicitos
  Future<BudgetModel?> getBudgetByCategoryMonth(int categoryId, int month, int year) async {
    final Database dbClient = await db();
    final res = await dbClient.rawQuery('''
      SELECT * FROM budgets
      WHERE category_id = ? AND month = ? AND year = ?
      LIMIT 1
    ''', [categoryId, month, year]);

    if (res.isEmpty) return null;
    return BudgetModel.fromMap(res.first);
  }

  /// Actualiza el registro de budget (por id). Retorna el número de filas afectadas.
  Future<int> updateBudget(BudgetModel budget) async {
    final Database dbClient = await db();
    // Asegúrate que toMap use las claves correctas: 'category_id','amount','spent','month','year'
    final data = {
      'category_id': budget.categoryId,
      'amount': budget.amount,
      'spent': budget.spent,
      'month': budget.month,
      'year': budget.year,
    };

    return await dbClient.update(
      'budgets',
      data,
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<List<Map<String, dynamic>>> getOverviewData() async {
    // Obtenemos la instancia de la base de datos
    Database dbClient = await db(); // Recuerda que db es una función que devuelve Future<Database>

    // Consulta: traer categorías con el monto asignado y el gasto total
    final List<Map<String, dynamic>> result = await dbClient.rawQuery('''
      SELECT 
        c.id AS category_id,
        c.name AS category_name,
        IFNULL(budget.amount, 0) AS amount,
        IFNULL(SUM(t.amount), 0) AS spent
      FROM categories c
      LEFT JOIN budgets budget ON budget.category_id = c.id
      LEFT JOIN transactions t ON t.category_id = c.id
      GROUP BY c.id, c.name, budget.amount
    ''');

    return result;
  }
}
