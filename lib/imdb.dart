import 'package:fintracker/model/category.dart';
import 'package:fintracker/model/expense.dart';
import 'package:fintracker/model/income.dart';
import 'package:fintracker/model/payment_method.dart';

class Imdb {
  static var incomeList = <Income>{};
  static var expensesList = <Expense>{};
  static var categoryList = <Category>{};

  static void runInitialData() {
    incomeList.add(Income(description: "Salary",
        source: "Company",
        date: DateTime(2026, 11, 13),
        value: 1620));
    incomeList.add(Income(description: "Freelance",
        source: "Customer Adam",
        date: DateTime.utc(2026, 10, 13),
        value: 829.90));
    incomeList.add(Income(description: "Donation",
        source: "Mother",
        date: DateTime(2026, 11, 12),
        value: 200));

    categoryList.add(Category("Transport"));
    categoryList.add(Category("Food"));
    categoryList.add(Category("Essentials"));
    categoryList.add(Category("Investments"));
    categoryList.add(Category("Schooling"));


    expensesList.add(Expense(description: "Gas",
        date: DateTime(2026, 11, 13),
        value: 100,
        paymentMethod: PaymentMethod.CREDIT_CARD,
        category: categoryList.elementAt(0)));
    expensesList.add(Expense(description: "Lunch",
        date: DateTime(2026, 11, 13),
        value: 19.90,
        paymentMethod: PaymentMethod.CREDIT_CARD,
        category: categoryList.elementAt(1)));
    expensesList.add(Expense(description: "Car Washing",
        date: DateTime(2026, 11, 13),
        value: 80,
        paymentMethod: PaymentMethod.MONEY,
        category: categoryList.elementAt(2)));
    expensesList.add(Expense(description: "Monthly Invest",
        date: DateTime(2026, 11, 13),
        value: 120,
        paymentMethod: PaymentMethod.PIX,
        category: categoryList.elementAt(3)));
    expensesList.add(Expense(description: "Flutter Course",
        date: DateTime(2026, 11, 13),
        value: 69.90,
        paymentMethod: PaymentMethod.PIX,
        category: categoryList.elementAt(4)));
  }

  static double getTotalExpenses() {
    double totalExpenses = 0;
    for(var expense in expensesList) {
      totalExpenses += expense.value;
    }
    return totalExpenses;
  }

  static double getTotalIncome() {
    double totalIncome = 0;
    for (var income in incomeList) {
      totalIncome += income.value;
    }
    return totalIncome;
  }

  static double getTotalResult() {
    return getTotalIncome() - getTotalExpenses();
  }

  static List<DateTime> getAvailableMonths() {
    final months = <String, DateTime>{};
    void addMonth(DateTime date) {
      final month = DateTime(date.year, date.month);
      months['${month.year}-${month.month}'] = month;
    }

    addMonth(DateTime.now());
    for (final income in incomeList) {
      addMonth(income.date);
    }
    for (final expense in expensesList) {
      addMonth(expense.date);
    }

    return months.values.toList()
      ..sort((a, b) => b.compareTo(a));
  }

  static List<Expense> filterExpensesbyMonth(DateTime month) {
    return expensesList
        .where((expense) =>
            expense.date.year == month.year && expense.date.month == month.month)
        .toList();
  }

  static List<Income> filterIncomebyMonth(DateTime month) {
    return incomeList
        .where((income) =>
            income.date.year == month.year && income.date.month == month.month)
        .toList();
  }

  static double getTotalExpensesbyMonth(DateTime month) {
    return filterExpensesbyMonth(month)
        .fold(0.0, (total, expense) => total + expense.value);
  }

  static double getTotalIncomebyMonth(DateTime month) {
    return filterIncomebyMonth(month)
        .fold(0.0, (total, income) => total + income.value);
  }

  static double getTotalResultbyMonth(DateTime month) {
    return getTotalIncomebyMonth(month) - getTotalExpensesbyMonth(month);
  }

  static Map<PaymentMethod, double> getExpenseTotalsByPaymentMethod(
    DateTime month,
  ) {
    final totals = <PaymentMethod, double>{};
    for (final expense in filterExpensesbyMonth(month)) {
      totals.update(
        expense.paymentMethod,
        (total) => total + expense.value,
        ifAbsent: () => expense.value,
      );
    }
    return totals;
  }

  static Map<String, double> getExpenseTotalsByCategory(DateTime month) {
    final totals = <String, double>{};
    for (final expense in filterExpensesbyMonth(month)) {
      totals.update(
        expense.category.name,
        (total) => total + expense.value,
        ifAbsent: () => expense.value,
      );
    }
    return totals;
  }
}
