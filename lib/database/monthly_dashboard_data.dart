import 'package:fintracker/model/payment_method.dart';

class MonthlyDashboardData {
  const MonthlyDashboardData({
    required this.availableMonths,
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalResult,
    required this.expenseTotalsByPaymentMethod,
    required this.expenseTotalsByCategory,
  });

  final List<DateTime> availableMonths;
  final double totalIncome;
  final double totalExpenses;
  final double totalResult;
  final Map<PaymentMethod, double> expenseTotalsByPaymentMethod;
  final Map<String, double> expenseTotalsByCategory;
}
