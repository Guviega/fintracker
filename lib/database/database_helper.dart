import 'package:fintracker/database/monthly_dashboard_data.dart';
import 'package:fintracker/model/category.dart';
import 'package:fintracker/model/expense.dart';
import 'package:fintracker/model/income.dart';
import 'package:fintracker/model/payment_method.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const _databaseName = 'fintracker.db';

  Future<Database>? _databaseFuture;

  Future<Database> get database {
    final currentDatabase = _databaseFuture;
    if (currentDatabase != null) return currentDatabase;

    final newDatabase = _initializeDatabase();
    _databaseFuture = newDatabase;
    return newDatabase;
  }

  Future<Database> _initializeDatabase() async {
    try {
      final databasePath = path.join(await getDatabasesPath(), _databaseName);

      return await openDatabase(
        databasePath,
        onConfigure: _configureDatabase,
        onCreate: _createDatabase,
      );
    } catch (_) {
      _databaseFuture = null;
      rethrow;
    }
  }

  Future<void> _configureDatabase(Database database) async {
    await database.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDatabase(Database database, int version) async {
    await database.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL COLLATE NOCASE UNIQUE,
        CHECK (length(trim(name)) BETWEEN 1 AND 20)
      )
    ''');

    await database.execute('''
      CREATE TABLE incomes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        source TEXT NOT NULL,
        date TEXT NOT NULL,
        amount_cents INTEGER NOT NULL CHECK (amount_cents > 0)
      )
    ''');

    await database.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        amount_cents INTEGER NOT NULL CHECK (amount_cents > 0),
        payment_method TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
          ON UPDATE CASCADE ON DELETE RESTRICT
      )
    ''');

    await database.execute('CREATE INDEX incomes_date_index ON incomes (date)');
    await database.execute(
      'CREATE INDEX expenses_date_index ON expenses (date)',
    );
    await database.execute(
      'CREATE INDEX expenses_category_index ON expenses (category_id)',
    );

    await _insertInitialData(database);
  }

  Future<void> _insertInitialData(Database database) async {
    final categoryIds = <String, int>{};
    for (final name in [
      'Transport',
      'Food',
      'Essentials',
      'Investments',
      'Schooling',
    ]) {
      categoryIds[name] = await database.insert('categories', {'name': name});
    }
  }

  Future<List<Category>> getCategories() async {
    final rows = await (await database).query(
      'categories',
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return rows.map(_categoryFromRow).toList();
  }

  Future<int> getCategoryCount() async {
    final rows = await (await database).rawQuery(
      'SELECT COUNT(*) AS count FROM categories',
    );
    return (rows.single['count'] as num).toInt();
  }

  Future<bool> isCategoryNameAvailable(
    String name, {
    int? excludingCategoryId,
  }) async {
    final rows = await (await database).query(
      'categories',
      columns: ['id'],
      where: excludingCategoryId == null ? 'name = ?' : 'name = ? AND id != ?',
      whereArgs: excludingCategoryId == null
          ? [name.trim()]
          : [name.trim(), excludingCategoryId],
      limit: 1,
    );
    return rows.isEmpty;
  }

  Future<int> insertCategory(Category category) async {
    return (await database).insert('categories', _categoryToMap(category));
  }

  Future<int> updateCategory(Category category) async {
    final id = _requiredId(category.id, 'category');
    return (await database).update(
      'categories',
      _categoryToMap(category),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> deleteCategory(int id) async {
    final db = await database;
    return db.transaction((transaction) async {
      final linkedExpenses = await transaction.query(
        'expenses',
        columns: ['id'],
        where: 'category_id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (linkedExpenses.isNotEmpty) return false;

      return await transaction.delete(
            'categories',
            where: 'id = ?',
            whereArgs: [id],
          ) >
          0;
    });
  }

  Future<List<Income>> getIncomes() async {
    final rows = await (await database).query(
      'incomes',
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(_incomeFromRow).toList();
  }

  Future<List<Income>> getIncomesByMonth(DateTime month) async {
    final rows = await (await database).query(
      'incomes',
      where: 'date >= ? AND date < ?',
      whereArgs: _monthRange(month),
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(_incomeFromRow).toList();
  }

  Future<int> insertIncome(Income income) async {
    return (await database).insert('incomes', _incomeToMap(income));
  }

  Future<int> updateIncome(Income income) async {
    final id = _requiredId(income.id, 'income');
    return (await database).update(
      'incomes',
      _incomeToMap(income),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteIncome(int id) async {
    return (await database).delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Expense>> getExpenses() async {
    final rows = await (await database).rawQuery('''
      SELECT
        expenses.id,
        expenses.description,
        expenses.date,
        expenses.amount_cents,
        expenses.payment_method,
        categories.id AS category_id,
        categories.name AS category_name
      FROM expenses
      INNER JOIN categories ON categories.id = expenses.category_id
      ORDER BY expenses.date DESC, expenses.id DESC
    ''');
    return rows.map(_expenseFromRow).toList();
  }

  Future<List<Expense>> getExpensesByMonth(DateTime month) async {
    final rows = await (await database).rawQuery('''
        SELECT
          expenses.id,
          expenses.description,
          expenses.date,
          expenses.amount_cents,
          expenses.payment_method,
          categories.id AS category_id,
          categories.name AS category_name
        FROM expenses
        INNER JOIN categories ON categories.id = expenses.category_id
        WHERE expenses.date >= ? AND expenses.date < ?
        ORDER BY expenses.date DESC, expenses.id DESC
      ''', _monthRange(month));
    return rows.map(_expenseFromRow).toList();
  }

  Future<int> insertExpense(Expense expense) async {
    return (await database).insert('expenses', _expenseToMap(expense));
  }

  Future<int> updateExpense(Expense expense) async {
    final id = _requiredId(expense.id, 'expense');
    return (await database).update(
      'expenses',
      _expenseToMap(expense),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    return (await database).delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<DateTime>> getAvailableMonths() async {
    final rows = await (await database).rawQuery('''
      SELECT DISTINCT substr(date, 1, 7) AS month
      FROM (
        SELECT date FROM incomes
        UNION ALL
        SELECT date FROM expenses
      )
      ORDER BY month DESC
    ''');

    final months = <String, DateTime>{};
    for (final row in rows) {
      final parts = (row['month'] as String).split('-');
      final month = DateTime(int.parse(parts[0]), int.parse(parts[1]));
      months[_monthKey(month)] = month;
    }

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    months[_monthKey(currentMonth)] = currentMonth;

    return months.values.toList()..sort((a, b) => b.compareTo(a));
  }

  Future<double> getTotalExpensesByMonth(DateTime month) async {
    return _getMonthlyAmount('expenses', month);
  }

  Future<double> getTotalExpenses() async => _getTotalAmount('expenses');

  Future<double> getTotalIncomeByMonth(DateTime month) async {
    return _getMonthlyAmount('incomes', month);
  }

  Future<double> getTotalIncome() async => _getTotalAmount('incomes');

  Future<double> getTotalResult() async {
    final income = await getTotalIncome();
    final expenses = await getTotalExpenses();
    return income - expenses;
  }

  Future<double> getTotalResultByMonth(DateTime month) async {
    final income = await getTotalIncomeByMonth(month);
    final expenses = await getTotalExpensesByMonth(month);
    return income - expenses;
  }

  Future<Map<PaymentMethod, double>> getExpenseTotalsByPaymentMethod(
    DateTime month,
  ) async {
    final rows = await (await database).rawQuery('''
        SELECT payment_method, SUM(amount_cents) AS total_cents
        FROM expenses
        WHERE date >= ? AND date < ?
        GROUP BY payment_method
      ''', _monthRange(month));

    return {
      for (final row in rows)
        _paymentMethodFromValue(row['payment_method'] as String):
            _amountFromCents(row['total_cents'] as num),
    };
  }

  Future<Map<String, double>> getExpenseTotalsByCategory(DateTime month) async {
    final rows = await (await database).rawQuery('''
        SELECT categories.name AS category_name,
               SUM(expenses.amount_cents) AS total_cents
        FROM expenses
        INNER JOIN categories ON categories.id = expenses.category_id
        WHERE expenses.date >= ? AND expenses.date < ?
        GROUP BY categories.id, categories.name
      ''', _monthRange(month));

    return {
      for (final row in rows)
        row['category_name'] as String: _amountFromCents(
          row['total_cents'] as num,
        ),
    };
  }

  Future<MonthlyDashboardData> getDashboardData(DateTime month) async {
    final availableMonths = await getAvailableMonths();
    final totalIncome = await getTotalIncomeByMonth(month);
    final totalExpenses = await getTotalExpensesByMonth(month);
    final totalsByPaymentMethod = await getExpenseTotalsByPaymentMethod(month);
    final totalsByCategory = await getExpenseTotalsByCategory(month);

    return MonthlyDashboardData(
      availableMonths: availableMonths,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      totalResult: totalIncome - totalExpenses,
      expenseTotalsByPaymentMethod: totalsByPaymentMethod,
      expenseTotalsByCategory: totalsByCategory,
    );
  }

  Future<void> close() async {
    final currentDatabase = _databaseFuture;
    if (currentDatabase == null) return;

    await (await currentDatabase).close();
    _databaseFuture = null;
  }

  Future<double> _getMonthlyAmount(String table, DateTime month) async {
    final rows = await (await database).rawQuery('''
        SELECT COALESCE(SUM(amount_cents), 0) AS total_cents
        FROM $table
        WHERE date >= ? AND date < ?
      ''', _monthRange(month));
    return _amountFromCents(rows.single['total_cents'] as num);
  }

  Future<double> _getTotalAmount(String table) async {
    final rows = await (await database).rawQuery(
      'SELECT COALESCE(SUM(amount_cents), 0) AS total_cents FROM $table',
    );
    return _amountFromCents(rows.single['total_cents'] as num);
  }

  List<String> _monthRange(DateTime month) => [
    _formatDate(DateTime(month.year, month.month)),
    _formatDate(DateTime(month.year, month.month + 1)),
  ];

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  DateTime _parseDate(String date) {
    final parts = date.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  String _monthKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';

  int _amountInCents(double amount) => (amount * 100).round();

  double _amountFromCents(num cents) => cents.toInt() / 100;

  int _requiredId(int? id, String entity) {
    if (id == null) throw ArgumentError('$entity must have a database id.');
    return id;
  }

  Map<String, Object?> _categoryToMap(Category category) => {
    'name': category.name.trim(),
  };

  Category _categoryFromRow(Map<String, Object?> row) =>
      Category(row['name'] as String, id: row['id'] as int);

  Map<String, Object?> _incomeToMap(Income income) => {
    'description': income.description.trim(),
    'source': income.source.trim(),
    'date': _formatDate(income.date),
    'amount_cents': _amountInCents(income.value),
  };

  Income _incomeFromRow(Map<String, Object?> row) => Income(
    id: row['id'] as int,
    description: row['description'] as String,
    source: row['source'] as String,
    date: _parseDate(row['date'] as String),
    value: _amountFromCents(row['amount_cents'] as num),
  );

  Map<String, Object?> _expenseToMap(Expense expense, {int? categoryId}) {
    final resolvedCategoryId = categoryId ?? expense.category.id;
    if (resolvedCategoryId == null) {
      throw ArgumentError('Expense category must have a database id.');
    }

    return {
      'description': expense.description.trim(),
      'date': _formatDate(expense.date),
      'amount_cents': _amountInCents(expense.value),
      'payment_method': expense.paymentMethod.name,
      'category_id': resolvedCategoryId,
    };
  }

  Expense _expenseFromRow(Map<String, Object?> row) => Expense(
    id: row['id'] as int,
    description: row['description'] as String,
    date: _parseDate(row['date'] as String),
    value: _amountFromCents(row['amount_cents'] as num),
    paymentMethod: _paymentMethodFromValue(row['payment_method'] as String),
    category: Category(
      row['category_name'] as String,
      id: row['category_id'] as int,
    ),
  );

  PaymentMethod _paymentMethodFromValue(String value) =>
      PaymentMethod.values.firstWhere(
        (method) => method.name == value,
        orElse: () => PaymentMethod.OTHER,
      );
}
