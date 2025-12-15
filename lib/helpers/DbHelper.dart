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
    await db.insert('categories', {'name': 'Auto', 'description': ''});
    await db.insert('categories', {'name': 'Health & Wellness', 'description': ''});
    await db.insert('categories', {'name': 'Shopping', 'description': ''});
    await db.insert('categories', {'name': 'Education', 'description': ''});
    await db.insert('categories', {'name': 'Utilities', 'description': ''});
    await db.insert('categories', {'name': 'Charity', 'description': ''});
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

  Future<int> updateTransaction(TransactionModel t) async {
    final dbClient = await db();

    return await dbClient.update(
      'transactions',
      t.toMap(),
      where: 'id = ?',
      whereArgs: [t.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<int> deleteTransaction(int id) async {
    final dbClient = await db();

    return await dbClient.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
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
  // static Future<void> addSpentToBudget(int categoryId, int month, int year, double value) async {
  //   final dbClient = await db();
  //   await dbClient.rawUpdate('''
  //     UPDATE budgets SET spent = spent + ? WHERE category_id = ? AND month = ? AND year = ?
  //   ''', [value, categoryId, month, year]);
  // }

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

  // static Future<void> addSpentToMonthlyBalance(int month, int year, double value) async {
  //   final dbClient = await db();
  //   final mb = await getMonthlyBalance(month, year);
  //   if (mb == null) {
  //     // create new
  //     await insertMonthlyBalance(MonthlyBalanceModel(
  //       initialBalance: 0,
  //       spent: value,
  //       month: month,
  //       year: year,
  //     ));
  //   } else {
  //     await dbClient.rawUpdate('''
  //       UPDATE monthly_balance SET spent = spent + ? WHERE id = ?
  //     ''', [value, mb.id]);
  //   }
  // }

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
  // Future<int> updateBudget(BudgetModel budget) async {
  //   final Database dbClient = await db();
  //   // Asegúrate que toMap use las claves correctas: 'category_id','amount','spent','month','year'
  //   final data = {
  //     'category_id': budget.categoryId,
  //     'amount': budget.amount,
  //     'spent': budget.spent,
  //     'month': budget.month,
  //     'year': budget.year,
  //   };

  //   return await dbClient.update(
  //     'budgets',
  //     data,
  //     where: 'id = ?',
  //     whereArgs: [budget.id],
  //   );
  // }

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

  Future<double> getTotalMonthlyBudget(int month, int year) async {
    final dbClient = await db();

    final result = await dbClient.rawQuery(
      '''
      SELECT SUM(amount) AS total
      FROM budgets
      WHERE month = ? AND year = ?
      ''',
      [month, year],
    );

    final value = result.first['total'];

    if (value == null) return 0.0;
    if (value is int) return value.toDouble();

    return value as double;
  }

  Future<List<Map<String, dynamic>>> getCategorySpending(int month, int year) async {
    final dbClient = await db();

    final result = await dbClient.rawQuery('''
      SELECT c.name AS category, SUM(t.amount) AS total
      FROM transactions t
      INNER JOIN categories c ON t.category_id = c.id
      WHERE t.transType = 'Expense' AND t.month = ? AND t.year = ?
      GROUP BY t.category_id
    ''', [month, year]);

    return result;
  }

  Future<void> addSpentToBudget(int categoryId, int month, int year, double amount) async {
    final dbClient = await db();

    await dbClient.rawUpdate('''
      UPDATE budgets
      SET spent = spent + ?
      WHERE category_id = ? AND month = ? AND year = ?
    ''', [amount, categoryId, month, year]);
  }

  Future<void> subtractSpentFromBudget(int categoryId, int month, int year, double amount) async {
    final dbClient = await db();

    await dbClient.rawUpdate('''
      UPDATE budgets
      SET spent = MAX(spent - ?, 0)
      WHERE category_id = ? AND month = ? AND year = ?
    ''', [amount, categoryId, month, year]);
  }

  Future<void> addSpentToMonthlyBalance(int month, int year, double amount) async {
    final dbClient = await db();

    await dbClient.rawUpdate('''
      UPDATE monthly_balance
      SET spent = spent + ?
      WHERE month = ? AND year = ?
    ''', [amount, month, year]);
  }

  Future<void> subtractSpentFromMonthlyBalance(int month, int year, double amount) async {
    final dbClient = await db();

    await dbClient.rawUpdate('''
      UPDATE monthly_balances
      SET spent = MAX(spent - ?, 0)
      WHERE month = ? AND year = ?
    ''', [amount, month, year]);
  }

  // Future<BudgetModel?> getBudgetByCategoryMonth(int categoryId, int month, int year) async {
  //   final dbClient = await db();
  //   final result = await dbClient.query(
  //     'budgets',
  //     where: 'category_id = ? AND month = ? AND year = ?',
  //     whereArgs: [categoryId, month, year],
  //   );

  //   if (result.isEmpty) return null;
  //   return BudgetModel.fromMap(result.first);
  // }

  Future<void> updateBudget(BudgetModel model) async {
    final dbClient = await db();

    await dbClient.update(
      'budgets',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<Map<String, dynamic>?> getLastTransaction() async {
    final dbClient = await db();

    final result = await dbClient.query(
      'transactions',
      orderBy: 'date DESC',
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }
}
