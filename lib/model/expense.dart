import 'package:fintracker/model/category.dart';

class Expense {
  String description;
  DateTime date;
  double value;
  Category category;

  Expense({
    required this.description,
    required this.date,
    required this.value,
    required this.category,
  });
}