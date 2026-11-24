import 'package:fintracker/model/category.dart';
import 'package:fintracker/model/payment_method.dart';

class Expense {
  final int? id;
  String description;
  DateTime date;
  double value;
  PaymentMethod paymentMethod;
  Category category;

  Expense({
    this.id,
    required this.description,
    required this.date,
    required this.value,
    required this.paymentMethod,
    required this.category,
  });
}
